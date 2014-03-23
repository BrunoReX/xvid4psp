#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#mvtools2.dll
#fft3dgpu.dll
#mt_masktools-26.dll
#Gradfun2db.dll
#AddGrainC.dll
#vinverse.dll
#SmoothAdjust.dll
#Gradfun2dbmod 1.5.avsi


setmtmode(2)
# setmemorymax(640)

# vinverse() # удаление остатков гребёнки

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
  
# удаление радужности и цветового шума
  ConvertToRGB32().CamCD(12,1).ConvertToYV12() 

SmoothCurve(Ycurve="0-0;8-0;244-255;255-255", Ucurve="0-0;8-0;248-255;255-255", Vcurve="0-0;8-0;248-255;255-255", interp=0) 
SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# ==== цветокоррекция при преобладании жёлто-зелёных цветов ====
# str=4
# thr=32
# SmoothCurve(Ucurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr+str)+";128-128;"+string(128+thr)+"-"+string(128+thr-str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255"\
#           ,Vcurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr-str)+";128-128;"+string(128+thr)+"-"+string(128+thr+str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255") 
 
source=last
preNR = source.blur(1.2)
preNR_super = preNR.MSuper(pel=2, sharp=2, rfilter=2)
source_super = source.MSuper(pel=2, sharp=2, levels=1)
vb2 = MAnalyse(preNR_super, isb=true,truemotion=false,delta=2,blksize=16,overlap=4,lambda=2000,pelsearch=2,search=3,DCT=5)
vb1 = MAnalyse(preNR_super, isb=true,truemotion=false,delta=1,blksize=16,overlap=4,lambda=2000,pelsearch=2,search=3,DCT=5)
vf1 = MAnalyse(preNR_super,isb=false,truemotion=false,delta=1,blksize=16,overlap=4,lambda=2000,pelsearch=2,search=3,DCT=5)
vf2 = MAnalyse(preNR_super,isb=false,truemotion=false,delta=2,blksize=16,overlap=4,lambda=2000,pelsearch=2,search=3,DCT=5)
source.MDegrain2(source_super,vb1,vf1,vb2,vf2,thSAD=350)
setmtmode(5)
fft3dgpu(wintype=1,bt=3,bw=16,bh=16,ow=8,oh=8,degrid=1,sigma=3.0,sigma2=2.5,sigma3=2.0,sigma4=6,plane=4,sharpen=0.5)
setmtmode(2)
Gradfun2dbmod(thr=1.4,thrC=1.8,mode=2,str=0.8,temp=50)


# Назначение: великолепный пресет для обработки TV, SAT и проблемного DVD источника со спецобработкой SmoothLevels и анти-aйлизнгом
# Тип предварительного шумоподавителя: блюр
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на двухэтапном шумоподавителе MDegrain2 + fft3dfilter
# Тип шарпера: LSFmod 
# наличие фильтра DeBanding: включен
# Скорость обработки: медленная  

