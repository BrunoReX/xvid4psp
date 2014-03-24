#avstp.dll
#RgTools.dll
#Dither.dll
#tcanny.dll
#awarpsharp2.dll
#mt_masktools-26.dll
#mvtools2mod.dll
#dfttestmod.dll
#flash3kyuu_deband.dll
#SmoothAdjust.dll
#AddGrainC.dll
#TEdgeMask.dll
#SangNom.dll
#Toon-v1.1.dll
#aa.avs
#O16mod.avsi
#dither.avsi
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#mt_xxpand_multi.avsi
#minblur.avs
#ContraSharpen_mod_16.avsi
 

# SetMTMode(2)
# setmemorymax(1333)

source = last
W = source.width()
H = source.height()
dbmask = last.tcanny(sigma=1.7, mode=1, plane=1).mt_binarize(2, U=1, V=1).mt_expand(U=1, V=1).RemoveGrain(11, -1).RemoveGrain(20, -1)

# === Denoiced & Sharpening ====
src16 = source.aaSW(multipler=2.0,warp=false).toon(0.2).U16()
denoised = src16.dfttest(sigma=5.0, sigma2=6.0, tbsize=3, threads=1, lsb_in=true, lsb=true, Y=true, U=true, V=true)
sharp = denoised.CSmod16(src16, lsb_in=true, lsb=true, chroma=true, preblur=2, edgemode=2, mergesrc=true)

# ==== DeBanding ===
# setmtmode(5)
# db1 = sharp.LumaDBL(g1str=7, g2str=4, g3str=2, g1soft=3, g2soft=40, g3soft=60, lsb=true, lsb_in=true) 
# setmtmode(2)

db1 = sharp.GradFun3(smode=2, radius=20, thr=0.45, thrc=0.45, mask=0, lsb_in=true, lsb=true, Y=3, U=3, V=3)
db2 = db1.f3kdb(20, 64, 64, 64, 0, 0, input_mode=1, output_mode=1).Dither_limit_dif16(sharp, thr=0.60, Y=3, U=3, V=3)
DB = db2#.Dither_add_grain16 (var=0.1, uvar=0, soft=2)
 
Dither_merge16_8(DB, src16, dbmask, luma=true, Y=3, U=3, V=3)

# ==== ресайз 16-битного видео ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10 # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-бит
""") : Down10(8)                           #8-бит


# Для конвертации 8 битного исходника HD разрешения в 16 бит c шумоподавителем dfttest 
# Тип шарпера LSFmod
# DeBanding на функции LumaDBL
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile
# Установите режим многопоточности для threads=4, как setmtmode(3,4)
