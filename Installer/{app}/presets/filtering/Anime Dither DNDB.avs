#avstp.dll
#dfttestmod.dll
#AddGrainC.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#EEDI2.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#SangNom.dll
#nnedi3.dll
#a60224.dll
#nnedi2.dll
#TDeInt.dll
#TIVTC.dll
#TMM.dll
#vinverse.dll
#Warpsharp.dll
#GradFun2DB.dll
#medianblur.dll
#awarpsharp2.dll
#dither.dll
#Dither.avsi
#DeHaloH.avs
#EdgeCleaner.avs
#aa.avs
#AAD.avs
#mt_xxpand_multi.avsi
#FastLineDarken 1.4x MT MOD.avsi


# AAD()  # Auto Anime Decomb

setmtmode(2)
# setmemorymax(640)

#ColorYUV(levels="TV->PC") 
#ColorYUV(gain_y=0,cont_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) 

# ===== Шумоподавление и DeBanding =====
# Your favourite 8-bit denoiser here, doing the main job
source = last
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()

# ==== антиайлиазинг =====
  aa_clp = source.maa()
# aa_clp = source.ediaa()
# aa_clp = source.daa()
  
filter = source.dfttest(sigma=10, tbsize=1, lsb=true, threads=1)
preNR = filter.DitherPost(mode=6)

# Restores a bit of noise
rdm = mt_lutxy (source, preNR, expr="x y < y 1 - x y > y 1 + y ? ?", y=3, u=3, v=3)
sup1 = preNR.MSuper(pel=2, sharp=2)
sup2 = rdm.MSuper(pel=2, sharp=2, levels=1)

# You could also reuse the vectors found in a previous processing stage
vf1 = MAnalyse (sup1, isb=false, delta=1, overlap=4, blksize=8)
vb1 = MAnalyse (sup1, isb=true,  delta=1, overlap=4, blksize=8)

# Turns remaining noise into 16-bit gradients
cf1 = MCompensate (sup2, vf1, thSAD=300)
cb1 = MCompensate (sup2, vb1, thSAD=300)
Interleave (cf1, rdm, cb1)
dfttest (sigma=1.5, tbsize=3, lsb=true, threads=1)
SelectEvery (3, 1)

# DeBanding
GradFun3 (thr=0.45, smode=1, radius=16, lsb_in=true, lsb=true)
# Dither_add_grain16 (var=0.05, uvar=0, soft=2)
DitherPost(mode=6)
  
  AdaptiveEdgeCleaner2(1, 20)
# EdgeCleaner(smode=1,strength=20)

mt_merge(last, aa_clp, m_aa)

# ===== затемнение линий =====
ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200),last, "AverageLuma()",">","50")
WarpSharp(80,6,170,0) 
  
# Назначение: Типовой пресет для обработки аниме для шумного исходника 
# Подавление радужности изображения по умолчанию: отсутствует
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: пространственно-временной фильтр dfttest + MCompensate
# Наличие фильтра DeBanding по умолчанию: включен GradFun3
# Скорость обработки: низкая
# ВНИМАНИЕ!!! В случае проблем со штатным деинтерлейсом откройте строку AAD() в этом скрипте, деинтерлейс будет осуществляться функцией AAD Auto Anime Decomb 