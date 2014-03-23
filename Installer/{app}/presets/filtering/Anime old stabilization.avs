#avstp.dll
#DePan.dll
#DePanEstimate.dll
#RgTools.dll
#deen.dll
#EEDI2.dll
#NNEDI3.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#SangNom.dll
#awarpsharp2.dll
#Warpsharp.dll
#medianblur.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#mt_xxpand_multi.avsi
#FastLineDarken 1.4x MT MOD.avsi
#DeHalo_Alpha.avs
#EdgeCleaner.avs
#aa.avs
#stab.avs
#LimitedSharpenFaster mod.avs


setmtmode(2)
setmemorymax(768)

MergeChroma(aWarpSharp2(chroma=4)) 

# ===== global motion stabilization stage =====
Stab (range=1, dxmax=2, dymax=2)

# ==== набор масок ====
source = last
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")

# ==== варианты антиайлиазинга ==== 
  aa_clp = source.maa() 
# aa_clp = source.ediaa()
# aa_clp = source.daa()

# ==== варианты DeHalo ==== 
dh_clp = aa_clp.DeHalo_Alpha(rx=2.4,ry=2.4,darkstr=0.5,brightstr=1.0,ss=1.5) 

# ===== local motion stabilization/degrain stage =====

tr = 3   # Temporal radius
super = source.MSuper(pel=2, sharp=2, rfilter=2)
multi_vec = MAnalyse (super, multi=true, delta=tr, blksize=8, overlap=4, truemotion=true, dct=5)
process = source.MDegrainN (super, multi_vec, tr, thSAD=400, thSAD2=150)
denoiced = mt_merge(process, mt_edge("min/max").RemoveGrain(19), U=3,V=3)
non_hl = mt_merge(denoiced, aa_clp, m_aa)
mt_merge(denoiced, dh_clp, m_halo)
EdgeCleaner(smode=2, 17) 

# ===== Варианты затемнения линий =====
ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200),last, "AverageLuma()",">","50")

LSFmod(defaults="fast",Smode=3,Smethod=3,Lmode=1,strength=80,preblur="ON",secure=true,edgemode=0,soft=0,soothe=true,ss_x=1.50,ss_y=1.50,source=source)

# ==== DeBanding ====
DB = f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)
# DB = LumaDB(g1str=1.2,g2str=1.0,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false)
mask = mt_edge("prewitt",17,17,17,17,u=3,v=3)
maskf = mt_logic(mask,mt_logic(mask.utoy(),mask.vtoy(),"or").spline36resize(width,height),"or").mt_expand().mt_expand()
mt_merge(last,DB,maskf.mt_invert(),luma=true)


# Назначение: пресет для старого аниме с global motion stabilization stage
# Подавление радужности изображения по умолчанию: включено
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: maa
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная
