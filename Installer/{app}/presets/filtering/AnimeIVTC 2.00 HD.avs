#avstp.dll
#RgTools.dll
#RSharpen.dll
#ReduceFlicker.dll
#mvtools2.dll
#nnedi3.dll
#yadifmod.dll
#Dup.dll
#hqdn3d.dll
#mt_masktools-26.dll
#WarpSharp.dll
#Toon-v1.1.dll
#aWarpSharp2.dll
#AddGrainC.dll
#Vaguedenoiser.dll
#vinverse.dll
#tmm.dll
#TDeint.dll
#TIVTC.dll
#average.dll
#Unfilter.dll
#SangNom.dll
#EEDI2.dll
#medianblur.dll
#FFT3DFilter.dll
#SmoothAdjust.dll
#flash3kyuu_deband.dll
#MSharpen.dll
#Gradfun2db.dll
#srestore.avs
#AnimeIVTC 2.00.avs
#QTGMC.avs
#aa.avs
#YAHR.avs
#EdgeCleaner.avs
#SmoothContrast.avsi
#FastLineDarken 1.4x MT MOD.avsi


# setmtmode(2)
# setmemorymax(1024)

  AnimeIVTC(mode=1,aa=0)
# AnimeIVTC(mode=1,chrfix=true,ifade=true,aa=0)
# Animeivtc(mode=1,aa=0,killcomb=2,blend=true)
# AnimeIVTC(mode=1,chrfix=true,killcomb=2,ifade=true,aa=0) # Chroma DeBland
# AnimeIVTC(mode=2,ifade=true,aa=0)
# AnimeIVTC(mode=3,chrfix=true,ifade=true,aa=0, pattern=-1) # на основе pattern=-1 выберите лучшее значение, обычно pattern=2

# ===============================================================
# Mode=1 Hard telecined
# Mode=2 Field blended
# Mode=3 Double hard telecine
# Mode=4 Hybrid
# ===============================================================

# Кодирование гибридного видео с VFR
# ============ Первый проход ==============
# AnimeIVTC(mode=4,omode=2,pass=1) # e1= ,i1= , e2= 
# Остальную часть скрипта при сохранении можно удалить и открыть в VD
# Кодировать данный скрипт x264_vfw в режиме loss-less и сохранить с каким-либо именем, например, losslesspass.avi, он соирает информацию с таймкодами
# =========== Второй проход ===============
# Откройте losslesspass.avi и кодируйте в обычном режиме окончательном скриптом
# AnimeIVTC(mode=4,omode=2,chrfix=true,ifade=true,aa=0,rendering=true, pass=2) # e1= ,i1= , e2= 
# ===============================================================


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


# Назначение: пресет обработки малошумного аниме HD исходников с любым типом интерлейса, включая гибридное аниме с VFR на основе скрипта AnimeIVTC 2.00
# Подавление радужности изображения по умолчанию: отсутствует
# Тип затемнения линий по умолчанию: toon
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: на основе  hqdn3d + Vaguedenoiser 
# Тип шарпера: sharpen
# Наличие фильтра DeBaning по умолчанию: включен LumaDB
# Скорость обработки: медленная
# Предупреждение: требует предварительного тщательного анализа DGIndex для определения типа интерлейса и подбора соответствующего деинтерлейса
# Деинтерлейс выставляемый XviD 4PSP5.10.305 ОТКЛЮЧИТЬ !!!

