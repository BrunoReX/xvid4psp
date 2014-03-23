########################################################################################################################
###                                                                                                                  ###
###                                                   RemoveDirtMC	           			     	     ###
###                                      	         v1.1                    				     ###
###                                               **SPECIAL EDITION**                                  		     ###
###                                           	      By NEPHILIS	                                             ###
###                                                      @2011                                      		     ###
###                                                                                                                  ###
########################################################################################################################

###########################################################
##							 ##
## Requirements : - MVTools      (v2.5.11.0)		 ##
## -------------  - Masktools    (v2.0a48)		 ##
##		  - RemoveGrainT (v1.0) package 	 ##
##		  - RemoveDirt   (v0.9) package		 ##
##		  - AvsRecursion (v0.2) 		 ##
##		  - FluxSmooth   (v1.1)			 ##
##		  - NLMeansCL package			 ##
##		    (AvsFilterNet.dll, Cloo.dll,	 ##
##		     NLMeansCL_netautoload.dll)		 ##
##		  - NVIDIA GeForce 8 series or newer VGA ##
##							 ##
###########################################################

########################################################################################################################
#													   	       #
# Usage : RemoveDirtMC_SE(clip input,int"radius",int"repmode",int"clmode",bool"TwoPass", bool"chroma",int"thSAD",int"thSADC" )       #
# ------		                           			                                               #
#													   	       #
########################################################################################################################

#################
# ------------- #
# PARAMETERS  	#
# ------------- #
#################

#######################################################################################################################
#
# ----------
# Radius    : -- Temporal Radius for MDeGrain at second stage DeNoising.
# ----------
#
# ----------
# repmode   : -- Repair mode value in main RemoveDirtSE function.
# ----------     
#
# ----------
# clmode    : -- RemoveGrain mode value in main RemoveDirtSE function.
# ----------
#
# ----------
# Twopass   : -- To make a Temporal Denoising (MDeGrain) after Spatial Denoising (RemoveDirtSE).   
# ----------   
#
# ----------
# thSAD, 
# thSADC    : -- MDeGrain's thSAD and thSADC parameters.
# ---------- 
#
#######################################################################################################################

Function RemoveDirtMC_SE(clip input, int"radius", int"repmode", int"clmode", bool"TwoPass", bool"chroma", int"thSAD", int"thSADC")

{

version  = "v1.1"

  radius = default(radius,     2)
 repmode = default(repmode,   16)
  clmode = default(clmode,     5)
 TwoPass = default(TwoPass, true)
   thSAD = default(thSAD ,   150)
  thSADC = default(thSADC, thSAD)
  chroma = default(chroma, true)
  
      ox = input.width()
      oy = input.height()
      HD = (ox== 1920 || oy>= 800) ? true : false
 blksize = (HD==true) ? 16:8
  search = (HD==true) ?  4:5
 overlap = blksize/2

         src = input
       PreNR = src.NLMeansCL(h=radius*1.5,plane=4).TemporalDeGrain()
 PreNR_super = MSuper(PreNR,hpad=4,vpad=4,pel=2,sharp=2)
   src_super = MSuper(src  ,hpad=4,vpad=4,pel=2,sharp=2,levels=1)

 bwv1 = MAnalyse(PreNR_super, blksize=blksize, search=search, isb=true,  delta=1, overlap=overlap, truemotion=true, chroma=chroma) 
 bwv2 = (radius>=2) ? \
	MAnalyse(PreNR_super, blksize=blksize, search=search, isb=true,  delta=2, overlap=overlap, truemotion=true, chroma=chroma) : BlankClip()
 bwv3 = (radius==3) ? \
	MAnalyse(PreNR_super, blksize=blksize, search=search, isb=true,  delta=3, overlap=overlap, truemotion=true, chroma=chroma) : BlankClip()
 fwv1 = MAnalyse(PreNR_super, blksize=blksize, search=search, isb=false, delta=1, overlap=overlap, truemotion=true, chroma=chroma) 
 fwv2 = (radius>=2) ? \
	MAnalyse(PreNR_super, blksize=blksize, search=search, isb=false, delta=2, overlap=overlap, truemotion=true, chroma=chroma) : BlankClip()
 fwv3 = (radius==3) ? \
	MAnalyse(PreNR_super, blksize=blksize, search=search, isb=false, delta=3, overlap=overlap, truemotion=true, chroma=chroma) : BlankClip()

 bcomp = MCompensate(src,src_super,bwv1) 
 fcomp = MCompensate(src,src_super,fwv1)
  
 NR1 = src.RemoveDirtSE(fcomp, bcomp, repmode=repmode, clmode=clmode)
 NR1_super = ( TwoPass==true  ) ? MSuper(NR1,hpad=4,vpad=4,pel=2,sharp=2,levels=1) : BlankClip()
       NR2 = ( TwoPass==false ) ? NR1
\   	   : (  radius==1  ) ? MDeGrain1(NR1, NR1_super, bwv1, fwv1, thSAD=thSAD, thSADC=thSADC)
\   	   : (  radius==2  ) ? MDeGrain2(NR1, NR1_super, bwv1, bwv2, fwv1, fwv2, thSAD=thSAD, thSADC=thSADC)
\   	   : 		       MDeGrain3(NR1, NR1_super, bwv1, bwv2, bwv3, fwv1, fwv2, fwv3, thSAD=thSAD, thSADC=thSADC)
 Return (NR2)

}

function TemporalDeGrain(clip input, int "mode", int "thr")

{
	mode = default(mode, 5)
	thr  = default(thr,  8)
	rg = RemoveGrain(input, mode=mode)
	tr = TemporalRepair(rg, input)
        fs = FluxSmoothT(tr,thr)
	Return(fs)
	 
}

function RemoveDirtSE(clip input, clip fcomp, clip bcomp, int "repmode", int "clmode")

{
      
	repmode = default(repmode, 16)
	clmode  = default(clmode,   5)
	clensed = interleave(fcomp,input,bcomp).Clense().selectevery(3,1)
	sbegin  = ForwardClense(input)
	send   = BackwardClense(input)
	alt = Repair(SCSelect(input, sbegin, send, clensed, debug=false), input, mode=repmode) 
	restore = Repair(clensed, input, mode=repmode)
	corrected = RestoreMotionBlocks(clensed, restore, neighbour=input, alternative=alt, gmthreshold=50, dist=1,\
	dmode=2, debug=false, noise=8, noisy=12)
	postNR = RemoveGrain(corrected, mode=clmode)
	Return(postNR)
	
}