###                                                  #
###                                                  #
### Mask functions Pack. By Dogway (16-10-2011)      #
###                                                  #
###                                                  #
######################################################
###
### BoxMask
###
### 16-10-2011
### by Dogway
### 
### Creates a boxed mask so you can use it in mt_merge for custom filtering in localised areas.
### 
### 
###########################

function BoxMask(clip clip, int "x1", int "y1", int "x2", int "y2", bool "show"){

w=clip.width()
h=clip.height()
x1=default(x1,0)
y1=default(y1,0)
x2=default(x2,w)
y2=default(y2,h)
show=default(show, false)

clip.mt_lut("255",u=-128,v=-128).crop(w-(x2-x1),h-(y2-y1),0,0)
AddBorders(x1,y1,w,h).crop(0,0,w,h)
show?mt_merge(clip,last,mt_lut(" x 17 < 0 x 2 / - ?"),u=-128,v=-128):mt_lut(" x 17 < 0 x ?")}



##################
###
### FlatMask
###
### 10-06-2011
### by cretindesalpes: (http://forum.doom9.org/showthread.php?p=1507257#post1507257)
### 
### Masks out flat areas with weak, small or no detail.
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

 str   = string(default(str, 6))     # Strength of the mask, the higher more detail protection

 luma  = default(luma,true)          # Enables dark zones to be masked out (for denoising) independent of detail
 th    = default(Lstr,75)            # Start of penumbra for masking when luma=true

 r     = default(r, 3)               # Mask blurriness
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



##############################################################
###                                                          #
### LumaMask() (10-09-2011)                                  #
###                                                          #
##############################################################
###
### Function by Didée, adapted by Dogway:
### http://forum.doom9.org/showpost.php?p=761786&postcount=3
### http://forum.doom9.org/showthread.php?t=158954
### 
### 
### Mixes 2 versions of the source by a mask defined by luminosity (Luma Plane)
###
###
### input [default: last]
### -------------------
### Your 1st clip version
###
###
### filtered [default: filtered]
### -------------------
### Your 2nd clip version. Mandatory parameter
###
###
### black [default: 24]
### -------------------
### Limit for 100% black in your mask. [0...255]
###
###
### White [default: 48]
### -------------------
### Limit for 100% white in your mask. [0...255]
###
###
### brightfilt [default: true]
### -------------------
### Whether you want your filtered clip to be passed through the white or black part of the mask
###
###
### show [default: false]
### -------------------
### Shows the mask
###
###_______________________
###                       |
### Example:              |
###  raw=last             |
###  dfttest()            |
###  LumaMask(raw)        |
###_______________________|
###  
###   This will pass the dfttest'ed version of the clip only in the brightest part of the image,
###   starting where luma pixel value is 24 bright and smoothed up to 100% bypass where 48 bright.
###   Useful to protect dark/bright areas from certain filters.
###
###
###   FEEL FREE TO REMOVE THIS USELESS HELP  :P
##############################################################


function LumaMask(clip filtered, clip raw, int "black", int "white", bool "brightfilt", bool "show"){

LO         = string(default(black, 24))
HI         = string(default(white, 48))
brightfilt = default(brightfilt,true)
show       = default(show, false)


code     = "x "+LO+" < 255 x "+HI+" > 0 255 x "+LO+" - 255 "+HI+" "+LO+" - / * - ? ?"

darkmask = !show               ? raw.mt_lut(code,U=-128,V=-128) : nop

mrg      = !show ? (brightfilt ? mt_merge(filtered, raw, darkmask, luma=true, U=3,V=3)
 \                             : mt_merge(raw, filtered, darkmask, luma=true, U=3,V=3)) : nop

show  ? ( brightfilt ? raw.mt_lut("x "+LO+" < 0 x "+HI+" > 255 0 x "+LO+" - 255 "+LO+" "+HI+" - / * - ? ?",U=-128,V=-128) : raw.mt_lut(code,U=-128,V=-128)) : mrg}