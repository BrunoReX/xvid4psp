#avstp.dll
#RemovegrainSSE2.dll
#RepairSSE2.dll
#dfttestmod.dll
#mvtools2mod.dll
#medianblur.dll
#Dither.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#mt_xxpand_multi.avsi
#Dither.avsi
#minblur.avs
#ContraHD.avs


SetMTMode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0) 
 
source = last
preNR = source.dfttest(sigma=12,tbsize=1,lsb=true,threads=1).ditherpost(mode=6)
psuper = preNR.MSuper(pel=2, sharp=2, rfilter=2)
ssuper = source.MSuper(pel=2, sharp=2, rfilter=2, levels=1)
b2v = MAnalyse(psuper,isb=true, delta=2, blksize=16, overlap=8, truemotion=false)
b1v = MAnalyse(psuper,isb=true, delta=1, blksize=16, overlap=8, truemotion=false)
f1v = MAnalyse(psuper,isb=false,delta=1, blksize=16, overlap=8, truemotion=false)
f2v = MAnalyse(psuper,isb=false,delta=2, blksize=16, overlap=8, truemotion=false)
cf2 = MCompensate(source, ssuper, f2v, thSCD1=400)
cf1 = MCompensate(source, ssuper, f1v, thSCD1=400)
cb1 = MCompensate(source, ssuper, b1v, thSCD1=400)
cb2 = MCompensate(source, ssuper, b2v, thSCD1=400)
interleave(cf2, cf1, source, cb1, cb2)
dfttest(sigma=6.0, tbsize=5, lsb=true, threads=1)
Selectevery(5,2)

# ==== DEBANDING ====
DB = last.f3kdb(16, 64, 40, 40, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)#.Dither_limit_dif16(last, thr=0.25, Y=3, U=3, V=3)
# DB = last.GradFun3 (thr=0.35, smode=0, radius=12, lsb_in=true, lsb=true)

output = DB.DitherPost(mode=-1) 

# === ContraHD ====
sharp8 = ContraHD(output,source,cb1,cf1,3) 
Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
DitherPost(mode=6,ampo=1,ampn=1)
# DitherPost(mode=6,ampo=0,ampn=1)  


# Назначение: Качественный пресет для обработки DVD средней зашумленности
# Тип шумоподавителя: на основе векторного анализа оценки движения на функции MCompensate с конечным фильтром dfttest 
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная                     





