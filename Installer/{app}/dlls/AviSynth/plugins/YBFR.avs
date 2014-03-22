# Author: RunForLife(Oleg Yushko) http://videomontazh.com.ua
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA, or visit
# http:#www.gnu.org/copyleft/gpl.html.

#LoadPlugin("C:\Program Files\AviSynth 2.5\plugins\MvTools2\mvtools2debug.dll")
#LoadPlugin("C:\Program Files\AviSynth 2.5\plugins\MaskTools2.0a36\mt_masktools-26.dll")

#####################################################################################################################################################################################################################################
function YFRC_for_YBFR(clip clp_Input, int "BlockH", int "BlockV", int "OverlayType", int "MaskExpand")
{
#Yushko Frame Rate Converter 2x
#ColorSpace: YUY2
#OverlayType: 0 - soft (blend), 1 - hard (SelectOdd)

clp_input      = ConvertToYUY2(clp_input)                      # script produce YV12 colorspace (3 times faster than YUY2!!!)
clp_Super      = MSuper(clp_Input.blur(1), chroma=true, pel=2) # blur(1) - smooth edges for better analysing
ox             = clp_Input.width()
oy             = clp_Input.height()
fps_num        = FrameRateNumerator(clp_input)*2  # Numerator  , always 2X
fps_den        = FrameRateDenominator(clp_input)  # Denominator, always same as input clip

fps_num        = ((fps_num==0||fps_den==0)) ? FramerateNumerator(clp_input)*2 : fps_num
fps_den        = ((fps_num==0||fps_den==0)) ? FramerateDenominator(clp_input) : fps_den
MaskExpand     = default(MaskExpand, 1) # 1 or 2
OverlayType    = default(OverlayType, 0) # 0 - like ConvertFPS (blend); 1 - like ChangeFPS (strong);
blendSOFT      = (OverlayType==0) ? clp_Input.ConvertFPS(fps_num, fps_den).SelectOdd() : DeleteFrame(clp_Input, 0)
BlockH         = default(BlockH, 8) # use 8 for 320x240 (WEB); 16 for 720x576 (SD); 32 for 1280x720 (720p HD); 32 for 1920x1080 (1080p HD)
BlockV         = default(BlockV, 8) # use 8 for 320x240 (WEB); 16 for 720x576 (SD); 32 for 1280x720 (720p HD); 32 for 1920x1080 (1080p HD)
blendHARD      = DeleteFrame(clp_Input, 0) # SceneChange detection

bw1_vec116     = clp_Super.MAnalyse(blksize=BlockH, blksizeV=BlockV, isb = true , chroma=false, search=1, searchparam=1, truemotion=true, lambda=2000, global=true, dct=0, divide=2)
fw1_vec116     = clp_Super.MAnalyse(blksize=BlockH, blksizeV=BlockV, isb = false, chroma=false, search=1, searchparam=1, truemotion=true, lambda=2000, global=true, dct=0, divide=2)
ErrorMask16L   = MMask(clp_input, bw1_vec116, kind=1)
ErrorMask16R   = DeleteFrame(MMask(clp_input, fw1_vec116, kind=1), 0)
ErrorMask16    = Overlay(ErrorMask16L, ErrorMask16R, opacity=0.5, mode="Lighten")#.ColorYUV(gain_y=256)
SceneChange    = MSCDetection(clp_input, bw1_vec116, thSCD2=130)
FPSconverted16 = clp_input.MFlowFps(clp_input.MSuper(), bw1_vec116, fw1_vec116, num=fps_num, den=fps_den, blend=false, mask=2, ml=10000) #mask=0 - doesn't matter what mode is

CircleExpand   = mt_circle(radius=MaskExpand, zero=true)
CircleInpand   = mt_circle(radius=1         , zero=true)
ErrorMask16    = ErrorMask16.ConvertToYV12().BicubicResize(Round((Ox/BlockH)/4)*4, Round((Oy/BlockV)/4)*4).mt_expand(mode=CircleExpand).mt_inpand(mode=CircleInpand).mt_binarize(64).Blur(1).BicubicResize(ox, oy)

ClipToReturn   = Overlay(SelectOdd(FPSconverted16), blendSOFT, mask=ErrorMask16.ConvertToYUY2())
ClipToReturn   = Overlay(ClipToReturn, blendHARD, mask=SceneChange.ConvertToYUY2())
ClipToReturn   = Interleave(clp_Input, ClipToReturn)

return ClipToReturn
}
#####################################################################################################################################################################################################################################
function YBFR(clip clp_input, int "Frame_Number", int "mode")
{
#Yushko Frame Recovery
#Frame_Number: enter "frame number" that you want replace by interpolated frame;
#Mode: 0 - Top Field only, 1 - Botton field only, 2 - Top and Botton Fields;
 function YRFTOP(clip clp_input, int "Frame_Number")
 {
 V1_1=clp_input.ASSumeBFF().SeparateFields().selectEven()
 V1_2=v1_1.Trim(Frame_Number-3, Frame_Number+1).DeleteFrame(3).DeleteFrame(1)
 FRN=FrameRateNumerator(v1_2)
 FRD=FrameRateDenominator(v1_2)
 v1_2=V1_2.YFRC_for_YBFR().Trim(3, 3).ASSumeFPS(FRN, FRD)
 V_1 =Trim(V1_1, 0, frame_number-1)+V1_2+Trim(V1_1, frame_number+1, 0)

 V2_1=clp_input.ASSUmeBFF().SeparateFields().selectOdd()
 V_2 =V2_1

 return InterLeave(V_1, V_2).Weave().ASSUmeFrameBased()
 }

 function YRFBOT(clip clp_input, int "Frame_Number")
 {
 V2_1=clp_input.ASSUmeBFF().SeparateFields().selectOdd()
 V2_2=v2_1.Trim(frame_number-3, frame_number+1).DeleteFrame(3).DeleteFrame(1)
 FRN=FrameRateNumerator(v2_2)
 FRD=FrameRateDenominator(v2_2)
 v2_2=V2_2.YFRC_for_YBFR().Trim(3, 3).ASSumeFPS(FRN, FRD)
 V_2 =Trim(V2_1, 0, frame_number-1)+v2_2+Trim(V2_1, frame_number+1, 0)

 V1_1=clp_input.ASSUmeBFF().SeparateFields().selectEven()
 V_1 =V1_1

 return InterLeave(V_1, V_2).Weave().ASSUmeFrameBased()        #.Trim(frame_number, frame_number)
 }

 mode           = default(mode, 2) #0 - TOPfield, 1 - BOTfield, 2 - Bottom and Top Field

 ClipOutPut = clp_input.ConvertToYUY2()
 ClipOutPut = (mode == 0) ? YRFTOP(clp_input.ConvertToYUY2(), Frame_Number=Frame_Number) : ClipOutput
 ClipOutPut = (mode == 1) ? YRFBOT(clp_input.ConvertToYUY2(), Frame_Number=Frame_Number) : ClipOutput
 ClipOutPut = (mode == 2) ? clp_input.ConvertToYUY2().YRFTOP(Frame_Number=Frame_Number).YRFBOT(Frame_Number=Frame_Number) : ClipOutput

 return ClipOutPut
}
#####################################################################################################################################################################################################################################