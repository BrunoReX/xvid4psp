#avstp.dll
#RemoveGrainSSE209.dll
#RemoveGrainSSE2.dll
#RepairSSE3.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#medianblur.dll
#Flux5framesT.avs
#minblur.avs
#ContraHD.avs
#Ylevels.avs


setmtmode(2)
setmemorymax(640)
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)

o = last
low = o.bicubicresize(72,56).bicubicresize(216,168,1,0).bicubicresize(720,576,1,0)
ld = mt_lutxy(o,low,"x y < x 1 - x y > x 1 + x ? ?",U=2,V=2)
super = o.msuper(pel=1)
bv1 = super.MAnalyse(isb=true, truemotion=false,global=true,delta=1,blksize=16,overlap=8,search=4,searchparam=4,DCT=0)
fv1 = super.MAnalyse(isb=false,truemotion=false,global=true,delta=1,blksize=16,overlap=8,search=4,searchparam=4,DCT=0)
cb1 = o.mcompensate(super,bv1,thSCD1=300)
cf1 = o.mcompensate(super,fv1,thSCD1=300)
interleave(o.selectevery(1,-2),cf1,ld,cb1,o.selectevery(1,2))
search = removegrain(4,0).Flux5framesT(15).selectevery(5,2)#.removegrain(11) # Flux(15) is pretty high, but hey ... it's quite some grain that needs to be catched
ContraHD(search,o,cb1,cf1,0)
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)
# YlevelsS(0,1.0,255,0,255)



