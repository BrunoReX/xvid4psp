# Motion compensated denoiser for progressive source clip with prefiltering optimised to reduce high-contrast noise
# Uses MVTools2 and RemoveGrain
function FizzKiller ( clip input, int "degrain", int "thSAD", int "thSCD1", int "limit", 
 \                  int "pel", int "sharp", int "blksize", int "overlap", int "search", bool"chroma", bool"truemotion")
{
o       = input
degrain = default( degrain,         2 ) # Degraining method (1 - 3)
blksize = default( blksize,        16 ) # MAnalyse block size (4, 8, 16, 32)
overlap = default( overlap, blksize/2 ) # MVAnalyse block overlap (even, ov<=blksize/2)
pel     = default( pel,             2 ) # MVAnalyse pel (1, 2, 4)
sharp   = default( sharp,           2 ) # MVAnalyse sharp (1, 2)
search  = default( search,          4 ) # MVAnalyse search (1-5)
thSAD   = default( thSAD,         350 ) # MVDegrain thSAD
thSCD1  = default( thSCD1,        450 ) # MVDegrain thSCD1
limit   = default( limit,         255 ) # MVDegrain limit (0 - 255)
chroma  = default( chroma,       true )
planes  = chroma?4:0
truemotion  = default( truemotion, false )

# Prefilter the clip
calm = o.invert("Y").levels(0, 0.5, 255, 0, 255, coring = false)
calm = calm.removegrain(mode = 17)
calm = calm.removegrain(mode = 17)
calm = calm.removegrain(mode = 17)

calm_super    = calm.MSuper(pel=2, hpad=blksize-overlap, vpad=blksize-overlap, sharp=sharp, chroma=chroma)
source_super  = o.MSuper(pel=2, hpad=blksize, vpad=blksize, sharp=sharp, levels=1, chroma=chroma)

bv3     = (degrain > 2) ?
 \        calm_super.MAnalyse(isb = true, delta = 3, overlap=overlap, blksize=blksize, truemotion=truemotion, search=search, chroma=chroma) : BlankClip
bv2     = (degrain > 1) ? 
 \        calm_super.MAnalyse(isb = true, delta = 2, overlap=overlap, blksize=blksize, truemotion=truemotion, search=search, chroma=chroma) : BlankClip
bv1     = calm_super.MAnalyse(isb = true, delta = 1, overlap=overlap, blksize=blksize, truemotion=truemotion, search=search, chroma=chroma)
fv1     = calm_super.MAnalyse(isb = false,delta = 1, overlap=overlap, blksize=blksize, truemotion=truemotion, search=search, chroma=chroma)
fv2     = (degrain > 1) ?
 \        calm_super.MAnalyse(isb = false,delta = 2, overlap=overlap, blksize=blksize, truemotion=truemotion, search=search, chroma=chroma) : BlankClip
fv3     = (degrain > 2) ?
 \        calm_super.MAnalyse(isb = false,delta = 3, overlap=overlap, blksize=blksize, truemotion=truemotion, search=search, chroma=chroma) : BlankClip
 
# Finally, MDegrain

output  = (degrain == 3) ? o.MDegrain3(source_super, bv1, fv1, bv2, fv2, bv3, fv3, thSAD=thSAD, thSCD1=thSCD1, limit=limit, plane=planes) :
 \        (degrain == 2) ? o.MDegrain2(source_super, bv1, fv1, bv2, fv2, thSAD=thSAD, thSCD1=thSCD1, limit=limit, plane=planes)           :
 \                         o.MDegrain1(source_super, bv1, fv1, thSAD=thSAD, thSCD1=thSCD1, limit=limit, plane=planes)

return(output)
}

