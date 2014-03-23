#avstp.dll
#RgTools.dll
#mvtools2.dll
#mt_masktools-26.dll
#Cnr2.dll
#SangNom.dll
#Bifrost.dll
#AddGrainC.dll
#Checkmate.dll
#flash3kyuu_deband.dll
#Chubbyrain2.avs
#aa.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(640)

Chubbyrain2().Checkmate(tthr2=0) # убрать радужность изображения

source = last
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
aa_clp = source.maa() 
preNR = source.blur(1.0)
preNR_super = preNR.MSuper(pel=2, sharp=1)
super = MSuper(pel=2, sharp=1)
bv2 = MAnalyse(preNR_super, isb = true, delta = 2, overlap=4)
bv1 = MAnalyse(preNR_super, isb = true, delta = 1, overlap=4)
fv1 = MAnalyse(preNR_super,isb = false, delta = 1, overlap=4)
fv2 = MAnalyse(preNR_super,isb = false, delta = 2, overlap=4)

degrain = source.MDegrain2(super, bv1,fv1,bv2,fv2,thSAD=150)
mask = source.mt_lut("x 3.10 ^ 41000 /")
degrainless = source.MDegrain2(super, bv1,fv1,bv2,fv2,thSAD=25)
flat = mt_merge(degrainless,degrain,mask,luma=true) # or swap degrainless for source if you want almost no touching of dark parts
mt_merge(flat, aa_clp, m_aa)

LSFmod(defaults="fast", strength=24)

# DeBanding
f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)

               

