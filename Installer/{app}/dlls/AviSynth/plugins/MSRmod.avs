## http://forum.doom9.org/showthread.php?t=142704
## ==== plugins ===
## avstp.dll
## AddGrainC.dll
## RemoveGrainSSE2.dll
## RepairSSE2.dll
## nnedi3.dll
## mvtools2.dll 
## mt_masktools-26.dll
## dfttest.dll v.1.9.2
## dither.dll
## dither.avsi
## flash3kyuu_deband.dll
## mt_xxpand_multi.avsi
## HighPassSharp.avs

function MSRmod(clip clp, int "W", int "H", float "thr", float "r", float "str", int "smode", int "radius", bool "HPS", bool "GF3", bool "lsb")
{
# Change those constants to tune for the best result of interpolation

# Resize
  W = Default( W, 1280 )
  H = Default( H,  720 )
  
# MSuper
  hpad        = 8           # 4
  vpad        = 8
  pel         = 2           # 1 or 4
  rfilter     = 4           # 2
  sharp       = 2           # 2
  isse        = true
 
# MAnalyse
  blks        = 16
  blksV       = 8
  overlap     = blks / 2
  overlapV    = blksV / 2
  search      = 5
  searchparam = 3
  dct         = 5
 
# MCompensate
  tSAD        = 10000
  tCD1        = 400
  tCD2        = 130

# GradFun3
  GF3    = Default( GF3, false )
  smode  = Default( smode, 0 )    # GradFun3 "smode" parameter
  thr    = Default( thr, 0.5 )    # GradFun3 "thr" parameter
  radius = Default( radius, 12 )  # GradFun3 "radius" parameter
 
# Overlay
  opacity    = 0.5
  
  lsb = Default( lsb, false )
 
# Sharpening
  HPS = Default( HPS, true )
  r   = Default( r, 0.15 )
  
# AddGrain
  str = Default( str,  4 )
 
  ox = clp.width
  oy = clp.height 
  brc   = BilinearResize(clp, ox * 2, oy * 2)
  super = MSuper(brc, hpad=hpad, vpad=vpad, pel=pel, sharp=sharp, rfilter=rfilter)
  vec1 = MAnalyse(super, truemotion=true, isb=true, delta=2, blksize=blks, blksizeV=blksV, overlap=overlap, overlapV=overlapV, search=search, searchparam=searchparam, pelsearch=pel, lambda=768, dct=dct)                    
  vec2 = MAnalyse(super, truemotion=true, isb=true, delta=1, blksize=blks, blksizeV=blksV, overlap=overlap, overlapV=overlapV, search=search, searchparam=searchparam, pelsearch=pel, lambda=768, dct=dct)
  vec3 = MAnalyse(super, truemotion=true, isb=false,delta=1, blksize=blks, blksizeV=blksV, overlap=overlap, overlapV=overlapV, search=search, searchparam=searchparam, pelsearch=pel, lambda=768, dct=dct) 
  vec4 = MAnalyse(super, truemotion=true, isb=false,delta=2, blksize=blks, blksizeV=blksV, overlap=overlap, overlapV=overlapV, search=search, searchparam=searchparam, pelsearch=pel, lambda=768, dct=dct)

  clp = NNEDI3_rpow2(clp, rfactor=2, cshift="lanczosresize", qual=2, nsize=4, nns=4)
 
  clp = (HPS == true ) ? clp.HighPassSharp(r).AddGrainC(str) : \
                         clp.Sharpen(1.0).AddGrainC(str)
  super = MSuper(clp, hpad=hpad, vpad=vpad, pel=pel, sharp=sharp, rfilter=rfilter)
  c1 = MCompensate(clp, super, vec1, thSAD=tSAD , fields=false, thSCD1=tCD1, thSCD2=tCD2)
  c2 = MCompensate(clp, super, vec2, thSAD=tSAD , fields=false, thSCD1=tCD1, thSCD2=tCD2)
  c3 = MCompensate(clp, super, vec3, thSAD=tSAD , fields=false, thSCD1=tCD1, thSCD2=tCD2)
  c4 = MCompensate(clp, super, vec4, thSAD=tSAD , fields=false, thSCD1=tCD1, thSCD2=tCD2)

  t1   = Overlay(clp, c1, opacity=opacity)
  t2   = Overlay(clp, c2, opacity=opacity)
  t3   = Overlay(clp, c3, opacity=opacity)
  t4   = Overlay(clp, c4, opacity=opacity)
  f1   = Overlay(t1,  t2, opacity=opacity)
  f2   = Overlay(t3,  t4, opacity=opacity)
         Overlay(f1,  f2, opacity=opacity)
  mergechroma( awarpsharp2(depth=12,thresh=255,blur=3) )
 
# DEBANDING		 
  (GF3 == true ) ? GradFun3(smode=smode, thr=thr, radius=radius, lsb=true): \
  f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,output_mode=1,output_depth=16,y=72,cb=64,cr=64,grainY=0,grainC=0)  
  
  Dither_resize16 (W, H)
  Dither_convert_yuv_to_rgb (matrix="601", output="rgb48y", lsb_in=true)
  r = SelectEvery (3, 0)
  g = SelectEvery (3, 1)
  b = SelectEvery (3, 2)
  output = ( lsb == true ) ? Dither_convert_rgb_to_yuv (r, g, b, matrix="709", lsb=true,  mode=7, ampn=1, ampo=0, output="YV16") : \
                             Dither_convert_rgb_to_yuv (r, g, b, matrix="709", lsb=false, mode=6, ampn=1, ampo=0) 
  return (output)
 }