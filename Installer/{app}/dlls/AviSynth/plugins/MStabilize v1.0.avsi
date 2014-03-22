###### MStabilize v1.0 #########   by mawen1250   #########  2013.02.28  ######
###### Requirements: masktools v2.0a48, mvtools v2.6.0.5, dither v1.22.1 ######
###############################################################################
### Apply 16bit temporal blur of 3 frames with any radius, use limit and motion mask to avoid artifacts.
###
### pixel of [Frame N] = ( (pixel of [Frame N-radius])*wf + (pixel of [Frame N])*wc + (pixel of [Frame N+radius])*wb ) / (wf+wc+wb)
###############################################################################

Function MStabilize(clip input, int "radius", float "limit", float "wf", float "wc", float "wb", float "mpow",
\                   int "dither", bool "lsb_in", bool "lsb", bool "show", int "Y", int "U", int "V",
\                   bool "chroma", bool "mt", int "pel", int "sharp", int "rfilter",
\                   int "blksize", int "overlap", int "search", bool "truemotion", int "dct", 
\                   float "ml", float "gamma", int "kind", int "Ysc", int "thSCD1", int "thSCD2")
{

radius = Default(radius, 1    )   # temporal blur step
limit  = Default(limit,  255.0)   # maximum difference between input pixel and filtered pixel
wf     = Default(wf,     1.00 )   # weight of forward  frame in temporal blur
wc     = Default(wc,     1.00 )   # weight of current  frame in temporal blur
wb     = Default(wb,     1.00 )   # weight of backward frame in temporal blur
mpow   = Default(mpow,   3.00 )   # exponent of power to tweak motion mask
dither = Default(dither, 6    )   # dither mode of DitherPost for 16bit-8bit conversion
lsb_in = Default(lsb_in, false)   # input  clip is 16-bit stacked or not
lsb    = Default(lsb,    false)   # output clip is 16-bit stacked or not
show   = Default(show,   false)   # whether to output mask clip instead of filtered clip
Y      = Default(Y,      3    )
U      = Default(U,      3    )
V      = Default(V,      3    )

# settings of MVTools
chroma = Default(chroma, false)   # whether to take chroma into account when doing the motion estimation
mt     = Default(mt,     true )   # enables multi-threading
sw     = input.width
sh     = input.height
sh     = lsb_in ? sh/2 : sh
HD     = (sw > 1024 || sh > 576) ? true : false

# settings of MSuper
pel    = Default(pel,    1    )
sharp  = Default(sharp,  2    )
rfilter= Default(rfilter,2    )

# settings of MAnalyse
bs     = HD ? 16 : 8
blksize= Default(blksize,bs   )
ol     = blksize/2
overlap= Default(overlap,ol   )
search = Default(search, 4    )
dct    = Default(dct,    0    )
truemotion = Default(truemotion, false)

# settings of MMask
ml     = Default(ml,     100  )
gamma  = Default(gamma,  1.0  )
kind   = Default(kind,   1    )
Ysc    = Default(Ysc,    255  )
thSCD1 = Default(thSCD1, 400  )
thSCD2 = Default(thSCD2, 130  )

radius = min(radius, 1)
Y      = min(Y,      3)
U      = min(U,      3)
V      = min(V,      3)
Yt     = Y == 3
Ut     = U == 3
Vt     = V == 3
Y31    = Yt ? 3 : 1
U31    = Ut ? 3 : 1
V31    = Vt ? 3 : 1
chroma = Ut||Vt ? chroma : false

src8   = lsb_in ? input.DitherPost(mode=dither) : input
src16  = lsb_in ? input                         : input.Dither_convert_8_to_16()

ss     = src8.Trim(0                , -1)
ss     = radius > 1 ? ss.Loop(radius) : ss
se     = src8.Trim(src8.framecount-1, -1)
se     = radius > 1 ? se.Loop(radius) : se
sf     = ss ++ src8.Trim(0, src8.framecount-1-radius)
sc     = src8
sb     = src8.Trim(radius, 0) ++ se

srcMVS = src8.MSuper(pel=pel, chroma=chroma, sharp=sharp, rfilter=rfilter, mt=mt)
frv    = srcMVS.MAnalyse(blksize=blksize, overlap=overlap, search=search, isb=false, chroma=chroma, delta=radius,
\                        truemotion=truemotion, dct=dct, mt=mt)
brv    = srcMVS.MAnalyse(blksize=blksize, overlap=overlap, search=search, isb=true,  chroma=chroma, delta=radius,
\                        truemotion=truemotion, dct=dct, mt=mt)
frm    = src8.MMask(frv, ml=ml, gamma=gamma, kind=kind, Ysc=Ysc, thSCD1=thSCD1, thSCD2=thSCD2)
brm    = src8.MMask(brv, ml=ml, gamma=gamma, kind=kind, Ysc=Ysc, thSCD1=thSCD1, thSCD2=thSCD2)
Mmask  = mt_average(frm, brm, Y=3, U=chroma?U31:1, V=chroma?V31:1)
\       .mt_lut(expr="x "+string(mpow)+" ^", Y=3, U=chroma?U31:show?-128:1, V=chroma?V31:show?-128:1)

Dither_lutxyz8(sf, sc, sb,
\              "x "+string(wf*256)+" * y "+string(wc*256)+" * + z "+string(wb*256)+" * + "+string(wf+wc+wb)+" /",
\              Y=Y31, U=U31, V=V31)
limit == 255 ? last : Dither_limit_dif16(last, src16, thr=limit, Y=Y31, U=U31, V=V31)
Dither_merge16_8(last, src16, Mmask, luma=!chroma, Y=Y, U=U, V=V)

show ? Mmask : lsb ? last : DitherPost(mode=dither)

}