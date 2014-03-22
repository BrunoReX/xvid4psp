###################################################
###                                             ###
###            GrainStabilize.avsi              ###
###                                             ###
###     By 06_taro ( astrataro@gmail.com )      ###
###                                             ###
###            v0.3 - 20 Feb 2012               ###
###                                             ###
###################################################
###
###
### Temporal-only on-top grain stabilizer
### Only stabilize the difference ( on-top grain ) between source clip and spatial-degrained clip
###
### Support YV12 input only
###
###
### +-------------+
### |  CHANGELOG  |
### +-------------+
###
### v0.3 - 21 February 2012:
###      - Use repair to remove temporal artifacts
###
### v0.2 - 20 February 2012:
###      - Add "radius"
###
### v0.1 - 19 February 2012:
###      - First script
###
###
### +----------------+
### |  REQUIREMENTS  |
### +----------------+
###
### -> RemoveGrain  (v1.0)
### -> Masktools2  (v2a48)
###
###
### +-------+
### | USAGE |
### +-------+
###
### GrainStabilize(int temp, int radius, int adapt, bool luma, bool chroma, clip p)
###
###
### +-----------+
### |  GENERAL  |
### +-----------+
###
### temp [int, default: 50]
### ------------------
###    Strength for temporal stabilization of on-top grain
###    0   = nervous
###    ..
###    100 = calm
###
### radius [int, default: 1]
### ------------------
###    Radius for temporal stabilization of on-top grain
###
### adapt [int, default: 64]
### -------------------
###    Threshold for luma-adaptative grain
###    -1  = off
###    0   = source
###    ..
###    255 = invert
###
### rep [int, default: 3]
### ------------------
###    Mode of repair, used to remove artifacts introduced by temporal soften
###
### luma, chroma [bool, default: true]
### ----------------------
###    Whether to process luma/chroma plane or not
###
### p [clip, default = not set]
### ----------------------
###    Define your own on-top grain removed clip instead of using internal RemoveGrain
###    e.g., GrainStabilize( p=PNLM2(strength=32, wSpan=2, tSpan=0) )
###
###

Function GrainStabilize(clip input, int "temp", int "radius", int "adapt", int "rep", bool "luma", bool "chroma", clip "p"){

  temp   = Default(temp,     50)
  radius = Default(radius,    1)
  adapt  = Default(adapt,    64)
  rep    = Default(rep,       3)
  luma   = Default(luma,   true)
  chroma = Default(chroma, true)

  Assert( input.IsYV12,            "GrainStabilize: only support YV12 colorspace!"    )
  Assert( temp>=0 && temp<=100,    "GrainStabilize: invalid value for temp(0~100)!"   )
  Assert( adapt>=-1 && adapt<=255, "GrainStabilize: invalid value for adapt(-1~255)!" )

  Y = luma   ? 3 : 2
  U = chroma ? 3 : 2
  V = chroma ? 3 : 2

  pre_nr  = Defined(p) ? p : input.RemoveGrain(luma?20:0, chroma?20:0)

  diff_nr = mt_makediff(input, pre_nr, Y=Y, U=U, V=V)

  diff_sb = (luma&&chroma) ? diff_nr.TemporalSoften(radius, 255, 255, scenechange=255, mode=2)
  \       :  luma          ? diff_nr.TemporalSoften(radius, 255,   0, scenechange=255, mode=2)
  \       :  chroma        ? diff_nr.TemporalSoften(radius,   0, 255, scenechange=255, mode=2)
  \       :                  diff_nr

  diff_mg = (temp ==   0) ? diff_nr
  \       : (temp == 100) ? diff_sb
  \       : (luma&&chroma) ? Merge(diff_nr, diff_sb, temp/100.)
  \       :  luma          ? MergeLuma(diff_nr, diff_sb, temp/100.)
  \       :  chroma        ? MergeChroma(diff_nr, diff_sb, temp/100.)
  \       :                  diff_nr

  stabled = rep==0 ? mt_adddiff(pre_nr, diff_mg, Y=Y, U=U, V=V)
  \                : mt_adddiff(pre_nr, diff_mg, Y=Y, U=U, V=V).Repair(input, mode=rep)

  Lmask = adapt==0   ? input.RemoveGrain(19, -1)
  \     : adapt==255 ? input.mt_invert(U=1, V=1).RemoveGrain(19, -1)
  \     :              input.mt_lut("x "+string(adapt)+" - abs 255 * "+string(adapt)+" 128 - abs 128 + /", U=1, V=1).RemoveGrain(19, -1)

  return adapt==-1 ? stabled
  \                 : mt_merge(input, stabled, Lmask, luma=chroma, Y=Y, U=U, V=V)

}
