#degrainmedian.dll
#RemoveGrainSSE2.dll
#RSharpenSSE2.dll
#RepairSSE2.dll
#ReduceFlicker.dll
#mvtoolsMT.dll
#mvtools2.dll
#fft3dgpu.dll
#nnedi2.dll
#nnedi3.dll
#yadifmod.dll
#TIVTC.dll
#tdeint.dll
#Dup.dll
#dfttest.dll
#vinverse.dll
#MaskTools.dll
#mt_masktools-26.dll
#WarpSharp.dll
#deen.dll
#MSharpen.dll
#TIVTC.dll
#Toon-v1.1.dll
#aWarpSharp2.dll
#vinverse.dll
#average.dll
#tmm.dll
#SangNom.dll
#TTempSmooth.dll
#EEDI2.dll
#VariableBlur.dll
#gradfun2db.dll
#AddGrainC.dll
#medianblur.dll
#dither.dll
#splineresize.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#mrestore.avs
#mrestore_v23e.avs
#srestore.avs
#bob_repair.avs
#Cdeblend.avs
#Cdeblend_v1.1b.avs
#Interlacing2Reader.avs
#FixBlendIVTC.avs
#mfToon-v0.54.avs
#AnimeIVTC - v1[1].06.1mod.avs
#ExBorders.avs
#EdgeCleaner.avs
#DeHalo_2.avs
#minblur.avs
#aa.avs
#TempGaussMC_beta1mod.avs
#LimitedSharpenFaster.avs
#LimitedSharpenFaster Mod.avs
#FastLineDarken 1.4x MT MOD.avsi
#MCBob_mod.avs


  SetMTmode(1,0)
# setmemorymax(768)

# ColorYUV(gain_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) #levels(16,1.0,240,0,255)
# ColorYUV(levels="TV->PC")

  AnimeIVTC (MT=true,mode=1,aa=0,dark=0.3) # mode Required parameter Defines the function's behavior

# Mode=1 или 3 (Hard telecined)
# Mode=2 или 4 (Double hard telecined // Field-blended norm conversion)
# Mode=3, 4 или 6 (Интерлейсные и\или прогрессивные фрагменты)
# Mode=3 или 4 с omode=1 (преобразование частоты кадров)
# Mode=5 или 6 (Hybrid)
# Mode=3 или 4 с omode=2 / Mode=5, 6 или 7 (VFR decimation)


  source = last
  m_edge = source.mt_edge("sobel",7,7,5,5).mt_inflate()
  m_aa   = m_edge.mt_expand()
  m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")

# ==== варианты антиайлиазинга ==== 
  aa_clp = source.maa() 
# aa_clp = source.ediaa()
# aa_clp = source.daa()

  dh_clp = aa_clp.DeHalo_2().gradfun2db(1.51) 
  
  sD = source.aWarpSharp2(chroma=2, depth=4, blur=1, thresh=252)
  prefiltered = source.degrainmedian(mode=2,limity=5,limituv=6)
  mVectors=prefiltered.mvanalysemulti(refframes=1,pel=2,blksize=8,overlap=4,sharp=2,truemotion=true,idx=1)
  cb1 = sD.mvcompensate(mVectors.mvmultiextract(0),thSCD1=300,idx=1)
  cf1 = sD.mvcompensate(mVectors.mvmultiextract(1),thSCD1=300,idx=1)
  interleave(cb1, sD, cf1)
# dfttest(sigma=6,tbsize=3,dither=1)
  setmtmode(5)
  fft3dgpu(bw=16,bh=16,ow=8,oh=8,bt=3,sigma=3.75,sigma2=2.75,sigma3=3.0,sigma4=1.0,plane=4,mode=1,precision=2)
  setmtmode(2)
  Selectevery(3,1)
  non_hl = mt_merge(last, aa_clp, m_aa)
  mt_merge(non_hl, dh_clp, m_halo)
  EdgeCleaner(smode=1, 20) 

# ===== Варианты затемнения линий =====
ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200),last, "AverageLuma()",">","50")
# ConditionalFilter(last.toon(0.2),last, "AverageLuma()",">","50")

DB = LumaDB(g1str=1.0,g2str=0.8,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false)
mask = mt_edge("prewitt",17,17,17,17,u=3,v=3)
maskf = mt_logic(mask,mt_logic(mask.utoy(),mask.vtoy(),"or").spline64resize(width,height),"or").mt_expand().mt_expand()
flat = mt_merge(last,DB,maskf.mt_invert(),luma=true)

# Sharpening
Sclp = flat.LSFmod(defaults="fast",Smode=3,Smethod=3,Lmode=1,strength=75,preblur="ON",secure=true,edgemode=0,soft=0,soothe=true,ss_x=1.5,ss_y=1.5,source=source)
Tmax = source.mt_logic(cf1,"max",U=1,V=1).mt_logic(cb1,"max",U=1,V=1)
Tmin = source.mt_logic(cf1,"min",U=1,V=1).mt_logic(cb1,"min",U=1,V=1)
Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)


# Назначение: для обработки малошумного аниме с любым типом интерлейса, включая гибридное аниме с VFR на основе скрипта AnimeIVTC - v1[1].06.2
# Подавление радужности изображения по умолчанию: отсутствует
# Тип затемнения линий по умолчанию: vmToon
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: на основе векторного анализа оценки движения и функцией MVCompensate мультиверсии mvtools c конечным шумоподавителем fft3dfilter или dfttest 
# Тип шарпера: asharp + LSFmod с включенным preblur для уменьшения звона на контурах
# Наличие фильтра DeBaning по умолчанию: включен
# Скорость обработки: очень медленная
# Предупреждение: требует предварительного тщательного анализа DGIndex для определения типа интерлейса и подбора соответствующего деинтерлейса

