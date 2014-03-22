#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#SmoothAdjust-ICL-x86.dll
#medianblur.dll
#RemoveGrainSSE2.dll
#mt_masktools-26.dll
#mvtools2mod.dll
#fluxsmooth.dll
#flash3kyuu_deband.dll
#SmoothContrast.avsi


  setmtmode(2)
# setmemorymax(640)

# vinverse() # удаление остатков гребёнки
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

ConvertToRGB32().CamCD(7,1).ConvertToYV12() # удаление радужности и цветового шума  

o = last
m2 = o.medianblur(2,0,0).removegrain(11)
lop = m2.fluxsmootht(5)
sup1 = lop.msuper(pel=2, chroma=false)
sup2 = m2.msuper(pel=2, levels=1, chroma=false)
bv1 = sup1.manalyse(isb=true, delta=1,blksize=16,overlap=8,truemotion=false,chroma=false,search=5,dct=5)
fv1 = sup1.manalyse(isb=false,delta=1,blksize=16,overlap=8,truemotion=false,chroma=false,search=5,dct=5)
bv2 = sup1.manalyse(isb=true, delta=2,blksize=16,overlap=8,truemotion=false,chroma=false,search=5,dct=5)
fv2 = sup1.manalyse(isb=false,delta=2,blksize=16,overlap=8,truemotion=false,chroma=false,search=5,dct=5)

KEEP = "0.75" # какое количество HiFreq-зерна надо сохранить. 0.0=ничего не сохраняем, 1.0=оставляем всё. !! String -это заданная величина !!
m2.mdegrain2(sup2,bv1,fv1,bv2,fv2,thSAD=300,plane=0).mergechroma(last)
 \.mt_adddiff(mt_makediff(o,m2,U=3,V=3).mt_lut("x 128 - abs 1 < x x 128 - abs 1 - "+KEEP+" * x 128 - x 128 - abs 0.001 + / * 128 + ?",U=2,V=2),U=3,V=3)

# LEVELS
  SmoothContrast(contrast=0.02) 
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=-1) # -1 -automatic choice, 1- SSE2 CPU, 2 - Sandy Bridge CPU
  
# ==== цветокоррекция при преобладании жёлто-зелёных цветов ====
#str=3 # значение подобрать
#thr=32
#SmoothCurve(Ucurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr+str)+";128-128;"+string(128+thr)+"-"+string(128+thr-str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255"\
#           ,Vcurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr-str)+";128-128;"+string(128+thr)+"-"+string(128+thr+str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255") 

# Debanding
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=88,cb=64,cr=64,grainY=0,grainC=0)

