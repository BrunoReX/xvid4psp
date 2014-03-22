#Colormatrix.dll
#GrapeSmoother.dll
#FFMpegSource.dll
#QTSource.dll
#Decomb.dll
#TDeint.dll
#TomsMoComp.dll
#nnedi3.dll
#yadifmod.dll
#EEDI2_imp.dll
#ConditionalSmoothBob.avs
#sD2HD.avs


sd2hd(interlaced = true,interlaced_out = true,OutputColorSpace = "YUY2", ScaleMethod = 2, OutputWidth = 1440
\    , OutputHeight = 1080, DeintMethod = 1, Sharpness = 0.75, NRStrength = 25, OutputBFF = true)


# Назначение: для конвертации HDV в DVD с частичной стабилизацией изображения и сохранением интерлейса
# По умолчанию стабилизация отключена, при съёмке без штатива подключить
# Установить тип исходного видео как прогрессивное
# Предупреждение: деинтерлейс в программе XviD 4PSP 5.0 НЕ ПОДКЛЮЧАТЬ!!!! Следует также отключить AutotoYV12 и ресайз, помимо указанного в пресете
# Пресет предназначен исключительно для формирования скрипта в XviD 4PSP 5.0 и передачи его в Rhozet Carbon Coder или ССE SP2

