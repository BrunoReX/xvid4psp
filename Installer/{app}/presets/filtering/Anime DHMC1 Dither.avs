#avstp.dll
#RgTools.dll
#dfttestmod.dll
#Cnr2.dll
#EEDI2.dll
#nnedi3.dll
#a60224.dll
#nnedi2.dll
#TDeInt.dll
#TIVTC.dll
#TMM.dll
#vinverse.dll
#mvtools2.dll
#deen_1.0.dll
#awarpsharp2.dll
#mt_masktools-26.dll
#msharpen.dll
#SangNom.dll
#Warpsharp.dll
#Bifrost.dll
#Checkmate.dll
#mipsmooth.dll
#Dither.dll
#medianblur.dll
#Fluxsmooth.dll
#AddGrainC.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#Chubbyrain2.avs
#DeRainbow2.avs
#aa.avs
#AAD.avs
#YAHR.avs
#DeHaloH.avs
#DeHalo_Alpha.avs
#FastLineDarken 1.4x MT MOD.avsi
#Dither.avsi
#mt_xxpand_multi.avsi
#minblur.avs
#ContraHD.avs
#LimitedSharpenFaster Mod.avs


# AAD() # Auto Anime Decomb

setmtmode(2)
# setmemorymax(768)

#ColorYUV(levels="TV->PC") 
#ColorYUV(gain_y=0,cont_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) 

# ==== DeRainbow ====
# Chubbyrain2()
# DeRainbow2()
  MergeChroma(aWarpSharp2(chroma=4))

source = last
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")
# m_halo = m_edge.mt_expand(mode=mt_square(2)).mt_lutxy(m_edge.mt_inpand(mode=mt_square(1)), "x y -").mt_lut("x 16 < x x 2 << ?")

# ==== варианты антиайлиазинга ==== 
  aa_clp = source.maa() 
# aa_clp = source.ediaa()
# aa_clp = source.daa()

# ==== варианты DeHalo ==== 
  dh_clp = aa_clp.YAHR().DeHalo_alpha(darkstr=1.0,brightstr=1.4,rx=2.4,ry=2.4,highsens=100,lowsens=30)
# dh_clp = aa_clp.DeHaloH(2, 10, Maska=false)
# dh_clp = aa_clp.DeHalo_Alpha(rx=2.4,ry=2.4,darkstr=0.5,brightstr=1.0,ss=1.5) 

pre = source.dfttest(sigma=12, tbsize=1, threads=1, lsb=true).DitherPost(mode=6)
psuper = pre.MSuper(pel=2, sharp=2, rfilter=2)
ssuper = source.MSuper(pel=2, sharp=2, levels=1)
vb1 = MAnalyse(psuper,isb=true, delta=1, blksize=8, overlap=4, truemotion=true, search=5, lambda=768)
vf1 = MAnalyse(psuper,isb=false,delta=1, blksize=8, overlap=4, truemotion=true, search=5, lambda=768)
cf1 = MCompensate(source, ssuper, vf1, thSCD1=300)
cb1 = MCompensate(source, ssuper, vb1, thSCD1=300)
interleave(cf1, source, cb1)
# checkmate(100)
dfttest(sigma=8.0, tbsize=3, threads=1, lsb=true)
Selectevery(3,1)

# ===== Варианты DeBanding =====
# setmtmode(5) 
# db1 = last.LumaDBL(g1str=8, g2str=4, g3str=0, lsb=true, lsb_in=true)
# setmtmode(2)  
db1 = last.GradFun3(smode=2, radius=16, thr=0.45, thrc=0.45, mask=0, lsb_in=true, lsb=true, Y=3, U=3, V=3)
db2 = db1.f3kdb(16, 54, 54, 54, 0, 0, input_mode=1, output_mode=1).Dither_limit_dif16(last, thr=0.6, Y=3, U=3, V=3)
DB  = db2#.Dither_add_grain16 (var=0.05, uvar=0, soft=2) 

den = DB.DitherPost(mode=-1)
non_hl = mt_merge(den, aa_clp, m_aa)
NR = mt_merge(non_hl, dh_clp, m_halo)

# ===== затемнение линий =====
dark = ConditionalFilter(NR.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200).aWarpSharp2(thresh=48, depth=4), NR, "AverageLuma()",">","50")

# ===== Варианты Sharpening ===== 
# Sclp = dark.LSFmod(defaults="fast", preblur="ON", strength=90)
# Tmax = source.mt_logic(cf1,"max",U=1,V=1).mt_logic(cb1,"max",U=1,V=1)
# Tmin = source.mt_logic(cf1,"min",U=1,V=1).mt_logic(cb1,"min",U=1,V=1)
# sharp8 = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1) # вариант 1

sharp8 = ContraHD(dark, source, cb1, cf1, 3) # вариант 2
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, dark))
# lsb_out = lsbctr.DitherPost(mode=6) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0)   # for x264 encode 
lsb_out


# Назначение: для обработки аниме с низким уровнем шумов и устранением ореолов и звона на контурах изображения  
# Подавление радужности изображения по умолчанию: включено
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: SangNom
# Тип шумоподавителя: MCompensate + dfttestmod
# Тип шарпера: ContraHD 
# Наличие фильтра DeBanding по умолчанию: LumaDBL
# Скорость обработки: средняя
# ВНИМАНИЕ!!! В случае проблем со штатным деинтерлейсом откройте строку AAD() в этом скрипте, деинтерлейс будет осуществляться функцией AAD Auto Anime Decomb 