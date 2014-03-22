#RemoveGrainSSE2.dll
#RepairSSE2.dll
#hqdn3d.dll
#EEDI2.dll
#deen.dll
#awarpsharp2.dll
#unfilter.dll
#mt_masktools-26.dll
#nnedi3.dll
#SangNom.dll
#Vaguedenoiser.dll
#medianblur.dll
#flash3kyuu_deband.dll
#aa.avs
#YAHR.avs
#EdgeCleaner.avs
#FastLineDarken 1.4x MT MOD.avsi


setmtmode(2)
# setmemorymax(1024)

m_edge = mt_edge("sobel", 7, 20).mt_inflate()
m_motn = mt_motion()
m_aa   = m_edge.mt_expand()
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")

aa_clp = AAA()
dh_clp = aa_clp.YAHR()

# ===== Denoiced =====
Temporal = hqdn3d(0.6, 0.6, 8, 8)
Vaguedenoiser(method=4, nsteps=10, wavelet=2, Wiener=true, auxclip=temporal, percent=95, chromaT=1.5, wratio=1.5, threshold=0.8)
EdgeCleaner(smode=1,strength=20) 

non_hl = mt_merge(last, aa_clp, m_aa)
mt_merge(non_hl, dh_clp, m_halo)

# ===== Варианты затемнения линий =====
ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200),last, "AverageLuma()",">","50")

DB = f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)
mask = mt_edge("prewitt",17,17,17,17,u=3,v=3)
maskf = mt_logic(mask,mt_logic(mask.utoy(),mask.vtoy(),"or").spline64resize(width,height),"or").mt_expand().mt_expand()
mt_merge(last,DB,maskf.mt_invert(),luma=true)
sharpen(0.22)

 
# Назначение: для обработки аниме с низким уровнем шумов BD_HD исходников и устранением ореолов и звона на контурах изображения  
# Подавление радужности изображения по умолчанию: отсутствует
# Тип затемнения линий по умолчанию: -
# Тип антиайлизинга по умолчанию: AAA
# Тип шумоподавителя: hqdn3d + Vaguedenoiser
# Тип шарпера: WarpSharp 
# Наличие фильтра DeBanding по умолчанию: включен LumaDB
# Скорость обработки: средняя
