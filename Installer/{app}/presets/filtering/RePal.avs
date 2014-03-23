#RgTools.dll
#NNEDI3.dll
#fft3dfilter.dll
#mvtools2.dll
#average.dll
#LGhost.dll
#repal.dll
#awarpsharp2.dll
#AddGrainC.dll
#GradFun2DB.dll
#mt_masktools-26.dll
#srestore.avs
#QTGMC.avs
#GradFun2DBmod.avs
 
 
 
AssumeTFF() 
# AssumeBFF()
QTGMC( Preset="Slower", tr2=2, Sharpness=0.9, Edithreads=1, dct=1 )

repal() # трансфер NTSC=>PAL
# srestore(Frate=24.975)
mergechroma( awarpsharp2(depth=12,thresh=255,blur=3) )

# удаление €ркостной наводки
# LGhost(2, 0, 16, 2, 0, 14, 1, 0, 14, 1, 0, 14) # подобрать параметры начина€ с mode
 #### Sintax: LGhost(clip, mode0, shift0, intensity0, ... , mode17, shift17, intensity17)
 #### mode 0 : (default), 1 : 2 : 3 : 4
 #### shift (-clip.width Вclip.width, default 0)
 #### intensity (-128 В 127, default 0)

GradFun2DBmod(thr=1.4,thrC=1.6,str=0.3,strC=0.0,temp=50,adapt=64)

# дл€ обратного трансфера  NTSC в PAL
