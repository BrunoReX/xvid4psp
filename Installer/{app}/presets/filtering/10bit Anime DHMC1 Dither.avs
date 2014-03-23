#avstp.dll
#RgTools.dll
#dfttestmod.dll
#Cnr2.dll
#deen_1.0.dll
#EEDI2.dll
#mvtools2.dll
#awarpsharp2.dll
#mt_masktools-26.dll
#msharpen.dll
#nnedi3.dll
#Toon-v1.1.dll
#SangNom.dll
#SmoothAdjust.dll
#Warpsharp.dll
#Bifrost.dll
#Checkmate.dll
#mipsmooth.dll
#Chubbyrain2.avs
#DeRainbow2.avs
#aa.avs
#Dither.dll
#medianblur.dll
#AddGrainC.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#minblur.avs
#DeHaloH.avs
#EdgeCleaner.avs
#DeHalo_Alpha.avs
#FastLineDarken 1.4x MT MOD.avsi
#minblur.avs
#Dither.avsi
#O16mod.avsi
#mt_xxpand_multi.avsi
#FastLineDarken 1.4x MT MOD.avsi
#HighPassSharp.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(1280)

# ==== DeRainbow ====
# Chubbyrain2()
# DeRainbow2()
  MergeChroma(aWarpSharp2(chroma=4))

source = last
W = width(source)
H = height(source)

m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")

# ==== варианты антиайлиазинга ==== 
  aa_clp = source.maa() 
# aa_clp = source.ediaa()
# aa_clp = source.daa()

# ==== варианты DeHalo ==== 
# dh_clp = aa_clp.DeHaloH(2, 10, Maska=false)
  dh_clp = aa_clp.DeHalo_Alpha(rx=2.4,ry=2.4,darkstr=0.5,brightstr=1.0,ss=1.5) 

# ==== Denoiced ====
super = source.MSuper(pel=2, sharp=2, rfilter=2)
vb1 = MAnalyse(super,isb=true, delta=1, blksize=8, overlap=4, truemotion=true, search=5, lambda=768)
vf1 = MAnalyse(super,isb=false,delta=1, blksize=8, overlap=4, truemotion=true, search=5, lambda=768)
cf1 = MCompensate(source, super, vf1, thSCD1=300)
cb1 = MCompensate(source, super, vb1, thSCD1=300)
interleave(cf1, source, cb1)
# checkmate(100)
dfttest(sigma=8.0, tbsize=3, threads=1, lsb=true)
Selectevery(3,1)

# ==== DeBanding ====
# setmtmode(5)
# DB = last.LumaDBL(lsb=true, lsb_in=true) 
# setmtmode(2)

# DB = last.GradFun3(smode=1, thr=0.35, radius=12, lsb_in=true, lsb=true)
db1 = last.GradFun3(smode=1, radius=20, thr=0.45, thrc=0.45, mask=0, lsb_in=true, lsb=true, Y=3, U=3, V=3)
db2 = db1.f3kdb(20, 52, 52, 52, 0, 0, input_mode=1, output_mode=1).Dither_limit_dif16(last, thr=0.60, Y=3, U=3, V=3)
DB = db2#.Dither_add_grain16 (var=0.1, uvar=0, soft=2) 

den = DB.DitherPost(mode=-1)
non_hl = mt_merge(den, aa_clp, m_aa)
spat   = mt_merge(non_hl, dh_clp, m_halo)
smE = spat.EdgeCleaner(smode=1, 20) 

# ===== затемнение линий =====
dark = ConditionalFilter(smE.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200).aWarpSharp2(thresh=48, depth=4), smE, "AverageLuma()",">","50")

# ==== Sharpening ====
# Sclp = dark.HighPassSharp(r=0.15) # for HD
Sclp = dark.LSFmod(defaults="fast",strength=90,preblur="ON") # for SD
Tmax = source.mt_logic(cf1,"max",U=1,V=1).mt_logic(cb1,"max",U=1,V=1)
Tmin = source.mt_logic(cf1,"min",U=1,V=1).mt_logic(cb1,"min",U=1,V=1)
sharp8 = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)

mask = mt_lutxy (sharp8, dark, "x y != 255 0 ?", u=0, v=0)  #  8, 8 ->  8
s16  = sharp8.U16()                                         #  8 -> 16
Dither_merge16_8 (DB, s16, mask, luma=true, Y=3, U=3, V=3)  # 16, 16, 8 -> 16 

# ==== ресайз 16-битного видео ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                        # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()            # 16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(stack=false, dither=-2)               # 10-бит
""") : DitherPost()                          # 8-бит                  


# Назначение: для обработки аниме с низким уровнем шумов и устранением ореолов и звона на контурах изображения с конветацией в 16 бит  
# Подавление радужности изображения по умолчанию: включено
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: на основе векторного анализа оценки движения и его функций MCompensate с конечным фильтром dfttest
# Тип шарпера: LSFmod  
# Наличие фильтра DeBanding по умолчанию: LumaDBL
# Скорость обработки: медленная
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile
# Установите режим многопоточности для threads=4, как setmtmode(3,4)



