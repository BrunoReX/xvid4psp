Function Stint_v1 (clip clp, int color, float "Sat", int "Luma_Low", int "Luma_High", int "Low_OS", int "High_OS", 
\                      bool "Exclude", clip "clp2",  bool "Blr", string "Blr_Type", float "Blr_rad", 
\                      bool "EdgeM", string "EMode", float "EThY1", float "EthY2",  
\                      bool "Grey", bool "Preview") 
{
#
# Description:
#
# Based on the original 'Tint' function by actionman133. Modified by WorBry to use MaskTools v2 and provide a 
# greater level of control. The input clip chroma is converted to luma and a luma mask is used to apply the desired 
# color tint. The original Tint function was intended to favour the mid-tones. This updated version allows the tint 
# to be applied to a defined 'luma range'. It is also possible to apply a (pre)blur and edge mask. These can assist 
# in creating localized hues, characteristic of some 'film looks' e.g. "Bleach Bypass' (Silver Retention).       
# The function Requires YV12 input and assumes and processes at full (pc) range (0-255); if input clip is 16-235 
# (tv) range, pre-scale accordingly with scaling filter of choice (ColorYUV, Levels, YLevels, SmoothLevels etc).   
# Requires MaskTools v2 and tsp's VariableBlur and MedianBlur. 
# 
# Parameters:
# Clp            - Input clip to which the tint will be applied.
# Color          - The chosen tint color. Uses hexadecimal color codes, preceded by $. Default is Sepia. 
# Sat            - Strength (saturation) of the tint. Range 0.0 - 1.0. Default 0.3
# Luma_Low       - Lower luma range point. Range 0 - 255 *
# Luma_High      - Upper luma range point. Range 0 - 255 *
# Low_OS         - Lower over-shoot point. Provides soft roll-off at lower range boundary. Range 0 - 255 * 
# High_OS        - Upper over-shoot point. Provides soft roll-off at upper range boundary. Range 0 - 255 *
# Exclude        - True/False. True excludes the selected range. Default is False. 
# Clp2           - Option to use a second clip for creation of the luma mask. Useful for applying other 
#                  pre-treatments that may influence the tint pattern - sharpening, altered luma curve etc.
# Blr            - True/False. True applies a blur of a selected type. Default is False. The blur is applied 
#                  prior to creation of the luma range control mask or edge mask. 
# Blr_type       - Blur type. The provided options are "binomial", "gauss", "average" (from VariableBlur) and 
#                  "median". Default is "binomial".
# Blr_rad        - Blur strength, as defined by the blur luma (y) radius (variance). Default is 3.0.  
# EdgeM          - True/False. True applies a luma edge mask (mt_edge). This replaces the luma range 
#                  control mask, so range control is not available in this mode; the range is fixed at 0-255.
#                  Default is False.  
# EMode          - Edge mask Mode (3x3 convolution kernel). Default is "sobel". "min/max" can be useful for 
#                  creating a more diffuse hue (halo) around edges, especially in combination with a (pre) blur. 
#                  For other available modes, see MaskTools v2 documentation. 
# EthY1          - Edge mask low luma threshold. Below this value, pixel is set to 0. Default is 10  
# EthY2          - Edge mask upper luma threshold. Above this value, pixel is set to 255. Default is 10
# Grey           - True/False. True applies the tint to the fully desaturated (greyscale) clip. Default is False.   
# Preview        - True/False. True provides a preview of the input clip, final output, greyscale clp with
#                  applied tint and mask. Default is False.
#
#*Note: the luma set points are limited with respect to each other to ensure correct orientation and avoid overlap.
# 
Color     = Default(Color, $5E2612) # Sepia
Sat       = Default(Sat, 0.3)
Exclude   = default(Exclude, False) 
Luma_Low  = default(Luma_Low, 0.0) 
Luma_High = default(Luma_High, 255)  
Low_OS    = Exclude ? default(Low_OS, Luma_Low + 20) 
\                   : default(Low_OS, Luma_Low - 20)   
High_OS   = Exclude ? default(High_OS, Luma_High - 20) 
\                   : default(High_OS, Luma_High + 20)
clp2      = Default(clp2, clp)
EdgeM     = Default(EdgeM, false)
EMode     = Default(EMode, "sobel")
EthY1     = default(EthY1, 10) 
EthY2     = default(EthY2, 10)
Blr       = default(Blr, false)
Blr_type  = default(Blr_type, "binomial")
Blr_rad   = default(Blr_rad, 3.0)
Grey      = default(Grey, false)  
Preview   = default(Preview, false)     
#
#Limits: 
Sat       = Sat  <0.0 ? 0.0 : Sat  >1.0 ? 1.0 : Sat
Luma_Low  = Luma_Low  <0.0 ? 0.0 : Luma_Low  >255 ? 255 : Luma_Low
Luma_High = Luma_High <0.0 ? 0.0 : Luma_High >255 ? 255 : Luma_High
Low_OS    = Exclude &&  Low_OS < Luma_Low ? Luma_Low 
\         : Exclude &&  Low_OS > High_OS ? ((Luma_Low + Luma_High)/2)                                  
\         : Low_OS <0.0 ? 0.0 : Low_OS >Luma_Low ? Luma_Low : Low_OS
High_OS   = Exclude &&  High_OS >Luma_High ? Luma_High 
\         : Exclude &&  High_OS < Low_OS ? ((Luma_Low + Luma_High + 2)/2)                                                     
\         : High_OS <Luma_High ? Luma_High : High_OS >255 ? 255 : High_OS
#
#Create blankclip with chosen color
colbc     = BlankClip (clp, color=color, pixel_type = "YV12")
#Create greyscale clp, if 'Grey" requested
clp       = Grey? clp.greyscale() : clp 
#Convert chroma from clp and blankclip to luma. Resulting images are half-size & greyscale.
clpu      = clp.UtoY () 
clpv      = clp.VtoY ()
colbcu    = colbc.UtoY () 
colbcv    = colbc.VtoY ()  
#Create greyscale clip for luma mask; uses clp2 if defined, or clp by default
clp2g     = clp2.Greyscale()
#Apply blur, if requested. 
clp2gb    = (Blr == False) ? clp2g
\         : (Blr_type == "binomial") ? clp2g.binomialblur(vary=Blr_rad)
\         : (Blr_type == "gauss")    ? clp2g.gaussianblur(vary=Blr_rad)
\         : (Blr_type == "median")   ? clp2g.MedianBlur(radiusy=Blr_rad)
\         : (Blr_type == "average")  ? clp2g.averageblur(rady=Blr_rad)
\         : clp2g
#Apply edge mask, if requested (will replace the luma range control mask)  
clp2em    = (EdgeM == false) ? clp2gb
\         : clp2gb.mt_edge(mode=EMode, thy1=EthY1, thy2=EthY2, y=3, u=2, v=2)
#Prepare luma range control mask:   
#"Include" mode [0]<-black->[Low_OS]<-gradient->[Low]<-white->[High]<-gradient->[High_OS]<-black->[255] 
#"Exclude" mode [0]<-white->[Low]<-gradient->[Low_OS]<-black->[High_OS]<-gradient->[High]<-white->[255] 
Low_OS    =  string(Low_OS)  
Luma_Low  =  string(Luma_Low) 
Luma_High =  string(Luma_High) 
High_OS   =  string(High_OS)
Sat       =  string(Sat)
#Create Include mode lut expression for mask:
blkI      =  "x "+Low_OS+" < x "+High_OS+" > | 0 "
whtI      =  "x "+Luma_Low+" >= x "+Luma_High+" <= & 255 "
grLI      =  "x "+Luma_Low+" < 255 x "+Low_OS+" - "+Luma_Low+" "+Low_OS+" - / * "
grHI      =  "x "+Luma_High+" > 255 1 x "+Luma_High+" - "+High_OS+" "+Luma_High+" - / - * "
exprI     =  blkI + whtI + grLI + grHI + "x ? ? ? ?"
#Create Exclude mode lut expression for mask:
blkE      = "x "+Low_OS+" >= x "+High_OS+" <= & 0 "
whtE      = "x "+Luma_Low+" < x "+Luma_High+" > | 255 "
grLE      = "x "+Low_OS+" <= 255 x "+Low_OS+" - "+Luma_Low+" "+Low_OS+" - / * "
grHE      = "x "+Luma_High+" < 255 x "+High_OS+" - "+Luma_High+" "+High_OS+" - / * "   
exprE     = blkE + whtE + grLE + grHE +  "x ? ? ? ?"
#Create luma range control mask (or use edge mask, if requested) 
LMask     = (EdgeM == False) ? clp2em.mt_lut(expr = (Exclude ? ExprE : ExprI))
\         : clp2em
#Modify mask for tint strength scaling and resize to match chroma 
LMask     = LMask.mt_lut("255 x 255 / 1 "+Sat+" - - * ", y=3).Reduceby2()
# Apply color tint with mask; convert luma back to chroma and restore luma from original clp 
clput     = mt_merge (clpu, colbcu, LMask, Y=3, U=2, V=2)
clpvt     = mt_merge (clpv, colbcv, LMask, Y=3, U=2, V=2)
Output    = YtoUV (clput, clpvt, clp)
#
#Set-up Preview:
clps      = clp.LanczosResize(640,360).Subtitle("Original Clip", Size=14)
outs      = output.LanczosResize(640,360).Subtitle("Final Output", Size=14)
LMasks    = LMask.LanczosResize(640,360).Subtitle("Luma Mask", Size=14)
#Tint applied to greyscale clp
clpgu     = clp.Greyscale().UtoY () 
clpgv     = clp.Greyscale().VtoY ()
clpgut    = mt_merge (clpgu, colbcu, LMask, Y=3, U=2, V=2)
clpgvt    = mt_merge (clpgv, colbcv, LMask, Y=3, U=2, V=2)
GsTin     = YtoUV (clpgut, clpgvt, clp)
GsTins    = GsTin.LanczosResize(640,360).Subtitle("Tint on Greyscale", Size=14)
#Create composite view 
Clpout    = StackVertical(clps,outs)
Mskgs     = StackVertical(LMasks, GsTins)
Prev      = StackHorizontal(Clpout,Mskgs)
#
Final     = Preview ? Prev : Output
#
Return(Final)
}

