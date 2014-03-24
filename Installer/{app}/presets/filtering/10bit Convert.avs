#avstp.dll
#RgTools.dll
#Dither.dll
#flash3kyuu_deband.dll
#SmoothAdjust.dll
#mt_masktools-26.dll
#Dither.avsi
#O16mod.avsi

 

# SetMTMode(2)
# setmemorymax(640)

W = width(last)
H = height(last)

U16()

# ==== ресайз 16-битного видео ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                      # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-бит
""") : Down10(8)                           #8-бит 


# Для конвертации 8 битного исходника в 16 бит
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile

