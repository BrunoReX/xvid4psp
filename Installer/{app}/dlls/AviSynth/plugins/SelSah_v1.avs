Function SelSah_v1 (clip clp, float "Sat", float "Hue", int "Luma_Low", int "Luma_High", int "Low_OS", int "High_OS",
\                bool "Exclude", bool "Preview")  
{

#  Extends Tweak to allow selective control of saturation and hue over a defined luma range.  
#  Assembled by WorBry. MaskTools computations kindly provided by Didee. Thanks to Gavino for advice on script syntax.    
#  Requires YV12 clp input and assumes full (pc) luma range 0-255.
#  Requires MaskTools v2.
#
#  Parameters:
#  Sat       - Saturation. (As per Tweak) Desaturation 0.0 < 1.0 > Increased saturation 
#  Hue       - Hue. (As per Tweak) Range -180 to +180 
#  Luma_Low  - Lower luma range point. Range 0 - 255 *
#  Luma_High - Upper luma range point. Range 0 - 255 *
#  Low_OS    - Lower over-shoot point. Provides soft roll-off at lower range boundary. Range 0 - 255 * 
#  High_OS   - Upper over-shoot point. Provides soft roll-off at upper range boundary. Range 0 - 255 *
#  Exclude     True/False. True excludes the range selected by the luma set points. False (default) includes the selected range.   
#  Preview   - True/False. True provides preview of original clip, output and luma masks with original and output chroma.

#*Note: the luma set points are limited with respect to each other to ensure correct orientation and avoid overlap.    
 
#Defaults:
Sat       = default(Sat, 1.0) 
Hue       = default(Hue, 0.0) 
Exclude   = default(Exclude, False) 
Luma_Low  = default(Luma_Low, 0.0) 
Luma_High = default(Luma_High, 255)  
Low_OS    = Exclude ? default(Low_OS,  Luma_Low + 20) 
\         : default(Low_OS,  Luma_Low - 20)    
High_OS   = Exclude ? default(High_OS, Luma_High - 20) 
\         : default(High_OS, Luma_High + 20)  
Preview   = default(Preview, False)         
#
#Limits:  
Sat       = Sat <0.0 ? 0.0 : Sat
Hue       = Hue <-180 ? -180 : Hue > 180 ? 180 : Hue
Luma_Low  = Luma_Low  <0.0 ? 0.0 : Luma_Low  >255 ? 255 : Luma_Low
Luma_High = Luma_High <0.0 ? 0.0 : Luma_High >255 ? 255 : Luma_High
Low_OS    = Exclude &&  Low_OS <Luma_Low ? Luma_Low 
\         : Exclude &&  Low_OS > High_OS ? ((Luma_Low + Luma_High)/2)                  
\         : Low_OS  <0.0 ? 0.0 : Low_OS >Luma_Low ? Luma_Low : Low_OS       
High_OS   = Exclude &&  High_OS >Luma_High ? Luma_High 
\         : Exclude && High_OS < Low_OS ? ((Luma_Low + Luma_High + 2)/2) 
\         : High_OS <Luma_High ? Luma_High : High_OS >255 ? 255 : High_OS  
#
#Create Saturation and Hue control clip:
twclp = clp.tweak(sat=Sat, hue=Hue, coring=false) 
# 
#Create luma mask with low/high range points and roll-off gradient at boundaries:   
#"Include" [0]<-black->[Low_OS]<-gradient->[Luma_Low]<-white->[Luma_High]<-gradient->[High_OS]<-black->[255]
#"Exclude" [0]<-white->[Luma_Low]<-gradient->[Low_OS]<-black->[High_OS]<-gradient->[Luma_High]<-white->[255] 
#
Low_OS    = string(Low_OS) Luma_Low  = String(Luma_Low) 
Luma_High = String(Luma_High) High_OS = String(High_OS) 
#Create "Include" range expression for mask:
blkI      = "x "+Low_OS+" < x "+High_OS+" > | 0 "
whtI      = "x "+Luma_Low+" >= x "+Luma_High+" <= & 255 "
grLI      = "x "+Luma_Low+" < 255 x "+Low_OS+" - "+Luma_Low+" "+Low_OS+" - / * "
grHI      = "x "+Luma_High+" > 255 1 x "+Luma_High+" - "+High_OS+" "+Luma_High+" - / - * "
exprI     = blkI + whtI + grLI + grHI + "x ? ? ? ?"
#Create "Exclude" range expression for mask: 
blkE      = "x "+Low_OS+" >= x "+High_OS+" <= & 0 "
whtE      = "x "+Luma_Low+" < x "+Luma_High+" > | 255 "
grLE      = "x "+Low_OS+" <= 255 x "+Low_OS+" - "+Luma_Low+" "+Low_OS+" - / * " 
grHE      = "x "+Luma_High+" < 255 x "+High_OS+" - "+Luma_High+" "+High_OS+" - / * "    
exprE     = blkE + whtE + grLE + grHE +  "x ? ? ? ?"
#Luma Mask (greyscale for output):
lmask     = twclp.mt_lut(expr = (Exclude ? ExprE : ExprI)) 
lmaskg    = lmask.Greyscale()
# Apply luma mask:
Output    = mt_merge(clp,twclp,lmaskg,luma=true,Y=2,U=3,V=3)
#
#PREVIEW set-up
clps      =clp.Subtitle("Original Clip").LanczosResize(640,360)
outs      =output.Subtitle("Final Output").LanczosResize(640,360)
#Luma Mask with chroma from tweaked clp 
lmcts     = lmask.Subtitle("Luma mask + Tweaked Chroma").LanczosResize(640,360)
#Luma Mask with chroma from original clp
lmcc      = Exclude ? clp.mt_lut(expr=ExprE) : clp.mt_lut(expr=exprI)  
lmccs     = lmcc.Subtitle("Luma Mask + Original Chroma").LanczosResize(640,360)
#Create composite view 
Clpout    = StackVertical(clps,outs)
Masks     = StackVertical(lmccs, lmcts)
Prev      = StackHorizontal(Clpout,Masks)
#
Final     = Preview ? Prev : Output
#
Return(Final)

}
