#avstp.dll
#FFT3DFilter.dll
#FFT3dgpu.dll
#dfttest.dll
#RgTools.dll
#mvtools2mod.dll
#TTempsmooth.dll
#EEDI2.dll
#Deblock.dll
#DctFilter.dll
#HQDn3D.dll
#Gradfun2db.dll
#WarpSharp.dll
#mt_masktools-26.dll
#Gradfun2db.dll
#AddGrainC.dll
#medianblur.dll
#awarpsharp2.dll
#DeHalo_Alpha.avs
#Deblock_QED_MT2.avs
#Gradfun2DBMod 1.5.avsi
#Ylevels.avs
#FastLineDarkenMOD.avs
#LimitedSharpenFaster mod.avs
#MCTemporalDenoise.avs


# setmemorymax(768)

ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=1,off_u=-0,off_v=-0) # коррекция яркости при кодировании XviD

string = "FFT3DGPU(sigma=3.0,sigma2=3.0,sigma3=10,sigma4=3.0,plane=3,bt=1,sharpen=0.3)"
# string = "FFT3DGPU(sigma=3.5,plane=3,bt=1).DeHalo_Alpha().FastLineDarkenMOD(strength=55, thinning=24)" # для аниме

# Setmtmode(2)
# string = "dfttest(tbsize=1,ftype=1,sigma=8).DeHalo_Alpha().FastLineDarkenMOD(strength=55, thinning=24)"

# ==== 1 variant ====
#  MCTemporalDenoise(settings="medium",sigma=6,gpu=false,ECmode=string,ECrad=4,ECthr=16,stabilize=true,enhance=true,GFthr=1.51, \
#                                    AGstr=0.3,temp=100,strength=100,SHmode=5,Tovershoot=0)

# ==== 2 variant ====
  MCTemporalDenoise(settings="high", sigma=10, twopass=true, stabilize=true, gpu=false, enhance=true, useQED=true, edgeclean=true, \
                    AGstr=1.2, GFthr=2.0, temp=100, ECrad=4, ECthr=20, ECmode=string, strength=120, SHmode=5, Tovershoot=0)
				  
YlevelsS(0,1.0,255,0,255,false) 

# Назначение: качественная обработка мультфильмов (cartoon), можно применить в качестве конечного фильтра для классического анимэ
# Тип предварительного шумоподавителя: fft3dfilter или dfttest
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на базе скрипта MCTemporalDenoise
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная