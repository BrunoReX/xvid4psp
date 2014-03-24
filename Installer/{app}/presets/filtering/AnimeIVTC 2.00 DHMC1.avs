#avstp.dll
#RgTools.dll
#RSharpen.dll
#ReduceFlicker.dll
#mvtools2.dll
#nnedi3.dll
#yadifmod.dll
#Dup.dll
#deen_1.0.dll
#mt_masktools-26.dll
#WarpSharp.dll
#aWarpSharp2.dll
#asharp.dll
#vinverse.dll
#tmm.dll
#TDeint.dll
#TIVTC.dll
#average.dll
#mipsmooth.dll
#SangNom.dll
#EEDI2.dll
#FFT3DFilter.dll
#FFT3DGPU.dll
#medianblur.dll
#MSharpen.dll
#AddGrainC.dll
#dither.dll
#splineresize.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#aa.avs
#FastLineDarken 1.4x MT MOD.avsi
#srestore.avs
#Dehalo_alpha.avs
#AnimeIVTC 2.00.avs
#QTGMC.avs
#YAHR.avs
#minblur.avs
#DeHaloH.avs
#ContraHD.avs
#LimitedSharpenFaster mod.avs


# setmtmode(2)
# setmemorymax(768)

#ColorYUV(levels="TV->PC") 
#ColorYUV(gain_y=0,cont_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) 

  AnimeIVTC(mode=1,aa=0)
# AnimeIVTC(mode=1,chrfix=true,ifade=true,aa=0)
# Animeivtc(mode=1,aa=0,killcomb=2, blend=true)
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
  dh_clp = aa_clp.YAHR().DeHalo_alpha(darkstr=1.0,brightstr=1.4,rx=2.4,ry=2.4,highsens=100,lowsens=30)
# dh_clp = aa_clp.DeHaloH(2, 10, Maska=false)
# dh_clp = aa_clp.DeHalo_Alpha(rx=2.4,ry=2.4,darkstr=0.5,brightstr=1.0,ss=1.5) 

super = source.MSuper(pel=2, sharp=2, rfilter=2)
vb1 = MAnalyse(super,isb=true, delta=1, blksize=8, overlap=4, truemotion=true, search=5)
vf1 = MAnalyse(super,isb=false,delta=1, blksize=8, overlap=4, truemotion=true, search=5)

maskb = source.mmask(vb1, ml=150, kind = 1, Ysc = 255, gamma=0.999)
maskf = source.mmask(vf1, ml=150, kind = 1, Ysc = 255, gamma=0.999)
tmask = mt_lutxy(maskb,maskf,"x 255 < y 255 < x y + 2 / x ? y ? 32 - 255 * 223 /")# комбинированная маска оценки движения SAD
maskstatic  = mt_invert(tmask)

cf1 = MCompensate(source, super, vf1, thSCD1=300)
cb1 = MCompensate(source, super, vb1, thSCD1=300)
interleave(cf1, source, cb1)
# checkmate(100)
# dfttest(sigma=8,tbsize=3,dither=1)
# setmtmode(5)
fft3dgpu(bw=16,bh=16,ow=8,oh=8,bt=3,sigma=3.2,sigma2=2.3,sigma3=2.5,sigma4=1.0,plane=4,mode=1,precision=2)
# setmtmode(2)
Selectevery(3,1)

non_hl = mt_merge(last, aa_clp, m_aa)
mt_merge(non_hl, dh_clp, m_halo)

# ===== Варианты затемнения линий =====
ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200).aWarpSharp2(thresh=48, depth=4), last, "AverageLuma()",">","50")

  DB = f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)
# DB = LumaDB(g1str=1.0,g2str=0.8,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false)
mask = mt_edge("prewitt",17,17,17,17,u=3,v=3)
maskf = mt_logic(mask,mt_logic(mask.utoy(),mask.vtoy(),"or").spline144resize(width,height),"or").mt_expand().mt_expand()
flat = mt_merge(last,DB,maskf.mt_invert(),luma=true)

# don't sharpen motion, dark area or starfield areas
maskstatic = mt_lutxy(flat,maskstatic,"x 32 < 0 y ?")

# Sharpening
Sclp = flat.LSFmod(defaults="fast",strength=90,preblur="ON")
Tmax = source.mt_logic(cf1,"max",U=1,V=1).mt_logic(cb1,"max",U=1,V=1)
Tmin = source.mt_logic(cf1,"min",U=1,V=1).mt_logic(cb1,"min",U=1,V=1)
shrp = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)
mt_merge(flat, shrp, maskstatic)


# Назначение: для обработки малошумного аниме высокого разрешения с любым типом интерлейса, включая гибридное аниме с VFR на основе скрипта AnimeIVTC 2.00
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: на основе векторного анализа оценки движения 
# Тип шарпера: aWarpSharp2 + LSFmod
# Наличие фильтра DeBaning по умолчанию: включен
# Скорость обработки: очень медленная
# Предупреждение: требует предварительного тщательного анализа DGIndex для определения типа интерлейса и подбора соответствующего режима mode
# Деинтерлейс выставляемый XviD 4PSP5.0.37.8 ОТКЛЮЧИТЬ !!!

