#RemoveGrainSSE2.dll
#dfttest.dll
#mvtools2.dll
#mt_masktools-26.dll
#hqdn3d.dll
#DeGrainMedian.dll
#SangNom.dll
#MaskTools.dll
#Unfilter.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#DfttestMC.avs
#mt_xxpand_multi.avsi
#GrainFactory3.avs
#Dehalo_alpha.avs
#aa.avs


setmtmode(2)
# setmemorymax(640)

dclip = hqdn3d(20, lt=0, ct=0)
line_mask = dclip.mt_edge(mode="cartoon", thY1=10, thY2=10).mt_expand().mt_deflate()
edge_mask = dclip.mt_edge(mode="prewitt", thY1=9, thY2=9).mt_expand().mt_deflate()
hys_mask = mt_hysteresis(line_mask, edge_mask).mt_binarize(threshold=16)
m_edge = mt_edge("sobel", 7, 20).mt_inflate()
m_aa   = m_edge.mt_expand()
aa_clp = maa()
denoise = DfttestMC(sigma=4, mdg=true, tbsize=1)
mt_merge(denoise, last, edge_mask, luma=true)
 
MaskedMerge(last, DfttestMC(sigma=1, mdg=true, tbsize=1), hys_mask)
 
dmask = mt_edge(mode="prewitt", thY1=13, thY2=13).mt_expand().mt_deflate().mt_binarize(threshold=16)
DB = GradFun3(thr=0.5, smode=0)
flat = mt_merge(DB, last, dmask, luma=true)
mt_merge(flat, aa_clp, m_aa)
 
L_mask = mt_lut("225 x - 4 *").mt_inflate()
grain = GrainFactory3(1, 1, 1, 55, 70, 62, 1.2, 0.9, 0.6)
mt_merge(grain, last, L_mask.mt_invert(), luma=true)


# Стандартный клип обработки аниме
