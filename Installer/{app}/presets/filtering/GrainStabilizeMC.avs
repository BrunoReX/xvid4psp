#avstp.dll
#RgTools.dll
#Warpsharp.dll
#mvtools2mod.dll
#Dither.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#Dither.avsi
#mt_xxpand_multi.avsi
#GrainStabilizeMC_v0.4.avsi
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
  
# ==== Denoiced ==== 
  GSMC(nrmode=1,radius=2,adapt=64,rep=13,lsb=true)
# GSMC(preset ="Very Fast",lsb_out=true)
# GSMC(preset ="Faster",lsb_out=true)
# GSMC(preset ="Fast",lsb_out=true)
# GSMC(preset ="Medium",lsb_out=true)
# GSMC(preset ="Slow",lsb_out=true)
# GSMC(preset ="Slower",lsb_out=true)
# GSMC(preset ="Very Slow",lsb_out=true)

# DEBANDING
  DB = last.GradFun3(smode=0, thr=0.35, radius=12, lsb_in=true, lsb=true)
# DB = last.f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)

output = DB.DitherPost(mode=-1) 

# ==== Sharpening ====
sharp8 = output.LSFmod(defaults="slow", strength=90)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out 



# Назначение: качественный пресет для создания DVDRip 
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrainN + Dither
# Тип шарпера: Contrasharpening
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная

