#TIVTC.dll
#a60224.dll
#TDeint.dll
#nnedi3.dll
#TMM.dll
#vinverse.dll
#RgTools.dll
#dfttestmod.dll
#awarpsharp2.dll
#mt_masktools-26.dll
#SangNom.dll
#Unfilter.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#Dither.avsi
#EdgeCleaner.avs
#mt_xxpand_multi.avsi
#Dehalo_alpha.avs
#aa.avs
#AAD.avs
#FastLineDarken 1.4x MT MOD.avsi


# ==== DeInterlaced ====
# AAD(mode=1,tff=true,debug=false,finalpass=true,ivtc2pass=true,ivtc3pass=true,ultimate=false)
# TFM(mode=5, PP=6, slow=2, scthresh=12.0, cthresh=9, MI=80).TDecimate(mode=1, hybrid=0, vfrDec=1)

setmtmode(2)
# setmemorymax(640)

# набор необходимых масок
m_edge = mt_edge("sobel", 7, 20).mt_inflate()
m_aa   = m_edge.mt_expand() # маска для антиайлиазинга
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -") # маска для DeHalo

aa_clp = AAA() # антиайлиазинг
dh_clp = aa_clp.Dehalo_alpha() # подавление ореолов
dfttest(sigma=8, tbsize=1, threads=1, lsb=true) # denoiced

# ===== DeBanding =====
# setmtmode(5) 
# DB = last.LumaDBL(g1str=8, g2str=4, g3str=0, lsb=true, lsb_in=true)
# setmtmode(2)  
# DB = last.GradFun3(smode=1, thr=0.35, radius=12, lsb=true, lsb_in=true)
  db1 = last.GradFun3 (thr=1.4*0.3, smode=1, radius=12, lsb_in=true, lsb=true)
  db2 = db1.f3kdb(16, 52, 48, 48, 0, 0, input_mode=1, output_mode=1).Dither_limit_dif16(last, thr=0.45, Y=3, U=3, V=3)
  DB = db2#.Dither_add_grain16 (var=0.1, uvar=0, soft=2) # добавление динамического зерна

nr_clp = DB.DitherPost(mode=-1)
non_hl = mt_merge(nr_clp, aa_clp, m_aa)
mt_merge(non_hl, dh_clp, m_halo)
smE = last.EdgeCleaner(smode=1, 20)

# ===== затемнение линий =====
dark = ConditionalFilter(smE.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200).aWarpSharp2(thresh=48, depth=4), smE, "AverageLuma()",">","50")

sharp8 = dark.sharpen(0.25)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, dark))
# lsb_out = lsbctr.DitherPost(mode=6) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0)   # for x264 encode 
lsb_out


# Типовой скрипт обработки аниме
# Подавление радужности изображения по умолчанию: нет
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: AAA
# Тип шумоподавителя: dfttestmod
# Тип шарпера: sharpen 
# Наличие фильтра DeBanding по умолчанию: GradFun3
# Скорость обработки: средняя
# ВНИМАНИЕ!!! В случае проблем со штатным деинтерлейсом откройте строку AAD() в этом скрипте, деинтерлейс будет осуществляться функцией AAD Auto Anime Decomb 