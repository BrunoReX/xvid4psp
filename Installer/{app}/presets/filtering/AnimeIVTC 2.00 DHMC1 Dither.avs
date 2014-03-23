#avstp.dll
#RgTools.dll
#RSharpen.dll
#ReduceFlicker.dll
#mvtools2mod.dll
#nnedi3.dll
#yadifmod.dll
#Dup.dll
#Cnr2.dll
#deen_1.0.dll
#dfttestmod.dll
#mt_masktools-26.dll
#WarpSharp.dll
#aWarpSharp2.dll
#asharp.dll
#AddGrainC.dll
#vinverse.dll
#tmm.dll
#TDeint.dll
#TIVTC.dll
#mipsmooth.dll
#SangNom.dll
#EEDI2.dll
#FFT3DFilter.dll
#medianblur.dll
#MSharpen.dll
#Gradfun2db.dll
#Bifrost.dll
#average.dll
#Checkmate.dll
#Dither.dll
#AddGrainC.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#Dither.avsi
#mt_xxpand_multi.avsi
#Chubbyrain2.avs
#DeRainbow2.avs
#srestore.avs
#AnimeIVTC 2.00.avs
#QTGMC.avs
#YAHR.avs
#minblur.avs
#Masked_DHA.avs
#DeHaloH.avs
#DeHalo_Alpha.avs
#FastLineDarken 1.4x MT MOD.avsi
#LimitedSharpenFaster Mod.avs
#ContraHD.avs


setmtmode(2)
# setmemorymax(768)

#ColorYUV(levels="TV->PC") 
#ColorYUV(gain_y=0,cont_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) 

  AnimeIVTC(mode=1,aa=0)
# AnimeIVTC(mode=1,chrfix=true,ifade=true,aa=0)
# Animeivtc(mode=1,aa=0,killcomb=2,blend=true)
# AnimeIVTC(mode=1,chrfix=true,killcomb=2,ifade=true,aa=0) # Chroma DeBland
# AnimeIVTC(mode=2,ifade=true,aa=0)
# AnimeIVTC(mode=3,chrfix=true,ifade=true,aa=0, pattern=-1, cache=15) # на основе pattern=-1 выберите лучшее значение, обычно pattern=2

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

# удаление радужности
# Chubbyrain2()
# DeRainbow2()
  MergeChroma(aWarpSharp2(chroma=4))

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
mt_merge(non_hl, dh_clp, m_halo)

# ===== затемнение линий =====
ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200).aWarpSharp2(thresh=48, depth=4), last, "AverageLuma()",">","50")

# ===== Варианты Sharpening ===== 
# Sclp = last.LSFmod(defaults="fast", preblur="ON", strength=90)
# Tmax = source.mt_logic(cf1,"max",U=1,V=1).mt_logic(cb1,"max",U=1,V=1)
# Tmin = source.mt_logic(cf1,"min",U=1,V=1).mt_logic(cb1,"min",U=1,V=1)
# sharp8 = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1) # вариант 1

sharp8 = ContraHD(last, source, cb1, cf1, 3) # вариант 2
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, last))
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=1) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0)   # for x264 encode 
lsb_out


# Назначение: Наиболее качественный пресет обработки аниме с любым типом интерлейса, включая гибридное аниме с VFR на основе скрипта AnimeIVTC 2.00
# Подавление радужности изображения по умолчанию: включено
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: на основе векторного анализа оценки движения 
# Тип шарпера: ContraHD или LSFmod
# Наличие фильтра DeBaning по умолчанию: включен
# Скорость обработки: очень медленная
# Предупреждение: требует предварительного тщательного анализа DGIndex для определения типа интерлейса и подбора соответствующего режима mode
# Деинтерлейс выставляемый XviD 4PSP5.0.37.8 ОТКЛЮЧИТЬ !!!

