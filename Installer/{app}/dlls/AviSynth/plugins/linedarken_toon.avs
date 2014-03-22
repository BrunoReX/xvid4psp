# LineDarkenToon use the idea of mf_toon (0.5) for linedarken.
# I wanted a really small fast code like FastLineDarken but with similar output like
# mf_toon and this is the result.
#
# needed filters:
# - WarpSharp
# - MaskTools v2
# - AWarpSharp2
# - RemoveGrain
# Common parameters are sstrength, sdboost and srange.
# If speed is most important for you, test fast=true.
# With fast=true no edgemask will be created, just a simple fast weighting.
# But this looks imho still better than FastLineDarken.



function linedarken_toon(clip orig, float "sstrength", "sdboost", int "srange", "warpdepth", bool "fast")
{
###### parameters ######
sstr = string(default(sstrength, 180)/255.0)
srange = default(srange, 0)
sdboost = default(sdboost, 1.0)
wdepth = default(warpdepth, 8)
fast = default(fast, false)

###### filtering ######
sharp = orig.Unsharpmask(300, 4, 0)

orig.mt_edge(thy1=3,thy2=255,mode="prewitt",Y=3,V=1,U=1)
mt_lut("x "+string(srange)+" + 195 / 1.0 "+string(sdboost)+" / ^ 255 *",U=1,V=1).mt_inflate().mt_inflate().mt_inflate()
linemask = mt_lutxy(orig, last, yexpr="300 1 x 255 / - 255 y - * x 1.14 ^ + - "+sstr+" *", uexpr="x", vexpr="x")

fast==false ? mt_merge(orig, sharp, linemask, Y=3, U=2, V=2) :
\ mt_lutxy(orig,sharp,"x y < 40 y < | x y x - 1 x 255 / - 2 ^ * 1 y 128 / - 4 ^ * "+sstr+" * x + ?",U=2,V=2)

final = wdepth<=0 ? last : aWarpSharp2(last,chroma=4,depth=wdepth,blur=1)

return final
}


function limited_toon(clip c, int "level", int "dark", int "line")
{
   level = default(level,24)
   dark  = default(dark,64)
   line  = default(line,64)
   o = c.linedarken_toon(warpdepth=8, sstrength=dark).FastLineDarkenMOD2(thinning=24, strength=line)
   return Soothe(o, c, level)
}


function m_contra (clip denoised, clip original)
{
s = denoised.minblur(1,1) # Damp down remaining spots of the denoised clip.
allD = mt_makediff(original,denoised) # The difference achieved by the denoising.
ssD = mt_makediff(s,s.removegrain(11,-1)) # The difference of a simple kernel blur.
ssDD = ssD.repair(allD,1) # Limit the difference to the max of what the denoising removed locally.
ssDD = SSDD.mt_lutxy(ssD,"x 128 - abs y 128 - abs < x y ?") # abs(diff) after limiting may not be bigger than before.

denoised.mt_adddiff(ssDD,U=2,V=2) # Apply the limited difference. (Sharpening is just inverse blurring.)

return( last )
}

function lite_dark(clip src, int "tline", int "fline")
{
   tline  = default(tline,64)
   fline  = default(fline,64)
b=src
a=b.LSFmod(ss_x=1.5, ss_y=1.5, smode=3, strength=60, overshoot=1, undershoot=1)
a=a.linedarken_toon(warpdepth=0, sstrength=tline).FastLineDarkenMOD2(thinning=0, strength=fline)
b=b.LSFmod()
return m_contra(b, a)
}

function FastLineDarkenMOD2( clip c, int "strength", int "luma_cap", int "threshold", int "thinning")
{
## parameters ##
str = string(default(strength, 48) /128.)
lum = string(default(luma_cap, 191))
thr = string(default(threshold, 4))
thinning = default(thinning,24)
thn = string(thinning /16.)

## filtering ##
exin = c.mt_expand().mt_inpand()
diff = mt_lutxy(c,exin,yexpr="y "+lum+" < y "+lum+" ? x "+thr+" + > x y "+lum+" < y "+lum+" ? - 0 ? 127 +",uexpr="x",vexpr="x",u=2, v=2)
#linemask= mt_lut(diff.mt_inpand(),"x 127 - "+thn+" * 255 +").mt_convolution("1 1 1","1 1 1",y=3,u=0,v=0)
linemask= mt_lut(diff.mt_inpand(),"x 127 - "+thn+" * 255 +").RemoveGrain(20,-1) # gives a little speed boost.
thick = mt_lutxy(c, exin, yexpr="y "+lum+" < y "+lum+" ? x "+thr+" + > x y "+lum+" < y "+lum+" ? - 0 ? "+str+" * x +",uexpr="x",vexpr="x",u=2, v=2)
thin = mt_lutxy(c.mt_expand(U=2,V=2),diff,yexpr="x y 127 - "+str+" 1 + * +",u=2, v=2)

return (thinning == 0) ? thick : mt_merge(thin,thick,linemask,y=3,u=2,v=2)
} 