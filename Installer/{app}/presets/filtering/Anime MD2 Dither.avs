#avstp.dll
#msharpen.dll
#Cnr2.dll
#RgTools.dll
#EEDI2.dll
#mvtools2mod.dll
#dfttestmod.dll
#awarpsharp2.dll
#deen.dll
#mt_masktools-26.dll
#nnedi3.dll
#Toon-v1.1.dll
#SangNom.dll
#Warpsharp.dll
#Dither.dll
#mipsmooth.dll
#AddGrainC.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#DeRainbow2.avs
#aa.avs
#DeHalo_2.avs
#DeHalo_Alpha.avs
#EdgeCleaner.avs
#Dither.avsi
#mt_xxpand_multi.avsi
#FastLineDarken 1.4x MT MOD.avsi
#LimitedSharpenFaster mod.avs


# setmtmode(2)
# setmemorymax(640)

#ColorYUV(levels="TV->PC") 
#ColorYUV(gain_y=0,cont_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) 
  
# ===== подавление радужных помех =====
DeRainbow2() 

source = last
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")

# ==== варианты антиайлиазинга ==== 
  aa_clp = source.maa() 
# aa_clp = source.ediaa()
# aa_clp = source.daa()

# ==== варианты DeHalo ==== 
# dh_clp = aa_clp.DeHalo_2()
  dh_clp = aa_clp.DeHalo_Alpha(rx=2.4,ry=2.4,darkstr=0.5,brightstr=1.0,ss=1.5) 

# ===== Denoiced =====

blksize = 8 # для увеличения скорости обработки установите 16
overlap = blksize/2
hpad = blksize/2
vpad = blksize/2
tr = 2 
chroma = true
search = 5

sD = source.aWarpSharp2(chroma=2, depth=2, blur=1, thresh=252)
super = sD.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2, chroma=chroma)
multi_vec = MAnalyse (super, multi=true, delta=tr, blksize=8, overlap=4, chroma=true, truemotion=true, search=5)
vb1 = multi_vec.SelectEvery (tr * 2, 0)
vf1 = multi_vec.SelectEvery (tr * 2, 1)
sD.MDegrainN (super, multi_vec, tr, thSAD=400, thSAD2=150, lsb=true)

# DeBanding
# DB = last.LumaDBL(g1str=8, g2str=4, g3str=0, lsb=true, lsb_in=true) 
# DB = last.GradFun3(smode=1, thr=0.5, radius=16, lsb=true, lsb_in=true)
GradFun3 (thr=1.4*0.3, smode=1, radius=12, lsb_in=true, lsb=true)
DB = last#.Dither_add_grain16 (var=0.05, uvar=0, soft=2)

den = DB.DitherPost(mode=-1)

non_hl = mt_merge(den, aa_clp, m_aa)
mt_merge(non_hl, dh_clp, m_halo)
smE = last.EdgeCleaner(smode=2,strength=20)

# ===== затемнение линий =====
dark = ConditionalFilter(smE.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200),smE, "AverageLuma()",">","50")

# Sharpening
b1c = sD.MCompensate(super,vb1)
f1c = sD.MCompensate(super,vf1)
Sclp = dark.LSFmod(defaults="fast",strength=90,preblur="ON")
Tmax = sD.mt_logic(f1c,"max",U=1,V=1).mt_logic(b1c,"max",U=1,V=1)
Tmin = sD.mt_logic(f1c,"min",U=1,V=1).mt_logic(b1c,"min",U=1,V=1)
sharp8 = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)

lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, last))
# lsb_out = lsbctr.DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0)   # for x264 encode 
lsb_out


# Назначение: для обработки аниме с средним уровнем шумов, радужностью изображенияи и наличием ореолов и звона на контурах  
# Подавление радужности изображения по умолчанию: отключено
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: на основе векторного анализа оценки движения и его функций MDegrain2 + MRecalculate + Dither
# Тип шарпера: aWarpSharp2 + LSFmod 
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная
