#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#ColorMatrix.dll
#mvtools2mod.dll
#nnedi3.dll
#AutoYUY2.dll
#AddGrainC.dll
#VerticalCleaner.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#unfilter.dll
#GradFun2DB.dll
#QTGMC.avs
#YV12ToYUY2imod.avs



setmtmode(2)
# setmemorymax(1024)

AssumeTFF()
Bicubicresize(720, Last.Height, -0.8, 0.6) 

QTGMC( "Fast", TR0=1,TR1=1,TR2=1, NNeurons=1, SubPelInterp=1, Sharpness=0, Edithreads=1 )

BicubicResize(Last.Width, 576, -0.8, 0.6) # for PAL

QTGMC( "Slow", TR2=1, InputType=1, Edithreads=1 )

blur(0,1).sharpen(0,0.51).blur(0,1).sharpen(0,0.85)

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=64,cb=40,cr=40,grainY=0,grainC=0)

#ColorMatrix(mode="Rec.709->Rec.601", inputFR=true, clamp=0) # for DV by Cedocida
ColorMatrix(mode="Rec.709->Rec.601", clamp=0) # for DVD

AutoYUY2()
AssumeTFF().SeparateFields().SelectEvery(4, 0, 3).Weave() 
# YV12ToYUY2imod()

# Назначение: для конвертации HDV в DV и сохранением интерлейса
# Установить тип исходного видео как прогрессивное
# Предупреждение: деинтерлейс в программе XviD 4PSP 5.0 НЕ ПОДКЛЮЧАТЬ!!!! Следует также отключить AutotoYV12 и ресайз, помимо указанного в пресете
# Пресет предназначен исключительно для формирования скрипта в XviD 4PSP 5.0 и передачи его в Rhozet Carbon Coder или ССE SP2
