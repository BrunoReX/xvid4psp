#Colormatrix.dll
#FFT3DFilter.dll
#GrapeSmoother.dll
#GetSystemEnv.dll
#TDeint.dll
#VScope.dll
#Decomb.dll
#EEDI2_imp.dll
#nnedi2.dll
#FFMpegSource.dll
#QTSource.dll
#TomsMoComp.dll
#yadifmod.dll
#ConditionalSmoothBob.avs
#hd2sd.avs


hd2sd(interlaced = true, Interlaced_out = true, ScaleRGBInput = true
\    , ExpandRGB = true, ResizeSharper = true, OutputColorSpace = "YUY2"
\    , OutputBFF = true, Output601 = true, DeintMethod = 1, HQFiltering = true
\    , VerticalBlur = 0.7, Sharpness = 0.5, NR=7, OutputHeight = 576, SmoothTime = false
\    , OutputWidth = 720, OutputWidescreen = true, WidescreenType = 0, GrapesmootherAmount = 30)


# Назначение: для конвертации HDV в DVD с частичной стабилизацией изображения и сохранением интерлейса
# По умолчанию стабилизация отключена, при съёмке без штатива подключить
# Установить тип исходного видео как прогрессивное
# Предупреждение: деинтерлейс в программе XviD 4PSP 5.0 НЕ ПОДКЛЮЧАТЬ!!!! Следует также отключить AutotoYV12 и ресайз, помимо указанного в пресете
# Пресет предназначен исключительно для формирования скрипта в XviD 4PSP 5.0 и передачи его в Rhozet Carbon Coder или ССE SP2

