#RgTools.dll
#TDeInt.dll
#mvtools2.dll
#dfttest.dll
#TIVTC.dll
#fft3dfilter.dll
#nnedi3.dll
#deen_1.0.dll
#AddGrainC.dll
#average.dll
#flash3kyuu_deband.dll
#mt_masktools-26.dll
#srestore.avs
#QTGMC.avs



# SetMTmode(2)
# setmemorymax(768)

o = last
y = o.tdeint(mode=1,order=-1) # order=0 if BBF
qtgmc = o.QTGMC(Preset="Fast",SLmode=1,SLrad=1)

qtgmc.Srestore(frate=23.976,dclip=y) 
# qtgmc.Srestore(frate=29.97,dclip=y)

# трансфер NTSC=>PAL
# qtgmc.Srestore(frate=25,dclip=y) # variant 1
# qtgmc.Srestore(mode=4,dclip=y) # variant 2

f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, input_mode=0, output_mode=0)

# для обратного трансфера  NTSC в PAL




