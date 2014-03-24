#RgTools.dll
#TDeInt.dll
#NNEDI3.dll
#fft3dfilter.dll
#mvtools2.dll
#average.dll
#TIVTC.dll
#RestoreFPS.dll
#AddGrainC.dll
#average.dll
#mt_masktools-26.dll
#srestore.avs
#QTGMC.avs



# SetMTmode(2)
# setmemorymax(768)

AssumeTFF()
# AssumeBFF()
QTGMC( Preset="Medium", Sharpness=0.6, Edithreads=1 )
RestoreFPS(48/1.001, 0.88) # значения подобрать
SRestore(frate=23.976)

# одна из попыток убрать бленды




