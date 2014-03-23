#avstp.dll
#nnedi3.dll
#a60224.dll
#nnedi2.dll
#TDeInt.dll
#TIVTC.dll
#TMM.dll
#vinverse.dll
#dfttestmod.dll
#RgTools.dll
#EEDI2.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#SangNom.dll
#nnedi3.dll
#Warpsharp.dll
#Toon-v1.1.dll
#awarpsharp2.dll
#dither.dll
#AddGrainC.dll
#Dither.avsi
#FastLineDarken 1.4x MT MOD.avsi
#EdgeCleaner.avs
#aa.avs
#AAD.avs
#mt_xxpand_multi.avsi
#LimitedSharpenFaster Mod.avs
#FastLineDarken 1.4x MT MOD.avsi


# AAD()  # Auto Anime Decomb

setmtmode(2)
# setmemorymax(640)

#ColorYUV(levels="TV->PC") 
#ColorYUV(gain_y=0,cont_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) 

# ==== набор масок ====
source = last
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
  
# ==== варианты антиайлиазинга ==== 
aa_clp = source.maa() 
# aa_clp = source.ediaa()
# aa_clp = source.daa()

  
# ===== Шумоподавление и DeBanding =====
o = dfttest(tbsize=1,sigma=10,lsb=true,threads=1)
la2 = o.DitherPost(mode=6)
la1 = o.DitherPost(mode=-1)
tr = 3
super = la2.MSuper(pel=2, sharp=2) 
multi_vec = MAnalyse (super, multi=true, delta=tr, blksize=8, overlap=4, chroma=true, truemotion=true, search=5)
ms1 = la1.MDegrainN (super, multi_vec, tr, thSAD=400, thSAD2=150, lsb=true)
ms2 = la2.MDegrainN (super, multi_vec, tr, thSAD=400, thSAD2=150, lsb=true)

msk = DitherBuildMask(la1,ms1.ditherpost(mode=-1))
Dither_merge16_8(o,ms2,msk)

GradFun3 (thr=1.4*0.3, smode=1, radius=16, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.03, uvar=0, soft=2)

den = DB.DitherPost(mode=-1)
mt_merge(den, aa_clp, m_aa)
EdgeCleaner(smode=1, 20)

# ===== затемнение линий =====
ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200),last, "AverageLuma()",">","50")

# Sharpening
sharp8 = last.LSFmod(defaults="slow", preblur="ON", strength=130)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, last))
# lsb_out = lsbctr.DitherPost(mode=6) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0)   # for x264 encode 
lsb_out
 

# Назначение: пресет для обработки аниме для исходника с сильным шумом  
# Подавление радужности изображения по умолчанию: отсутствует
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: пространственно-временной фильтр dfttest + MDegrainN
# Наличие фильтра DeBanding по умолчанию: включен Dither
# Скорость обработки: медленная
# ВНИМАНИЕ!!! В случае проблем со штатным деинтерлейсом откройте строку AAD() в этом скрипте, деинтерлейс будет осуществляться функцией AAD Auto Anime Decomb 