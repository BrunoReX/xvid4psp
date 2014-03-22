#Example/download, direct link: http://www.videomontazh.com.ua/avisynth/YFRC/
#LoadPlugin("C:\Program Files\AviSynth 2.5\plugins\MvTools2\mvtools2.dll")
#LoadPlugin("C:\Program Files\AviSynth 2.5\plugins\MaskTools2.0a36\mt_masktools-26.dll")
# =========================================================================
function YFRC(clip clp_Input, int "fps_num", int "fps_den", int "mask_scale", int "MaskExpand", int "MaskInpand", int "OverlayType", int "Lambada", int "BlockH", int "BlockV")
{
#Yushko Frame Rate Converter 2x
#ColorSpace: YV12
#OverlayType: 0 - soft (blend), 1 - hard (SelectOdd)

clp_input      = ConvertToYV12(clp_input)
clp_Super      = MSuper(clp_Input.blur(1), chroma=false, pel=2, hpad=BlockH, vpad=BlockV)
ox             = clp_Input.width()
oy             = clp_Input.height()

fps_num        = default(fps_num, 50) # Numerator,   Default=50, 0 - means fps_num=fps*2, fps_den=den
fps_den        = default(fps_den, 1)  # Denominator, Default=1,  0 - means fps_num=fps*2, fps_den=den
fps_num        = ((fps_num==0||fps_den==0)) ? FramerateNumerator(clp_input)*2 : fps_num
fps_den        = ((fps_num==0||fps_den==0)) ? FramerateDenominator(clp_input) : fps_den
mask_scale     = default(mask_scale, (Ox>=Oy) ? Round(Oy/72) : Round(Ox/72)) #Reduce FrameSize in both directions for SpeedUp masktools, I recomend 8 for 720x576. Default, if Ox>=Oy then Mask_scale=Round(Oy/72) else Mask_scale=Round(Ox/72)
MaskExpand     = default(MaskExpand, mask_scale+1) #<--->
MaskInpand     = default(MaskInpand, mask_scale-1) #<--->
OverlayType    = default(OverlayType, 0)
Lambada        = default(Lambada, 2000)
blendSOFT      = (OverlayType==0) ? clp_Input.ConvertFPS(fps_num, fps_den).SelectOdd() : DeleteFrame(clp_Input, 0)
BlockH         = default(BlockH, 16)
BlockV         = default(BlockV, 16)

blendHARD      = DeleteFrame(clp_Input, 0)

bw1_vec116     = clp_Super.MAnalyse(blksize=BlockH, blksizeV=BlockV, isb = true , chroma=false, search=5, searchparam=1, truemotion=true, lambda=Lambada, global=true, dct=0, divide=2)
fw1_vec116     = clp_Super.MAnalyse(blksize=BlockH, blksizeV=BlockV, isb = false, chroma=false, search=5, searchparam=1, truemotion=true, lambda=Lambada, global=true, dct=0, divide=2)
ErrorMask16L   = MMask(clp_input, bw1_vec116, kind=1)
ErrorMask16R   = DeleteFrame(MMask(clp_input, fw1_vec116, kind=1), 0)
ErrorMask16    = Overlay(ErrorMask16L, ErrorMask16R, opacity=0.5)
SceneChange    = MSCDetection(clp_input, bw1_vec116, thSCD2=130)
FPSconverted16 = clp_input.MFlowFps(clp_input.MSuper(), bw1_vec116, fw1_vec116, num=fps_num, den=fps_den)
#FPSconverted16 = clp_input.MBlockFps(clp_input.MSuper(), bw1_vec116, fw1_vec116, num=fps_num, den=fps_den, blend=false, mode=0)

CircleExpand   = mt_circle(radius=MaskExpand, zero=true)
CircleInpand   = mt_circle(radius=MaskInpand, zero=true)
ErrorMask16    = ErrorMask16.BicubicResize(Round(Ox/mask_scale/4)*4, Round(Oy/mask_scale/4)*4).mt_expand(mode=CircleInpand).mt_inpand(mode=CircleInpand).ColorYUV(off_y=-128).ColorYUV(gain_y=256).ReduceBy2().blur(1).BicubicResize(ox, oy)#.ConvertToYUY2()
#ErrorMask16    = ErrorMask16.BicubicResize(Round(Ox/mask_scale/4)*4, Round(Oy/mask_scale/4)*4).mt_expand(mode=CircleExpand).mt_inpand(mode=CircleInpand).ReduceBy2().BicubicResize(ox, oy)#.ConvertToYUY2()

ClipToReturn   = Overlay(SelectOdd(FPSconverted16), blendSOFT, mask=ErrorMask16)
ClipToReturn   = Overlay(ClipToReturn, blendHARD, mask=SceneChange)
ClipToReturn   = Interleave(clp_Input, ClipToReturn)

return ClipToReturn
}
# =========================================================================
function YFOC(clip clp_input, int "mode")
{
#Yushko Frame Order Changer
#mode= (0 : Temporal), (1 : Spatial) --==>> default=0
#ColorSpace: YUY2
#mode 0: BFF -> TFF
#mode 1: TFF -> BFF
 function YFOC_BFF_to_TFF(clip clp)
 {
  Clp2=clp.ASSumeBFF().SeparateFields().ConvertToYV12()
  return Clp2.Trim(1, FrameCount(clp2)-2).Weave().ConvertToYUY2()
 }

 function YFOC_TFF_to_BFF(clip clp)
 {
  Clp2=clp.ASSumeTFF().SeparateFields().ConvertToYV12()
  return Clp2.Trim(1, FrameCount(clp2)-2).Weave().ConvertToYUY2()
 }

 mode = default(mode, 0)
 return (Mode==0) ? YFOC_BFF_to_TFF(clp_input) : YFOC_TFF_to_BFF(clp_input)
}
# =========================================================================
function YFR(clip clp_input, int "Frame_Number", int "mode")
{
#Yushko Frame Recovery
#Frame_Number: enter "frame number" that you want replace by interpolated frame;
#Mode: 0 - Top Field only, 1 - Botton field only, 2 - Top and Botton Fields;
 function YRFTOP(clip _clp_input, int "Frame_Number")
 {
 V1_1=_clp_input.ASSumeBFF().SeparateFields().selectEven()
 V1_2=v1_1.Trim(Frame_Number-3, Frame_Number+1).DeleteFrame(3).DeleteFrame(1)
 FRN=FrameRateNumerator(v1_2)
 FRD=FrameRateDenominator(v1_2)
 v1_2=V1_2.YFRC(fps_num=0, fps_den=0, mask_scale=8, MaskExpand=7, MaskInpand=6).Trim(3, 3).ASSumeFPS(FRN, FRD)
 V_1 =Trim(V1_1, 0, frame_number-1)+V1_2+Trim(V1_1, frame_number+1, 0)

 V2_1=_clp_input.ASSUmeBFF().SeparateFields().selectOdd()
 V_2 =V2_1

 return InterLeave(V_1, V_2).Weave().ASSUmeFrameBased()
 }
# =========================================================================
 function YRFBOT(clip _clp_input, int "Frame_Number")
 {
 V2_1=_clp_input.ASSUmeBFF().SeparateFields().selectOdd()
 V2_2=v2_1.Trim(frame_number-3, frame_number+1).DeleteFrame(3).DeleteFrame(1)
 FRN=FrameRateNumerator(v2_2)
 FRD=FrameRateDenominator(v2_2)
 v2_2=V2_2.YFRC(fps_num=0, fps_den=0, mask_scale=8, MaskExpand=7, MaskInpand=6).Trim(3, 3).ASSumeFPS(FRN, FRD)
 V_2 =Trim(V2_1, 0, frame_number-1)+v2_2+Trim(V2_1, frame_number+1, 0)

 V1_1=_clp_input.ASSUmeBFF().SeparateFields().selectEven()
 V_1 =V1_1

 return InterLeave(V_1, V_2).Weave().ASSUmeFrameBased()        #.Trim(frame_number, frame_number)
 }

 mode           = default(mode, 2) #0 - TOPfield, 1 - BOTfield, 2 - Bottom and Top Field

 ClipOutPut = clp_input
 ClipOutPut = (mode == 0) ? YRFTOP(clp_input.ConvertToYUY2(), Frame_Number=Frame_Number) : ClipOutput
 ClipOutPut = (mode == 1) ? YRFBOT(clp_input.ConvertToYUY2(), Frame_Number=Frame_Number) : ClipOutput
 ClipOutPut = (mode == 2) ? clp_input.ConvertToYUY2().YRFTOP(Frame_Number=Frame_Number).YRFBOT(Frame_Number=Frame_Number) : ClipOutput


 return ClipOutPut
}


