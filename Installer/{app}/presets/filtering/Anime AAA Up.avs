#avstp.dll
#nnedi3.dll
#mt_masktools-26.dll
#awarpsharp2.dll
#RgTools.dll
#mvtools2mod.dll
#warpsharp.dll
#SangNom.dll
#Unfilter.dll
#dfttestmod.dll
#AddGrainC.dll
#dither.dll
#YSharp.dll
#aa.avs
#HighPassSharp.avs
#Dehalo_Alpha.avs
#Dither.avsi
#EdgeCleaner.avs
#mt_xxpand_multi.avsi
#FastLineDarken 1.4x MT MOD.avsi


# setmtmode(2)
# setmemorymax(1280)

nnedi3_rpow2(rfactor=2, nsize=0, nns=4, qual=2, etype=0, pscrn=4, cshift="lanczosresize", threads=1)
WarpSharp(56,6,170,0)

LanczosResize(1440, 1080, taps=16) # 1200х720 for AR 16:9
LanczosResize(1800, 1350, taps=4)  # 1500х900 for AR 16:9
LanczosResize(1440, 1080, taps=16) # 1200х720 for AR 16:9
WarpSharp(56,6,170,0)

Dither_convert_8_to_16 ()
W = 1440 # 1200 for AR 16:9  
H = 1080 # 720
Dither_resize16 (W, H)

Dither_convert_yuv_to_rgb (matrix="601", output="rgb48y", lsb_in=true)
r = SelectEvery (3, 0)
g = SelectEvery (3, 1)
b = SelectEvery (3, 2)
Dither_convert_rgb_to_yuv (r, g, b, matrix="709", lsb=false, mode=0)

m_edge = mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")

aa_clp = AAA()
dh_clp = aa_clp.Dehalo_Alpha(rx=2.4,ry=2.4,darkstr=0.1,brightstr=1.2,ss=1.5)
shrp = YSharp(1.6)

# ==== Denoiced =====
super  = MSuper(pel=2,sharp=2)
ssuper = MSuper(shrp, pel=2,sharp=2,levels=1)
multi_vec = MAnalyse (super, multi=true, delta=2, blksize=16, overlap=8, truemotion=false, lambda=1200)
shrp.MDegrainN (ssuper, multi_vec, 2, thSAD=400, thSAD2=150, lsb=true)

# ==== DeBanding ====
# DB = last.GradFun3(smode=1, thr=0.5, radius=16, lsb=true, lsb_in=true)
GradFun3 (thr=1.4*0.3, smode=1, radius=16, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.15, uvar=0, soft=2) 

den = DB.DitherPost(mode=-1)
flat = mt_merge(den, aa_clp, m_aa)
mt_merge(den, dh_clp, m_halo)
EdgeCleaner(smode=1, 20)
output = ConditionalFilter(last.FastLineDarkenMod(strength=24,threshold=1, thinning=9,luma_cap=200).aWarpSharp2(thresh=48, depth=8), last, "AverageLuma()",">","50")
sharp8 = output.HighPassSharp(r=0.15)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=1) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0)   # for x264 encode 
lsb_out

AddBorders(240, 0, 240, 0) # for AR 4:3

# Назначение : Для апскейла аниме 
# Наличие антиайлиазинга : включен maa
# Шумоподавители: MDegrainN
# Тип шарпера : HighPassSharp или LSFmod
# Наличие DeBanding : включен GradFun3
# Кроп и ресайз выполнить в начале скрипта
