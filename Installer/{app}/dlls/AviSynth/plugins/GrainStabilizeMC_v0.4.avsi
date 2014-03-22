###### GrainStabilizeMC v0.4 ######   by mawen1250   ######  2012.11.25  ######
###### Requirements: masktools v2.0a48, mvtools v2.6.0.5, dither v1.21.0 ######
###### RemoveGrain v1.0pre                                               ######

Function GSMC(clip input, clip "p", clip "Lmaskl", string "Preset", int "nrmode", int "radius", int "adapt", int "rep",
\ int "Y", int "U", int "V", bool "lsb_in", bool "lsb", bool "lsb_out", int "dither",
\ bool "chromamv", int "blksize", int "overlap", int "thSAD", int "thSADC", int "thSCD1", int "thSCD2", int "limit", int "limitc",
\ bool "truemotion", bool "MVglobal", int "pel", int "pelsearch", int "search", int "searchparam", int "MVsharp", int "DCT")
{

  nrmode   = Default(nrmode, 1      )
  # Mode to get grain/noise from input clip:
  # 1: 3x3 Average Blur on luma, 3x3 Gaussian Blur on chroma,
  # 2: 3x3 Min Blur,  3: 5x5 Min Blur,  4: 7x7 Min Blur.
  # or define your own denoise clip "p".
  
  radius   = Default(radius, 1      )
  # Temporal radius of MDegrain for grain stabilize.(1-3)
  
  adapt    = Default(adapt,  64     )
  # Threshold for luma-adaptative mask
  # -1: off,  0: source,  255: invert.
  # or define your own luma mask clip "Lmaskl".
  
  rep      = Default(rep,    13     )
  # Mode of repair to avoid artifacts, set 0 to turn off this operation.
  
  Y        = Default(Y,      3      )
  U        = Default(U,      2      )
  V        = Default(V,      2      )
 
  Y        = max(min(Y, 3), 1)
  U        = max(min(U, 3), 1)
  V        = max(min(V, 3), 1)
  Yt       = Y == 3
  Ut       = U == 3
  Vt       = V == 3
  Y31      = Yt ? 3 : 1
  U31      = Ut ? 3 : 1
  V31      = Vt ? 3 : 1
  Y321     = Y <= 1 ? 1 : 3
  U321     = U <= 1 ? 1 : 3
  V321     = V <= 1 ? 1 : 3
  Y421     = Y == 3 ? 4 : Y
  U421     = U == 3 ? 4 : U
  V421     = V == 3 ? 4 : V
  
  Assert( nrmode>=1 && nrmode<=4,  "GrainStabilizeMC: invalid value for nrmode(1~4)!"   )
  Assert( radius>=1 && radius<=3,  "GrainStabilizeMC: invalid value for radius(1~3)!"   )
  Assert( adapt>=-1 && adapt<=255, "GrainStabilizeMC: invalid value for adapt(-1~255)!" )
  
  lsb_in   = Default(lsb_in, false  )   # input      clip is 16-bit stacked or not
  lsb      = Default(lsb,    false  )   # processing clip is 16-bit stacked or not
  lsb_out  = Default(lsb_out,lsb    )   # output     clip is 16-bit stacked or not
  dither   = Default(dither, 6      )   # dither mode for 16-bit to 8-bit conversion
 
  sw       = input.width
  sh       = input.height
  sh       = lsb_in ? sh/2 : sh
  HD       = (sw > 1024 || sh > 576) ? true : false
 
  Preset   = Default(Preset, "Faster")

  pnum     = preset == "Very Fast" ?  0
  \        : preset == "Faster"    ?  1
  \        : preset == "Fast"      ?  2
  \        : preset == "Medium"    ?  3
  \        : preset == "Slow"      ?  4
  \        : preset == "Slower"    ?  5
  \        : preset == "Very Slow" ?  6
  \        :                          7
  Assert( pnum<=6, """GrainStabilizeMC: Unknown Preset!
  Allowed Preset: "Very Fast","Faster","Fast","Medium","Slow","Slower","Very Slow".""" )
 
  # Preset groups:                                 Very Fast     Fast          Slow          Very Slow
  # Preset groups:                                        Faster        Medium        Slower

  bs          = HD ? 16 :  8
  bs2         = HD ? 32 : 16
  chromamv    = Default(chromamv,    Ut || Vt    )
  blksize     = Default(blksize,     Select(pnum,  bs2,   bs2,   bs2,   bs,    bs,    bs,    bs    ))
  ol          = blksize/2
  ol2         = blksize/4
  overlap     = Default(overlap,     Select(pnum,  ol2,   ol2,   ol2,   ol,    ol,    ol,    ol    ))
  thSAD       = Default(thSAD,       300         )
  thSADC      = Default(thSADC,      thSAD/2     )
  thSCD1      = Default(thSCD1,      300         )
  thSCD2      = Default(thSCD2,      100         )
  truemotion  = Default(truemotion,  false       )
  MVglobal    = Default(MVglobal,    false       )
  pel         = Default(pel,         Select(pnum,  1,     1,     2,     2,     2,     2,     2     ))
  pelsearch   = Default(pelsearch,   Select(pnum,  1,     2,     2,     1,     2,     2,     2     ))
  search      = Default(search,      Select(pnum,  2,     4,     4,     2,     2,     4,     5     ))
  searchparam = Default(searchparam, Select(pnum,  1,     2,     2,     2,     2,     2,     2     ))
  MVsharp     = Default(MVsharp,     2           )
  DCT         = Default(DCT,         0           )

  Umv      = chromamv ? 3 : U31
  Vmv      = chromamv ? 3 : V31
  plane    = !Yt ? !Ut ? 2 : !Vt ? 1 : 3 : !Ut&&!Vt ? 0 : 4
  
  
  
  input8   = !lsb_in ? input : input.DitherPost(Y=3, U=lsb?1:U321, V=lsb?1:V321, mode=dither)
  input16  =  lsb_in ? input : input.Dither_convert_8_to_16
  
  plsb_in  = Defined(p) ? input.height == p.height ? lsb_in : !lsb_in : lsb_in
  iresc    = Defined(p) ? plsb_in == lsb_in ? input.height == p.height ? true : false
  \                                         : lsb_in == false ? input.height*2 == p.height ? true : false
  \                                                           : input.height == p.height*2 ? true : false
  \                     : true
  Assert( iresc == true, """GrainStabilizeMC: clip "input" and clip "p" resolution not match!
  (GSMC have already considered different condition of lsb)""" )
  
  p8       = Defined(p) ? !plsb_in ? p : p.DitherPost(Y=3, U=Umv, V=Vmv, mode=0) : NOP()
  p16      = Defined(p) ?  plsb_in ? p : p.Dither_convert_8_to_16 : NOP()
  
  pre_nr8  = !lsb ? Defined(p) ? p8  
  \                            : nrmode == 1 ? input8 .RemoveGrain(Yt?20:0, Ut?11:0, Vt?11:0)
  \                                          : input8 .GSMC_MinBlur(nrmode-1, Ut||Vt?3:2)
  \               : NOP()
  dif_nr8  = !lsb ? mt_makediff(input8, pre_nr8, Y=Y31, U=U31, V=V31) : NOP()
  
  pre_nr16 =  lsb ? Defined(p) ? p16
  \                            : nrmode == 1 ? input16.Dither_removegrain16(Yt?20:0, Ut?11:0, Vt?11:0)
  \                                          : input16.GSMC_MinBlur16(nrmode-1, Ut||Vt?3:2)
  \               : NOP()
  dif_nr16 =  lsb ? Dither_sub16(input16, pre_nr16, Y=Y31, U=U31, V=V31, dif=true) : NOP()

  pre_nr   = Defined(p) ? p8 : lsb ? pre_nr16.DitherPost(Y=3  , U=Umv, V=Vmv, mode=0) : pre_nr8
  dif_nr   =  lsb ? dif_nr16.DitherPost(Y=Y31, U=U31, V=V31, mode=dither) : dif_nr8

  psuper   = pre_nr.MSuper(pel=pel, levels=0, sharp=MVsharp, chroma=chromamv)
  difsuper = dif_nr.MSuper(pel=pel, levels=1, sharp=MVsharp, chroma=Ut || Vt)

  fv3      = radius>=3 ? psuper.MAnalyse(isb=false, delta=3, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=DCT, global=MVglobal, chroma=chromamv) : NOP()
  fv2      = radius>=2 ? psuper.MAnalyse(isb=false, delta=2, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=DCT, global=MVglobal, chroma=chromamv) : NOP()
  fv1      = radius>=1 ? psuper.MAnalyse(isb=false, delta=1, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=DCT, global=MVglobal, chroma=chromamv) : NOP()
  bv1      = radius>=1 ? psuper.MAnalyse(isb=true,  delta=1, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=DCT, global=MVglobal, chroma=chromamv) : NOP()
  bv2      = radius>=2 ? psuper.MAnalyse(isb=true,  delta=2, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=DCT, global=MVglobal, chroma=chromamv) : NOP()
  bv3      = radius>=3 ? psuper.MAnalyse(isb=true,  delta=3, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=DCT, global=MVglobal, chroma=chromamv) : NOP()
  
  dif_sb   = radius==1 ? dif_nr.MDegrain1(difsuper, bv1, fv1                    , thSAD=thSAD, thSADC=thSADC, thSCD1=thSCD1, thSCD2=thSCD2, limit=limit, limitc=limitc, plane=plane, lsb=lsb)
  \        : radius==2 ? dif_nr.MDegrain2(difsuper, bv1, fv1, bv2, fv2          , thSAD=thSAD, thSADC=thSADC, thSCD1=thSCD1, thSCD2=thSCD2, limit=limit, limitc=limitc, plane=plane, lsb=lsb)
  \        :             dif_nr.MDegrain3(difsuper, bv1, fv1, bv2, fv2, bv3, fv3, thSAD=thSAD, thSADC=thSADC, thSCD1=thSCD1, thSCD2=thSCD2, limit=limit, limitc=limitc, plane=plane, lsb=lsb)
  
  Lmaskl   = Defined(Lmaskl) ? Lmaskl
  \        : adapt == -1     ? NOP()
  \        : adapt == 0      ? input8.RemoveGrain(19, -1)
  \        : adapt == 255    ? input8.mt_invert(U=1, V=1).RemoveGrain(19, -1)
  \        :                   input8.mt_lut("x "+string(adapt)+" - abs 255 * "+string(adapt)+" 128 - abs 128 + /", U=1, V=1).RemoveGrain(19, -1)
  Lmask    = adapt == -1     ? NOP() : Ut || Vt  ? Lmaskl.GSMC_YtoYUV : Lmaskl

  stable8  = !lsb ? mt_adddiff(pre_nr8, dif_sb, Y=Y31, U=U31, V=V31) : NOP()
  stable8  = !lsb ? rep   ==  0 ? stable8  : stable8.Repair(input8, Yt?rep:-1, Ut?rep:-1, Vt?rep:-1) : NOP()
  mL8      = !lsb ? adapt == -1 ? mt_lutxy(input8, stable8, Y=Y421, U=U421, V=V421)  
  \                             : mt_merge(input8, stable8, Lmask, luma=false, Y=Y, U=U, V=V) : NOP()

  stable16 =  lsb ? Dither_add16(pre_nr16, dif_sb, Y=Y31, U=U31, V=V31, dif=true) : NOP()
  stable16 =  lsb ? rep   ==  0 ? stable16 : stable16.Dither_repair16(input16, Yt?rep:-1, Ut?rep:-1, Vt?rep:-1) : NOP()
  mL16     =  lsb ? adapt == -1 ? mt_lutxy(input16, stable16, Y=Y421, U=U421, V=V421)
  \                             : Dither_merge16_8(input16, stable16, Lmask, luma=false, Y=Y, U=U, V=V) : NOP()
  
  end      = lsb_out ? lsb ? mL16
  \                        : mL8.Dither_convert_8_to_16
  \                  : lsb ? mL16.DitherPost(Y=Y321, U=U321, V=V321, mode=dither)
  \                        : mL8
  
  return end

}


Function GSMC_YtoYUV(clip inputl, string "colorspace")
{
 sw          = inputl.width
 sh          = inputl.height
 wmod4       = (sw/4*4==sw) ? true : false
 hmod4       = (sh/4*4==sh) ? true : false

 icolorspace = inputl.YtoYUV_GetCSP
 ocolorspace = Defined(colorspace) ? colorspace : icolorspace
 
 try {
   inputp = inputl.ConvertToY8
   inputc = ocolorspace == "YV24" ? inputp
   \      : ocolorspace == "YV16" ? inputp.BicubicResize(sw/2, sh  , -0.50)
   \      :                         inputp.BicubicResize(sw/2, sh/2, -0.50)
   
   output = YtoUV(inputc, inputc, inputp)
 
 } catch ( error_msg ) {
   inputp = wmod4&&hmod4 ? inputl : inputl.PointResize(wmod4?sw:sw+2, hmod4?sh:sh+2, 0, 0, wmod4?sw:sw+2, hmod4?sh:sh+2)
   inputc = inputp.BicubicResize(sw/2, sh/2, -0.50)
   
   output = YtoUV(inputc, inputc, inputp)
   output = wmod4&&hmod4 ? output : output.Crop(0, 0, wmod4?0:-2, hmod4?0:-2)
 
 }
 
 return output
 
 Function YtoYUV_GetCSP(clip c) {
   return c.IsPlanar ? c.IsYV12 ? "YV12" :
   \                   c.IsYV16 ? "YV16" :
   \                   c.IsYV24 ? "YV24" : c.GetCSP_Y8_YV411 :
   \      c.IsYUY2   ? "YUY2"   :
   \      c.IsRGB32  ? "RGB32"  :
   \      c.IsRGB24  ? "RGB24"  : "Unknown"
  
   Function GetCSP_Y8_YV411(clip c) {
     try {
       c.UtoY
       csp = "YV411"
     } catch ( error_msg ) {
      csp = "Y8"
     }
     return csp
   }
 }
}


Function GSMC_MinBlur(clip clp, int "r", int "uv"){

r     = Default(r,  1)
uv    = Default(uv, 3)

uv2   = (uv==2) ? 1  : uv
rg4   = (uv==3) ? 4  : -1
rg11  = (uv==3) ? 11 : -1
rg20  = (uv==3) ? 20 : -1
medf  = (uv==3) ? 1  : -200
uvm2  = (r==2)  ? (uv==3?3:uv==2?0:-1) : nop()
uvm3  = (r==3)  ? (uv==3?3:uv==2?0:-1) : nop()

RG11D = (r<=0) ? mt_makediff(clp, clp.MinBlur_sbr(uv=uv2  ), U=uv2, V=uv2)
\     : (r==1) ? mt_makediff(clp, clp.RemoveGrain(11, rg11), U=uv2, V=uv2)
\     : (r==2) ? mt_makediff(clp, clp.RemoveGrain(11, rg11).RemoveGrain(20, rg20), U=uv2, V=uv2)
\     :          mt_makediff(clp, clp.RemoveGrain(11, rg11).RemoveGrain(20, rg20).RemoveGrain(20, rg20), U=uv2, V=uv2)
RG4D  = (r<=1) ? mt_makediff(clp, clp.RemoveGrain(4,  rg4 ), U=uv2, V=uv2)
\     : (r==2) ? mt_makediff(clp, clp.Quantile(radius_y=2, radius_u=uvm2, radius_v=uvm2), U=uv2, V=uv2)
\     :          mt_makediff(clp, clp.Quantile(radius_y=3, radius_u=uvm3, radius_v=uvm3), U=uv2, V=uv2)

DD    = mt_lutxy(RG11D, RG4D, "x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?", U=uv2, V=uv2)

return clp.mt_makediff(DD, U=uv, V=uv)


  Function MinBlur_sbr(clip c, int "uv") {
  uv     = Default(uv, 1)
  uv2    = (uv==2) ? 1  : uv
  rg11   = (uv==3) ? 11 : -1
  rg11D  = mt_makediff(c, c.RemoveGrain(11, rg11), U=uv2, V=uv2)
  rg11DD = mt_lutxy(rg11D, rg11D.RemoveGrain(11, rg11), "x y - x 128 - * 0 < 128 x y - abs x 128 - abs < x y - 128 + x ? ?", U=uv2, V=uv2)

  return c.mt_makediff(rg11DD, U=uv, V=uv)
  }
}


Function GSMC_MinBlur16(clip clp, int "mode", int "uv"){

mode  = Default(mode, 1)
uv    = Default(uv,   3)

uv2   = (uv==2) ? 1  : uv
rg4   = (uv==3) ? 4  : -1
rg11  = (uv==3) ? 11 : -1
rg20  = (uv==3) ? 20 : -1

RG11D = (mode<=1) ? Dither_sub16(clp, clp.Dither_removegrain16(11, rg11), U=uv2, V=uv2, dif=true)
\     : (mode==2) ? Dither_sub16(clp, clp.Dither_removegrain16(20, rg20), U=uv2, V=uv2, dif=true)
\     : (mode==3) ? Dither_sub16(clp, clp.MinBlur16_sbr16     (uv=uv2  ), U=uv2, V=uv2, dif=true)
\     : (mode==4) ? Dither_sub16(clp, clp.Dither_removegrain16(11, rg11).Dither_removegrain16(20, rg20), U=uv2, V=uv2, dif=true)
\     :             Dither_sub16(clp, clp.Dither_removegrain16(11, rg11).Dither_removegrain16(20, rg20)
\                                        .Dither_removegrain16(20, rg20), U=uv2, V=uv2, dif=true)
RG4D  = (mode<=3) ? Dither_sub16(clp, clp.Dither_removegrain16(4,  rg4 ), U=uv2, V=uv2, dif=true)
\     : (mode==4) ? Dither_sub16(clp, clp.Dither_median16(2, 2, 0, U=uv2, V=uv2), U=uv2, V=uv2, dif=true)
\     :             Dither_sub16(clp, clp.Dither_median16(3, 3, 0, U=uv2, V=uv2), U=uv2, V=uv2, dif=true)

DD    = MinBlur16_limitdiff16(RG11D, RG4D, U=uv2, V=uv2)

return clp.Dither_sub16(DD, U=uv, V=uv, dif=true)


  Function MinBlur16_sbr16(clip clp, int "uv") {
  uv       = Default(uv, 1)
  uv2      = (uv==2) ? 1  : uv
  rg11     = (uv==3) ? 11 : -1

  rg11D    = Dither_sub16(clp, clp.Dither_removegrain16(11, rg11), U=uv2, V=uv2, dif=true)
  rg11Dr   = rg11D.Dither_removegrain16(11, rg11)

  abrg11D  = rg11D.Dither_lut16("x 32768 - abs", U=uv2, V=uv2)
  Ddiff    = Dither_sub16(rg11D, rg11Dr, U=uv2, V=uv2, dif=true)
  abDdiff  = Ddiff.Dither_lut16("x 32768 - abs", U=uv2, V=uv2)
  abDDD    = Dither_sub16(abDdiff, abrg11D, U=uv2, V=uv2, dif=true)

  Dmask1   = abDDD.Dither_lut16("x 32768 < 65535 0 ?", U=uv2, V=uv2)
  Ddiffg   = Ddiff.Dither_lut16("x 32768 == x x 32768 < 0 65535 ? ?", U=uv2, V=uv2).Crop(0, 0, 0, -Ddiff.height()/2)
  rg11Dg   = rg11D.Dither_lut16("x 32768 == x x 32768 < 0 65535 ? ?", U=uv2, V=uv2).Crop(0, 0, 0, -rg11D.height()/2)
  Dmask2   = mt_lutxy(Ddiffg, rg11Dg, "x 128 - y 128 - * 0 < 0 255 ?", U=uv2, V=uv2)

  DD1      = Dither_merge16(rg11D, Ddiff, Dmask1, luma=false, U=uv2, V=uv2)
  DD2      = Dither_merge16_8(DD1.MinBlur16_gen_null_diff(), DD1, Dmask2, luma=false, U=uv2, V=uv2)

  return clp.Dither_sub16(DD2, U=uv, V=uv, dif=true)
  }
  
  
  Function MinBlur16_limitdiff16(clip diff1, clip diff2, int "Y", int "U", int "V")
  {
  Y          = Default(Y,        3)
  U          = Default(U,        3)
  V          = Default(V,        3)

  abdiff1    = Dither_lut16(diff1, "x 32768 - abs", Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1)
  abdiff2    = Dither_lut16(diff2, "x 32768 - abs", Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1)
  abdiffdiff = Dither_sub16(abdiff1, abdiff2, Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1, dif=true)
  bin        = Dither_lut16(abdiffdiff, "x 32768 <= 0 65535 ?", Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1)

  return Dither_merge16(diff1, diff2, bin, luma=false, Y=Y, U=U, V=V)
  }
  
  
  Function MinBlur16_gen_null_diff(clip input, bool "lsb_in")
  {
  lsb_in = Default(lsb_in, true)
	
  vers   = VersionNumber ()
  p_t    = (vers < 2.60) ? "YV12" : Dither_undef ()
	
  input    = lsb_in ? input.Crop(0, 0, 0, -input.height/2) : input
	
  StackVertical(BlankClip(input, pixel_type=p_t, color_yuv=8421504), BlankClip(input, pixel_type=p_t, color_yuv=0))
  }
}