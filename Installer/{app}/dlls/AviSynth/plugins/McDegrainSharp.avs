function McDegrainSharp(clip c, int "frames", float "bblur", float "csharp", bool "bsrch")
{ # Based on MCDegrain By Didee, http://forum.doom9.org/showthread.php?t=161594
  # Also based on DiDee observations in this thread: http://forum.doom9.org/showthread.php?t=161580 
  # "Denoise with MDegrainX, do slight sharpening where motionmatch is good, do slight blurring where motionmatch is bad"
  # In areas where MAnalyse cannot find good matches, the blur() will be dominant.
  # In areas where good matches are found, the sharpen()'ed pixels will overweight the blur()'ed pixels
  # when the pixel averaging is performed. 
	frames = default(frames, 2)
	bblur  = default(bblur, 0.6)
	csharp = default(csharp, 0.6)
	bsrch  = default(bsrch, true)
	bs = (c.width>960) ? 16 : 8
	
	c2 = c.blur(bblur)
	super = bsrch ? c2.MSuper(pel=2, sharp=1) : c.MSuper(pel=2, sharp=1)
	super_rend 	= c.sharpen(csharp).MSuper(pel=2, sharp=1,levels=1)
	backward_vec3 = MAnalyse(super, isb = true, delta = 3, blksize=bs, overlap=bs/2)
	backward_vec2 = MAnalyse(super, isb = true, delta = 2, blksize=bs, overlap=bs/2)
	backward_vec1 = MAnalyse(super, isb = true, delta = 1, blksize=bs, overlap=bs/2)
	forward_vec1 = MAnalyse(super, isb = false, delta = 1, blksize=bs, overlap=bs/2)
	forward_vec2 = MAnalyse(super, isb = false, delta = 2, blksize=bs, overlap=bs/2)
	forward_vec3 = MAnalyse(super, isb = false, delta = 3, blksize=bs, overlap=bs/2)	
	(frames<=0) ? c :\
	(frames==1) ? c2.MDegrain1(super_rend, backward_vec1,forward_vec1,thSAD=400) :\
	(frames==2) ? c2.MDegrain2(super_rend, backward_vec1,forward_vec1,backward_vec2,forward_vec2,thSAD=400) :\
		      c2.MDegrain3(super_rend, backward_vec1,forward_vec1,backward_vec2,forward_vec2,backward_vec3,forward_vec3,thSAD=400)
	return(last)
}