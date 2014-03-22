#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RemoveGrainSSE2.dll
#RemoveGrainTSSE2.dll
#RemoveDirt.dll
#RepairSSE3.dll
#mt_masktools-26.dll
#mvtools2.dll
#SmoothAdjust-ICL-x86.dll
#RemovedirtMC_03.avs
#degrainmedian.dll
#vinverse.dll
#Warpsharp.dll
#AddGrainC.dll
#Gradfun2db.dll
#FluxSmooth.dll
#GradFun2DBmod 1.5.avsi


setmtmode(2)
# setmemorymax(640)

Vinverse() # удаление остатков гребёнки

ConvertToRGB32().CamCD(5,1).converttoyv12() 
SmoothLevels(useopt=-1) # -1 -automatic choice, 1- SSE2 CPU, 2 - Sandy Bridge CPU

source = last
filtered = source.RemoveDirt(false,16)
# filtered = RemoveDirtMC(source,40)

dark   = 32
bright = 196
mask1  = mt_lut(source,"x "+string(dark)+" < 255 x "+string(bright)+" > 255 0 ? ?",U=1,V=1).removegrain(19,-1,-1)

min   = 16
max   = 255
mask2 = mt_lutxy(source,filtered,"x y - abs "+string(min)+" < 0 x y - abs "+string(max)+" > 0 255 ? ?",U=1,V=1).removegrain(19,-1,-1)
rdr = mt_merge(source,filtered,mt_logic(mask1,mask2,"min"),luma=true)
super = rdr.MSuper(pel=2, sharp=2, rfilter=2)
vb2 = MAnalyse(super, isb=true, truemotion=false, delta=2, blksize=16, overlap=8) # при мерцании по яркости ввести dct=5 или dct=1
vb1 = MAnalyse(super, isb=true, truemotion=false, delta=1, blksize=16, overlap=8)
vf1 = MAnalyse(super,isb=false, truemotion=false, delta=1, blksize=16, overlap=8)
vf2 = MAnalyse(super,isb=false, truemotion=false, delta=2, blksize=16, overlap=8)
rdr.MDegrain2(super,vb1,vf1,vb2,vf2,thSAD=400).FluxSmoothST(5,5).unsharpmask(20,1,0)

# SHARPENING
sharpen(0.3).sharpen(0.3).blur(0.2)

# ENHANCING
GradFun2DBmod(thr=1.4,thrC=1.6,str=0.8,strC=0.0,temp=50,adapt=64)

# для обработки проблемных исходников DVB типа телеканалов ИНТЕР и ТРК УКРАИНА



