######
###
### HQDering mod v1.0 by mawen1250
###
### Requirements: masktools v2.0a48, RemoveGrain + Repair v1.0pre, RemoveGrainHD v0.5, dfttest v1.9.2, dither v1.22.0
###
### Applies deringing by using a smart smoother near edges (where ringing occurs) only.
###
######

Function HQDeringmod(clip input, clip "smoothed", int "Y", int "U", int "V", int "mthr", int "mrad", int "nrmode", int "nrmodec", float "sigma", float "sigma2", int "sbsize", int "sosize", bool "sharp", int "drrep", bool "lsb_in", bool "lsb", int "dither", bool "show") {

 HD       = input.width >= 1280 || input.height >= 720 ? true : false

 Y        = Default(Y,      3       )
 U        = Default(U,      2       )
 V        = Default(V,      2       )
 
 lsb_in   = Default(lsb_in, false   )   # input  clip is 16-bit stacked or not
 lsb      = Default(lsb,    false   )   # output clip is 16-bit stacked or not
 dither   = Default(dither, 6       )   # dither mode for 8-bit output
 
 mthr     = Default(mthr,   60      )   # threshold of edge mask, lower  value means more aggressive processing
 mrad     = Default(mrad,   2       )   # radius    of ring mask, higher value means more aggressive processing
 
 nrmode   = Default(nrmode, HD?2:1  )   # kernel of dering - 0: dfttest, 1: MinBlur(radius=1), 2: MinBlur(radius=2), 3: MinBlur(radius=3)
 nrmodec  = Default(nrmodec,nrmode  )   # kernel of dering for chroma
 sigma    = Default(sigma,  128.0   )   # dfttest: sigma for medium frequecies
 sigma2   = Default(sigma2, sigma/16.0)   # dfttest: sigma for low&high frequecies
 sbsize   = Default(sbsize, HD?8:6  )   # dfttest: length of the sides of the spatial window
 sosize   = Default(sosize, HD?6:4  )   # dfttest: spatial overlap amount
 sigma    = string (sigma           )
 sigma2   = string (sigma2          )
 
 sharp    = Default(sharp,  false   )   # whether to use contra-sharpening to resharp deringed clip
 drrep    = Default(drrep,  nrmode>0?lsb?13:24:0)   # use repair for details retention, recommended values are 24/23(only for lsb=false)/13/12/1
 
 show     = Default(show,   false   )   # whether to output mask clip instead of filtered clip
 
 Y        = min(Y, 3)
 U        = min(U, 3)
 V        = min(V, 3)
 Yt       = Y == 3
 Ut       = U == 3
 Vt       = V == 3
 Y31      = Yt ? 3 : 1
 U31      = Ut ? 3 : 1
 V31      = Vt ? 3 : 1
 
 input8   = lsb_in ? input.DitherPost(mode=lsb?-1:dither, Y=3, U=3, V=3) : input
 input16  = lsb_in ? input                                               : input.Dither_convert_8_to_16()

 smoothc  = nrmodec <= 0 ? input.dfttest(Y=false, U=Ut, V=Vt, sbsize=sbsize, sosize=sosize, tbsize=1,
 \                               sstring="0.0:"+sigma2+" 0.05:"+sigma+" 0.5:"+sigma+" 0.75:"+sigma2+" 1.0:0.0", lsb_in=lsb_in, lsb=lsb)
 \                       : input.HQDeringmod_MinBlur(nrmodec, Y=1, U=U, V=V, lsb_in=lsb_in, lsb=lsb, dither=dither)
 smoothed = Defined(smoothed) ? lsb_in ? lsb ? smoothed : smoothed.DitherPost(mode=dither) : lsb ? smoothed.Dither_convert_8_to_16() : smoothed : nrmode <= 0 ? input.dfttest(Y=Yt, U=(nrmode==nrmodec||!(Ut||Vt))?Ut:false, V=(nrmode==nrmodec||!(Ut||Vt))?Vt:false,
 \                                      sbsize=sbsize, sosize=sosize, tbsize=1, lsb_in=lsb_in, lsb=lsb,
 \                                      sstring="0.0:"+sigma2+" 0.05:"+sigma+" 0.5:"+sigma+" 0.75:"+sigma2+" 1.0:0.0")
 \                      : input.HQDeringmod_MinBlur(nrmode, lsb_in=lsb_in, lsb=lsb, dither=dither,
 \                                                  Y=Y, U=(nrmode==nrmodec||!(Ut||Vt))?U:1, V=(nrmode==nrmodec||!(Ut||Vt))?V:1)
 smoothed = nrmode == nrmodec || !(Ut || Vt) ? smoothed : smoothed.MergeChroma(smoothc)
 
 pre           = lsb ? smoothed .Dither_removegrain16(Yt ? 4  : -1, Ut ? 4  : -1, Vt ? 4  : -1)
 \                   : smoothed .         RemoveGrain(Yt ? 4  : -1, Ut ? 4  : -1, Vt ? 4  : -1)
 method        = lsb ? pre      .Dither_removegrain16(Yt ? 11 : -1, Ut ? 11 : -1, Vt ? 11 : -1)
 \                   : pre      .         RemoveGrain(Yt ? 11 : -1, Ut ? 11 : -1, Vt ? 11 : -1)
 sharpdiff     = lsb ? pre      .Dither_sub16(method,   Y=Y31, U=U31, V=V31, dif=true)
 \                   : pre      . mt_makediff(method,   Y=Y31, U=U31, V=V31)
 allD          = lsb ? input16  .Dither_sub16(smoothed, Y=Y31, U=U31, V=V31, dif=true)
 \                   : input8   . mt_makediff(smoothed, Y=Y31, U=U31, V=V31)
 ssDD          = lsb ? sharpdiff.Dither_repair16(allD, Yt ? 1 : -1, Ut ? 1 : -1, Vt ? 1 : -1)
 \                   : sharpdiff.         Repair(allD, Yt ? 1 : -1, Ut ? 1 : -1, Vt ? 1 : -1)
 ssDD          = lsb ? ssDD     .HQDeringmod_limitdiff16(sharpdiff, Y=Y31, U=U31, V=V31)
 \                   : ssDD     .mt_lutxy(sharpdiff, "x 128 - abs y 128 - abs <= x y ?", Y=Y31, U=U31, V=V31)
 sclp          = !sharp ? smoothed :
 \               lsb ? smoothed .Dither_add16(ssDD,     Y=Y31, U=U31, V=V31, dif=true)
 \                   : smoothed .  mt_adddiff(ssDD,     Y=Y31, U=U31, V=V31)
 
 repclp        = drrep <= 0 ? sclp
 \                          : lsb ? input16.Dither_repair16(sclp, Yt ? drrep : -1, Ut ? drrep : -1, Vt ? drrep : -1)
 \                                : input8 .         Repair(sclp, Yt ? drrep : -1, Ut ? drrep : -1, Vt ? drrep : -1)
 
 prewittm      = input8.mt_edge("prewitt", mthr, 255, 0, 0, V=1, U=1)
 fmask         = mt_hysteresis(prewittm.RemoveGrain(4, -1), prewittm, U=1, V=1)
 omask         = mrad > 1 ? fmask.mt_expand(U=1, V=1) : fmask
 omask         = mrad > 2 ? omask.mt_expand(U=1, V=1) : omask
 omask         = mrad > 3 ? omask.mt_expand(U=1, V=1) : omask
 omask         = mrad > 4 ? omask.mt_expand(U=1, V=1) : omask
 imask         = fmask.mt_inflate(U=1, V=1).mt_inpand(U=1, V=1)
 ringmaskl     = omask.mt_lutxy(imask, "x 255 y - * 255 /", U=1, V=1)
 ringmask      = Ut || Vt ? ringmaskl.HQDeringmod_YtoYUV : ringmaskl

 return show ? ringmask 
 \           : lsb ? Dither_merge16_8(input16, repclp, ringmask, luma=false, Y=Y, U=U, V=V)
 \                 : mt_merge        (input8,  repclp, ringmask, luma=false, Y=Y, U=U, V=V)
 
}


Function HQDeringmod_MinBlur(clip clp, int "r", int "Y", int "U", int "V", bool "lsb_in", bool "lsb", int "dither"){

r     = Default(r,    1)
Y     = Default(Y,    3)
U     = Default(U,    3)
V     = Default(V,    3)

Y2    = (Y==2) ? 1  :  Y
Y4    = (Y==3) ? 4  : -1
Y11   = (Y==3) ? 11 : -1
Y20   = (Y==3) ? 20 : -1
Ym2   = (Y==3) ? 2  : Y==2 ? 0 : -1
Ym3   = (Y==3) ? 3  : Y==2 ? 0 : -1
U2    = (U==2) ? 1  :  U
U4    = (U==3) ? 4  : -1
U11   = (U==3) ? 11 : -1
U20   = (U==3) ? 20 : -1
Um2   = (U==3) ? 2  : U==2 ? 0 : -1
Um3   = (U==3) ? 3  : U==2 ? 0 : -1
V2    = (V==2) ? 1  :  V
V4    = (V==3) ? 4  : -1
V11   = (V==3) ? 11 : -1
V20   = (V==3) ? 20 : -1
Vm2   = (V==3) ? 2  : V==2 ? 0 : -1
Vm3   = (V==3) ? 3  : V==2 ? 0 : -1

lsb_in   = Default(lsb_in,   false)
lsb      = Default(lsb,      false)
dither   = Default(dither,       6)

clp8  = lsb_in ? clp.DitherPost(mode=dither, Y=3, U=3, V=3) : clp
clp16 = lsb_in ? clp                                        : clp.Dither_convert_8_to_16()

RG11  = (r<=1) ? lsb ? clp16.Dither_removegrain16(Y11, U11, V11)
\                    : clp8 .         RemoveGrain(Y11, U11, V11)
\     : (r==2) ? lsb ? clp16.Dither_removegrain16(Y11, U11, V11).Dither_removegrain16(Y20, U20, V20)
\                    : clp8 .         RemoveGrain(Y11, U11, V11).         RemoveGrain(Y20, U20, V20)
\     :          lsb ? clp16.Dither_removegrain16(Y11, U11, V11).Dither_removegrain16(Y20, U20, V20).Dither_removegrain16(Y20, U20, V20)
\                    : clp8 .         RemoveGrain(Y11, U11, V11).         RemoveGrain(Y20, U20, V20).         RemoveGrain(Y20, U20, V20)

RG4   = (r<=1) ? lsb_in&&lsb ? clp16.Dither_removegrain16(Y4, U4, V4)
\                            : clp8 .RemoveGrain(Y4, U4, V4)
\     : (r==2) ? lsb_in&&lsb ? clp16.Dither_median16(2, 2, 0, Y=Y2, U=U2, V=V2)
\                            : clp8 .Quantile(radius_y=Ym2, radius_u=Um2, radius_v=Vm2)
\     :          lsb_in&&lsb ? clp16.Dither_median16(3, 3, 0, Y=Y2, U=U2, V=V2)
\                            : clp8 .Quantile(radius_y=Ym3, radius_u=Um3, radius_v=Vm3)
RG4   = !lsb_in&&lsb ? RG4  .Dither_convert_8_to_16() : RG4

RG11D = lsb ? NOP() : mt_makediff(clp8,  RG11, Y=Y2, U=U2, V=V2)
RG4D  = lsb ? NOP() : mt_makediff(clp8,  RG4,  Y=Y2, U=U2, V=V2)

DD    = lsb ? NOP() : mt_lutxy(RG11D, RG4D, "x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?", Y=Y2, U=U2, V=V2)
end   = lsb ? HQDeringmod_min_dif16(RG11, RG4, clp16, Y=Y, U=U, V=V)
\           : clp8.mt_makediff(DD, Y=Y, U=U, V=V)

return end
}


Function HQDeringmod_limitdiff16(clip diff1, clip diff2, int "Y", int "U", int "V")
{
Y          = Default(Y,        3)
U          = Default(U,        3)
V          = Default(V,        3)

sh         = diff1.height/2

nulldiff   = diff1.HQDeringmod_gen_null_diff(lsb_in=true)
maxdif     = Dither_max_dif16(diff1, diff2, nulldiff, Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1)
bin_stack  = mt_lutxy(diff1, maxdif, "x y == 255 0 ?", Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1)
bin_msb    = bin_stack.Crop(0, 0, 0, -sh)
bin_lsb    = bin_stack.Crop(0, +sh, 0, 0)
bin        = mt_logic(bin_msb, bin_lsb, "min", Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1)

return Dither_merge16_8(diff1, diff2, bin, luma=false, Y=Y, U=U, V=V)
}


Function HQDeringmod_min_dif16(clip src1, clip src2, clip ref, int "Y", int "U", int "V")
{
Y          = Default(Y,        3)
U          = Default(U,        3)
V          = Default(V,        3)

sh         = ref.height/2

maxdif     = Dither_max_dif16(src1, src2, ref, Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1)
bin_stack  = mt_lutxy(src1, maxdif, "x y == 255 0 ?", Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1)
bin_msb    = bin_stack.Crop(0, 0, 0, -sh)
bin_lsb    = bin_stack.Crop(0, +sh, 0, 0)
bin        = mt_logic(bin_msb, bin_lsb, "min", Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1)

return Dither_merge16_8(src1, src2, bin, luma=false, Y=Y, U=U, V=V)
}


Function HQDeringmod_gen_null_diff(clip input, bool "lsb_in")
{
    lsb_in = Default(lsb_in, true)
	
	vers   = VersionNumber ()
	p_t    = (vers < 2.60) ? "YV12" : Dither_undef ()
	
	input    = lsb_in ? input.Crop(0, 0, 0, -input.height/2) : input
	
	StackVertical(BlankClip(input, pixel_type=p_t, color_yuv=8421504), BlankClip(input, pixel_type=p_t, color_yuv=0))
}


Function HQDeringmod_YtoYUV(clip inputl, string "colorspace")
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


Function HQDeringmod_Spline36Resize(clip input, int "target_width", int "target_height", float "src_left", float "src_top", float "src_width", float "src_height", bool "chroma") {

 w             = input.width
 h             = input.height
  
 target_width  = Default(target_width,      w)
 target_height = Default(target_height,     h)
 src_left      = Default(src_left,          0)
 src_top       = Default(src_top,           0)
 src_width     = Default(src_width,         w)
 src_height    = Default(src_height,        h)
 chroma        = Default(chroma,         true)

 try {
   inputp = chroma ? input  : input .ConvertToY8
   resize = inputp.Spline36Resize(target_width, target_height, src_left, src_top, src_width, src_height)
   resize = chroma ? resize : resize.ConvertToYV12
 } catch ( error_msg ) {
   resize = input.Spline36Resize(target_width, target_height, src_left, src_top, src_width, src_height)
 }

  return resize
}