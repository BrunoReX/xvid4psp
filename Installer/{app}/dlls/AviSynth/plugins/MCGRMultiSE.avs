########################################################################################################################
###                                                                                                                  ###
###                                          Motion Compansated Grain Remover	           			                 ###
###                                      with Sharpening and Debanding Features		                                 ###
###                                               **SPECIAL EDITION**                                  		         ###
###                                           	      By NEPHILIS	                                                 ###
###                                                      @2011                                      		         ###
###                                                                                                                  ###
########################################################################################################################

##########################################################
##						   	                            ##
## Requirements     : - MVTools     (v2.5.11.1)	   	    ##
## -----------------  - Masktools   (v2.0a48)	   	    ##
##		      - Removegrain (v1.0) package 	            ##
##		      - AddGrain        	   	                ##
##		      - Gradfun2db  (v1.0)	   	                ##
##		      - Gradfun2dbmod (v1.5)	   	            ##
##		      - Some Brain  :P			                ##
##							                            ##
##########################################################

########################################################################################################################
#													   	                                                               #
# Usage     : MCGRMultiSE(clip input, float"ssx", float"ssy", float"Sstr", int"Tlimit", int"Slimit",		           #
# ----------		              int"radius", int"search", int"thSAD", int"thSADC",			                       #
#			              bool"DeBanding", float"thr", float"thrC")	              			                           #
#													   	                                                               #
########################################################################################################################

#################	
# ------------- #
# PARAMETERS  	#
# ------------- #
#################

###############           
#	          #
# SHARPEN   : #
# ----------  #
#######################################################################################################################
#
# ----------
# Ssx,Ssy   : -- Supersampling factor.
# ----------
#		 
# ----------
# Sstr      : -- Sharpening strength.
# ----------     
#
# ----------
# SLimit    : -- Spatial Limiting value.
# ----------
#
# ----------
# TLimit    : -- Temporal Limiting value. (Motion Compesated Temporal Limiting)
# ----------     
# 
#######################################################################################################################

###############
#	          #
# DENOISE   : #
# ----------  #
#######################################################################################################################
#
# ----------  
# Radius    : -- Temporal radius, to use MDeGrain1/2 or 3 as denoiser
# ----------  
#
# ----------
# Search    : -- MVTools search 
# ----------     
#
# ----------
# thSAD, 
# thSADC    : -- MVTools thSAD and thSADC
# ---------- 
#
#######################################################################################################################

###############
#	          #
# DEBANDING : #
# ----------  #
#######################################################################################################################
#
# ----------
# DeBanding : -- To activate DeBanding feature use "DeBanding=true". Default(=false)
# ----------    
# 
# ----------
# thr, 
# thrC      : -- Gradfun2db's "thr" and "thrC" options. 
# ----------     
#
######################################################################################################################


Function MCGRMultiSE(clip input, float"ssx", float"ssy", float"Sstr", int"Tlimit", int"Slimit",
\		                 int"radius", int"search", int"thSAD", int"thSADC", 
\			             bool"chroma", bool"DeBanding", float"thr", float"thrC")

{

ssx     = default( ssx    ,   1.0 )
ssy     = default( ssy    ,   ssx )
Sstr    = default( Sstr   ,   1.0 )
Tlimit  = default( Tlimit ,     2 )
Slimit  = default( Slimit ,     6 )
radius  = default( radius ,     2 )
search  = default( search ,     5 )
thSAD   = default( thSAD  ,   125 )
thSADC  = default( thSADC , thSAD )
chroma  = default( chroma ,  true )
DeBanding = default( DeBanding , false )
thr     = default( thr    ,   1.2 )
thrC    = default( thrC   ,   thr )

Assert(       isYV12(input) == True ? true : false, chr(10) + " Input is not YV12 clip. Convert to YV12 first " + chr(10))
Assert(( radius>= 1 && radius<= 3 ) ? true : false, chr(10) + "     'Radius' value should be between [1-3]    " + chr(10))
Assert(( search>= 0 && search<= 5 ) ? true : false, chr(10) + "     'Search' value should be between [0-5]    " + chr(10))
    
ox = input.width()
oy = input.height()
HD = (ox== 1920 || oy>= 800) ? true : false
xss = mod4(ox*ssx)
yss = mod4(oy*ssy)
Str = string(Sstr)
shrp = mt_lutxy(input,input.RemoveGrain(11,-1,-1),\
	   yexpr="x y == x x x y - abs 16 / 1 4 / ^ 16 * "+Str+" * x y - x y - abs / * x y - 2 ^ 16 2 ^ "+Str+\
	   " 4 * + * x y - 2 ^ "+Str+" 4 * + 16 2 ^ * / * 1 1 3 / 4 ^ + 1 x y - abs 48 / 4 ^ + / * + ?",U=1,V=1)
EE = input.Spline36resize(xss,yss).mt_edge("prewitt",0,255,0,0,u=1,v=1).mt_expand(U=1,V=1).\
	   mt_inflate(U=1,V=1).removegrain(20,-1).Spline36resize(ox,oy,0.5,-0.5,xss,yss)
EEDS = mt_merge(input,shrp,EE,chroma="copy first")
repaired = repair(shrp,EEDS,1,-1,-1)
shrpdiff = mt_makediff(input,repaired)
Limited = mt_lutxy(repaired,shrpdiff,yexpr=" y 128 "+string(Slimit)+" + > x "+string(Slimit)+" - y 128 "+string(Slimit)+\
					    " - < x "+string(Slimit)+" + x y 128 - - ? ?",chroma="copy first")

blksize = (HD==true) ? 16:8
overlap = blksize/2
planes  = chroma ? 4:0 
	
src = input
src_super = MSuper(src,hpad=4,vpad=4,pel=2,sharp=2,chroma=chroma)
bv1 = MAnalyse(src_super,blksize=blksize,search=search,isb=true, delta=1,overlap=overlap,truemotion=true,lambda=1000,chroma=chroma)
fv1 = MAnalyse(src_super,blksize=blksize,search=search,isb=false,delta=1,overlap=overlap,truemotion=true,lambda=1000,chroma=chroma)
bv2 = (radius>=2) ? \
	   MAnalyse(src_super,blksize=blksize,search=search,isb=true, delta=2,overlap=overlap,truemotion=true,lambda=1000,chroma=chroma) : Blankclip()
fv2 = (radius>=2) ? \
	   MAnalyse(src_super,blksize=blksize,search=search,isb=false,delta=2,overlap=overlap,truemotion=true,lambda=1000,chroma=chroma) : Blankclip()
bv3 = (radius==3) ? \
	   MAnalyse(src_super,blksize=blksize,search=search,isb=true, delta=3,overlap=overlap,truemotion=true,lambda=1000,chroma=chroma) : Blankclip()
fv3 = (radius==3) ? \
	   MAnalyse(src_super,blksize=blksize,search=search,isb=false,delta=3,overlap=overlap,truemotion=true,lambda=1000,chroma=chroma) : Blankclip()
    
bcomp = MCompensate(input,src_super,bv1,thSAD=512)
fcomp = MCompensate(input,src_super,fv1,thSAD=512)
max   = mt_logic(bcomp,fcomp,"max").mt_logic(input,"max")
min   = mt_logic(bcomp,fcomp,"min").mt_logic(input,"min")
LSharp = mt_clamp(Limited,max,min,Tlimit,Tlimit,U=2,V=2)
FSharp = LSharp.MergeChroma(src)
    
shrp_super = MSuper(FSharp,hpad=4,vpad=4,pel=2,sharp=2,chroma=chroma,levels=1)

MCNR = (radius==1) ? MDegrain1(input,shrp_super,bv1,fv1,thSAD=thSAD,thSADC=thSADC,plane=planes) \ 
     : (radius==2) ? MDegrain2(input,shrp_super,bv1,fv1,bv2,fv2,thSAD=thSAD,thSADC=thSADC,plane=planes) \
     :		     MDegrain3(input,shrp_super,bv1,fv1,bv2,fv2,bv3,fv3,thSAD=thSAD,thSADC=thSADC,plane=planes)

DB = (DeBanding==True) ? DeBand(MCNR,thr,thrC) : MCNR
Return (DB)
 
}

Function DeBand(clip clp, float thr, float thrC)

{ 
     w = clp.width()  + 32
     h = clp.height() + 32
   
   RDY = clp.pointresize(w,h,-16,-16,w,h)

   LUM = RDY.gradfun2db(thr).Crop(16,16,-16,-16)
   CHR = RDY.gradfun2db(thrC).Crop(16,16,-16,-16)

Dither = thr==1.0 && thrC==1.0 ? CLP
   \   : thr==thrC             ? LUM
   \   : thr!=1.0 && thrC==1.0 ? LUM.mergechroma(CLP)
   \   : thr==1.0 && thrC!=1.0 ? CLP.mergechroma(CHR)
   \   :                         LUM.mergechroma(CHR)

  Mask = mt_luts(clp,clp,mode="range",pixels=mt_square(2),expr="y",u=1,v=1).\
	 mt_lut(expr="255 x 1 2 / * 2 ^ /",u=1,v=1).removegrain(19,-1)

Output = mt_merge(clp,Dither,Mask,luma=true,u=3,v=3)

Return (Output) 

}

function mod4(float"x") 
{
return(x<16 ? 16 : int(round(x/4.0)*4))
}
