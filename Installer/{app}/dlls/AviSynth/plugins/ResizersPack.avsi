###                                                  #
###                                                  #
### Resizers functions pack. By Dogway (27-09-2011)  #
###                                                  #
###                                                  #
######################################################
###
### High Quality Resizer based totally on the Dither tools by cretindesalpes.
###             (http://forum.doom9.org/showthread.php?p=1386559#post1386559)
### 
### With these tools now is possible to resize and change matrix all in float point (thus almost zero rounding error)
### and use modern dithering methods for the back to 8 bits stage. You can pick your prefered kernel resizer and even make use
### of linear scaling. What is done in this function are handy automatizations for using it whether is yuv or rgb inputs,
### 16 or 8 bit input/output, and SD or HD with matrix conversion if necessary. Therefore there's no strict need of
### rgb/tvrange/matrix parameters for common (correct) inputs.
###
### Limitations:
### Input must be mod2, either it will be cropped 1 pixel.
### Output is always mod 2, even in RGB.
### Also you can't change matrix in rgb mode.
### Linear=true is not possible when downsizing from HD to SD with matrix change.
###
### * Note about lsb_in, and lsb_out parameters:
### For yuv inputs it is straight forward (although you will have to deal with matrix conversions for yourself if needed).
### For RGB instead is mandatory to define rgb=true, i.e. if both lsb parameters are on, the most common chain would become:
###
### Interleave(showred("yv12"),showgreen("yv12"),showblue("yv12"))
###   Dither_convert_8_to_16()
###       LinearResize(1400,700,lsb_in=true,lsb_out=true,rgb=true)
###   Ditherpost(ampn=0.5,mode=6,y=3,u=1,v=1)
### MergeRGB(SelectEvery(3,0),SelectEvery(3,1),SelectEvery(3,2)) 
###
###
###############################################################################                                                
  
function LinearResize(clip a, int "w", int "h", string "kernel", bool "linear", bool "TVrange", string "matrix", \
                      string "matrixOut", float "fh", float "fv", bool "rgb", bool "lsb_in", bool "lsb_out"){

 w       = default ( w,        a.width )
 h       = default ( h,        a.height)
 kernel  = default ( kernel, "spline36")
 linear  = default ( linear,      false)
 rgba    = default ( rgb,  a.isrgb ? true  : false)
 TV      = default ( TVrange, rgba ? false : true )
 m1      = default ( matrix,    rgba || a.width<1280 ? "601" : "709")
 m2      = default ( matrixOut, Defined(matrix) ? matrix : ( rgba || w<1280 ? "601" : "709"))
 fh      = default ( fh, 1.0)         # Shrink (>1.0 Sharpen) or expand (<1.0 Blur) the Kernel
 fv      = default ( fv, fh)          # idem but vertically
 lsb_in  = default ( lsb_in,  false)
 lsb_out = default ( lsb_out, false)

function mmod2(clip a){
bh = 2 - ((a.Width() -1)%2 + 1)
bv = 2 - ((a.Height()-1)%2 + 1)
a.crop(bh/2,bv/2,-bh,-bv)}

size = a.width>1279 && w<1280    ? true : false
mtrx = m1!=m2                    ? true : false
if1  = mtrx   &&  size           ? true : false
if2  = linear && (!size || rgba) ? true : false

if1      ?  Assert(linear==false, "HD to SD downsize requires linear=false") : nop
rgba     ?  Assert(mtrx==false,   "You can't change matrix in RGB")          : nop

!lsb_in  && rgba   ?  a.mmod2 : a                     
!lsb_in  ? (rgba   ?         Interleave(showred("yv12"), showgreen("yv12"), showblue("yv12")).Dither_convert_8_to_16            \
         :           (if1 ?  Dither_convert_8_to_16.Dither_convert_yuv_to_rgb(lsb_in=true,matrix=m1,tv_range=tv,output="rgb48y") \
         :                   Dither_convert_8_to_16))                                                                             \
         : (if1    ?                                Dither_convert_yuv_to_rgb(lsb_in=true,matrix=m1,tv_range=tv,output="rgb48y") : last)

if2      ?                   Dither_y_gamma_to_linear(tv_range_in=tv,tv_range_out=false)                       : last
                             Dither_resize16(w%2+w,h%2+h,kernel=kernel,fh=fh,fv=fv,u=rgba?1:3,v=rgba?1:3)
if2      ?                   Dither_y_linear_to_gamma(tv_range_in=false,tv_range_out=tv)                       : last


!lsb_out && rgba   ?         Ditherpost(ampn=0.5,mode=6,u=1,v=1)                                               : last
mtrx && !size      ?         Dither_convert_yuv_to_rgb(lsb_in=true,matrix=m1,tv_range=tv,output="rgb48y")      : last
r = mtrx || rgba   ?         SelectEvery (3, 0)                                                                : nop
g = mtrx || rgba   ?         SelectEvery (3, 1)                                                                : nop
b = mtrx || rgba   ?         SelectEvery (3, 2)                                                                : nop

!lsb_out ? (rgba   ?         Mergergb(r,g,b)                                                                   \
                   :(mtrx ?  Dither_convert_rgb_to_yuv(r,g,b,lsb=false,matrix=m2,tv_range=tv) :  Ditherpost))   \
         : (mtrx   ?         Dither_convert_rgb_to_yuv(r,g,b,lsb=true ,matrix=m2,tv_range=tv) :  last)}




##############################
### Resizer based on different ratios, like DAR, PAR, percentage, etc.
### More like a useful resize calculator than a resizer per se.
### The Adapt parameter accepts the next modes (in quotes):
### 
### "DAR"         Convert source to a target DAR (display aspect ratio).
### "DARConform"  You can also "conform" DAR:
###               i.e. resize it in such way that when your media player apply DAR of 4/3, 16/9, etc
###               to your video, image is geometry correct. Useful for anamorphic encodes.
### "%"           I added a percentage mode too, for example use 0.5 to resize to half.
###               You actually can read it as "how many times the original size"
### "PAR"         In the last update I added PAR. Find out what PAR your source is and input it here.
###               If you are thinking in crop + resize (anamorphic) and want to know what your PAR
###               changed to, then apply the formula below* and input it along your target dimensions (PreW,PreH)
### "adjust2w"    This new adapt mode resizes height according to input width. So you input your target width size
###               as the ratio value, and target height will resize automatically according keeping image proportions.
### "adjust2h"    Same as above, but here you fix to the target height instead.
###
### PreW,PreH  Substitutes resizing previously.
###
### Mod        Defines what mod you want to conform to for output; mod2, mod4, mod8...
###
### Kernel     Define the kernel (resizer algo) you want to use: spline36, spline64, bicubic, lanczos, etc
###
### b, c       These are the supplementary parameters for BicubicResize, so you can do Catmull-Rom, Robidoux, etc
### 
### NOTE:      ALWAYS USE FLOAT VALUES 0.9, 1.33, 4/3.0, 16/9.0, etc
###
###
### *NOTE for "PAR":
###
### ((source.croppedRes)*(source.taggedPAR))/(target.Res)=new par
### i.e.
### ((706/478)*(4320/4739))/(720/480)=0.8975
###
###
### RatioResize(0.8975,"PAR",prew=720,preh=480)
###
###############################################################################   

function RatioResize(clip s, float "ratio", string "adapt", int "PreW", int "PreH", int "mod", string "kernel", float "b", float "c")
{
r     = default(ratio, 16/9.0)
adapt = default(adapt, "DAR")
mod   = default(mod, isrgb(s) ? 1 : 2)
w     = default(PreW, s.width)
h     = default(PreH, s.height)
kernel= default(kernel,"spline36")

Assert(isint(ratio)==false,   "'Ratio' must be a float number")
kernel!="bicubic" ? Assert(defined(b)==false,   "'b' and 'c' are BicubicResize only parameters") : nop
kernel!="bicubic" ? Assert(defined(c)==false,   "'b' and 'c' are BicubicResize only parameters") : nop

v  = (adapt=="adjust2w")   ? round(h/(w/r))
\  : (adapt=="adjust2h")   ? round(w/(h/r))
\  : (adapt=="DAR")        ? round(w/(w/(h*r)))
\  : (adapt=="DARconform") ? round(w*(w/(h*r)))
\  : (adapt=="PAR"         \
   || adapt=="%")          ? round(w*r) : nop
h1 = (adapt=="%")          ? round(h*r) : nop

op = (adapt=="DAR")        ? Apply(Kernel + "Resize",s,v+v%mod,h,b,c)
\  : (adapt=="DARconform") ? Apply(Kernel + "Resize",s,v+v%mod,h,b,c)
\  : (adapt=="PAR")        ? Apply(Kernel + "Resize",s,v+v%mod,h,b,c)
\  : (adapt=="%")          ? Apply(Kernel + "Resize",s,v+v%mod,h1+h1%mod,b,c)
\  : (adapt=="adjust2w")   ? Apply(Kernel + "Resize",s,round(r)+round(r)%mod,v+v%mod,b,c)
\  : (adapt=="adjust2h")   ? Apply(Kernel + "Resize",s,v+v%mod,round(r)+round(r)%mod,b,c)
\  :  Assert(false, "Wrong adapt mode")
return op}



########################
### Resizer which gets the best from 2 worlds: The "sharpness" of spline64 and the "ringing-free" catmull-rom
### biased by a threshold. Slightly mod from javlak's function http://forum.doom9.org/showthread.php?p=1504678#post1504678

function SpliceResize(clip v, int "w", int "h", int "threshold"){
	threshold = default (threshold, 8)
	w=default(w, width(v))
        h=default(h, height(v))
	mt_lutxy(BicubicResize(v, w, h,0.0,0.5),Spline64Resize(v, w, h),"x y - abs "+string(threshold)+" > y x ?")}