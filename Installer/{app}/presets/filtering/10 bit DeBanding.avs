#avstp.dll
#RgTools.dll
#AddGrainC.dll
#dither.dll
#dfttestmod.dll
#TEdgeMask.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#SmoothAdjust.dll
#dither.avsi
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#mt_xxpand_multi.avsi
#O16mod.avsi


# SetMTMode(2)
# setmemorymax(768)

W = width(last)
H = height(last)

U16() # 8 => 16

# ==== DeBanding ====
# LumaDBL(g1str=12, g2str=6, g3str=0, g1soft=20, g2soft=40, g3soft=60, g1size=1.2, g2size=0.9, g3size=0.6, thr=0.5, lsb_in=true, lsb=true) # for anime & Cartoon
# LumaDBL(g1str=4, g2str=3, g3str=2, g1soft=5, g2soft=10, g3soft=20, g1size=1.3, g2size=1.0, g3size=0.7, thr=0.35, lsb_in=true, lsb=true) # for Films

# GradFun3(smode=1, thr=0.5,  radius=16, lsb_in=true, lsb=true)   # for anime & Cartoon
f3kdb(16, 64, 48, 48, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1) # for Films 
  
# ==== ресайз 16-битного видео ====
Dither_Resize16(W, H)

OUTPUT_BIT_DEPTH = 10 # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-бит
""") : Down10(8)                           #8-бит  


# Для конвертации 8 битного исходника в 16 бит с фильтром DeBanding
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile