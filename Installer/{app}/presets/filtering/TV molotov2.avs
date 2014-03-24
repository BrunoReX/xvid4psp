#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#mvtools2.dll
#vinverse.dll
#fft3dgpu.dll
#SmoothAdjust.dll
#mt_masktools-26.dll
#deen.dll
#defreq.dll
#AddGrainC.dll
#GradFun2DB.dll
#GradFun2DBmod 1.5.avsi

# setmtmode(2)
# setmemorymax(640)

# vinverse() # удаление остатков гребёнки
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# DeFreq(fx=30,fy=-40) # удаление частотных наводок

# удаление радужности и цветового шума
ConvertToRGB32().CamCD(15,1).ConvertToYV12() 

source = last
preNR=source.blur(1.2)
preNR_super = preNR.MSuper(pel=2, sharp=2, rfilter=2, chroma=false)
source_super = source.MSuper(pel=2, sharp=2, chroma=false, levels=1)
vb2 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=2, blksize=16, overlap=8, chroma=false)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=1, blksize=16, overlap=8, chroma=false)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=1, blksize=16, overlap=8, chroma=false)
vf2 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=2, blksize=16, overlap=8, chroma=false)
source.MDegrain2(source_super,vb1,vf1,vb2,vf2,thSAD=400,plane=0)
MergeLuma(deen("a2d",3,0,14),\
FFT3DGPU(bw=24,bh=24,ow=12,oh=12,bt=3,sigma=3.0,sigma2=2.7,sigma3=2.5,sigma4=6.0,plane=0,sharpen=0.6))

SmoothCurve(Ycurve="0-0;8-0;244-255;255-255", Ucurve="0-0;8-0;248-255;255-255", Vcurve="0-0;8-0;248-255;255-255", interp=0) 
SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code
# DeBanding
GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=0.8,strC=0.0,temp=50,adapt=64)


# Назначение: прекрасный пресет для обработки сильно зашумленного TV сигнала с удалением интерференционных полос-наводок в телесигнале
# Тип предварительного шумоподавителя: degrainmedian 
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain1 и FFT3Dfilter
# Скорость обработки: медленная       



