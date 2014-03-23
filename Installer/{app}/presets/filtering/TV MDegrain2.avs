#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#degrainmedian.dll
#mvtools2.dll
#ttempsmooth.dll
#mt_masktools-26.dll
#vinverse.dll
#AddGrainC.dll
#GradFun2DB.dll
#SmoothAdjust.dll
#minblur.avs
#ContraSharpening.avs
#GradFun2DBmod 1.5.avsi
#Ylevels.avs


setmtmode(2)
# setmemorymax(640)
# vinverse() # удаление остатков гребёнки
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

ConvertToRGB32()
CamCD(20,1)       # удаление радужности и цветового шума
converttoyv12()

source = last
preNR=source.blur(1.2)
preNR_super = preNR.MSuper(pel=2, sharp=2, rfilter=4)
source_super = source.MSuper(pel=2, sharp=2, levels=1)
vb2 = MAnalyse(preNR_super, isb=true,truemotion=false,delta=2,blksize=16,overlap=4,pelsearch=2,search=3,DCT=5)
vb1 = MAnalyse(preNR_super, isb=true,truemotion=false,delta=1,blksize=16,overlap=4,pelsearch=2,search=3,DCT=5)
vf1 = MAnalyse(preNR_super,isb=false,truemotion=false,delta=1,blksize=16,overlap=4,pelsearch=2,search=3,DCT=5)
vf2 = MAnalyse(preNR_super,isb=false,truemotion=false,delta=2,blksize=16,overlap=4,pelsearch=2,search=3,DCT=5)
denoiced = source.MDegrain2(source_super,vb1,vf1,vb2,vf2,thSAD=400).ttempsmooth()
ContraSharpening(denoiced,source)

SmoothCurve(Ycurve="0-0;8-0;244-255;255-255", Ucurve="0-0;8-0;248-255;255-255", Vcurve="0-0;8-0;248-255;255-255", interp=0) 
SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# DeBanding
GradFun2DBmod(thr=1.4,thrC=1.4,mode=2,str=0.8,strC=0.0,temp=50,adapt=64)


# Назначение: хороший пресет для обработки TV сигнала с спецобработкой SmoothLevels и анти-aйлизингом
# Тип предварительного шумоподавителя: CamCD + блюр
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain2
# Тип сглаживателя: временной ttempsmooth
# Тип шарпера: Contra-Sharpening
# Скорость обработки: ниже средней       