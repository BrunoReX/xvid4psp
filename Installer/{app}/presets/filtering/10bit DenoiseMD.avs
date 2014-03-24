#avstp.dll
#RgTools.dll
#Warpsharp.dll
#mvtools2mod.dll
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
#DenoiseMD.avs
#HighPassSharp.avs
#FineSharp.avs
#O16mod.avsi
#LimitedSharpenFaster mod.avs


# SetMTMode(2)
# setmemorymax(1536)

W = width(last)
H = height(last)

DenoiseMD2(lsb=true, sigma=6.0, blksize=16, thcomp=96, str=0.8)
 
# ==== DeBanding ====
# setmtmode(5)
# DB = last.LumaDBL(g1str=7, g2str=4, g3str=2, g1soft=5, g2soft=10, g3soft=20, g1size=1.2, g2size=0.9, g3size=0.6, lsb=true, lsb_in=true) 
# DB = last.LumaDBL(g1str=7, g2str=4, g3str=2, g1soft=5, g2soft=10, g3soft=20, g1size=1.2, g2size=0.9, g3size=0.6, lsb=true, lsb_in=true, ditherC="f3kdb_dither()")
# setmtmode(2)

  f3kdb(16, 64, 40, 40, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)
# GradFun3(smode=1, thr=0.5,  radius=16, lsb=true, lsb_in=true)
# GradFun3(smode=0, thr=0.35, radius=12, lsb=true, lsb_in=true)
# GradFun3 (thr=1.4*0.3, smode=0, radius=12, lsb_in=true, lsb=true)
  DB = last.Dither_add_grain16 (var=0.08, uvar=0, soft=2) 

f    = DB.DitherPost (mode=-1)                      # 16 ->  8 bits

# ==== Sharpening ====
# s  = f.LSFmod(defaults="fast",strength=80)        #  8 ->  8 для разрешений до 1280х720
# s  = f.FineSharp()                                #  8 ->  8 для разрешений свыше 1280х720
  s  = f.HighPassSharp(r=0.15)                      #  8 ->  8 для разрешений свыше 1280х720

mask = mt_lutxy (s, f, "x y != 255 0 ?", u=0, v=0)  #  8, 8 ->  8
s16  = s.U16 ()                  #  8 -> 16
Dither_merge16_8 (DB, s16, mask)                    # 16, 16, 8 -> 16         

# ==== ресайз 16-битного видео ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                        # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-бит
""") : Down10(8)                           #8-бит  


# Для конвертации 8 битного исходника HD разрешения в 16 бит с фильтром DeBanding c шумоподавителем на базе векторного анализа оценки движения
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile
# Установите режим многопоточности для threads=4, как setmtmode(3,4)
