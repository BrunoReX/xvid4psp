Function zzz_denoise (clip src, Float "sigma", Int "thr", Bool "mask")
{
	sigma = Default (sigma,    16)
	thr   = Default (thr,       5)
	mask  = Default (mask,  False)
  
  w = src.Width ()
	h = src.Height ()

	# Motion analysis
	pre = src.dfttest(Y=true,U=false,V=false,sigma=sigma*1.25,tbsize=1,ftype=1)
  pre_super = MSuper(pre, pel=2, sharp=2, rfilter=2)
  src_super = MSuper(src, pel=2, sharp=2, levels=1)
	fv3 = pre_super.MAnalyse (isb=false, delta=3, overlap=4)
	fv2 = pre_super.MAnalyse (isb=false, delta=2, overlap=4)
	fv1 = pre_super.MAnalyse (isb=false, delta=1, overlap=4)
	bv1 = pre_super.MAnalyse (isb=true,  delta=1, overlap=4)
	bv2 = pre_super.MAnalyse (isb=true,  delta=2, overlap=4)
	bv3 = pre_super.MAnalyse (isb=true,  delta=3, overlap=4)

	fc2 = src.MCompensate (src_super, fv2)
	fc1 = src.MCompensate (src_super, fv1)
	bc1 = src.MCompensate (src_super, bv1)
	bc2 = src.MCompensate (src_super, bv2)

	# Spatio-temporal denoising using modified dfttest
	inter = Interleave (fc2, fc1, src, bc1, bc2)
	mvden = inter.dfttest(sigma=sigma,tbsize=5,ftype=1,lsb=true)	# Double height
	c_dft = mvden.SelectEvery (5, 2)

	# Temporal-only denoising using modified MDegrain
	c_deg = src.MDegrain3 (src_super, bv1, fv1, bv2, fv2, bv3, fv3,lsb=true)	# Double height

	# Spatio-temporal denoising smoothes too much the details,
	# therefore we use pure temporal denoising on edges or detailed areas.
	edge_src = c_deg.Crop (0, 0, w, h)
	edge_mask = edge_src.mt_edge (mode="prewitt", thY1=thr, thY2=thr)
	edge_mask = edge_mask.mt_expand ()
	edge_mask = StackVertical (edge_mask, edge_mask)	# Double height
	c_hyb = mt_merge (c_dft, c_deg, edge_mask, luma=true, y=3, u=3, v=3)

	return (mask ? edge_mask.GreyScale () : c_hyb)
}

