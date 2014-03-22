##
## Tools for interleaving and de-interleaving 2, 3, and 4-channel data.
## For higher numbers of colour / spectral channels, use the PointResize
## trick as seen in ExpandRGBTo3ChannelGrey() and Collapse3ChannelToRGB()
##
## For reference, here is a table of what PointResize does to a few
## different groupings of pixels:
## PointResize 2/3 width turns 123 into 12
## PointResize 3/4 width turns 1234 into 123
## PointResize 2/5 width turns 12345 into 13
## PointResize 3/5 width turns 12345 into 124
## PointResize 4/5 width turns 12345 into 1234
## PointResize 5/6 width turns 123456 into 12345
## PointResize 2/7 width turns 1234567 into 14
## PointResize 3/7 width turns 1234567 into 135
## PointResize 4/7 width turns 1234567 into 1246
## PointResize 5/7 width turns 1234567 into 12356
## PointResize 6/7 width turns 1234567 into 123456
## PointResize 3/2 width turns 12 into 112
## PointResize 5/2 width turns 12 into 11122
## PointResize 7/2 width turns 12 into 1111222
## PointResize 4/3 width turns 123 into 1123
## PointResize 5/3 width turns 123 into 11223
## PointResize 7/3 width turns 123 into 1112233
## PointResize 5/4 width turns 123 into 11234
## PointResize 7/4 width turns 123 into 1122334
##
## Functions defined in this script:
## - ExpandRGBATo4ChannelGrey
## - ExpandRGBTo3ChannelGrey
## - ExpandYUVTo3ChannelGrey
## - ExpandChromaTo2ChannelGrey
##
## - Collapse4ChannelToRGBA
## - Collapse3ChannelToRGB
## - Collapse3ChannelToYUV
## - Show2ChannelsAsYV12Colour
##
## They are completely reversible, and can be tested as:
##
##  ExpandRGBATo4ChannelGrey().Collapse4ChannelToRGBA()
##
##  ExpandRGBTo3ChannelGrey().Collapse3ChannelToRGB()
##
##  ExpandYUVTo3ChannelGrey()
##  Collapse3ChannelToYUV()
##
##  luma = ConvertToYV12().Greyscale()
##  ExpandChromaTo2ChannelGrey()
##  Show2ChannelsAsYV12Colour()
##  MergeLuma(luma)
##
## Distributed with Sashimi which is GPL2, but this script is free as in beer.
## Peter Pakulski, 2011
##


##
## Take an RGB clip and expand it to greyscale where the first column is R,
## the second G, the third B, the fourth is Alpha, repeating.
##
## You should never really need this function for writing to / reading to file
## for simple cases, just use the native support - ie: RawWriter(..., "RGBA")
## This is provided as an example for assembling exotic formats.
##
function ExpandRGBATo4ChannelGrey(clip C)
{
    C = C.ConvertToRGB32()
    Red   = ShowRed(  C, "YV12")
    Green = ShowGreen(C, "YV12")
    Blue  = ShowBlue( C, "YV12")
    Alpha = ShowAlpha(C, "YV12")
    RiBiGiA = Interleave(Red, Blue, Green, Alpha)

    RiBiGiA = RiBiGiA.TurnRight()
    RBiGA   = RiBiGiA.AssumeFieldBased().AssumeTFF().Weave()
    RGBA    = RBiGA.AssumeFieldBased().AssumeTFF().Weave()
    RGBA    = RGBA.TurnLeft()

    return RGBA
}


##
## Take an RGB clip and expand it to greyscale where the first column is R,
## the second G, the third B, repeating.
##
## You should never really need this function for writing to / reading to file
## for simple cases, just use the native support - ie: RawWriter(..., "RGB")
## This is provided as an example for assembling exotic formats.
##
function ExpandRGBTo3ChannelGrey(clip C)
{
    RGBA = C.ExpandRGBATo4ChannelGrey()
    #
    # Thanks to <Gavino> for pointing me to <pbristow>'s trick:  PointResize
    #  can be used to skip lines for you!
    # When you skip every fourth column of RGBB, you get RGB!
    #  http://forum.doom9.org/showthread.php?t=153737
    #
    return PointResize(RGBA, RGBA.Width()/4*3, RGBA.Height())
}


##
## Take a YUV clip and expand it to greyscale where the first column is Y,
## the second U, the third V, repeating.
##
## Unfortunately, AVISynth doesn't support non-subsampled YUV, so the U and V
## channels will be affected.  If this is no good for you, then change your
## workflow.  For example, you could do identical transformations to two clips,
## One for your Y channel (with half-width U and V), and one for your U and V
## channels (with double-width Y).
##
## You should never really need this function for writing to / reading to file
## for simple cases, just use the native support - ie: RawWriter(..., "YUV")
## This is provided as an example for assembling exotic formats.
##
function ExpandYUVTo3ChannelGrey(clip C)
{
    C = C.ConvertToYV12()
    Y = Greyscale(C)
    # Yes, resize with PointResize.  This is actually the correct way!
    # See http://msdn.microsoft.com/en-us/library/ms867704.aspx#yuvformats_yuvsampling
    U = UtoY(C).PointResize(C.Width(), C.Height())
    V = VtoY(C).PointResize(C.Width(), C.Height())
    Padding = BlankClip(Y)
    YiViUiP = Interleave(Y, V, U, Padding)

    YiViUiP = YiViUiP.TurnRight()
    YViUP   = YiViUiP.AssumeFieldBased().AssumeTFF().Weave()
    YUVP    = YViUP.AssumeFieldBased().AssumeTFF().Weave()
    YUVP    = YUVP.TurnLeft()
    return PointResize(YUVP, YUVP.Width()/4*3, YUVP.Height())
}

##
## Take the Chroma from a YUV clip and expand it to greyscale where the first
## column is U and the second is V.
##
## This is provided as an example for assembling exotic formats.
##
function ExpandChromaTo2ChannelGrey(clip C)
{
    C = C.ConvertToYV12()
    U = UtoY(C).PointResize(C.Width(), C.Height())
    V = VtoY(C).PointResize(C.Width(), C.Height())
    UiV = Interleave(U, V)

    UiV = UiV.TurnRight()
    UV  = UiV.AssumeFieldBased().AssumeTFF().Weave()
    UV  = UV.TurnLeft()

    return UV
}


##
## Take a greyscale clip where the columns alternate between 4 channels and
## combine it to be an RGBA clip, ie: The first column becomes the red channel,
## the second green, the third blue, the fourth Alpha, repeating.
##
## You should never need this function for writing to / reading to file for
## simple RGB cases, just use the native support - ie: RawWriter(..., "Y8")
##
## This is provided as an example for assembling exotic formats.
##
function Collapse4ChannelToRGBA(Clip C)
{
    RGBA = C.ConvertToYV12()

    RGBA    = RGBA.TurnRight()
    RBiGA   = RGBA.AssumeFrameBased().AssumeTFF().SeparateFields()
    RiBiGiA = RBiGA.AssumeFrameBased().AssumeTFF().SeparateFields()
    RiBiGiA = RiBiGiA.TurnLeft()
    red   = RiBiGiA.SelectEvery(4,0)
    blue  = RiBiGiA.SelectEvery(4,1)
    green = RiBiGiA.SelectEvery(4,2)
    alpha = RiBiGiA.SelectEvery(4,3)
    return MergeARGB(alpha, red, green, blue)
}


##
## Take a greyscale clip where the columns alternate between 3 channels and
## combine it to be an RGB clip, ie: The first column becomes the red channel,
## the second green, the third blue, repeating.
##
## You should never need this function for writing to / reading to file for
## simple RGB cases, just use the native support - ie: RawWriter(..., "Y8")
##
## This is provided as an example for assembling exotic formats.
##
function Collapse3ChannelToRGB(Clip C)
{
    RGB = C.ConvertToYV12()

    #PointResize repeats values to pad as necessary.
    RRGB = PointResize(RGB, RGB.Width()/3*4, RGB.Height())

    RRGB    = RRGB.TurnRight()
    RGiRB   = RRGB.AssumeFrameBased().AssumeTFF().SeparateFields()
    RiGiRiB = RGiRB.AssumeFrameBased().AssumeTFF().SeparateFields()
    RiGiRiB = RiGiRiB.TurnLeft()
    red   = RiGiRiB.SelectEvery(4,0)
    green = RiGiRiB.SelectEvery(4,1)
    blue  = RiGiRiB.SelectEvery(4,3)
    return MergeRGB(red, green, blue)
}


##
## Take a greyscale clip where the columns alternate between 3 channels and
## combine it to be an YUV clip, ie: The first column becomes the Y channel,
## the second U, the third V, repeating.
##
## You should never need this function for writing to / reading to file for
## simple RGB cases, just use the native support - ie: RawWriter(..., "Y8")
##
## Unfortunately, AVISynth doesn't support non-subsampled YUV, so the U and V
## channels will be affected.  If this is no good for you, then change your
## workflow.  For example, you could do identical transformations to two clips,
## One for your Y channel (with half-width U and V), and one for your U and V
## channels (with double-width Y).
##
## This is provided as an example for assembling exotic formats.
##
function Collapse3ChannelToYUV(Clip C)
{
    YUV = C.ConvertToYUY2()

    #PointResize repeats values to pad as necessary.
    YYUV = PointResize(YUV, YUV.Width()/3*4, YUV.Height())

    YYUV    = YYUV.TurnRight()
    YUiYV   = YYUV.AssumeFrameBased().AssumeTFF().SeparateFields()
    YiUiYiV = YUiYV.AssumeFrameBased().AssumeTFF().SeparateFields()
    YiUiYiV = YiUiYiV.TurnLeft()
    Y = YiUiYiV.SelectEvery(4,0)
    # Yes, resize with PointResize.  This is actually the correct way!
    # See http://msdn.microsoft.com/en-us/library/ms867704.aspx#yuvformats_yuvsampling
    U = YiUiYiV.SelectEvery(4,1).PointResize(Y.Width()/2, Y.Height())
    V = YiUiYiV.SelectEvery(4,3).PointResize(Y.Width()/2, Y.Height())
    return YToUV(U, V, Y)
}


##
## Take a greyscale clip where the columns alternate between 2 channels and
## combine them to be the colour channel of a YV12 clip for visualisation.
##
## This is provided as an example for assembling exotic formats.
##
function Show2ChannelsAsYV12Colour(Clip C)
{
    UV = C.ConvertToYUY2()

    UV    = UV.TurnRight()
    UiV   = UV.AssumeFrameBased().AssumeTFF().SeparateFields()
    UiV = UiV.TurnLeft()
    U   = UiV.SelectEven()
    V   = UiV.SelectOdd()
    return YToUV(U, V).PointResize(C.Width()/2, C.Height())
}
