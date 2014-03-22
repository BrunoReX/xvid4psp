#avstp.dll
#DePan.dll
#DePanEstimate.dll
#dfttestmod.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#checkmate.dll
#Deen.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#SangNom.dll
#Warpsharp.dll
#awarpsharp2.dll
#dither.dll
#AddGrainC.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#SmoothAdjust-ICL-x86.dll
#TIVTC.dll
#frfun7.dll
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#Dither.avsi
#stab.avs
#sbr.avs
#Vinverse.avs
#EdgeCleaner.avs
#HighPassSharp.avs
#maa.avs
#mt_xxpand_multi.avsi
#O16mod_v1.6.1.avsi
#FastLineDarken 1.4x MT MOD.avsi
#LimitedSharpenFaster mod.avs


setmtmode(2)
# setmemorymax(1280)

MergeChroma(aWarpSharp2(chroma=4)) 

# ===== global motion stabilization stage =====
# Stab (range=1, dxmax=2, dymax=2) # or dxmax=4 dymax=4
  
# ===== Шумоподавление и DeBanding =====
# Your favourite 8-bit denoiser here, doing the main job

source = last
W = width(source)
H = height(source)

m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()

# ==== антиайлиазинг =====
aa_clp = source.maa()
  
filter = source.dfttest(sigma=8, tbsize=1, threads=1, lsb=true)
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
# checkmate(100) # DeDot
dfttest (sigma=1.5, tbsize=3, lsb=true, threads=1)
SelectEvery (3, 1)

# ==== DeBanding ===
# setmtmode(5)
# DB = last.LumaDBL(g1str=12, g2str=6, g3str=1, thr=0.35, lsb=true, lsb_in=true) 
# setmtmode(2)

# DB = last.GradFun3(smode=1, thr=0.35, radius=12, lsb_in=true, lsb=true)

db1 = last.GradFun3(smode=1, radius=20, thr=0.45, thrc=0.45, mask=0, lsb_in=true, lsb=true, Y=3, U=3, V=3)
db2 = db1.f3kdb(20, 64, 64, 64, 0, 0, input_mode=1, output_mode=1).Dither_limit_dif16(last, thr=0.60, Y=3, U=3, V=3)
DB  = db2.Dither_add_grain16 (var=0.1, uvar=0, soft=2) 

den = DB.DitherPost(mode=-1)   # 16 ->  8 bits
smE = den.EdgeCleaner(smode=2,strength=17)
spat = mt_merge(smE, aa_clp, m_aa)

# ===== затемнение линий =====
dark = ConditionalFilter(spat.FastLineDarkenMod(strength=19,threshold=1,thinning=9,luma_cap=200).aWarpSharp2(thresh=48, depth=4), spat, "AverageLuma()",">","50")

# ==== Sharpening ====
# sharp8 = dark.HighPassSharp(r=0.15) # for HD
Sclp = dark.LSFmod(defaults="fast",strength=80,preblur="ON") # for SD
Tmax = source.mt_logic(cf1,"max",U=1,V=1).mt_logic(cb1,"max",U=1,V=1)
Tmin = source.mt_logic(cf1,"min",U=1,V=1).mt_logic(cb1,"min",U=1,V=1)
sharp8 = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)

mask = mt_lutxy (sharp8, spat, "x y != 255 0 ?", u=0, v=0) #  8, 8 ->  8
s16  = sharp8.U16()                                        #  8 -> 16
Dither_merge16_8 (DB, s16, mask)                           # 16, 16, 8 -> 16

# ==== ресайз 16-битного видео ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10 # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-бит
""") : Down10(8)                           #8-бит  


# Для конвертации 8 битного исходника аниме в 16 бит c шумоподавителем dfttest 
# Тип шарпера WarpSharp
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile
# Установите режим многопоточности для threads=4, как setmtmode(3,4)
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: пространственно-временной фильтр dfttest + MCompensate
# Наличие фильтра DeBanding по умолчанию: включен LumaDBL
# Скорость обработки: низкая