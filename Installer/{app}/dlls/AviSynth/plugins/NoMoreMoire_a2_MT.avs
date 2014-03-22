#   NoMoreMoire filter by um3k/Justin Phillips                     
#   Based on a "Super Resolution" script by scharfis_brain     
#   Reduces moire, aliasing, noise, and compression artifacts 
#   in shaky, low-quality video from digital still cameras         
#   Alpha 2
    
    

function NoMoreMoire_alpha2_MT(clip c, int "mode", int "scale", int "r", int "lmshr", int "lmmed", int "lmmin", int "lmmax", int "cmshr", int "cmmed", int "cmthr", int "smthr", int "smrad", string "inputlog", bool "chroma")
{

    # 0 = lanczos-scaled video (for DeShaker log creation), 1 = filtered video, 2 = scaled with mask overlay, 3 = processed with mask overlay
    mode = Default(mode, 1)
    
    # Determines whether the chroma is included in the mask calculations
    chroma = Default(chroma, true)
    
    # Scaling factor of the video. Not much advantage to going above 2.
    scale = Default(scale, 2)
    
    # Temporal radius of the blending
    r = Default(r, 4)
    
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
    
    # for comparision
    i = c.lanczos4resize(c.width*scale,c.height*scale).converttoyv12()

    # for rendering
    j = c.nnedi2_rpow2(scale, cshift="spline36resize").converttoyv12()

    # Motion Comp
    comp = (Defined(inputlog)==true) ? Eval("""
        data = i
        j.depaninterleave(data,pixaspect=1.0,prev=r,next=r,subpixel=2,mirror=0,inputlog=inputlog)
    """) : Eval("""
        data = i.depanestimate(range=2,pixaspect=1.0,zoommax=1,improve=false,trust=0)
        j.depaninterleave(data,pixaspect=1.0,prev=r,next=r,subpixel=2,mirror=0)
    """)

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
    
    #~ return out
    return out
}

function DeflateX(clip c, int "count", bool "strict")    {
    strict = Default(strict, true)
    Assert((strict ? count >= 0 : true), "DeflateX: 'count' cannot be negative")
    return count > 0 ? c.MT_deflate().DeflateX(count=count - 1) : c
}