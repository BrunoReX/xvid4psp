#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#deen.dll
#dfttestmod.dll
#EEDI2.dll
#mvtools2.dll
#mt_masktools-26.dll
#Toon-v1.1.dll
#SangNom.dll
#medianblur.dll
#aWarpsharp2.dll
#Warpsharp.dll
#medianblur.dll
#mipsmooth.dll
#MSharpen.dll
#NoiseGenerator.dll
#Dither.dll
#medianblur.dll
#AddGrainC.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#mt_xxpand_multi.avsi
#aa.avs
#minblur.avs
#DeHalo_2.avs
#EdgeCleaner.avs
#DeRainbow2.avs
#Dither.avsi
#ContraHD.avs


setmtmode(2)
# setmemorymax(768)

#ColorYUV(gain_y=0,cont_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) 

# ===== подавление радужных помех =====
DeRainbow2()  

# ==== предварительное повышение резкости ====
# warpsharp(90,5,85,-0.6)

# ===== Шумоподавитель =====
source  = last
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")
aa_clp = source.maa()
# aa_halo = aa_clp.DeHalo_2()
super = source.MSuper(pel=2, sharp=2, rfilter=2)
vf2 = super.MAnalyse(isb = false,lambda = 768, blksize = 8, overlap = 4, delta = 2, search = 3, searchparam = 3)
vf1 = super.MAnalyse(isb = false,lambda = 768, blksize = 8, overlap = 4, delta = 1, search = 3, searchparam = 3)
vb1 = super.MAnalyse(isb = true, lambda = 768, blksize = 8, overlap = 4, delta = 1, search = 3, searchparam = 3)
vb2 = super.MAnalyse(isb = true, lambda = 768, blksize = 8, overlap = 4, delta = 2, search = 3, searchparam = 3)

mask1 = source.mmask(vb1, ml = 300, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 400) # маска1 SAD назад
mask2 = source.mmask(vb2, ml = 300, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 400) # маска2 SAD назад
mask3 = source.mmask(vf1, ml = 300, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 400) # маска1 SAD вперед
mask4 = source.mmask(vf2, ml = 300, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 400) # маска2 SAD вперед
tsadb = mt_lutxy(mask1,mask2,"x 255 < y 255 < x y + 2 / x ? y ?")
tsadf = mt_lutxy(mask3,mask4,"x 255 < y 255 < x y + 2 / x ? y ?")
tmask = mt_lutxy(tsadb,tsadf,"x 255 < y 255 < x y + 2 / x ? y ? 32 - 255 * 223 /")

den = source.MDegrain2(super,vb1,vf1,vb2,vf2,thSAD=256,thSCD1=250,thSCD2=104)
mrg = mt_merge(source, den, tmask, Y=3, U=3,V=3)
mrg_super = mrg.Msuper(pel=2)

cf2 = MCompensate(mrg, mrg_super, vf2, thSCD1 = 400)
cf1 = MCompensate(mrg, mrg_super, vf1, thSCD1 = 400)
cb1 = MCompensate(mrg, mrg_super, vb1, thSCD1 = 400)
cb2 = MCompensate(mrg, mrg_super, vb2, thSCD1 = 400)

interleave(cf2, cf1, mrg, cb1, cb2)
dfttest(sigma=10, tbsize=5, lsb=true)
selectevery(5,2)

# DeBanding
# setmtmode(5)
# DB = last.LumaDBL(lsb=true, lsb_in=true) 
# setmtmode(2)
DB = last.GradFun3(smode=1, thr=0.35, lsb=true, lsb_in=true)

# ContraHD
den = DB.DitherPost(mode=-1)
NR = mt_merge(den, aa_clp, m_aa)
# NR = mt_merge(NR, dh_clp, m_halo)
output = NR.EdgeCleaner(smode=1, 20) 
sharp8 = ContraHD(output,source,cb1,cf1,3)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=6,ampn=1,ampo=0) 
lsb_out




# Назначение: качественный пресет для зашумленного аниме 
# Подавление радужности изображения по умолчанию: отключено
# Тип затемнения линий по умолчанию: отключена
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: на основе векторного анализа оценки движения c радиусом 1 и его функции MCompensate с конечным фильтром dfttest 
# Тип шарпера: ContraHD
# Наличие фильтра DeBanding по умолчанию: включен Dither
# Скорость обработки: медленная
