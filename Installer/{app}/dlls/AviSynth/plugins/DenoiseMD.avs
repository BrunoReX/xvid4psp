function DenoiseMD1(clip c, float "sigma", int "blksize", int "thcomp", float "str", bool "lsb") {
	# Fast, accurate 8/16-bit denoise by Andrew Revvo, 2011
	# Requires: mvtools, dfttest from Dither, BlendClips, Range8to16
	sigma = default(sigma, 6)
	blksize = default(blksize,16)
	overlap = blksize/2
	thcomp = default(thcomp, 70)
	str = default(str, 0.8)
	lsb = default(lsb, true)
	super = MSuper(c, pel=1, sharp=2)
	b1 = super.MAnalyse(isb=true,  delta=1, blksize=blksize, overlap=overlap, search=5, sadx264=3)
	f1 = super.MAnalyse(isb=false, delta=1, blksize=blksize, overlap=overlap, search=5, sadx264=3)
	bc1 = c.MCompensate(super, b1, thSAD=thcomp)
	fc1 = c.MCompensate(super, f1, thSAD=thcomp)
	comp = Interleave(fc1, c, bc1)
	comp.dfttest(sigma=sigma, sbsize=12, sosize=8, tbsize=3, threads=1, lsb=lsb)
	SelectEvery(3, 1)
	BlendClips(lsb?c.Range8to16():c, str, lsb)
}

function DenoiseMD2(clip c, float "sigma", int "blksize", int "thcomp", float "str", bool "lsb") {
	# Fast, accurate 8/16-bit denoise by Andrew Revvo, 2011
	# Requires: mvtools, dfttest from Dither, BlendClips, Range8to16
	sigma = default(sigma, 6)
	blksize = default(blksize,16)
	overlap = blksize/2
	thcomp = default(thcomp, 70)
	str = default(str, 0.8)
	lsb = default(lsb, true)
	super = MSuper(c, pel=2, sharp=2)
	b2 = super.MAnalyse(isb=true,  delta=2, blksize=blksize, overlap=overlap, search=5, sadx264=3)
	b1 = super.MAnalyse(isb=true,  delta=1, blksize=blksize, overlap=overlap, search=5, sadx264=3)
	f1 = super.MAnalyse(isb=false, delta=1, blksize=blksize, overlap=overlap, search=5, sadx264=3)
	f2 = super.MAnalyse(isb=false, delta=2, blksize=blksize, overlap=overlap, search=5, sadx264=3)
	bc2 = c.MCompensate(super, b2, thSAD=thcomp)
	bc1 = c.MCompensate(super, b1, thSAD=thcomp)
	fc1 = c.MCompensate(super, f1, thSAD=thcomp)
	fc2 = c.MCompensate(super, f2, thSAD=thcomp)
	comp = Interleave(fc2, fc1, c, bc1, bc2)
	comp.dfttest(sigma=sigma, sbsize=12, sosize=8, tbsize=5, threads=1, lsb=lsb)
	SelectEvery(5, 2)
	BlendClips(lsb?c.Range8to16():c, str, lsb)
}

function BlendClips(clip c1, clip c2, float "str", bool "lsb") {
	# Requires: Dither, mt_masktools2
	str = Round(default(str, 0.5)*255)
	lsb = default(lsb, true)
	m = c1.mt_lut(Y=str,U=0,V=0)
	lsb ? Dither_merge16(c1, c2, m) : mt_merge(c1, c2, m, luma=true)
}

function Range8to16(clip c) {
	# Requires: mt_masktools2
	StackVertical(c, c.mt_lut(Y=0,U=0,V=0))
}

function DiffCol(clip a, clip b, int "col", int "colnum", bool "hista", bool "histb") {
	# By Andrew Revvo 2011
	col = default(col, 1)
	colnum = default(colnum, 8)
	hista = default(hista, true)
	histb = default(histb, true)
	w1 = Floor(b.width()/colnum/2)*2
	w = b.width()
	h = b.height()
	a = (a.width() != w) ? a.Spline36Resize(w, h) : a
	ac = a.Crop(w1*(col), 0, w1,h)
	bc = b.Crop(w1*(col), 0, w1,h)
	dc = Subtract(bc, ac).Levels(117,1,159,0,255)
	b.Overlay(ac, w1*(col+1),0)
	Overlay(dc, w1*(col+2),0)
	histb ? Overlay(b.Histogram(mode="levels").Crop(w, 0, 256,226), w-256-4, h-226-130) : last
	hista ? Overlay(a.Histogram(mode="levels").Crop(w, 0, 256,226), w-256-256-6, h-226-130) : last
}