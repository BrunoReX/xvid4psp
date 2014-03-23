#RgTools.dll
#TemporalCleaner.dll
#WarpSharp.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(256)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

TemporalCleaner (ythresh=5, cthresh=10)
Temporalsoften(2,2,2,6,2)
LSFmod(defaults="fast", preblur="ON", strength=100)
f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, input_mode=0, output_mode=0)


# Назначение: хороший фильтр для обработки качественного DVD и BD для улучшения сжатия 
# Тип основного шумоподавителя: TemporalCleaner
# Тип шарпера: LSFmod
# Скорость обработки: высокая       
