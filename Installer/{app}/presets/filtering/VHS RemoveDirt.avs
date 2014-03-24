#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#RemoveDirt.dll
#Warpsharp.dll
#mvtools2.dll
#Deblock.dll
#DctFilter.dll
#medianblur.dll
#mt_masktools-26.dll
#Deblock_QED_MT2.avs
#deen.dll
#fft3dfilter.dll
#fft3dgpu.dll
#awarpsharp2.dll
#focus.avs
#minblur.avs
#AddGrainC.dll
#Gradfun2DB.dll
#deVCR.avs
#RemoveColorBleeding.avs
#RemoveDirtMC.avs
#LimitedSharpenFaster.avs
#Gradfun2dbmod 1.5.avsi


# setmtmode(2)
# setmemorymax(640)

ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=1,off_u=-0,off_v=-0) # коррекция яркости при кодировании XviD
  
# ==== Подавление цветового шума и радужности изображения ==== 
  ConvertToRGB32().CamCD(5,1).ConvertToYV12() # вариант 1

# setmtmode(5)
# fft3dgpu(bw=32,bh=32,ow=16,oh=16,bt=1,sigma=2.5,sigma2=1.75,sigma3=8.0,sigma4=2.0,plane=3,sharpen=0.3) # вариант 2
# setmtmode(2) 

# ==== удаление белых и чёрных стрелок VHS ====
# ConvertToYUY2().DePulse(h=180, l=60, d=30, debug=false).ConvertToYV12() 

# Удалить Colorbleeding (размытость цветовых контуров)
RemoveColorBleeding() 
 
# ==== Устранение VHS цветового сдвига (colorshift), требует ручной подстройки ====
Vshift=2  # 2 пикселя на ленте 
Hshift=0 
mergechroma(last.crop(Hshift,Vshift,0,0, align=true).addborders(0,0,Hshift,Vshift))

# ==== Deblocking ====
# Deblock_QED(uv=3) # подключить при блочности исходника

# ==== Многокаскадный фильтр ремонта горизонтальных линий затиров VHS ====
deVCR(30)#.deVCR(0)#.deVCR(0) 
 
# ==== Ремонт полосы нарезки и наложение её на исходник ==== 
# source = last
# filtered = source.RemoveDirtMC(false,10).RemoveDirt().RemoveDust(3)
# top = filtered.crop(0,300,0,-144,true) # где в данном случае 300-высота в клипе выше полосы нарезки,-160 -высота в клипе ниже линии нарезки приведены для примера
# Overlay(source,top,y=300).tweak(sat=1.05) # привязку сопоставить с кропом сверху

# ==== Двухкаскадный  временнОй и пространственно-временнОй шумоподавитеь ====
rdr = last
psup = rdr.blur(1.5).MSuper(pel=2, sharp=2, rfilter=4) # закрыть при ремонте полосы нарезки
# psup = filtered.MSuper(pel=2, sharp=2, rfilter=4) # открыть при ремонте полосы нарезки
rsup = rdr.MSuper(pel=2, sharp=2, rfilter=2, levels=1)
vb2 = MAnalyse(psup, isb=true, truemotion=false, delta=2, blksize=16, overlap=4, dct=5)
vb1 = MAnalyse(psup, isb=true, truemotion=false, delta=1, blksize=16, overlap=4, dct=5)
vf1 = MAnalyse(psup,isb=false, truemotion=false, delta=1, blksize=16, overlap=4, dct=5)
vf2 = MAnalyse(psup,isb=false, truemotion=false, delta=2, blksize=16, overlap=4, dct=5)
NR = rdr.MDegrain2(rsup,vb1,vf1,vb2,vf2,thSAD=400,plane=3)
den = NR.MDegrain2(rsup,vb1,vf1,vb2,vf2,thSAD=400,plane=0)
dsup = den.MSuper(pel=2,levels=1,chroma=true)
cf2 = MCompensate(den, dsup, vf2, thSCD1=500)
cf1 = MCompensate(den, dsup, vf1, thSCD1=500)
cb1 = MCompensate(den, dsup, vb1, thSCD1=500)
cb2= MCompensate(den, dsup, vb2, thSCD1=500)
interleave(cf2, cf1, den, cb1, cb2)
MedianblurT(0,0,0,1) 
SelectEvery(5,2)
MergeLuma(deen("a2d",3,0,12),\
 fft3dfilter(wintype=1,bt=3,bw=32,bh=32,ow=16,oh=16,degrid=1,sigma=1.5,plane=0))

# ==== Sharpening ====
Sclp = last.LimitedSharpenfaster(ss_x=2.0,ss_y=2.0,smode=3,strength=170)
Tmax = rdr.mt_logic(cf1,"max",U=1,V=1).mt_logic(cb1,"max",U=1,V=1)
Tmin = rdr.mt_logic(cf1,"min",U=1,V=1).mt_logic(cb1,"min",U=1,V=1)
sharp =Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)

focus(sharp, sharp.width, sharp.height)
 
# Дебандинг
GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=1.0,strC=0.0,temp=50,adapt=64)

# Назначение:для обработки старых проблемных DVD 
# Тип предварительного шумоподавителя: CamCD, DePulse, blur, RemoveDirtMC, RemoveDirt и RemoveDust
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на MDegrain2+ MCompensate c MedianblurT
# Тип шарпера: LimitedSharpenfaster
# наличие фильтра DeBanding: включен
# Скорость обработки: медленная  
