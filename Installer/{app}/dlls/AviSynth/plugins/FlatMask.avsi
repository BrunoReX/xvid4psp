##################
### 10-06-2011
### by cretindesalpes: (http://forum.doom9.org/showthread.php?p=1507257#post1507257)
### 
### masks out flat areas with weak, small or no detail.
### Useful for denoising cel animation while protecting detailed backgrounds
### 
### Use like this:
###
### raw=last
### dfttest()
### flatmask(raw)
### 
### 
###########################

function FlatMask(clip filtered, clip raw, int "str", int "Lstr", bool "luma", int "r", bool "invert", bool "debug"){

 str   = string(default(str, 6))     # strength of the mask, the higher more detail protection
 th    = default(Lstr,75)            # Start of penumbra for masking when luma=true
 luma  = default(luma,true)          # Enables dark zones to be masked out (for denoising) independent of detail
 r     = default(r, 3)               # mask blurriness
 debug = default(debug, false)       # Shows the mask
 in    = default(invert, false)      # Inverts the mask

e1 = raw.mt_edge (mode="prewitt", thY1=0, thY2=255)
e2 = raw.mt_edge (mode="min/max", thY1=0, thY2=255)
mt_makediff (e1, e2)
mt_lut ("x 128 - 0 max 256 / 0.25 ^ 256 *")
mt_deflate ().mt_deflate ()
luma ? mt_logic(last,raw.mt_binarize(threshold=th),"min") : last
w = width ()
h = height ()
BicubicResize (w / (r*2) * 2, h / (r*2) * 2, 1, 0)
TemporalSoften (2, 20, 255)
mt_expand ().mt_inpand ().mt_inpand (mode="both")
BicubicResize (w, h, 1, 0)
mt_lut ("x 10 - "+str+" *")
in    ? mt_invert : last
debug ? MergeRGB (last, last, last) : mt_merge(filtered,raw,last,luma=true, y=3, u=3, v=3)}