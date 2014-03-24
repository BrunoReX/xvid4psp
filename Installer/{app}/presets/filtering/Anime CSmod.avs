#avstp.dll
#mt_masktools-26.dll
#mvtools2.dll
#SangNom.dll
#Fluxsmooth.dll
#nnedi3.dll
#EEDI2.dll
#tcanny.dll
#RgTools.dll
#medianblur.dll
#dfttestmod.dll
#warpsharp.dll
#awarpsharp2.dll
#deen_1.0.dll
#Toon-v1.1.dll
#dither.dll
#AddGrainC.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#aa.avs
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#mt_xxpand_multi.avsi
#Dither.avsi
#ContraSharpen_mod.avsi
#FastLineDarken 1.4x MT MOD.avsi
#Dehalo_alpha.avs
#DeHaloH.avs


# setmtmode(2)
# setmemorymax(640)

source   = last
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")

# ==== варианты антиайлиазинга ==== 
  aa_clp = source.maa() 
# aa_clp = source.ediaa()
# aa_clp = source.daa()

# dh_clp = aa_clp.Dehalo_alpha(rx=2.4,ry=2.4,darkstr=0.3,brightstr=0.8,ss=1.5)
dh_clp = aa_clp.DeHaloH(2, 10, Maska=false)

source.dfttest(sigma=4.0, sigma2=4.0, tbsize=3, lsb=true)

# DB = last.LumaDBL(lsb=true, lsb_in=true)
db1 = last.GradFun3 (thr=1.4*0.3, smode=1, radius=12, lsb_in=true, lsb=true)
db2 = db1.f3kdb(16, 52, 36, 36, 0, 0, input_mode=1, output_mode=1).Dither_limit_dif16(last, thr=0.45, Y=3, U=3, V=3)
DB = db2#.Dither_add_grain16 (var=0.1, uvar=0, soft=2) # добавление динамического зерна

den = DB.DitherPost(mode=-1)
flat = mt_merge(source,den,m_edge,luma=true)
non_hl = mt_merge(flat, aa_clp, m_aa) 
mt_merge(dh_clp,non_hl,m_halo) 

# ===== затемнение линий =====
output = ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200),last, "AverageLuma()",">","50")

# Sharpening
sharp8 = CSmod(source, output, chroma=false, ss_w=1.50, ss_h=1.50, strength=80, limit=false, Slimit=true, Tlimit=true)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=1) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0)   # for x264 encode 
lsb_out


# Назначение: для антиайлиазинга, Dehalo и дебандинга аниме с низким уровнем шумов
# Тип антиайлизинга по умолчанию: SangNom
# Тип шумоподавителя: dfttestmod
# Тип шарпера: CSmod  
# Наличие фильтра DeBanding по умолчанию: LumaDBL
# Скорость обработки: медленная