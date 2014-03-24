#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#ReduceFlicker.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#Warpsharp.dll
#AddGrainC.dll
#VagueDenoiser.dll
#flash3kyuu_deband.dll
#Dither.dll
#Dither.avsi
#mt_xxpand_multi.avsi
#Ylevels.avs
#LimitedSharpenFaster Mod.avs


# setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

ConvertToRGB32()
CamCD(7,1)       # удаление радужности и цветового шума
ConvertToYV12()

source = last
tr = 3
# Prefilter the clip
calm = source.reduceflicker(strength=3,aggressive=true)
calm = calm.repair(source,mode=1)
calm = calm.removegrain(mode = 17)
calm = calm.removegrain(mode = 17)
calm = calm.removegrain(mode = 17)

calm_super = calm.MSuper(pel=2, sharp=2, rfilter=2)
source_super = source.MSuper(pel=2, sharp=2, levels=1)
multi_vec = MAnalyse (calm_super, multi=true, delta=tr, blksize=16, overlap=8, chroma=true, truemotion=false)
source.MDegrainN (source_super, multi_vec, tr, thSAD=550, thSAD2=170, plane=3)
MDegrainN (source_super, multi_vec, tr, thSAD=400, thSAD2=150, plane=0, lsb=true)

# DEBANDING
# GradFun3(smode=0, thr=0.35, lsb_in=true, lsb=true)
# DB = last.Dither_add_grain16 (var=0.05, uvar=0, soft=2)
DB = last.f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)

den = DB.DitherPost(mode=-1)
Diff1 = mt_makediff(source,den,U=3,V=3)
NR  = den.VagueDenoiser(method=4, nsteps=6, wavelet=2, Wiener=true, auxclip=calm, percent=95, chromaT=1.3, wratio=0.75, threshold=0.8)
Diff2 = mt_makediff(source,NR,U=3,V=3)
lutxy = mt_lutxy(Diff1,Diff2,"x 128 - abs y 128 - abs < x y ?")
output = source.mt_makediff(lutxy,U=3,V=3)

sharp8 = output.LSFmod(defaults="slow",preblur="ON",strength=130)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost() 
lsb_out
YlevelsS(10,1.0,250,0,255,false)


# Назначение: Для качественной обработки сильно зашумленного любого типа видеоматериала  на базе скрипта Killer
# Тип предварительного шумоподавителя: reduceflicker с removegrain(mode = 17)
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain1,2 или 3
# Тип шарпера: LSFmod с блюром
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная



