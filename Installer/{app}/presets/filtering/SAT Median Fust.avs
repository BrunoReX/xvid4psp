#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#SmoothAdjust.dll
#medianblur.dll
#RgTools.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#fluxsmooth.dll
#SmoothContrast.avsi


# setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# удаление радужности и цветового шума
  ConvertToRGB32().CamCD(4,1).ConvertToYV12() 
  
  o  = last
  m2 = o.removegrain(11,0).medianblur(2,0,0).removegrain(11,20)
  m2.fluxsmootht(5).mt_adddiff(mt_makediff(o,m2,U=3,V=3).mt_lut("x 128 - abs 1 < x x 128 - abs 1 - 0.751 * x 128 - x 128 - abs 0.001 + / * 128 + ?",U=2,V=2),U=3,V=3)

# SmoothContrast(contrast=0.02) 
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code
  
# DeBanding
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)

# Ќазначение: дл€ обработки исходника DVB с крупно-зернистым шумом
# “ип шумоподавител€: на основе CamCD + removegrain + medianblur + fluxsmootht
# —корость обработки:  быстра€     