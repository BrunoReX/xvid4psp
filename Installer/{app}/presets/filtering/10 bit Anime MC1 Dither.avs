#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mvtools2mod.dll
#dither.dll
#tcanny.dll
#Toon-v1.1.dll
#aWarpSharp2.dll
#dfttestmod.dll
#SangNom.dll
#checkmate.dll
#mvtools2mod.dll
#medianblur.dll
#AddGrainC.dll
#mt_masktools-26.dll
#SmoothAdjust-ICL-x86.dll
#flash3kyuu_deband.dll
#dither.avsi
#O16mod_v1.6.1.avsi
#mt_xxpand_multi.avsi
#aa.avs
#minblur.avs
#ContraHD.avs
#EdgeCleaner.avs


SetMTMode(2)
# setmemorymax(1024)

MergeChroma(aWarpSharp2(chroma=4))
# checkmate(thr=2, max=2, tthr2=5)

source = last
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
aa_clp = source.aaSW(multipler=2.0,warp=false)

# ==== Denoiced ====
pre = source.dfttest(sigma=12, tbsize=1, threads=1, lsb=true).DitherPost(mode=6)
psuper = pre.MSuper(pel=2, sharp=2, rfilter=2)
ssuper = source.MSuper(pel=2, sharp=2, levels=1)
vb1 = MAnalyse(psuper,isb=true, delta=1, blksize=8, overlap=4, truemotion=true, search=5, lambda=768)
vf1 = MAnalyse(psuper,isb=false,delta=1, blksize=8, overlap=4, truemotion=true, search=5, lambda=768)
cf1 = MCompensate(source, ssuper, vf1, thSCD1=300)
cb1 = MCompensate(source, ssuper, vb1, thSCD1=300)
interleave(cf1, source, cb1)
dfttest(sigma=8.0, tbsize=3, threads=1, lsb=true)
Selectevery(3,1)

db1 = last.GradFun3(smode=1, radius=20, thr=0.90, thrc=0.70, mask=0, lsb_in=true, lsb=true, Y=3, U=3, V=3)
db2 = db1.f3kdb(20, 64, 64, 64, 0, 0, input_mode=1, output_mode=1).Dither_limit_dif16(last, thr=0.85, Y=3, U=3, V=3)
DB  = db2#.Dither_add_grain16 (var=0.1, uvar=0, soft=2) 

den = DB.DitherPost(mode=-1)
output = mt_merge(den, aa_clp, m_aa).EdgeCleaner(smode=1, 17).toon(0.2)
sharp8 = ContraHD(output,source,cb1,cf1,3) 
Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))


OUTPUT_BIT_DEPTH = 10 # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)   #10-бит
""") : Down10(8)      #8-бит


# Для конвертации 8 битного исходника Anime в 10 бит с фильтром DeBanding
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile