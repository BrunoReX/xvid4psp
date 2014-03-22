####################################################################################################################
###                                                                                                              ###
###                                  Dither Tools Bilateral Smoother	           			    		         ###
###                               with Sharpening, Debanding,and Limiters	                             	     ###
###                                  Version 4.312 SMDegrain enhanced                             	      	     ###
###                                          By TheProfileth	                                                 ###
###                                                                                                              ###
####################################################################################################################
function dbilateral4(input, clip "ref",\
 int "radius", float "thr", float "flat", float "wmin", float "subspl", int "y", int "u", int "v",\
 int "tr", int "thSAD", bool "RefineMotion", int "plane", int "pel", int "blksize", int "overlap", int "search", bool "truemotion", bool "chroma",\
 bool "multi", int "vortex", float "VT", float "VS",\
 bool "fix", float "recover", int "Sharpen", int "Smode", int "FSMA", bool "Soothe", int "SthSS", int "SthST",\
 float "Sharp", int "dampen", int "DPower",int "MStr", int "MRest",int "MRad",\
 int "Lmode", int "limit", int "bias",int "Slimit", int "Tlimit", bool "darkprotect", float "nlscale", int "nlthresh", \
 int "DitherMethod", int "DitherDMethod",\
 int "dither", float "ampo", float "ampn", int "pat", bool "dyn", bool "prot", clip "dithermask",\
 int "range", int "YThresh", int "CbThresh", int "CrThresh", int "ditherY", int "ditherC", int "sample_mode", bool "blur_first")
{
	DitherMethod = default(DitherMethod,0)
	DitherDMethod = default(DitherDMethod,0)
	CDUP = (DitherMethod <= -1 ? true : false)
	w =float(input.width())
	h =(CDUP==false) ? input.height() : input.Dither_get_msb().height()
	HD = (w>= 1280 || h>= 720) ? true : false
	radius	= default(radius,round(w/80))
	thr	= default(thr,3)	
	flat = default(flat,0)	#recommended 0 better detail preservation at 0
	wmin = default(wmin,1)	#recommended 1 not much difference but usually slightly more details kept
	subspl = default(subspl,0)	#recommended 0 leave alone
	y = default(y,3)
	u = default(u,3) 
	v = default(v,3)
	tr = default(tr,2)
	thSAD = default(thSAD,400)
	RefineMotion = default(RefineMotion,true)
	plane = default( plane,4)
	pel = default(pel,HD==true ? 1 : 2)
	blksize = default(blksize,8)
	overlap = default(overlap,blksize/2)
	search = default(search,4)
	truemotion = default(truemotion,false)
	chroma = default(chroma,true)
	multi = default(multi,false)
	vortex = default(vortex,0)
	VT = default(VT,vortex==3 ? 25 : 1)
	VS = default(VS,vortex==3 ? 0 : 4)
	fix = default(fix,false)	
	recover = default(recover,0.6)	
	Sharpen = default(Sharpen,0)	
	Smode = default(Smode,0)
	Mrad = default(Mrad,2)
	FSMA = default(FSMA,HD==true ? 1 : 0)
	Soothe = default(Soothe,false)
	SthSS = default(SthSS,0)
	SthST = default(SthST,25)
	Sharp = default(Sharp,0.45)
	dampen = default(dampen,-1) 
	Dpower = default(Dpower,5)
	MStr = default(MStr,32)
	MRest = default(MRest,128)
	MRad = default(MRad,1)
	lmode = default(lmode,0) 
	limit = default(limit,4) 
	bias = default(bias,50) 
	nlscale = default(nlscale,3.1)	#recommended 3.0 - 3.4
	nlthresh = default(nlthresh,5000)	#recommended 1000-15000
	darkprotect = default(darkprotect,false)	
	range = default(range,15)
	YThresh = default(YThresh,64)
	CbThresh = default(CbThresh,64)
	CrThresh = default(CrThresh,64)
	ditherY = default(ditherY,64)
	ditherC = default(ditherC,64)
	sample_mode = default(sample_mode,2)
	blur_first = default(blur_first,true)
	dither = default(dither,6)	#recommended 0 or 6, read the info for descriptions
	ampo = default(ampo,1)	
	ampn = default(ampn,0)
	pat = default(pat,1)
	dyn = default(dyn,false)
	prot = default(prot,false)	
	Assert(-1<lmode<5,    "Lmode must be between 0~4: "+string(Lmode))
	Assert(-1<smode<6,    "Smode must be between 0~5: "+string(Smode))	
	Assert(-2<Sharpen<2,    "Sharpen must be either -1,0 or 1: "+string(Sharpen)) 
	Assert(-2<Dampen<3,    "Dampen must be between -1~2: "+string(Dampen))
	Assert(-1<Dpower<7,    "Dpower must be between 0~6: "+string(Dpower))
	Assert(0<Recover<1,    "Recover must be between 0< but <1: "+string(Recover))
	Assert(-1<FSMA<4,    "FSMA must be between 0 and 3: "+string(FSMA))
	Assert(-6<DitherMethod<5,    "DitherMethod must be between -6~5: "+string(DitherMethod))
	Assert(-2<DitherDMethod<3,    "DitherDMethod must be between -1~2: "+string(DitherDMethod))
	Assert(-0<Sample_Mode<3,    "Sample_mode must be between 1 and 2: "+string(Sample_Mode))	
	LIM1  = string( round(limit*100.0/bias-1.0) ) 
	LIM2  = string(limit)
	BIA   = string(bias)
	nlthr=string(nlthresh)
	nlscl=string(nlscale)
	limitmode=(CDUP==true) ? input.Dither_get_msb : input
	limitmode=lmode==0 ? input : limitmode
	limitmode=lmode==1 ? "x y = x x "+LIM1+" + y < x "+LIM2+" + x "+LIM1+" - y > x "+LIM2+" - "+ "x 100 "+BIA+" - * y "+BIA+" * + 100 / ? ? ?" : limitmode
	limitmode=lmode==2 ? mt_logic(input.invert(),input,"min",U=3,V=3).removegrain(20,0) : limitmode
	limitmode=lmode==3 ? mt_logic(mt_logic(input,input.vmean(1,1),"min",U=3,V=3),mt_logic(input,input.vmean(1,1),"max",U=3,V=3),"or",U=3,v=3) : limitmode
	#limitmode=lmode==4 ? input.convert16().SmoothGrad(radius=1,thr=0.5,elast=6,u=1,v=1).dither_get_lsb.ttempsmoothf(maxr=3,strength=8,lthresh=200,scthresh=0,fp=false).Grayscale : limitmode
	
	Sharpmode=(CDUP==true) ? input.Dither_get_msb : input
	Sharpmode=(Smode==0 && Sharpen==-1) ? Sharpmode.FineSharpM(sstr=sharp) : Sharpmode
	Sharpmode=(Smode==1 && Sharpen==-1) ? Sharpmode.MedSharpT(Str=Sharp,FSMA=FSMA) : Sharpmode
	Sharpmode=(Smode==2 && Sharpen==-1) ? Sharpmode.MedSharpT2(Str=Sharp,FSMA=FSMA) : Sharpmode
	Sharpmode=(Smode==3 && Sharpen==-1) ? Sharpmode.MedSharpT3(Str=Sharp,FSMA=FSMA) : Sharpmode
	Sharpmode=(Smode==4 && Sharpen==-1) ? Sharpmode.MedSharpT4(rad=Mrad,FSMA=FSMA) : Sharpmode
	Sharpmode=(Smode==5 && Sharpen==-1) ? Sharpmode.MedSharpT5(strength=Sharp,Szrp=Szrp,Spwr=Spwr,SdmpLo=SdmpLo,SdmpHi=SdmpHi,FSMA=FSMA) : Sharpmode
	
	Sharpmode=(Sharpen==-1 && Soothe==true) ? SootheS2(sharpmode,input,sootheT=SthST,sootheS=SthSS) : sharpmode
	
	prep=(Dampen==-1 || Dampen==2) ? Dpower==-1 ? sharpmode.dampener0() : Dpower==0 ? sharpmode.MosquitoNR(strength=MStr,Restore=MRest,Radius=MRad) : Dpower==1 ? sharpmode.dampener() : Dpower==2 ? sharpmode.dampener2() : Dpower==3 ? sharpmode.dampener3() : Dpower==4 ? sharpmode.dampener4() : sharpmode : sharpmode
	
	ditherup=(DitherMethod==-5) ? stackvertical(prep,input.Dither_get_lsb)\
	.f3kdb(range=range,DitherY=DitherY,DitherC=DitherC,DitherY=DitherY,DitherC=DitherC,Y=YThresh,Cb=CbThresh,Cr=CrThresh,sample_mode=sample_mode,blur_first=blur_first,precision_mode=4,input_depth=16,input_mode=1,output_mode=1,output_depth=16,mt=true)\ 
	.smdegrain(lsb=true,lsb_in=true,lsb_out=true,tr=tr,thSAD=thSAD,blksize=blksize,overlap=overlap,search=search,truemotion=truemotion,prefilter=0,refinemotion=refinemotion,pel=pel,plane=plane)\
	: prep
	
	ditherup=(DitherMethod==-4) ? stackvertical(prep,input.Dither_get_lsb)\
	.smdegrain(lsb=true,lsb_in=true,lsb_out=true,tr=tr,thSAD=thSAD,blksize=blksize,overlap=overlap,search=search,truemotion=truemotion,prefilter=0,refinemotion=refinemotion,pel=pel,plane=plane)\
	.f3kdb(range=range,DitherY=DitherY,DitherC=DitherC,Y=YThresh,Cb=CbThresh,Cr=CrThresh,sample_mode=sample_mode,blur_first=blur_first,precision_mode=4,input_depth=16,input_mode=1,output_mode=1,output_depth=16,mt=true)\
	: ditherup
	
	ditherup=(DitherMethod==-3) ? stackvertical(prep,input.Dither_get_lsb)\
	.f3kdb(range=range,DitherY=DitherY,DitherC=DitherC,Y=YThresh,Cb=CbThresh,Cr=CrThresh,sample_mode=sample_mode,blur_first=blur_first,precision_mode=4,input_depth=16,input_mode=1,output_mode=1,output_depth=16,mt=true)\
	: ditherup
	
	ditherup=(DitherMethod==-2) ? stackvertical(prep,input.Dither_get_lsb)\
	.smdegrain(lsb=true,lsb_in=true,lsb_out=true,tr=tr,thSAD=thSAD,blksize=blksize,overlap=overlap,search=search,truemotion=truemotion,prefilter=0,refinemotion=refinemotion,pel=pel,plane=plane)\
	: ditherup
	
	ditherup=(DitherMethod==-1) ? stackvertical(prep,input.Dither_get_lsb)\
	: ditherup
	
	ditherup=(DitherMethod==0) ? ditherup.convert16() : ditherup
	
	ditherup=(DitherMethod==1) ? ditherup\
	.smdegrain(lsb_out=true,tr=tr,thSAD=thSAD,blksize=blksize,overlap=overlap,search=search,truemotion=truemotion,prefilter=0,refinemotion=refinemotion,pel=pel,plane=plane)\
	: ditherup
	
	ditherup=(DitherMethod==2) ? ditherup\
	.f3kdb(range=range,DitherY=DitherY,DitherC=DitherC,Y=YThresh,Cb=CbThresh,Cr=CrThresh,sample_mode=sample_mode,blur_first=blur_first,precision_mode=4,input_depth=8,input_mode=0,output_mode=1,output_depth=16,mt=true)\
	: ditherup
	
	ditherup=(DitherMethod==3) ? ditherup\
	.smdegrain(lsb_out=true,tr=tr,thSAD=thSAD,blksize=blksize,overlap=overlap,search=search,truemotion=truemotion,prefilter=0,refinemotion=refinemotion,pel=pel,plane=plane)\
	.f3kdb(range=range,DitherY=DitherY,DitherC=DitherC,Y=YThresh,Cb=CbThresh,Cr=CrThresh,sample_mode=sample_mode,blur_first=blur_first,precision_mode=4,input_depth=16,input_mode=1,output_mode=1,output_depth=16,mt=true)\
	: ditherup
	
	ditherup=(DitherMethod==4) ? ditherup\
	.f3kdb(range=range,DitherY=DitherY,DitherC=DitherC,Y=YThresh,Cb=CbThresh,Cr=CrThresh,sample_mode=sample_mode,blur_first=blur_first,precision_mode=4,input_depth=8,input_mode=0,output_mode=1,output_depth=16,mt=true)\
	.smdegrain(lsb=true,lsb_in=true,lsb_out=true,tr=tr,thSAD=thSAD,blksize=blksize,overlap=overlap,search=search,truemotion=truemotion,prefilter=0,refinemotion=refinemotion,pel=pel,plane=plane)\
	: ditherup
	
	normal=(Dampen==-1 || Dampen==2) ?\
	Dpower==5 ? ditherup.smoothgrad(thr=0.4,radius=2,elast=2.5,u=2,v=2).smoothgrad(thr=1,radius=4,elast=3.5,u=2,v=2):\
	Dpower==6 ? ditherup.smoothgrad(thr=0.25,radius=1,elast=4,u=2,v=2).\
				smoothgrad(thr=0.4,radius=2,elast=3.5,u=2,v=2).\
				smoothgrad(thr=2,radius=4,elast=2,u=2,v=2).\
				smoothgrad(thr=0.4,radius=2,elast=3.5,u=2,v=2).\
				smoothgrad(thr=0.25,radius=1,elast=4,u=2,v=2)\
				: ditherup : ditherup
	normal=(multi==true && vortex != 0) ?\
	vortex==1 ?\
	VortexMultiPass(normal,sharpmode.convert16,VS1=VS,VS2=VS,VS3=VS,VS4=VS,VS5=VS,VS6=VS,y=y,u=u,v=v) : \
	vortex==2 ?\
	VortexMultiPass2(normal,sharpmode.convert16,VT=VT,VS=VS,y=y,u=u,v=v):\
	vortex==3 ?\
	VortexMultiPass3(normal,sharpmode.convert16,VT=VT,VS=VS,y=y,u=u,v=v):\
	normal.\
	dither_bilateral16(radius=2,thr=8,wmin=1,flat=0,y=y,u=u,v=v).\
	dither_bilateral16(radius=4,thr=6,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup).\
	dither_bilateral16(radius=8,thr=4,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup).\
	dither_bilateral16(radius=16,thr=2,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup).\
	dither_bilateral16(radius=32,thr=1,wmin=1,flat=0,y=y,u=u,v=v) :\
	normal.Dither_bilateral16(ref=ref,radius=radius,thr=thr,flat=flat,wmin=wmin,subspl=subspl,y=y,u=u,v=v)
	
	normal=(Dampen==1 || Dampen==2) ? Dpower==5 ?\
	normal.smoothgrad(thr=0.4,radius=2,elast=2.5,u=2,v=2).smoothgrad(thr=1,radius=4,elast=3.5,u=2,v=2)\
	: Dpower==6 ? normal.smoothgrad(thr=0.25,radius=1,elast=4,u=2,v=2).\
				smoothgrad(thr=0.4,radius=2,elast=3.5,u=2,v=2).\
				smoothgrad(thr=2,radius=4,elast=2,u=2,v=2).\
				smoothgrad(thr=0.4,radius=2,elast=3.5,u=2,v=2).\
				smoothgrad(thr=0.25,radius=1,elast=4,u=2,v=2)\
				:normal : normal
	output=(fix==true) ? RaverageW(cdup==true ? input.Dither_get_msb : input,recover,normal.Dither_get_msb,1-recover).mergechroma(normal.Dither_get_msb) : normal.Dither_get_msb
	output2=(Dampen==1 || Dampen==2) ? Dpower==-1 ? output.dampener0() : Dpower==0 ? output.MosquitoNR(strength=MStr,Restore=MRest,Radius=MRad) : Dpower==1 ? output.dampener() : Dpower==2 ? output.dampener2() : Dpower==3 ? output.dampener3() : Dpower==4 ? output.dampener4() : output : output

	ditherdown=stackvertical(output2,normal.Dither_get_lsb)
	
	ditherdown=(DitherDMethod==-1) ? ditherdown : ditherdown
	
	ditherdown=(DitherDMethod==0) ? ditherdown.\
	ditherpost(mode=dither,ampo=ampo,ampn=ampn,pat=pat,dyn=dyn,prot=prot,mask=dithermask)\
	: ditherdown
	
	ditherdown=(DitherDMethod==1) ? ditherdown.\
	F3KDB(precision_mode=(dither==6 ? 3 : dither==0 ? 2 : 3),input_depth=16,input_mode=1,output_mode=0,output_depth=8,range=range,DitherY=DitherY,DitherC=DitherC,Y=YThresh,Cb=CbThresh,Cr=CrThresh,sample_mode=sample_mode,blur_first=blur_first,mt=true)\
	: ditherdown
	
	ditherdown=(DitherDMethod==2) ? ditherdown.\
	ditherpost(mode=dither,ampo=ampo,ampn=ampn,pat=pat,dyn=dyn,prot=prot,mask=dithermask).\
	F3KDB(precision_mode=(dither==6 ? 3 : dither==0 ? 2 : 3),input_depth=8,input_mode=0,output_mode=0,output_depth=8,range=range,DitherY=DitherY,DitherC=DitherC,range=range,DitherY=DitherY,DitherC=DitherC,Y=YThresh,Cb=CbThresh,Cr=CrThresh,sample_mode=sample_mode,blur_first=blur_first,mt=true)\
	: ditherdown
	
	masking=(lmode==2 || lmode==3 && CDUP==true || DitherDmethod==-1) ? \
	DitherDMethod==-1 && CDUP==true ? stackvertical(Rmerge(ditherup.dither_get_msb,ditherdown.dither_get_msb,limitmode,u=4,v=4),ditherdown.dither_get_lsb):\
	DitherDMethod==-1 && CDUP==false ? stackvertical(Rmerge(prep,ditherdown.dither_get_msb,limitmode,u=4,v=4),normal.dither_get_lsb):\
	DitherDMethod !=-1 && CDUP==true ? Rmerge(ditherup.dither_get_msb,ditherdown,limitmode,u=4,v=4)\
	: ditherdown : ditherdown
	masking=(lmode==2 || lmode==3 && CDUP==false && DitherDmethod !=-1) ? \
	 merge(prep,ditherdown,limitmode,u=4,v=4) : lmode==4 ? SootheS2(ditherdown,input,sootheT=Tlimit, sootheS=Slimit) : masking
	
	limiting=(lmode==1 && CDUP==true || Dither==9) ?\
	DitherDMethod==-1 && CDUP==true ? stackvertical(mt_lutxy(ditherup.dither_get_msb,ditherdown.dither_get_msb,expr=limitmode,u=4,v=4),ditherdown.dither_get_msb):\
	DitherDMethod==-1 && CDUP==false ? stackvertical(mt_lutxy(prep,ditherdown.dither_get_msb,expr=limitmode,u=4,v=4),normal.dither_get_lsb):\
	DitherDMethod !=-1 && CDUP==true ? mt_lutxy(ditherup.dither_get_msb,ditherdown,expr=limitmode,u=4,v=4)\
	: masking : masking
	limiting=(lmode==1 && CDUP==false && DitherDMethod !=-1) ?\
	mt_lutxy(prep,ditherdown,expr=limitmode,u=4,v=4) : limiting
	
	Sharpmode2=limiting
	Sharpmode2=(Smode==0 && Sharpen==1) ? Sharpmode2.FineSharpM(sstr=sharp) : Sharpmode2
	Sharpmode2=(Smode==1 && Sharpen==1) ? Sharpmode2.MedSharpT(Str=Sharp,FSMA=FSMA) : Sharpmode2
	Sharpmode2=(Smode==2 && Sharpen==1) ? Sharpmode2.MedSharpT2(Str=Sharp,FSMA=FSMA) : Sharpmode2
	Sharpmode2=(Smode==3 && Sharpen==1) ? Sharpmode2.MedSharpT3(Str=Sharp,FSMA=FSMA) : Sharpmode2
	Sharpmode2=(Smode==4 && Sharpen==1) ? Sharpmode2.MedSharpT4(Rad=Mrad,FSMA=FSMA) : Sharpmode2
	Sharpmode2=(Smode==5 && Sharpen==1) ? Sharpmode2.MedSharpT5(strength=Sharp,Szrp=Szrp,Spwr=Spwr,SdmpLo=SdmpLo,SdmpHi=SdmpHi,FSMA=FSMA) : Sharpmode2
	
	Sharpmode2=(Sharpen==1 && Soothe==true) ? SootheS2(sharpmode2,limiting,sootheT=SthST,sootheS=SthSS) : sharpmode2
	
	post=Sharpmode2 
	darkprotection=(dither !=9 && darkprotect==true) ? Rmerge(prep,post,mt_lut(input,"x "+string(nlscl)+" ^ "+string(nlthr)+" /"),u=4,v=4) : post
	darkprotection=(dither ==9 && darkprotect==true) ? stackvertical(post.dither_get_msb,Rmerge(ditherup.dither_get_lsb,output2.dither_get_lsb,mt_lut(ditherup.dither_get_lsb,"x "+string(nlscl)+" ^ "+string(nlthr)+" /"),u=4,v=4)) : darkprotection
	return(darkprotection)
	}
	
function Convert16(clip)
 {return(clip.Dither_convert_8_to_16())}	
	
	function HPS3(clip c, float "r", bool "half",bool "half2", bool "soft", bool "limit",float "thr",bool "mask") {
	# High Pass sharpen modded and optimized by The_Profileth
	# Requires: mt_masktools2, dither
	thr	= default(thr,2)
	r = default(r, 3)
	half = default(half, false)
	half2 = default(half, false)
	soft = default(soft, true)
	limit= default(limit,true)
	mask=default(mask,true)
	blur = c.Dither_convert_8_to_16 ().Dither_box_filter16 (radius=r, y=3, u=2, v=2).ditherpost(mode=-1)
	hpm = mt_average(c, blur.Invert()).Greyscale()
	mode = soft ? "softlight" : "hardlight"
	prep=c.Overlay(hpm, mode=mode)
	fix=half ? mt_average(c, prep) : prep
	sharp= limit ? mt_lutxy(c,fix,"x "+string(thr)+" + y < x "+string(thr)+" + x "+string(thr)+" - y > x "+string(thr)+" - y ? ?") : fix
	masking= mask ? mt_merge(c,sharp,sharp.lsfmod(edgemode=-1)) : sharp
	output= half2 ? mt_average(c,masking) : masking
	return(output)
	}

	function HPS4(clip c, float "r", bool "half",bool "half2", bool "soft", bool "limit",float "thr",bool "mask") {
	# High Pass sharpen modded and optimized by The_Profileth
	# Requires: mt_masktools2, dither, RedAverage
	thr	= default(thr,2)
	r = default(r, 3)
	half = default(half, false)
	half2 = default(half, false)
	soft = default(soft, true)
	limit= default(limit,true)
	mask=default(mask,true)
	blur = c.Dither_convert_8_to_16 ().Dither_box_filter16 (radius=r, y=3, u=2, v=2).ditherpost(mode=-1)
	hpm = RAverageW(c,0.5, blur.Invert(),0.5,u=2,v=2).Greyscale()
	mode = soft ? "softlight" : "hardlight"
	prep=c.Overlay(hpm, mode=mode)
	fix=half ? RAverageW(c,0.5, prep,0.5,u=2,v=2) : prep
	sharp= limit ? mt_lutxy(c,fix,"x "+string(thr)+" + y < x "+string(thr)+" + x "+string(thr)+" - y > x "+string(thr)+" - y ? ?") : fix
	masking= mask ? Rmerge(c,sharp,sharp.lsfmod(edgemode=-1),u=2,v=2) : sharp
	output= half2 ? RAverageW(c,0.5,masking,0.5,u=2,v=2) : masking
	return(output)
}

function HPSX(clip c, float "r", bool "half",bool "half2", bool "soft", bool "limit",float "thr",bool "mask", float "SS") {
	# High Pass sharpen modded and optimized by The_Profileth
	# Requires: mt_masktools2, dither
	thr	= default(thr,12)
	r = default(r, 3)
	half = default(half, false)
	half2 = default(half, false)
	soft = default(soft, false)
	limit= default(limit,false)
	mask=default(mask,false)
	SS=default(SS,1.33)
	w=c.width
	SSW=w*SS
	h=c.height
	SSH=h*SS
	blur = bilinearresize(c,m4(SSW),m4(SSH)).vmean(r=r,rc=1).bilinearresize(w,h)
	hpm = RAverageW(c,0.5, blur.Invert(),0.5).Greyscale()
	mode = soft ? "softlight" : "hardlight"
	prep=Rmerge(c,overlay(c,hpm,mode=mode),Raveragew(hpm,0.5,mt_lutxy(c.mt_expand(),c.mt_inpand(),"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?"),0.5))
	fix=half ? RAverageW(c,0.5, prep,0.5) : prep
	sharp= limit ? mt_lutxy(c,fix,"x "+string(thr)+" + y < x "+string(thr)+" + x "+string(thr)+" - y > x "+string(thr)+" - y ? ?") : fix
	masking= mask ? Rmerge(c,sharp,sharp.lsfmod(edgemode=-1)) : sharp
	output= half2 ? RAverageW(c,0.5,masking,0.5) : masking
	return(output)
}
	
	Function vmean (clip v,int "r",int "rc")
	{
	#variable mean
	r = default(r, 4)
	rc= default(rc, r*2)
	v.Dither_convert_8_to_16()
	Dither_box_filter16 (radius=r, y=3, u=2, v=2)
	Dither_box_filter16 (radius=rc, y=2, u=3, v=3) # for 4:2:0 chroma subsampling
	DitherPost (mode=-1,stacked=true)
	}
	
	function FineSharpm(clip c, int "mode", float "sstr", float "cstr", float "xstr", float "lstr", float "pstr", int "thresh")
{
# Small and relatively fast realtime-sharpening function, 
# for 1080p, or after scaling 720p -> 1080p during playback (to make 720p look more like being 1080p)
# It's a generic sharpener. Only for good quality sources! 
# (If the source is crap, FineSharp will happily sharpen the crap.) ;)
# Noise/grain will be enhanced, too. The method is GENERIC.
#
# Modus operandi: A basic nonlinear sharpening method is performed, then the *blurred* sharp-difference gets subtracted again. 
#
# - Didée
#FineSharpM by TheProfileth
#Added a threshold to reduce aliasing
#we shall see what else we get
mode  = default(mode, 1   )   #  1 to 3, weakest to strongest. When negative -1 to -3, a broader kernel for equalisation is used.
sstr  = default(sstr, 1.0 )   #  strength of sharpening, 0.0 up to ??
 
_cstr = spline(sstr, 0,0, 0.5,0.1, 1.0,0.6, 2.0,0.9, 2.5,1.09, 3.0,1.15, 3.5,1.19, 4.0,1.249, 8.0,1.5, 255.0,2.0)

cstr  = default(cstr, _cstr)  #  strength of equalisation, 0.0 to ? 2.0 ? (recomm. 0.5 to 1.5, default AUTO)
xstr  = default(xstr, 0.19 )  #  strength of XSharpen-style final sharpening, 0.0 to 1.0 (but, better don't go beyond 0.249 ...)

                             #  Viscera parameters
lstr  = default(lstr, 1.49 )  #  modifier for non-linear sharpening
pstr  = default(pstr, 1.272)  #  exponent for non-linear sharpening
thresh = default(thresh, 5)
thr = string(thresh)

str1  = sstr
str2  = cstr
SSTR  = string(sstr)
CSTR  = string(cstr)
LSTR  = string(lstr)
PSTR  = string(pstr)
rg=mode>0?11:20
 
b = (abs(mode)==1) ? c.removegrain(11,-1).removegrain(4,-1)
\ : (abs(mode)==2) ? c.removegrain(4,-1).removegrain(11,-1)
\ : (abs(mode)==3) ? c.removegrain(4,-1).removegrain(11,-1).removegrain(4,-1) : c
 
shrpD = mt_lutxy(c,b,"x y - abs "+LSTR+" / 1 "+PSTR+" / ^ "+SSTR+" * x y - x y - abs 0.001 + / * 128 +")
 
shrp = (str1<0.01) ? c : c.mt_adddiff(shrpD,U=2,V=2)

shrp = (str2<0.01) ? shrp : shrp.mt_makediff(shrpD.mt_lut("x 128 - "+CSTR+" * 128 +").removegrain(rg,-1),U=2,V=2)

shrp = (xstr<0.01) ? shrp
\    : mt_lutxy(shrp,shrp.removegrain(20,-1),"x x y - 9.9 * +",U=2,V=2).repair(shrp,12,0).mergeluma(shrp,1.0-xstr)
regulate=(thresh==0) ? shrp : mt_lutxy(shrp,c,"x y - abs "+thr+" < x y ?",u=2,v=2)
return(regulate)
}
	
	function Dampener0(clip input) 
	{soothes2(input,input.regmed(thresh=5),50,0)}
	
	function Dampener(clip input)
	{repair(input,input.ReduceFluctuations(limitu=0,limitv=0),5,0,0)}
	
	function Dampener2(clip input) 
	{soothes2(input,input.removegrain(4,0,0),60,0)}
	
	function Dampener3(clip input) 
	{repair(input,input.hqdn3d(2,0,3,0),5,0,0)}
	
	function Dampener4(clip input) {
	#TTempsmooth limited
   ttemp = input.ttempsmooth(lthresh=20,cthresh=8)
   limited=Rmerge(input,ttemp,mt_logic(input.invert(),input,"min",U=3,V=3).removegrain(20,0),U=3,v=3)
   return(limited)
	}
	
	function MedsharpT(clip source, float "Str", int "FSMA"){
	STR=default(STR,1)
	FSMA=default(FSMA,1)
    blksize=(FSMA==0 ? 8 : FSMA==1 ? 16 : FSMA==2 ? 32 : 8)
	overlap = blksize/2
	sharp0 = mt_adddiff(source,mt_makediff(source,source.removegrain(4),u=1,v=1),U=1,V=1) # "median sharpen" (won't create halos on its own, IF the source is halo-free)
	sup1   = source.MSuper(pel=2,sharp=2)
	sup2   = sharp0.MSuper(pel=2,sharp=2,levels=1)
	bv1    = sup1.MAnalyse(isb=true, delta=1,blksize=blksize, search=3, overlap=overlap, truemotion=true, lambda=1000)
	fv1    = sup1.MAnalyse(isb=false,delta=1,blksize=blksize, search=3, overlap=overlap, truemotion=true, lambda=1000)
	bc1    = source.MCompensate(sup2,bv1,thSAD=500)  # using the super clip from the median-sharpener, to provide
	fc1    = source.MCompensate(sup2,fv1,thSAD=500)  # more headroom for the limiting process
	max    = mt_logic(bc1,fc1,"max").mt_logic(source,"max")
	min    = mt_logic(bc1,fc1,"min").mt_logic(source,"min")
	sharp1 = source.sharpen(Str)
	return(sharp1.mt_clamp(max,min,0,0,U=2,V=2).mergechroma(source))
	}
	
	function MedsharpT2(clip source,float "Rad", float "Str", int "FSMA"){
	STR=default(STR,0.5)
	rad=default(rad,0.5)
	FSMA=default(FSMA,1)
	blksize =(FSMA==0 ? 8 : FSMA==1 ? 16 : FSMA==2 ? 32 : 8)
	overlap = blksize/2
	strength=Str*2/rad
	sharp0 = mt_adddiff(source,RAverageW(source,1,source.medianblur(radiusu=0,radiusv=0),-1,u=1,v=1,bias=128),U=1,V=1) # "median sharpen" using medianblur gives better results than removegrain(4)
	sup1   = source.MSuper(pel=2,sharp=2)
	sup2   = sharp0.MSuper(pel=2,sharp=2,levels=1)
	bv1    = sup1.MAnalyse(isb=true, delta=1,blksize=blksize, search=3, overlap=overlap, truemotion=true, lambda=1000)
	fv1    = sup1.MAnalyse(isb=false,delta=1,blksize=blksize, search=3, overlap=overlap, truemotion=true, lambda=1000)
	bc1    = source.MCompensate(sup2,bv1,thSAD=500)  # using the super clip from the median-sharpener, to provide
	fc1    = source.MCompensate(sup2,fv1,thSAD=500)  # more headroom for the limiting process
	max    = mt_logic(bc1,fc1,"max").mt_logic(source,"max")
	min    = mt_logic(bc1,fc1,"min").mt_logic(source,"min")
	sharp1 = source.addborders(2,2,2,2).Unsharp(varY=rad,varC=1,strength=Strength,border=2).crop(2,2,-2,-2)
	return(sharp1.mt_clamp(max,min,0,0,U=2,V=2).mergechroma(source))
	}

	function MedsharpT3(clip source, float "Rad", float "Str", int "FSMA"){
	STR=default(STR,0.5)
	rad=default(rad,0.5)
	FSMA=default(FSMA,1)
	blksize =(FSMA==0 ? 8 : FSMA==1 ? 16 : FSMA==2 ? 32 : 8)
	overlap = blksize/2
	strength=Str*2/rad
	inp=source.mt_inpand(u=1,v=1)
	exp=source.mt_expand(u=1,v=1)
	med=source.medianblur(radiusu=0,radiusv=0)
	equation=mt_polish("(x + ((z-y)/2)/2)")
	#Using a weighted median provides better results in general and side effects are reduced halos and darker lines
	sharp0 = mt_adddiff(source,RAverageW(source,1,mt_lutxyz(med,inp,exp,equation,u=1,v=1),-1,u=1,v=1,bias=128),U=1,V=1) 
	sup1   = source.MSuper(pel=2,sharp=2)
	sup2   = sharp0.MSuper(pel=2,sharp=2,levels=1)
	bv1    = sup1.MAnalyse(isb=true, delta=1,blksize=blksize, search=3, overlap=overlap, truemotion=true, lambda=1000)
	fv1    = sup1.MAnalyse(isb=false,delta=1,blksize=blksize, search=3, overlap=overlap, truemotion=true, lambda=1000)
	bc1    = source.MCompensate(sup2,bv1,thSAD=500)  # using the super clip from the median-sharpener, to provide
	fc1    = source.MCompensate(sup2,fv1,thSAD=500)  # more headroom for the limiting process
	max    = mt_logic(bc1,fc1,"max").mt_logic(source,"max")
	min    = mt_logic(bc1,fc1,"min").mt_logic(source,"min")
	sharp1 = source.addborders(2,2,2,2).Unsharp(varY=rad,varC=1,strength=Strength,border=2).crop(2,2,-2,-2)
	return(sharp1.mt_clamp(max,min,0,0,U=2,V=2).mergechroma(source))
	}
	function MedsharpT4(clip source, int "FSMA", int "rad"){
	FSMA=default(FSMA,1)
	rad=default(rad,2)
    blksize=(FSMA==0 ? 8 : FSMA==1 ? 16 : FSMA==2 ? 32 : 8)
	overlap = blksize/2
	inp=source.mt_inpand(u=1,v=1)
	exp=source.mt_expand(u=1,v=1)
	med=source.medianblur(radiusy=rad,radiusu=0,radiusv=0)
	equation=mt_polish("(x + ((z-y)/2)/2)")
	#Using a weighted median provides better results in general and side effects are reduced halos and darker lines
	sharp0 = mt_adddiff(source,RAverageW(source,1,mt_lutxyz(med,inp,exp,equation,u=1,v=1),-1,u=1,v=1,bias=128),U=1,V=1)
	sup1   = source.MSuper(pel=2,sharp=2)
	sup2   = sharp0.MSuper(pel=2,sharp=2,levels=1)
	bv1    = sup1.MAnalyse(isb=true, delta=1,blksize=blksize, search=3, overlap=overlap, truemotion=true, lambda=1000)
	fv1    = sup1.MAnalyse(isb=false,delta=1,blksize=blksize, search=3, overlap=overlap, truemotion=true, lambda=1000)
	bc1    = source.MCompensate(sup2,bv1,thSAD=500)  # using the super clip from the median-sharpener, to provide
	fc1    = source.MCompensate(sup2,fv1,thSAD=500)  # more headroom for the limiting process
	max    = mt_logic(bc1,fc1,"max").mt_logic(source,"max")
	min    = mt_logic(bc1,fc1,"min").mt_logic(source,"min")
	return(sharp0.mt_clamp(max,min,0,0,U=1,V=1).mergechroma(source))
	}
	function MedsharpT5(clip source, int "FSMA", int "rad"){
	FSMA=default(FSMA,1)
	rad=default(rad,2)
    blksize=(FSMA==0 ? 8 : FSMA==1 ? 16 : FSMA==2 ? 32 : 8)
	overlap = blksize/2
	inp=source.mt_inpand(u=1,v=1)
	exp=source.mt_expand(u=1,v=1)
	med=source.medianblur(radiusy=rad,radiusu=0,radiusv=0)
	equation=mt_polish("(x + ((z-y)/2)/2)")
	#Using a weighted median provides better results in general and side effects are reduced halos and darker lines
	sharp0 = mt_adddiff(source,RAverageW(source,1,mt_lutxyz(med,inp,exp,equation,u=1,v=1),-1,u=1,v=1,bias=128),U=1,V=1)
	sup1   = source.MSuper(pel=2,sharp=2)
	sup2   = sharp0.MSuper(pel=2,sharp=2,levels=1)
	bv1    = sup1.MAnalyse(isb=true, delta=1,blksize=blksize, search=3, overlap=overlap, truemotion=true, lambda=1000)
	fv1    = sup1.MAnalyse(isb=false,delta=1,blksize=blksize, search=3, overlap=overlap, truemotion=true, lambda=1000)
	bc1    = source.MCompensate(sup2,bv1,thSAD=500)  # using the super clip from the median-sharpener, to provide
	fc1    = source.MCompensate(sup2,fv1,thSAD=500)  # more headroom for the limiting process
	max    = mt_logic(bc1,fc1,"max").mt_logic(source,"max")
	min    = mt_logic(bc1,fc1,"min").mt_logic(source,"min")
	return(sharp0.mt_clamp(max,min,0,0,U=1,V=1).mergechroma(source))
	}
	
	function TQuant(clip input) 
{
first=mt_lutxy(input,input.selectevery(1,-1).quantile,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",u=1,v=1)
second=mt_lutxy(input,input.selectevery(1,1).quantile,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",u=1,v=1)
out=raveragew(first,0.3,input,0.4,second,0.3,u=4,v=4)
return(out)
}
	function VortexMultiPass(clip normal, clip ditherup, int "VS1", int "VS2", int "VS3", int "VS4", int "VS5", int "VS6",int "Y", int "U", int "V")
	{
	
	#If used externally it requires a 16bit clip and a reference clip
	VS1=default(VS1,4)
	VS2=default(VS2,4)
	VS3=default(VS3,4)
	VS4=default(VS4,4)
	VS5=default(VS5,4)
	VS6=default(VS6,4)
	
	VS1 = string(VS1)
	p1=normal.dither_bilateral16(radius=2,thr=8,wmin=1,flat=0,y=y,u=u,v=v)
	p1msb=p1.dither_get_msb()
	p1lsb=p1.dither_get_lsb()
	p1lut=stackvertical(mt_lutxy(normal.dither_get_msb,p1msb,"x "+VS1+" + y < x "+VS1+" + x "+VS1+" - y > x "+VS1+" - y ? ?",U=4,V=4),p1lsb)
	
	VS2 = string(VS2)
	p2=p1lut.dither_bilateral16(radius=4,thr=6,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p2msb=p2.dither_get_msb()
	p2lsb=p2.dither_get_lsb()
	p2lut=stackvertical(mt_lutxy(normal.dither_get_msb,p2msb,"x "+VS2+" + y < x "+VS2+" + x "+VS2+" - y > x "+VS2+" - y ? ?",U=4,V=4),p2lsb)
	
	VS3 = string(VS3)
	p3=p2lut.dither_bilateral16(radius=8,thr=4,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p3msb=p3.dither_get_msb()
	p3lsb=p3.dither_get_lsb()
	p3lut=stackvertical(mt_lutxy(normal.dither_get_msb,p3msb,"x "+VS3+" + y < x "+VS3+" + x "+VS3+" - y > x "+VS3+" - y ? ?",U=4,V=4),p3lsb)
	
	VS4 = string(VS4)
	p4=p3lut.dither_bilateral16(radius=8,thr=4,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p4msb=p4.dither_get_msb()
	p4lsb=p4.dither_get_lsb()
	p4lut=stackvertical(mt_lutxy(normal.dither_get_msb,p4msb,"x "+VS4+" + y < x "+VS4+" + x "+VS4+" - y > x "+VS4+" - y ? ?",U=4,V=4),p4lsb)
	
	VS5 = string(VS5)
	p5=p4lut.dither_bilateral16(radius=16,thr=2,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p5msb=p5.dither_get_msb()
	p5lsb=p5.dither_get_lsb()
	p5lut=stackvertical(mt_lutxy(normal.dither_get_msb,p5msb,"x "+VS5+" + y < x "+VS5+" + x "+VS5+" - y > x "+VS5+" - y ? ?",U=4,V=4),p5lsb)
	
	VS6 = string(VS6)
	p6=p5lut.dither_bilateral16(radius=32,thr=1,wmin=1,flat=0,y=y,u=u,v=v)
	p6msb=p6.dither_get_msb()
	p6lsb=p6.dither_get_lsb()
	p6lut=stackvertical(mt_lutxy(normal.dither_get_msb,p6msb,"x "+VS6+" + y < x "+VS6+" + x "+VS6+" - y > x "+VS6+" - y ? ?",U=4,V=4),p6lsb)
	return(p6lut)
	}
	
	function VortexMultiPass2(clip normal, clip ditherup, float "VT", float "VS",int "Y", int "U", int "V")
	{
	
	#If used externally it requires a 16bit clip and a reference clip
	VT=default(VT,1)
	VS=default(VS,4)
	
	p1=normal.dither_bilateral16(radius=2,thr=8,wmin=1,flat=0,y=y,u=u,v=v)
	p1lim=Dither_limit_dif16(p1,normal,ditherup,thr=VT,elast=VS)
	
	p2=p1lim.dither_bilateral16(radius=4,thr=6,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p2lim=Dither_limit_dif16(p2,p1lim,ditherup,thr=VT,elast=VS)	

	p3=p2lim.dither_bilateral16(radius=8,thr=4,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p3lim=Dither_limit_dif16(p3,p2lim,ditherup,thr=VT,elast=VS)
	
	p4=p3lim.dither_bilateral16(radius=8,thr=4,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p4lim=Dither_limit_dif16(p4,p3lim,ditherup,thr=VT,elast=VS)
	
	p5=p4lim.dither_bilateral16(radius=16,thr=2,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p5lim=Dither_limit_dif16(p5,p4lim,ditherup,thr=VT,elast=VS)
	
	p6=p5lim.dither_bilateral16(radius=32,thr=1,wmin=1,flat=0,y=y,u=u,v=v)
	p6lim=Dither_limit_dif16(p6,p5lim,ditherup,thr=VT,elast=VS)
	return(p6lim)
	}
	
	function VortexMultiPass3(clip normal, clip ditherup, int "VT", int "VS",int "Y", int "U", int "V")
	{
	#Uses stack and unstack method
	#If used externally it requires a 16bit clip and a reference clip
	VT=default(VT,25)
	VS=default(VS,0)
	
	p1=normal.dither_bilateral16(radius=2,thr=8,wmin=1,flat=0,y=y,u=u,v=v)
	p1msb=p1.dither_get_msb()
	p1lsb=p1.dither_get_lsb()
	p1lim=SootheS2(p1msb,normal.dither_get_msb(),sootheT=VT,sootheS=VS)
	p1lim2=SootheS2(p1lsb,normal.dither_get_lsb(),sootheT=VT,sootheS=VS)
	p1stack=stackvertical(p1lim,p1lim2)
	
	p2=p1stack.dither_bilateral16(radius=4,thr=6,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p2msb=p2.dither_get_msb()
	p2lsb=p2.dither_get_lsb()
	p2lim=SootheS2(p2msb,p1lim,sootheT=VT,sootheS=VS)
	p2lim2=SootheS2(p2lsb,p1lim2,sootheT=VT,sootheS=VS)
	p2stack=stackvertical(p2lim,p2lim2)	

	p3=p2stack.dither_bilateral16(radius=8,thr=4,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p3msb=p3.dither_get_msb()
	p3lsb=p3.dither_get_lsb()
	p3lim=SootheS2(p3msb,p2lim,sootheT=VT,sootheS=VS)
	p3lim2=SootheS2(p3lsb,p2lim2,sootheT=VT,sootheS=VS)
	p3stack=stackvertical(p3lim,p3lim2)
	
	p4=p3stack.dither_bilateral16(radius=8,thr=4,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p4msb=p4.dither_get_msb()
	p4lsb=p4.dither_get_lsb()
	p4lim=SootheS2(p4msb,p3lim,sootheT=VT,sootheS=VS)
	p4lim2=SootheS2(p4lsb,p3lim2,sootheT=VT,sootheS=VS)
	p4stack=stackvertical(p4lim,p4lim2)
	
	p5=p4stack.dither_bilateral16(radius=16,thr=2,wmin=1,flat=0,y=y,u=u,v=v,ref=ditherup)
	p5msb=p5.dither_get_msb()
	p5lsb=p5.dither_get_lsb()
	p5lim=SootheS2(p5msb,p4lim,sootheT=VT,sootheS=VS)
	p5lim2=SootheS2(p5lsb,p4lim2,sootheT=VT,sootheS=VS)
	p5stack=stackvertical(p5lim,p5lim2)
	
	p6=p5stack.dither_bilateral16(radius=32,thr=1,wmin=1,flat=0,y=y,u=u,v=v)
	p6msb=p6.dither_get_msb()
	p6lsb=p6.dither_get_lsb()
	p6lim=SootheS2(p6msb,p5lim,sootheT=VT,sootheS=VS)
	p6lim2=SootheS2(p6lsb,p5lim2,sootheT=VT,sootheS=VS)
	p6stack=stackvertical(p6lim,p6lim2)
	
	return(p6stack)
	}
	
	
	function SootheS2(clip sharp, clip orig, int "sootheT", int "sootheS")
{
sootheT  = default(sootheT, 25 )
sootheS  = default(sootheS,  0 )
sootheT  = (sootheT > 100) ? 100 : (sootheT < -100) ? -100 : sootheT
sootheS  = (sootheS > 100) ? 100 : (sootheS < 0) ? 0 : sootheS
ST    = string( 100 - abs(sootheT))
SSPT  = string( 100 - abs(sootheS))

mt_makediff(orig,sharp)

(sootheS==0) ? last
 \           : mt_lutxy( last, last.vmean(1,1),
 \             "x 128 - y 128 - * 0 < x 128 - 100 / "+SSPT+" * 128 + x 128 - abs y 128 - abs > x "+SSPT+" * y 100 "+SSPT+" - * + 100 / x ? ?", chroma="ignore")
 
(sootheT==0) ? last
 \           : mt_lutxy( last, last.temporalsoften(1,255,0,32,2),
 \           "x 128 - y 128 - * 0 < x 128 - 100 / "+ST+" * 128 + x 128 - abs y 128 - abs > x "+ST+" * y 100 "+ST+" - * + 100 / x ? ?", chroma="ignore")

(sootheT > -1) ? last 
 \             : mt_lutxy( last, last.temporalsoften(1,255,0,32,2),
 \             "x 128 - y 128 - * 0 < x 128 - 100 / "+ST+" * 128 + x 128 - abs y 128 - abs > x "+ST+" * y 100 "+ST+" - * + 100 / x ? ?",chroma="ignore")

mt_makediff(orig,last)
mergechroma(sharp)
return( last )
}

Function Median2(clip "input_1", clip "input_2", clip "input_3", clip "input_4", clip "input_5", string "chroma")
{# median of 5 clips from Helpers.avs by G-force

chroma = default(chroma,"process") #default is "process". Alternates: "copy first" or "copy second"

#MEDIAN(i1,i3,i5)
Interleave(input_1,input_3,input_5)
chroma == "process" ? Clense(reduceflicker=false) : Clense(reduceflicker=false,grey=true)
m1 = selectevery(3,1)

#MAX(MIN(i1,i3,i5),i2)
m2  = input_1.MT_Logic(input_3,"min",chroma=chroma).MT_Logic(input_5,"min",chroma=chroma).MT_Logic(input_2,"max",chroma=chroma)

#MIN(MAX(i1,i3,i5),i4)
m3  = input_1.MT_Logic(input_3,"max",chroma=chroma).MT_Logic(input_5,"max",chroma=chroma).MT_Logic(input_4,"min",chroma=chroma)

Interleave(m1,m2,m3)
chroma == "process" ? Clense(reduceflicker=false) : Clense(reduceflicker=false,grey=true)
selectevery(3,1)

chroma == "copy first" ? last.MergeChroma(input_1) : chroma == "copy second" ? last.MergeChroma(input_2) : last

Return(last)
}

Function fastmedian(clip o,int "pixelskip"){
ox = o.width()
oy = o.height()
pixelskip=default(pixelskip,1)

lft = o.pointresize(ox,oy,-pixelskip, 0,ox,oy)
rgt = o.pointresize(ox,oy, pixelskip, 0,ox,oy)
top = o.pointresize(ox,oy, 0,-pixelskip,ox,oy)
bot = o.pointresize(ox,oy, 0, pixelskip,ox,oy)

output=Median2(lft,rgt,o,top,bot)

return(output)
}

function RegMed(input, int "radius", int "thresh", bool "chroma"){
#Regulated Median
#A limited median filter I made from the ideas in the filter Bucket Median
#new = abstract(median - old) < thresh ? median : old
#(new:filtered pix value, old:src pix value)
#^This is the main idea behind this, essentially cap the total change that
#occurs in the median and by doing this we can hopefully get a better result
thresh = default(thresh,1)
thresh = string(thresh)
radius = default(radius,1)
chroma = default(chroma,false)
median=\
(radius==1) ? input.removegrain(4, chroma==true ? 4 : 0) :\
(radius>1) ? input.medianblur(radius, chroma==true ? radius : 0, chroma==true ? radius : 0)\
: input.removegrain(4, chroma==true ? 4 : 0)
regulate=mt_lutxy(median,input,"x y - abs "+thresh+" < x y ?",y=3,v=(chroma==true ? 3 : 4),u=(chroma==true ? 3 : 4))
return(regulate)}

function MRegMed(input, int "radius", int "thresh", bool "chroma"){
#Multi-Pass Regulated Median
#
thresh = default(thresh,5)
radius = default(radius,2)
chroma = default(chroma,false)

radx2=(radius==-2) ?\
input.regmed(radius=abs(radius)-1,thresh=thresh,chroma=chroma).\
regmed(radius=abs(radius),thresh=round(thresh/2)+1,chroma=chroma)\
: input
radx3=(radius==-3) ?\
input.regmed(radius=abs(radius)-2,thresh=round(thresh/3)+1,chroma=chroma).\
regmed(radius=abs(radius)-1,thresh=round(thresh/2)+1,chroma=chroma).\
regmed(radius=abs(radius),thresh=thresh,chroma=chroma) : radx2

rad2=(radius==2) ?\
input.regmed(radius=radius,thresh=round(thresh/2)+1,chroma=chroma).\
regmed(radius=radius-1,thresh=thresh,chroma=chroma) : radx3
rad3=(radius==3) ?\
input.regmed(radius=radius,thresh=round(thresh/3)+1,chroma=chroma).\
regmed(radius=radius-1,thresh=round(thresh/2)+1,chroma=chroma).\
regmed(radius=radius-2,thresh=thresh,chroma=chroma) : rad2
return(rad3)
}
