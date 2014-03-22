###################################################
###                                             ###
###                ALMerge.avsi                 ###
###                                             ###
###     By 06_taro ( astrataro@gmail.com )      ###
###                                             ###
###            v1.3 - 12 April 2012             ###
###                                             ###
###################################################
###
###
### Merge with Luma mask
### Support both 8-bit precision and stacked 16-bit precision
###
###
### +-------------+
### |  CHANGELOG  |
### +-------------+
###
### v1.3 - 12 April 2012:
###      - Added support for Y8/YV16/YV24 and removed RemoveGrain requirement, by replacing RemoveGrain with GaussResize
###
### v1.2 - 27 March 2012:
###      - Adjusted merge16_8 usage to latest version of dither package
###
### v1.1 - 13 March 2012:
###      - Fully support Y/U/V in -65535~5 of 16-bit merge
###      - Change default U/V to 2, which is correct for merge, previous 1 generated garbage if used as final result
###
### v1.0 - 03 March 2012:
###      - First script
###
###
### +----------------+
### |  REQUIREMENTS  |
### +----------------+
###
### -> Masktools2          (v2a48)
### -> dither  (dll only, v1.15.0)
###
###
### +-------+
### | USAGE |
### +-------+
###
### ALMerge(clip clip_a,  clip clip_b,  clip "clip_l",
### \       int  "adapt", bool "mblur",
### \       bool "lsb_a", bool "lsb_b", bool "lsb_l"
### \       int  "Y",     int  "U",     int  "V"       )
###
### Takes luma value from clip_l to make luma mask,
### then merge clip_a and clip_b as mt_merge does.
###
### If both clip_a and clip_b are normal 8-bit clips, output is normal 8-bit clip.
### Otherwise output is stacked 16-bit clip.
###
### Example(Luma adaptive deband):
### ALMerge(f3kdb(output_depth=16), last, U=3, V=3)
###
###
### +-----------+
### |  GENERAL  |
### +-----------+
###
### clip_a, clip_b [clip, not named arguments, cannot be omitted]
### ------------------
###    The two clips to be merged
###
### clip_l [clip, default=clip_b]
### ------------------
###    The clip where luma value is taken from
###
### adapt [int(0~255), default=64]
### -------------------
###    luma-adaptative threshold ( value in 8-bit precision )
###    0   = source, the brighter the more taken from clip_b, and the darker the more taken from clip_a
###    ..
###    255 = invert, the brighter the more taken from clip_a, and the darker the more taken from clip_b
###
### mblur [bool, default=true]
### ------------------
###    Apply blurring to luma mask or not
###
### lsb_a, lsb_b, lsb_l [bool]
### ------------------
###    Input clip is stacked 16-bit if set to true, normal 8-bit if set to false
###    Should be automatically set correctly, unless all three clips are stacked 16-bit
###    Default:
###             lsb_a = (clip_a.height==2*clip_b.height || clip_a.height==2*clip_l.height) ? true  :
###                     (clip_a.width / clip_a.height > 1.2)                               ? false :
###                                                                                          true
###             lsb_b = (clip_b.height==2*clip_a.height || clip_b.height==2*clip_l.height) ? true  :
###                     (clip_b.height==clip_a.height)                                     ? lsb_a :
###                     (clip_b.width / clip_b.height > 1.2)                               ? false :
###                                                                                          true
###             lsb_l = (clip_l.height==2*clip_a.height || clip_l.height==2*clip_b.height) ? true  :
###                     (clip_l.height==clip_b.height)                                     ? lsb_b :
###                     (clip_l.height==clip_a.height)                                     ? lsb_a :
###                     (clip_l.width / clip_l.height > 1.2)                               ? false :
###                                                                                          true
###
### Y, U, V [int]
### ------------------
###    Same as mt_merge if both clip_a and clip_b are normal 8-bit clips, otherwise same as Dither_merge16_8
###    Default:
###             Y=3
###             U=2
###             V=2
###
###


Function ALMerge(clip clip_a,  clip clip_b,  clip "clip_l",
\                int  "adapt", bool "mblur",
\                bool "lsb_a", bool "lsb_b", bool "lsb_l",
\                int  "Y",     int  "U",     int  "V"       ){

  clip_l   = Default( clip_l, clip_b )
  adapt    = Default( adapt,      64 )
  mblur    = Default( mblur,    true )

  width_a  = clip_a.width
  width_b  = clip_b.width
  width_l  = clip_l.width

  height_a = clip_a.height
  height_b = clip_b.height
  height_l = clip_l.height

  lsb_a    = ( height_a == height_b * 2 || height_a == height_l * 2 ) ? Default( lsb_a,  true ) :
  \          ( width_a > height_a * 1.2 )                             ? Default( lsb_a, false ) :
  \                                                                     Default( lsb_a,  true )

  lsb_b    = ( height_b == height_a * 2 || height_b == height_l * 2 ) ? Default( lsb_b,  true ) :
  \          ( height_b == height_a )                                 ? Default( lsb_b, lsb_a ) :
  \          ( width_b > height_b * 1.2 )                             ? Default( lsb_b, false ) :
  \                                                                     Default( lsb_b,  true )

  lsb_l    = ( height_l == height_a * 2 || height_l == height_b * 2 ) ? Default( lsb_l,  true ) :
  \          ( height_l == height_b )                                 ? Default( lsb_l, lsb_b ) :
  \          ( height_l == height_a )                                 ? Default( lsb_l, lsb_a ) :
  \          ( width_l > height_l * 1.2 )                             ? Default( lsb_l, false ) :
  \                                                                     Default( lsb_l,  true )

  Y        = Default( Y,           3 )
  U        = Default( U,           2 )
  V        = Default( V,           2 )

  Assert( adapt>=0 && adapt<=255, "ALMerge: invalid value for adapt(0~255)!" )

  high_p = ( lsb_a || lsb_b ) ? true : false

  clip_a = ( high_p && !lsb_a ) ? clip_a.ALM_convert_8_to_16 : clip_a
  clip_b = ( high_p && !lsb_b ) ? clip_b.ALM_convert_8_to_16 : clip_b

  clip_l   = lsb_l ? clip_l.DitherPost() : clip_l
  height_l = lsb_l ? height_l / 2 : height_l

  Lmask = adapt==0   ? clip_l
  \     : adapt==255 ? clip_l.mt_invert(U=1, V=1)
  \     :              clip_l.mt_lut("x "+string(adapt)+" - abs 255 * "+string(adapt)+" 128 - abs 128 + /", U=1, V=1)

  Lmask = mblur ? Lmask.GaussResize(width_l/5*4, height_l/5*4, p=15).GaussResize(width_l, height_l, p=15)
  \             : Lmask

### luma=true cannot be used with Y8/YV16/YV24 in mt_merge, and luma=true always overrides U/V
### +--------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+
### | U == 3 | True  | True  | True  | True  | True  | True  | True  | True  | False | False | False | False | False | False | False | False |
### | V == 3 | True  | True  | True  | True  | False | False | False | False | True  | True  | True  | True  | False | False | False | False |
### | IsYV12 | True  | True  | False | False | True  | True  | False | False | True  | True  | False | False | True  | True  | False | False |
### | high_p | True  | False | True  | False | True  | False | True  | False | True  | False | True  | False | True  | False | True  | False |
### +--------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+
### |  luma  | True  | True  | True  | False | False | False | False | False | False | False | False | False | False | False | False | False |
### |  copy  | False | False | False | True  | True  | True  | True  | True  | True  | True  | True  | True  | False | False | False | False |
### +--------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+-------+
### luma: "luma" in mt_merge / ALM_merge16_8
### copy: copy luma plane to chroma planes in Lmask or not

  luma  = U==3 && V==3 && ( Lmask.IsYV12 || high_p ) ? True : False
  Lmask = !luma && ( U==3 || V==3 )  ? Lmask.MergeChroma( Lmask.YToUV(Lmask).BilinearResize(width_l, height_l) )
  \	                                 : Lmask

  return  high_p ? ALM_merge16_8(clip_a, clip_b, Lmask, luma=luma, Y=Y, U=U, V=V)
  \              : mt_merge(clip_a, clip_b, Lmask, luma=luma, Y=Y, U=U, V=V)
}


# ------- Support functions for stacked high bit depth -------

Function ALM_get_msb(clip src){  return src.Crop(0, 0, src.Width, src.Height/2) }
Function ALM_get_lsb(clip src){  return src.Crop(0, src.Height/2, src.Width, src.Height/2) }
Function ALM_convert_8_to_16(clip src){ return StackVertical(src, BlankClip(src, color_yuv=0)) }

Function ALM_merge16_8(clip src1, clip src2, clip mask, bool "luma", int "y", int "u", int "v"){
	luma = Default(luma, false)

	y = Default(y, 3)
	u = Default(u, 2)
	v = Default(v, 2)

	mask16 = StackVertical(mask, mask)
	Dither_merge16(src1, src2, mask16, luma=luma, y=y, u=u, v=v)
}
