#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Depan.dll
#DepanEstimate.dll
#WarpSharp.dll
#RgTools.dll
#mvtools2.dll
#mt_masktools-26.dll
#DeJitter.dll
#DeScratch.dll
#Fluxsmooth.dll
#AddGrainC.dll
#Gradfun2DB.dll
#awarpsharp2.dll
#RemoveColorBleeding.avs
#stab.avs
#deVCR.avs
#Fizzkiller.avs
#Gradfun2dbmod 1.5.avsi


# setmtmode(2)
# setmemorymax(640)

ConvertToRGB32()
CamCD(12,1)       # подавление цветового шума камкодеров
converttoyv12()

# DeScratch(mindif=4, maxgap=20, minlen=300, blurlen=50, keep=100, border=0, maxangle=0) # удаление царапин и полос старых киноплёнок
# DeJitter(last,jmax=10,th=80, wsyn=8, extend=true)

# Убираем горизонтальные линии нарезки VHS
#  deVCR(last,30)

# Удалить Colorbleeding (размытость цветовых контуров)
 RemoveColorBleeding() 
 
# Удалить VHS colorshift (цветовой сдвиг)
Vshift=2  # 2 пикселя на ленте 
Hshift=0 
mergechroma(last.crop(Hshift,Vshift,0,0, align=true).addborders(0,0,Hshift,Vshift)) 

# Частичная стабилизация изображения
# Stab()

# Шумоподавление
Fizzkiller(degrain=3, blksize=16, thSAD=480, chroma=false).FluxSmoothST(5,5).unsharpmask(40,1,0)

sharpen(0.3).sharpen(0.3).blur(0.15)
Gradfun2dbmod(thr=1.51,thrC=2.0,str=1.0,temp=50,adapt=64)
coloryuv(off_U=-0,off_V=-0).levels(0,1.0,255,0,255)

# Назначение: для качественной обработки DVC VHS с частичной стабилизацией изображения 
# Наличие фильтра подавления радужности изображения и цветового шума: включен
# Тип предварительного шумоподавителя: RemoveDirtMC
# Тип основного шумоподавителя: на основе векторного анализа оценки движения с шумоподавлением: MDegrain3
# Тип шарпера: unsharpmask + LSFmod
# Скорость обработки: медленная
# Рекомендуемый деинтерлейс SmoothDeInterlace или YadifmodNNEDI3 (х2)


