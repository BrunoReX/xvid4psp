##
## YUV-space tools for loading interleaved files by /cheating/!
## We load as raw planar and then pull out the detail we need.
##
## Distributed with Sashimi which is GPL2, but this script is free as in beer.
## Peter Pakulski, 2010
##

#
# Functions defined in this script:
# - RawReadInterleaved
# - RawWriteInterleaved
#
# - RawReadInterleavedYUVToYUY2
# - RawReadInterleavedAYUVToYUY2
# - RawReadInterleavedAYUVToRGB32
# - RawReadInterleavedYUY2
# - RawReadInterleavedUYVYToYUY2
#
# - RawWriteInterleavedYUV
# - RawWriteInterleavedAYUV
# - RawWriteInterleavedAYUV
# - RawWriteInterleavedYUY2
# - RawWriteInterleavedUYVY
#

#
# Helper function, calls the appropriate other functions in this script.
#
function RawReadInterleaved(string filename, string type, int width, int height, string "packing", int "filehead", int "framehead", bool "flip")
{
    packing   = Default(packing,  "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,  false)

    type == "YUV" ?  RawReadInterleavedYUVToYUY2( filename, width, height, packing, filehead, framehead, flip) : \
    type == "AYUV" ? RawReadInterleavedAYUVToYUY2(filename, width, height, packing, filehead, framehead, flip) : \
    type == "YUY2" ? RawReadInterleavedYUY2(      filename, width, height, packing, filehead, framehead, flip) : \
    type == "UYVY" ? RawReadInterleavedUYVYToYUY2(filename, width, height, packing, filehead, framehead, flip) : \
    Assert(false, "Unrecognised type")
}

#
# Helper function, calls the appropriate other functions in this script.
#
function RawWriteInterleaved(clip c, string filename, string type, string "packing", int "filehead", int "framehead", bool "flip", bool "overwrite", bool "truncate")
{
    packing   = Default(packing,   "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,      false)
    overwrite = Default(overwrite, false)
    truncate  = Default(truncate,  false)

    type == "YUV" ?  RawWriteInterleavedYUV( c, filename, packing, filehead, framehead, flip, overwrite, truncate) : \
    type == "AYUV" ? RawWriteInterleavedAYUV(c, filename, packing, filehead, framehead, flip, overwrite, truncate) : \
    type == "YUY2" ? RawWriteInterleavedYUY2(c, filename, packing, filehead, framehead, flip, overwrite, truncate) : \
    type == "UYVY" ? RawWriteInterleavedUYVY(c, filename, packing, filehead, framehead, flip, overwrite, truncate) : \
    Assert(false, "Unrecognised type")
}

#
# This is for a plain YUV file.  Such a thing doesn't commonly exist.
#
function RawWriteInterleavedYUV(clip C, string filename, string "packing", int "filehead", int "framehead", bool "flip", bool "overwrite", bool "truncate")
{
    packing   = Default(packing,   "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,      false)
    overwrite = Default(overwrite, false)
    truncate  = Default(truncate,  false)

    # Extract and reassemble.  Assume YUY2 input.
    C = C.ConvertToYUY2()
    out = MergeRGB \
    ( \
        C, \
        UToY(C).PointResize(Width(C), Height(C)), \
        VToY(C).PointResize(Width(C), Height(C)) \
    )
    
    # Write as though it was RGB.
    RawWriter(out, filename, "rgb", packing, filehead, framehead, flip, overwrite, truncate)
}

function RawReadInterleavedYUVToYUY2(string filename, int width, int height, string "packing", int "filehead", int "framehead", bool "flip")
{
    packing   = Default(packing,  "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,  false)

    # Cheat and load as extra-wide planar
    input = RawReader(filename, "rgb", width, height, -1, packing, filehead, framehead, flip)

    # Now take what we need
    y = ShowRed(  input, "YUY2")
    u = ShowGreen(input, "YUY2")
    v = ShowBlue( input, "YUY2")

#    # Note resize via merging - samples are averaged between the two values.  This is sometimes done, but not technically the right way
#    return YToUV \
#    ( \
#        Merge(u.TurnLeft().SeparateFields().SelectEven(), u.TurnLeft().SeparateFields().SelectOdd()).TurnRight(), \
#        Merge(v.TurnLeft().SeparateFields().SelectEven(), v.TurnLeft().SeparateFields().SelectOdd()).TurnRight(), \
#        y \
#    )

    # Note resize by dropping samples.  This is actually the correct way!
    # See http://msdn.microsoft.com/en-us/library/ms867704.aspx#yuvformats_yuvsampling
    return YToUV \
    ( \
        u.PointResize(Width(y)/2, Height(y)), \
        v.PointResize(Width(y)/2, Height(y)), \
        y \
    )
}

#
# This is for FOURCC code AYUV.  The YUY2 format doesn't have alpha so we discard that.
#
function RawWriteInterleavedAYUV(clip C, string filename, string "packing", int "filehead", int "framehead", bool "flip", bool "overwrite", bool "truncate")
{
    packing   = Default(packing,   "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,      false)
    overwrite = Default(overwrite, false)
    truncate  = Default(truncate,  false)

    # Extract and reassemble.  Assume YUY2 input.
    C = C.ConvertToYUY2()
    out = MergeARGB \
    ( \
        BlankClip(C, color=$FFFFFFFF), \
        C, \
        UToY(C).PointResize(Width(C), Height(C)), \
        VToY(C).PointResize(Width(C), Height(C)) \
    )
    
    # Write as though it was ARGB.
    RawWriter(out, filename, "argb", packing, filehead, framehead, flip, overwrite, truncate)
}

function RawReadInterleavedAYUVToYUY2(string filename, int width, int height, string "packing", int "filehead", int "framehead", bool "flip")
{
    packing   = Default(packing,  "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,  false)

    # Cheat and load as extra-wide planar
    input = RawReader(filename, "argb", width, height, -1, packing, filehead, framehead, flip)

    # Now take what we need (discarding the alpha channel)
    # alpha = ShowAlpha(input, "YUY2")
    y = ShowRed(  input, "YUY2")
    u = ShowGreen(input, "YUY2")
    v = ShowBlue( input, "YUY2")

#    # Note resize via merging - samples are averaged between the two values.  This is sometimes done, but not technically the right way
#    return YToUV \
#    ( \
#        Merge(u.TurnLeft().SeparateFields().SelectEven(), u.TurnLeft().SeparateFields().SelectOdd()).TurnRight(), \
#        Merge(v.TurnLeft().SeparateFields().SelectEven(), v.TurnLeft().SeparateFields().SelectOdd()).TurnRight(), \
#        y \
#    )

    # Note resize by dropping samples.  This is actually the correct way!
    # See http://msdn.microsoft.com/en-us/library/ms867704.aspx#yuvformats_yuvsampling
    return YToUV \
    ( \
        u.PointResize(Width(y)/2, Height(y)), \
        v.PointResize(Width(y)/2, Height(y)), \
        y \
    )
}

#
# This is also for FOURCC code AYUV.  The RGB32 format has alpha but we have to
# colour-convert to incorporate it when reading.  For writing, Alpha is provided
# as a separate clip.
#
function RawWriteInterleavedAYUV(clip C, clip AlphaClip, string filename, string "packing", int "filehead", int "framehead", bool "flip", bool "overwrite", bool "truncate")
{
    packing   = Default(packing,   "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,      false)
    overwrite = Default(overwrite, false)
    truncate  = Default(truncate,  false)

    # Extract and reassemble.  Assume YUY2 input.
    C = C.ConvertToYUY2()
    out = MergeARGB \
    ( \
        AlphaClip.ConvertToYV12().Greyscale(), \
        C, \
        UToY(C).PointResize(Width(C), Height(C)), \
        VToY(C).PointResize(Width(C), Height(C)) \
    )
    
    # Write as though it was ARGB.
    RawWriter(out, filename, "argb", packing, filehead, framehead, flip, overwrite, truncate)
}

function RawReadInterleavedAYUVToRGB32(string filename, int width, int height, string "packing", int "filehead", int "framehead", bool "flip")
{
    packing   = Default(packing,  "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,  false)

    # Cheat and load as extra-wide planar
    input = RawReader(filename, "argb", width, height, -1, filehead, framehead, flip)

    # Now take what we need (discarding the alpha channel)
    alpha = ShowAlpha(input, "RGB32")
    y = ShowRed(  input, "YUY2")
    u = ShowGreen(input, "YUY2")
    v = ShowBlue( input, "YUY2")

#    # Note resize via merging - samples are averaged between the two values.  This is sometimes done, but not technically the right way
#    return YToUV \
#    ( \
#        Merge(u.TurnLeft().SeparateFields().SelectEven(), u.TurnLeft().SeparateFields().SelectOdd()).TurnRight(), \
#        Merge(v.TurnLeft().SeparateFields().SelectEven(), v.TurnLeft().SeparateFields().SelectOdd()).TurnRight(), \
#        y \
#    )

    # Note resize by dropping samples.  This is actually the correct way!
    # See http://msdn.microsoft.com/en-us/library/ms867704.aspx#yuvformats_yuvsampling
    intermediate = YToUV \
    ( \
        u.PointResize(Width(y)/2, Height(y)), \
        v.PointResize(Width(y)/2, Height(y)), \
        y \
    )
    return intermediate.ConvertToRGB32().Mask(alpha)
}

#
# This is for FOURCC code YUY2 and translates directly to AVISynth's internal
# YUY2 format.
#
function RawWriteInterleavedYUY2(clip C, string filename, string "packing", int "filehead", int "framehead", bool "flip", bool "overwrite", bool "truncate")
{
    packing   = Default(packing,   "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,      false)
    overwrite = Default(overwrite, false)
    truncate  = Default(truncate,  false)

    # Extract and reassemble.  Assume YUY2 input.
    C = C.ConvertToYUY2()
    y0 = C.TurnLeft().AssumeFrameBased().SeparateFields().SelectEven().TurnRight()
    y1 = C.TurnLeft().AssumeFrameBased().SeparateFields().SelectOdd().TurnRight()
    
    out = MergeARGB \
    ( \
        y0, \
        UToY(C), \
        y1, \
        VToY(C) \
    )
    
    # Write as though it was RGB.
    RawWriter(out, filename, "argb", packing, filehead, framehead, flip, overwrite, truncate)
}
function RawReadInterleavedYUY2(string filename, int width, int height, string "packing", int "filehead", int "framehead", bool "flip")
{
    packing   = Default(packing,  "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,  false)

    # Cheat and load as extra-wide planar
    input = RawReader(filename, "argb", width/2, height, -1, packing, filehead, framehead, flip)

    # Now take what we need (discarding the alpha channel)
    y0 = ShowAlpha(input, "YUY2")
    u  = ShowRed(  input, "YUY2")
    y1 = ShowGreen(input, "YUY2")
    v  = ShowBlue( input, "YUY2")

    y_assembled = Weave(Interleave(y0.TurnLeft(), y1.TurnLeft()).AssumeFieldBased()).TurnRight()

    return YToUV(u, v, y_assembled)
}

#
# This is for FOURCC code UYVY and translates directly to AVISynth's internal
# YUY2 format.
#
function RawWriteInterleavedUYVY(clip C, string filename, string "packing", int "filehead", int "framehead", bool "flip", bool "overwrite", bool "truncate")
{
    packing   = Default(packing,   "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,      false)
    overwrite = Default(overwrite, false)
    truncate  = Default(truncate,  false)

    # Extract and reassemble.  Assume YUY2 input.
    C = C.ConvertToYUY2()
    y0 = C.TurnLeft().AssumeFrameBased().SeparateFields().SelectEven().TurnRight()
    y1 = C.TurnLeft().AssumeFrameBased().SeparateFields().SelectOdd().TurnRight()
    
    out = MergeARGB \
    ( \
        UToY(C), \
        y0, \
        VToY(C), \
        y1 \
    )
    
    # Write as though it was RGB.
    RawWriter(out, filename, "argb", packing, filehead, framehead, flip, overwrite, truncate)
}
function RawReadInterleavedUYVYToYUY2(string filename, int width, int height, string "packing", int "filehead", int "framehead", bool "flip")
{
    packing   = Default(packing,  "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,  false)

    # Cheat and load as extra-wide planar
    input = RawReader(filename, "argb", width/2, height, -1, packing, filehead, framehead, flip)

    # Now take what we need (discarding the alpha channel)
    u  = ShowAlpha(input, "YUY2")
    y0 = ShowRed(  input, "YUY2")
    v  = ShowGreen(input, "YUY2")
    y1 = ShowBlue( input, "YUY2")

    y_assembled = Weave(Interleave(y0.TurnLeft(), y1.TurnLeft()).AssumeFieldBased()).TurnRight()

    return YToUV(u, v, y_assembled)
}
