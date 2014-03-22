#   NoMoreMoire filter by um3k/Justin Phillips                     
#   Based on a "Super Resolution" script by scharfis_brain     
#   Reduces moire, aliasing, noise, and compression artifacts 
#   in shaky, low-quality video from digital still cameras         
#   Alpha 3

    #~ SetMTMode(2, 0)
    #~ SetMemoryMax(512)

function NoMoreMoire_alpha3(clip c, int "mode", int "scale", bool "j4i", int "globest", bool "preproc", int "r", string "mcmode", int "lmshr", int "lmmed", int "lmmin", int "lmmax", int "cmshr", int "cmmed", int "cmthr", int "smthr", int "smrad", string "inputlog", bool "chroma")
{
    # 0 = lanczos-scaled video (for DeShaker log creation), 1 = filtered video, 2 = scaled with mask overlay, 3 = processed with mask overlay
    mode = Default(mode, 1)
    
    # Determines whether the chroma is included in the mask calculations
    chroma = Default(chroma, true)
    
    # Scaling factor of the video. Not much advantage to going above 2.
    scale = Default(scale, 2)
    
    # Use NNEDI2-scaled clip for all calculations
    j4i = Default(j4i, false)
	
	# Global estimation mode
	globest = Default(globest, 1)
	
	# Set preprocessing
	preproc = Default(preproc, true)
    
    # Temporal radius of the blending
    r = Default(r, 4)
    
    # Whether to use MVTools for motion compensation
    mcmode = Default(mcmode, "blockonly")
    
    # Luma mask adjustments.
    lmshr = Default(lmshr, 5)
    lmmed = Default(lmmed, 3)
    lmmin = Default(lmmin, 25)
    lmmax = Default(lmmax, 70)
    
    # Chroma mask adjustments
    cmshr = Default(cmshr, 12)
    cmmed = Default(cmmed, 8)
    cmthr = Default(cmthr, 20)
    
    # Shadow mask adjusments. Smthr controls the cutoff point, smrad controls the feathering.
    smthr = Default(smthr, 27)
    smrad = Default(smrad, 3)
    
    ####################################################################################
    # Now stuff happens.
    
    # for rendering
    j = c.nnedi2_rpow2(scale, cshift="spline36resize").converttoyv12()
    
    # for comparision
    i1 = (j4i==true) ? j
    \   :   c.lanczos4resize(c.width*scale,c.height*scale).converttoyv12()

    # Motion Comp
	gendata = (globest==0) ? i1.depanestimate(range=2,pixaspect=1.0,zoommax=1,improve=false,trust=0)
	\	:	i1.GenDepan()
    data = (Defined(inputlog)==true) ? i1
    \   :   gendata

    # Pre Processing
    i = (preproc==true) ? i1.MoirePreProcess(data=data, inputlog=inputlog)
    \   :   i1
    
    globalonly = j.depaninterleave(data,pixaspect=1.0,prev=r,next=r,subpixel=2,mirror=0,inputlog=inputlog)
    
    global4hybrid = i.depaninterleave(data,pixaspect=1.0,prev=r,next=r,subpixel=2,mirror=0,inputlog=inputlog)
    
    blockonly = j.MVInterleave(i, r, false, alt=true, blk=8, ovr=4)
    
    hybrid = globalonly.MVInterleave(global4hybrid, r, true)
    
    precomp = (mcmode=="blockonly") ? blockonly
    \   :   (mcmode=="globalonly") ? globalonly
    \   :   (mcmode=="hybrid") ? hybrid
    \   :   Assert("NoMoreMoire: mcmode does not have the option "+mcmode)
    
    # Moire Mask / Processing
    vm = 2
    mcmask = mt_makediff(hybrid.MMask(mcvecthy, ml=3, gamma=2.0, kind=vm),hybrid.MMask(mcvecthy, ml=12, gamma=2.0, kind=vm)).mt_lut("x 128 - 2 *").Greyscale().mt_binarize(192).medianblur(5)
    m2mask = mt_makediff(precomp, globalonly).mt_lut("x 128 - abs 2 *", chroma="process").mt_binarize(20).medianblur(6)
    mmproc = mt_hysteresis(m2mask, mcmask)
    mcmerge = mt_merge(precomp, globalonly, mmproc, true)
    
    comp = (mcmode=="hybrid") ? mcmerge
    \   :   precomp

    # Mask Creation
    diff = (chroma==true) ? mt_makediff(comp, j.ChangeFPS(comp.Framerate), chroma="process").mt_lut("x 128 - abs 2 *", chroma="process")
    \   : mt_makediff(comp, j.ChangeFPS(comp.Framerate), chroma="1").mt_lut("x 128 - abs 2 *", chroma="1")
        
    # Luma Mask / Processing
    lumask = diff
    lms = lumask.DeflateX(count=lmshr).Medianblur(lmmed).mt_binarize(lmmax)
    lmb = lumask.mt_binarize(lmmin)
    lmproc = mt_hysteresis(lms, lmb).mt_expand()
    
    # Chroma Mask / Processing
    chromask = Overlay(diff.UToY(), diff.VtoY(), opacity=1.0, mode="lighten", pc_range=true).BicubicResize(lumask.width,lumask.height)
    cmproc = chromask.DeflateX(count=cmshr).Medianblur(cmmed).mt_binarize(cmthr)#.mt_expand()
    
    # Motion Mask
    momask = (chroma==true) ? Overlay(lmproc, cmproc, opacity=1.0, mode="lighten", pc_range=True)
    \   : lmproc

    # Shadow Mask
    finmask = (smthr==0) ? momask
    \   :   Overlay(momask, comp.mt_expand().YLevels(smthr-smrad, 1.000, smthr+smrad, 0, 255).invert().mt_expand().mt_deflate().ChangeFPS(comp.Framerate), opacity=1.0, mode="lighten", pc_range=true).Grayscale()
    
    # Mask Visualization
    maskvis = finmask.temporalsoften(r,255,255).selectevery(2*r+1,r).Greyscale()
    
    # Merge Compensated with Original to Protect Motion
    mix = mt_merge(comp, j.ChangeFPS(comp.Framerate), finmask, luma=true) 
    
    # The Important Part
    temp = mix.temporalsoften(r,255,255) 
    
    # Back to normal framerate
    dec = temp.selectevery(2*r+1,r) 
    
    # Decide output
    out = (mode==3) ? Overlay(dec.YLevels(16, 1.000, 235, 16, 127), maskvis.YLevels(0, 1.000, 255, 16, 235), opacity=1.0, mode="add", pc_range=false)
    \   :   (mode==2) ? Overlay(i.YLevels(16, 1.000, 235, 16, 127), maskvis.YLevels(0, 1.000, 255, 16, 235), opacity=1.0, mode="add", pc_range=false)
    \   :   (mode==1) ? dec
    \   :   i
    
    return out
    #~ return mcmerge#.temporalsoften(r,255,255).selectevery(2*r+1,r) 
    #~ return mcmask
    #~ return blockonly
    #~ return StackVertical(StackHorizontal(j.ChangeFPS(comp.Framerate), globalonly), StackHorizontal(blockonly, hybrid)).temporalsoften(r,255,255).selectevery(2*r+1,r) 
}

function DeflateX(clip c, int "count", bool "strict")    {
    strict = Default(strict, true)
    Assert((strict ? count >= 0 : true), "DeflateX: 'count' cannot be negative")
    return count > 0 ? c.MT_deflate().DeflateX(count=count - 1) : c
}

function MVInterleave(clip c, clip v, int rad, bool hybrid, int "borders", bool "alt", int "pel", int "blk", int "ovr")   {
    #~ borders = 16
    pel = Default(pel, 1)
    alt = Default(alt, false)
    blk = Default(blk, 16)
    ovr = Default(ovr, 8)
    super = v.MSuper(pel=pel)
    dumsuper = v.blankclip().MSuper(pel=1)
    altsuper = c.MSuper(pel=pel)
    #~ c = c.AddBorders(borders, borders, borders, borders, color=$000000)
    bv6 = MAnalyse(super, blksize=blk, isb = true, delta=6, overlap=ovr)
    bv5 = MAnalyse(super, blksize=blk, isb = true, delta=5, overlap=ovr)
    bv4 = MAnalyse(super, blksize=blk, isb = true, delta=4, overlap=ovr)
    bv3 = MAnalyse(super, blksize=blk, isb = true, delta=3, overlap=ovr)
    bv2 = MAnalyse(super, blksize=blk, isb = true, delta=2, overlap=ovr)
    bv1 = MAnalyse(super, blksize=blk, isb = true, overlap=ovr)
    nv0 = MAnalyse(dumsuper, blksize=blk, isb = true, overlap=ovr)
    fv1 = MAnalyse(super, blksize=blk, isb = false, overlap=ovr)
    fv2 = MAnalyse(super, blksize=blk, isb = false, delta=2, overlap=ovr)
    fv3 = MAnalyse(super, blksize=blk, isb = false, delta=3, overlap=ovr)
    fv4 = MAnalyse(super, blksize=blk, isb = false, delta=4, overlap=ovr)
    fv5 = MAnalyse(super, blksize=blk, isb = false, delta=5, overlap=ovr)
    fv6 = MAnalyse(super, blksize=blk, isb = false, delta=6, overlap=ovr)
    super = (alt==true) ? altsuper : super
    bc6 = MCompensate(c, super, bv6, thSCD1=600)
    bc5 = MCompensate(c, super, bv5, thSCD1=600)
    bc4 = MCompensate(c, super, bv4, thSCD1=600)
    bc3 = MCompensate(c, super, bv3, thSCD1=600)
    bc2 = MCompensate(c, super, bv2, thSCD1=600)
    bc1 = MCompensate(c, super, bv1, thSCD1=600)
    fc1 = MCompensate(c, super, fv1, thSCD1=600)
    fc2 = MCompensate(c, super, fv2, thSCD1=600)
    fc3 = MCompensate(c, super, fv3, thSCD1=600)
    fc4 = MCompensate(c, super, fv4, thSCD1=600)
    fc5 = MCompensate(c, super, fv5, thSCD1=600)
    fc6 = MCompensate(c, super, fv6, thSCD1=600)
    inter = (rad==1) ? Interleave(fc1, c, bc1)
    \   :   (rad==2) ? Interleave(fc2, fc1, c, bc1, bc2)
    \   :   (rad==3) ? Interleave(fc3, fc2, fc1, c, bc1, bc2, bc3)
    \   :   (rad==4) ? Interleave(fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4)
    \   :   (rad==5) ? Interleave(fc5, fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4, bc5)
    \   :   (rad==6) ? Interleave(fc6, fc5, fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4, bc5, bc6)
    \   :   Assert("MVInterleave: r must be 1-6")
    interhy = (rad==1) ? Interleave(fc1, c, bc1).SelectEvery(9, 3, 4, 5)
    \   :   (rad==2) ? Interleave(fc2, fc1, c, bc1, bc2).SelectEvery(25, 10, 11, 12, 13, 14)
    \   :   (rad==3) ? Interleave(fc3, fc2, fc1, c, bc1, bc2, bc3).SelectEvery(49, 21, 22, 23, 24, 25, 26, 27)
    \   :   (rad==4) ? Interleave(fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4).SelectEvery(81, 36, 37, 38, 39, 40, 41, 42, 43, 44)
    \   :   (rad==5) ? Interleave(fc5, fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4, bc5).SelectEvery(121, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65)
    \   :   (rad==6) ? Interleave(fc6, fc5, fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4, bc5, bc6).SelectEvery(169, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90)
    \   :   Assert("MVInterleave: r must be 1-6")
    global mcvect = (rad==1) ? Interleave(fv1, nv0, bv1)
    \   :   (rad==2) ? Interleave(fv2, fv1, nv0, bv1, bv2)
    \   :   (rad==3) ? Interleave(fv3, fv2, fv1, nv0, bv1, bv2, bv3)
    \   :   (rad==4) ? Interleave(fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4)
    \   :   (rad==5) ? Interleave(fv5, fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4, bv5)
    \   :   (rad==6) ? Interleave(fv6, fv5, fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4, bv5, bv6)
    \   :   Assert("MVInterleave: r must be 1-6")
    global mcvecthy = (rad==1) ? Interleave(fv1, nv0, bv1).SelectEvery(9, 3, 4, 5)
    \   :   (rad==2) ? Interleave(fv2, fv1, nv0, bv1, bv2).SelectEvery(25, 10, 11, 12, 13, 14)
    \   :   (rad==3) ? Interleave(fv3, fv2, fv1, nv0, bv1, bv2, bv3).SelectEvery(49, 21, 22, 23, 24, 25, 26, 27)
    \   :   (rad==4) ? Interleave(fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4).SelectEvery(81, 36, 37, 38, 39, 40, 41, 42, 43, 44)
    \   :   (rad==5) ? Interleave(fv5, fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4, bv5).SelectEvery(121, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65)
    \   :   (rad==6) ? Interleave(fv6, fv5, fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4, bv5, bv6).SelectEvery(169, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90)
    \   :   Assert("MVInterleave: r must be 1-6")
    out = (hybrid==true) ? interhy
    \   :   inter
    return out
}

function MFlowInterleave(clip c, clip v, int rad, bool hybrid, int "borders", bool "alt", int "pel", int "blk", int "ovr")   {
    #~ borders = 16
    pel = Default(pel, 1)
    alt = Default(alt, false)
    blk = Default(blk, 16)
    ovr = Default(ovr, 8)
    super = v.MSuper(pel=pel)
    dumsuper = v.blankclip().MSuper(pel=1)
    altsuper = c.MSuper(pel=pel)
    #~ c = c.AddBorders(borders, borders, borders, borders, color=$000000)
    bv6 = MAnalyse(super, blksize=blk, isb = true, delta=6, overlap=ovr)
    bv5 = MAnalyse(super, blksize=blk, isb = true, delta=5, overlap=ovr)
    bv4 = MAnalyse(super, blksize=blk, isb = true, delta=4, overlap=ovr)
    bv3 = MAnalyse(super, blksize=blk, isb = true, delta=3, overlap=ovr)
    bv2 = MAnalyse(super, blksize=blk, isb = true, delta=2, overlap=ovr)
    bv1 = MAnalyse(super, blksize=blk, isb = true, overlap=ovr)
    nv0 = MAnalyse(dumsuper, blksize=blk, isb = true, overlap=ovr)
    fv1 = MAnalyse(super, blksize=blk, isb = false, overlap=ovr)
    fv2 = MAnalyse(super, blksize=blk, isb = false, delta=2, overlap=ovr)
    fv3 = MAnalyse(super, blksize=blk, isb = false, delta=3, overlap=ovr)
    fv4 = MAnalyse(super, blksize=blk, isb = false, delta=4, overlap=ovr)
    fv5 = MAnalyse(super, blksize=blk, isb = false, delta=5, overlap=ovr)
    fv6 = MAnalyse(super, blksize=blk, isb = false, delta=6, overlap=ovr)
    super = (alt==true) ? altsuper : super
    bc6 = MFlow(c, super, bv6, thSCD1=500)
    bc5 = MFlow(c, super, bv5, thSCD1=500)
    bc4 = MFlow(c, super, bv4, thSCD1=500)
    bc3 = MFlow(c, super, bv3, thSCD1=500)
    bc2 = MFlow(c, super, bv2, thSCD1=500)
    bc1 = MFlow(c, super, bv1, thSCD1=500)
    fc1 = MFlow(c, super, fv1, thSCD1=500)
    fc2 = MFlow(c, super, fv2, thSCD1=500)
    fc3 = MFlow(c, super, fv3, thSCD1=500)
    fc4 = MFlow(c, super, fv4, thSCD1=500)
    fc5 = MFlow(c, super, fv5, thSCD1=500)
    fc6 = MFlow(c, super, fv6, thSCD1=500)
    inter = (rad==1) ? Interleave(fc1, c, bc1)
    \   :   (rad==2) ? Interleave(fc2, fc1, c, bc1, bc2)
    \   :   (rad==3) ? Interleave(fc3, fc2, fc1, c, bc1, bc2, bc3)
    \   :   (rad==4) ? Interleave(fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4)
    \   :   (rad==5) ? Interleave(fc5, fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4, bc5)
    \   :   (rad==6) ? Interleave(fc6, fc5, fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4, bc5, bc6)
    \   :   Assert("MVInterleave: r must be 1-6")
    interhy = (rad==1) ? Interleave(fc1, c, bc1).SelectEvery(9, 3, 4, 5)
    \   :   (rad==2) ? Interleave(fc2, fc1, c, bc1, bc2).SelectEvery(25, 10, 11, 12, 13, 14)
    \   :   (rad==3) ? Interleave(fc3, fc2, fc1, c, bc1, bc2, bc3).SelectEvery(49, 21, 22, 23, 24, 25, 26, 27)
    \   :   (rad==4) ? Interleave(fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4).SelectEvery(81, 36, 37, 38, 39, 40, 41, 42, 43, 44)
    \   :   (rad==5) ? Interleave(fc5, fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4, bc5).SelectEvery(121, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65)
    \   :   (rad==6) ? Interleave(fc6, fc5, fc4, fc3, fc2, fc1, c, bc1, bc2, bc3, bc4, bc5, bc6).SelectEvery(169, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90)
    \   :   Assert("MVInterleave: r must be 1-6")
    global mcvect = (rad==1) ? Interleave(fv1, nv0, bv1)
    \   :   (rad==2) ? Interleave(fv2, fv1, nv0, bv1, bv2)
    \   :   (rad==3) ? Interleave(fv3, fv2, fv1, nv0, bv1, bv2, bv3)
    \   :   (rad==4) ? Interleave(fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4)
    \   :   (rad==5) ? Interleave(fv5, fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4, bv5)
    \   :   (rad==6) ? Interleave(fv6, fv5, fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4, bv5, bv6)
    \   :   Assert("MVInterleave: r must be 1-6")
    global mcvecthy = (rad==1) ? Interleave(fv1, nv0, bv1).SelectEvery(9, 3, 4, 5)
    \   :   (rad==2) ? Interleave(fv2, fv1, nv0, bv1, bv2).SelectEvery(25, 10, 11, 12, 13, 14)
    \   :   (rad==3) ? Interleave(fv3, fv2, fv1, nv0, bv1, bv2, bv3).SelectEvery(49, 21, 22, 23, 24, 25, 26, 27)
    \   :   (rad==4) ? Interleave(fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4).SelectEvery(81, 36, 37, 38, 39, 40, 41, 42, 43, 44)
    \   :   (rad==5) ? Interleave(fv5, fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4, bv5).SelectEvery(121, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65)
    \   :   (rad==6) ? Interleave(fv6, fv5, fv4, fv3, fv2, fv1, nv0, bv1, bv2, bv3, bv4, bv5, bv6).SelectEvery(169, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90)
    \   :   Assert("MVInterleave: r must be 1-6")
    out = (hybrid==true) ? interhy
    \   :   inter
    return out
}

# PreProcess for creating motion vectors (blockonly)
function MoirePreProcess(clip c, clip "data", string "inputlog")
{
	ci = c.DePanInterleave(data=data, prev=1, next=1, inputlog=inputlog)
	cd = ci.DeGrainMedian(limitY=15, limitUV=6, mode=0, interlaced=false, norow=false)
	return cd.SelectEvery(3, 1)
}

# Generates depan data
function GenDepan(clip c)
{
	vectors = c.MSuper().MAnalyse(isb = false)
	return c.MDepan(vectors, pixaspect=1.000, error=30, thSCD1=400)
}