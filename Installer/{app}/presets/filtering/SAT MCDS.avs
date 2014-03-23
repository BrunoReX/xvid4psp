#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#mvtools2mod.dll
#Bifrost.dll
#mt_masktools-26.dll
#SmoothAdjust.dll
#flash3kyuu_deband.dll


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

ConvertToRGB32().CamCD(2,1).ConvertToYV12()
  
source = last
sharp = source.mt_adddiff(mt_makediff(source,source.removegrain(4)),U=2,V=2) 
source_super = source.MSuper(pel=2, sharp=2, rfilter=2, chroma=false)
sharp_super = sharp.MSuper(pel=2, sharp=2, levels=1, chroma=false)
b1v = MAnalyse(source_super, isb=true, truemotion=false, delta=1, blksize=16, overlap=4, search=4, chroma=false)
f1v = MAnalyse(source_super,isb=false, truemotion=false, delta=1, blksize=16, overlap=4, search=4, chroma=false)
cf1 = MCompensate(source, sharp_super, f1v)
cb1 = MCompensate(source, sharp_super, b1v)
max = mt_logic(cb1,cf1,"max").mt_logic(source,"max")
min = mt_logic(cb1,cf1,"min").mt_logic(source,"min")
sharp1 = source.sharpen(0.4)
sharp1.mt_clamp(max,min,0,0,U=2,V=2)

super = MSuper(pel=2,sharp=2,rfilter=2, chroma=false)
bv2 = MAnalyse(super, isb = true, truemotion=false, delta=2, blksize=16, overlap=4, search=4, chroma=false)
# bv1 = MAnalyse(super, isb = true, truemotion=false, delta=1, blksize=16, overlap=4, search=4, chroma=false)
# fv1 = MAnalyse(super,isb = false, truemotion=false, delta=1, blksize=16, overlap=4, search=4, chroma=false)
fv2 = MAnalyse(super,isb = false, truemotion=false, delta=2, blksize=16, overlap=4, search=4, chroma=false)
# den = MDegrain2(super, bv1, fv1, bv2, fv2, thSAD=150, plane=0)
den = MDegrain2(super, b1v, f1v, bv2, fv2, thSAD=150, plane=0).Temporalsoften(2,1,1,6,2)

smD = mt_makediff(source,den,U=3,V=3)
source.mt_makediff(smD,U=3,V=3)

# LEVELS
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# ==== цветокоррекция при преобладании жёлто-зелёных цветов ====
# str=3
# thr=32
# SmoothCurve(Ucurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr+str)+";128-128;"+string(128+thr)+"-"+string(128+thr-str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255"\
#            ,Vcurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr-str)+";128-128;"+string(128+thr)+"-"+string(128+thr+str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255") 

# ENHANCING
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)


# Назначение: прекрасный пресет для "мягкого" SATRemux с повышением резкости движущего объекта 
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain2
# Тип шарпера: "median sharpen" 
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная     
