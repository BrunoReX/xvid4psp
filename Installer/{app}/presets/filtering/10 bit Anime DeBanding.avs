#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#dither.dll
#tcanny.dll
#dfttestmod.dll
#Toon-v1.1.dll
#SangNom.dll
#aWarpSharp2.dll
#checkmate.dll
#MSharpen.dll
#mt_masktools-26.dll
#SmoothAdjust.dll
#flash3kyuu_deband.dll
#dither.avsi
#aa.avs
#O16mod.avsi
#mt_xxpand_multi.avsi


# SetMTMode(2)
# setmemorymax(1000)

MergeChroma(aWarpSharp2(chroma=4))
checkmate(thr=2, max=2, tthr2=5)

src = last
dbmask = src.tcanny(sigma=1.7, mode=1, plane=1).mt_binarize(2, U=1, V=1).mt_expand(U=1, V=1).RemoveGrain(11, -1).RemoveGrain(20, -1)

aaSW(multipler=2.0,warp=false)
toon(0.2).MSharpen(threshold=10, strength=80,mask=false,highq=true)
dfttest(sigma=1.0, tbsize=1, threads=1, lsb=true)

src16 = src.U16()
db1   = last.GradFun3(smode=2, radius=20, thr=0.45, thrc=0.45, mask=0, lsb_in=true, lsb=true, Y=3, U=3, V=3)
db2   = db1.f3kdb(20, 52, 52, 52, 0, 0, input_mode=1, output_mode=1).Dither_limit_dif16(src16, thr=0.60, Y=3, U=3, V=3)

Dither_merge16_8(db2, src16, dbmask, luma=true, Y=3, U=3, V=3)

OUTPUT_BIT_DEPTH = 10 # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          # 16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         # 10-бит
""") : Down10(8)                           #  8-бит



# Для конвертации 8 битного исходника Anime в 10 бит с фильтром DeBanding
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile