function GreyCenteredToMask(clip input) {
input.Levels(128, 1, 255, 0, 255, false)
one = last
input.Levels(0, 1, 128, 255, 0, false)
two = last
Overlay(one, two, mode="lighten")
}

function Camembert(clip input) {

input
SmoothUV(3,200,false)
Overlay(last, Blur(1).Blur(1), mode="difference")
Greycenteredtomask().greyscale()
Levels(0, 1, 115, 0, 255, false)
mask1 = last
Blur(1)
Levels(0, 0.4, 64, 0, 255, false)
mask = last
Blur(1).Blur(1)
Levels(0, 1, 30, 0, 255, false).Blur(1)
mask2 = last
return (mask2)
}

function Camembert2(clip input)
{
input
a=RemoveGrain(12,-1).RemoveGrain(12,-1)
mt_makediff(a,input)
#input
#a=RemoveGrain(12).RemoveGrain(12)
#mt_adddiff(input,mt_makediff(a,input))
mt_lut("x 128 - abs 2 *")
greyscale()
mt_lut(Yexpr = "X 0 - 115 0 - / 1 1.0 / ^ 255 0 - * 0 +", U=2,V=2)
RemoveGrain(12)
mt_lut(Yexpr = "X 0 - 64  0 - / 1 0.4 / ^ 255 0 - * 0 +", U=2,V=2)
RemoveGrain(12)
RemoveGrain(12)
mt_lut(Yexpr = "X 0 - 30  0 - / 1 1.0 / ^ 255 0 - * 0 +", U=2,V=2)
RemoveGrain(12)
return (last)
}

function CamembertMod(clip input)
{
 EM1=input.Camembert2()
 EM2=input.mt_edge(mode="min/max", thY1=1, thY2=255, thC1=10, thC2=10, chroma="process").mt_inflate().RemoveGrain(20).RemoveGrain(20).invert()#.blur(1.5).blur(1.5).invert()
 return mt_logic(EM1, EM2, "and")
}

Function EMask(clip i, int mode, int trh)
{

#e_mask = mode == 1 ? mt_makediff(i.blur(1.58).blur(1.58),i).mt_binarize(threshold=trh).mt_inflate().mt_inflate() :
e_mask = mode == 1 ? mt_makediff(i.RemoveGrain(20).RemoveGrain(20),i).mt_binarize(threshold=trh).mt_inflate().mt_inflate() :
     \   mode == 2 ? mt_logic(i.mt_binarize(105,upper=true).mt_expand(),i.mt_binarize(110,upper=false).mt_expand(),"and").  \
                     mt_deflate() : NOP()
return e_mask
}

Function DR_Radius(clip i, int dr_rad, int count)
{
return count > dr_rad ? i : DR_Radius(i.mt_expand(), dr_rad, count+1)
}

Function DeHaloH(clip input, int "DR_Radius", int "DR_Str", bool "Maska", bool "strong", int "mode", int "threshold")
{
 strong     = Default(strong, true)
 Maska      = Default(Maska, false)
 DR_Radius  = Default(DR_Radius, 2)
 DR_Str     = Default(DR_Str, 10)
 mode       = Default(mode, 0)
 threshold  = Default(threshold, 140)

 EM = mode == 0 ? (strong ? input.Camembert2() : input.CamembertMod()) : EMask(input, mode, threshold)

 RM=DR_Radius(EM,DR_Radius,0)
 DeRinging  = input.Deen("a2d", 2, DR_Str  , 0, 0, 0, 0, 0)
 DeRinging = Maska ?  DeRinging.Invert() : DeRinging
return mt_Merge(input, DeRinging, RM)
}

Function AdaptiveEdgeCleaner(clip input, int "DR_Radius", int "DR_Str", bool "Maska", bool "strong", int "mode", int "threshold")
{
 strong     = Default(strong, true)
 Maska      = Default(Maska, false)
 DR_Radius  = Default(DR_Radius, 2)
 DR_Str     = Default(DR_Str, 24)
 mode       = Default(mode, 0)
 threshold  = Default(threshold, 140)

 EM = mode == 0 ? (strong ? input.Camembert2() : input.CamembertMod()) : EMask(input, mode, threshold)

 RM=DR_Radius(EM,DR_Radius,0)
 DeRinging  = input.EdgeCleaner(DR_Str)
 DeRinging = Maska ?  DeRinging.Invert() : DeRinging
return mt_Merge(input, DeRinging, RM)
}

Function AdaptiveEdgeCleaner2(clip input, int "DR_Radius", int "DR_Str", bool "Maska", bool "strong", int "mode", int "threshold")
{
 strong     = Default(strong, true)
 Maska      = Default(Maska, false)
 DR_Radius  = Default(DR_Radius, 2)
 DR_Str     = Default(DR_Str, 24)
 mode       = Default(mode, 0)
 threshold  = Default(threshold, 140)

 input_low    = 1
 gamma        = 1.0
 input_high   = 128
 output_low   = 255
 output_high  = 0

 EM = mode == 0 ? (strong ? input.Camembert2() : input.CamembertMod()) : EMask(input, mode, threshold)

 lmask = input.mt_lut(Yexpr = "x " +string(input_low)+ " - " +string(input_high)+ " " +string(input_low)+ " - / 1 " +string(gamma)+
    \        " / ^ " +string(output_high)+ " " +string(output_low)+ " - * " +string(output_low)+ " +", U=2,V=2).invert().RemoveGrain(12)#.blur(0.5)
# lmask = input.levels(th_low, 1.0, th_high, 255, 0, false).invert().blur(0.5)
 RM=DR_Radius(EM,DR_Radius,0)
 DeRinging  = input.EdgeCleaner(DR_Str)
 DeRinging = Maska ?  DeRinging.Invert() : DeRinging
 RM = mt_logic(RM, lmask, "and")
return mt_Merge(input, DeRinging, RM)
}

function OnLigt(clip i)
{
i
Dark = FastLineDarkenMOD2(thinning=0)
#Dark = invert()
th_low = 1
th_high = 128
dmask = levels(th_low, 1.0, th_high, 255, 0, false).invert().blur(1.5)
return mt_merge(Dark, dmask, U=3, V=3, luma=true)
}

Function SmartSharp(clip input, int "DR_Radius", int "SH_Str", bool "Maska", int "threshold")
{
 Maska      = Default(Maska, false)
 DR_Radius  = Default(DR_Radius, 2)
 SH_Str     = Default(SH_Str, 55)
 threshold  = Default(threshold, 15)

 EM = input.mt_edge(mode="min/max", thY1=1, thY2=255, thC1=10, thC2=10, chroma="process").invert().mt_inflate().blur(1.5).blur(1.5)#
 RM = DR_Radius(EM,DR_Radius,0)
 DeRinging  = input.MSharpen(threshold=threshold, strength=SH_Str, highq=true)
 DeRinging  = Maska ?  DeRinging.Invert() : DeRinging
return mt_Merge(input, DeRinging, RM)
}

Function AdaptiveNoneEdgeCleaner(clip input, bool "Maska", bool "strong", int "mode", int "threshold")
{
 strong     = Default(strong, true)
 Maska      = Default(Maska, false)
 mode       = Default(mode, 0)
 threshold  = Default(threshold, 140)

 EM = mode == 0 ? (strong ? input.Camembert2() : input.CamembertMod()) : EMask(input, mode, threshold)
 DeRinging  = input.FrFun7(1.5,2.5,1.5)
 DeRinging = Maska ?  DeRinging.Invert() : DeRinging

return mt_Merge(input, DeRinging, EM.invert())
}
