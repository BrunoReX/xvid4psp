#avstp.dll
#EEDI2.dll
#EEDI3.dll
#nnedi3.dll
#mt_masktools-26.dll
#SangNom.dll
#tcanny.dll
#Fluxsmooth.dll
#mvtools2.dll
#MSharpen.dll
#awarpsharp2.dll
#RgTools.dll
#warpsharp.dll
#variableblur.dll
#dfttestmod.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#Soothe.avs
#Dehalo_alpha.avs
#LimitedSharpenFaster mod.avs
#TAA.avsi
#ContraSharpen_mod.avsi


setmtmode(2)
# setmemorymax(640)

source   = last
m_edge  = mt_edge("sobel",7,7,5,5).mt_inflate()

zero_l = 64       
m_luma = source.mt_lut("x "+String(zero_l)+" - Abs 255 * "+String(zero_l)+" 128 - Abs 128 + /")

m_aa   = m_edge.mt_expand()
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")

aa_clp = source.TAA(preaa=1, aatype=1, mtype=1, sharp=0, src=source, mclip=m_edge)
dh_clp = aa_clp.Dehalo_alpha()
denoiced = source.dfttest(sigma=4.0, sigma2=4.0, Y=true, U=true, V=true)
non_hl = mt_merge(denoiced, aa_clp, m_aa)
mt_merge(non_hl, dh_clp, m_halo)

sharp = CSmod(source, chroma=true, Tlimit=true)

# DeBanding 
db_clp = sharp.LumaDB(g1str=1.0,g2str=0.8,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false) 
mt_merge(db_clp, sharp, m_luma, luma=true)


# Назначение: для обработки аниме с средним уровнем шумов с применением аниайлиазинга и дебандинга
# Тип антиайлизинга по умолчанию: TAA
# Тип шумоподавителя: dfttest
# Тип шарпера: CSmod 
# Наличие фильтра DeBanding по умолчанию: LumaDB
# Скорость обработки: медленная