#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#RemoveDirt.dll
#Warpsharp.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#Deblock.dll
#AddGrainC.dll
#VagueDenoiser.dll
#flash3kyuu_deband.dll
#Dither.dll
#Dither.avsi
#mt_xxpand_multi.avsi
#RemoveDirtMC_03.avs
#Soothe.avs
#Ylevels.avs
#LimitedSharpenFaster Mod.avs


# setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

ConvertToRGB32()
CamCD(9,1)       # удаление радужности и цветового шума
ConvertToYV12()

# Deblock with Re-Sharp
o = last
dbl = o.Deblock()                                 
dblD = mt_makediff(o,dbl,U=3,V=3)
shrpD = mt_makediff(dbl,dbl.removegrain(11),U=3,V=3)
DD = shrpD.repair(dblD,13)
d = dbl.mt_adddiff(DD,U=3,V=3) 
Soothe(d,dbl) # успокоение, если не нужно, можно убрать

source=last
filtered = source.RemoveDirt(false,23)
# filtered = RemoveDirtMC(source,40)

dark   = 32
bright = 196
mask1  = mt_lut(source,"x "+string(dark)+" < 255 x "+string(bright)+" > 255 0 ? ?",U=1,V=1).removegrain(19,-1,-1)

min   = 16
max   = 255
mask2 = mt_lutxy(source,filtered,"x y - abs "+string(min)+" < 0 x y - abs "+string(max)+" > 0 255 ? ?",U=1,V=1).removegrain(19,-1,-1)
rdr = mt_merge(source,filtered,mt_logic(mask1,mask2,"min"),luma=true)
preNR_super = filtered.MSuper(pel=2, sharp=2, rfilter=2)
rdr_super = rdr.MSuper(pel=2, sharp=2, levels=1)
tr = 3
multi_vec = MAnalyse (preNR_super, multi=true, delta=tr, blksize=16, overlap=8, chroma=true, truemotion=false)
rdr.MDegrainN (rdr_super, multi_vec, tr, thSAD=512, thSAD2=160, plane=3)
MDegrainN (rdr_super, multi_vec, tr, thSAD=400, thSAD2=150, plane=0, lsb=true)

# ==== DEBANDING ====
# f3kdb(16, 56, 36, 36, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)
GradFun3 (thr=0.42, smode=0, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.1, uvar=0, soft=2)

den = DB.DitherPost(mode=-1)
Diff1 = mt_makediff(source,den,U=3,V=3)
NR  = den.VagueDenoiser(method=4, nsteps=8, wavelet=2, Wiener=true, percent=95, chromaT=1.0, wratio=0.75, threshold=0.5)
Diff2 = mt_makediff(source,NR,U=3,V=3)
lutxy = mt_lutxy(Diff1,Diff2,"x 128 - abs y 128 - abs < x y ?")
output = source.mt_makediff(lutxy,U=3,V=3)

sharp8 = output.LSFmod(defaults="slow",preblur="ON",strength=150)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=6,ampn=1,ampo=1) 
lsb_out
YlevelsS(10,1.0,250,0,255,false)


# Назначение:для обработки старых проблемных DVD от пятен и грязи 
# Тип предварительного шумоподавителя: CamCD, DePulse, blur
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на MDegrain3 + MCompensate c RemoveDirtMC
# Тип шарпера: LSFmod 
# наличие фильтра DeBanding: включен
# Скорость обработки: медленная  
