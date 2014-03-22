##
## Planar conversion functions for AVISynth.
##
## Distributed with Sashimi which is GPL2, but this script is free as in beer.
## Peter Pakulski, 2010
##

#
# Functions defined in this script:       
# - RawReadPlanar
# - RawWritePlanar
#
# - RGB_To_PlanarRGB
# - RGB_To_PlanarARGB
# - YUY2_To_PlanarYUV444
# - YUY2_To_PlanarYUV422
# - YV12_To_PlanarYUV420YV12
# - YV12_To_PlanarYUV420IMC2
#
# - PlanarRGB_To_RGB24
# - PlanarARGB_To_RGB32
# - PlanarYUV444_To_YUY2
# - PlanarYUV422_To_YUY2
# - PlanarYUV420YV12_To_YV12
# - PlanarYUV420IMC2_To_YV12
#

#
# Helper function, calls the appropriate other functions in this script.
#
function RawReadPlanar(string filename, string type, int width, int height, string "packing", int "filehead", int "framehead", bool "flip")
{
    packing   = Default(packing,  "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)                     
    flip      = Default(flip,  false)                     

    type == "RGB"    ? PlanarRGB_To_RGB24(      RawReader(filename, "Y8", width, height*3,   -1, packing, filehead, framehead, flip)) : \
    type == "ARGB"   ? PlanarARGB_To_RGB32(     RawReader(filename, "Y8", width, height*4,   -1, packing, filehead, framehead, flip)) : \
    type == "YUV444" ? PlanarYUV444_To_YUY2(    RawReader(filename, "Y8", width, height*3,   -1, packing, filehead, framehead, flip)) : \
    type == "YUV422" ? PlanarYUV422_To_YUY2(    RawReader(filename, "Y8", width, height*2,   -1, packing, filehead, framehead, flip)) : \
    type == "YUV420" ? PlanarYUV420YV12_To_YV12(RawReader(filename, "Y8", width, height*3/2, -1, packing, filehead, framehead, flip)) : \
    Assert(false, "Unrecognised type")
}                                                                 

#
# Helper function, calls the appropriate other functions in this script.
#
function RawWritePlanar(clip c, string filename, string type, string "packing", int "filehead", int "framehead", bool "flip", bool "overwrite", bool "truncate")
{
    packing   = Default(packing,   "")
    filehead  = Default(filehead,  0)
    framehead = Default(framehead, 0)
    flip      = Default(flip,      false)
    overwrite = Default(overwrite, false)
    truncate  = Default(truncate,  false)

    type == "RGB"    ? RawWriter(RGB_To_PlanarRGB(        c), filename, "Y8", packing, filehead, framehead, flip, overwrite, truncate) : \
    type == "ARGB"   ? RawWriter(RGB_To_PlanarARGB(       c), filename, "Y8", packing, filehead, framehead, flip, overwrite, truncate) : \
    type == "YUV444" ? RawWriter(YUY2_To_PlanarYUV444(    c), filename, "Y8", packing, filehead, framehead, flip, overwrite, truncate) : \
    type == "YUV422" ? RawWriter(YUY2_To_PlanarYUV422(    c), filename, "Y8", packing, filehead, framehead, flip, overwrite, truncate) : \
    type == "YUV420" ? RawWriter(YV12_To_PlanarYUV420YV12(c), filename, "Y8", packing, filehead, framehead, flip, overwrite, truncate) : \
    Assert(false, "Unrecognised type")
}

##
## RGB-space planar conversion
##
function RGB_To_PlanarRGB(clip C)
{
    #This function assumes RGB input and discards the Alpha channel if present
    C = C.ConvertToRGB24()
    return StackVertical \
    ( \
        ShowRed(C, "YV12"), \
        ShowGreen(C, "YV12"), \
        ShowBlue(C, "YV12") \
    )
}

function RGB_To_PlanarARGB(clip C)
{
    #This function assumes RGB input with Alpha channel
    C = C.ConvertToRGB32()
    return StackVertical \
    ( \
        ShowAlpha(C, "YV12"), \
        ShowRed(C, "YV12"), \
        ShowGreen(C, "YV12"), \
        ShowBlue(C, "YV12") \
    )
}

function PlanarRGB_To_RGB24(clip C)
{
    #This function assumes greyscale input channels
    C = C.ConvertToYV12()
    return MergeRGB \
    ( \
        Crop(C, 0, 0,             Width(C), Height(C)/3), \
        Crop(C, 0, Height(C)/3,   Width(C), Height(C)/3), \
        Crop(C, 0, Height(C)/3*2, Width(C), Height(C)/3) \
    )
}

function PlanarARGB_To_RGB32(clip C)
{
    #This function assumes greyscale input channels
    C = C.ConvertToYV12()
    return MergeARGB \
    ( \
        Crop(C, 0, 0,             Width(C), Height(C)/4), \
        Crop(C, 0, Height(C)/4,   Width(C), Height(C)/4), \
        Crop(C, 0, Height(C)/4*2, Width(C), Height(C)/4), \
        Crop(C, 0, Height(C)/4*3, Width(C), Height(C)/4) \
    )
}


##
## YUV-space planar conversions
##
function YUY2_To_PlanarYUV444(clip C)
{
    # This function assumes YUV input
    C = C.ConvertToYUY2()

    # Note the deliberate use of the PointResize.
    return StackVertical \
    ( \
        Greyscale(C).ConvertToYV12(), \
        UToY(C).PointResize(Width(C), Height(C)).ConvertToYV12(), \
        VToY(C).PointResize(Width(C), Height(C)).ConvertToYV12() \
    )
}

function PlanarYUV444_To_YUY2(clip C)
{
    #This function assumes greyscale input channels
    C = C.ConvertToYUY2()

    # Note the deliberate use of the PointResize.
    return YToUV \
    ( \
        Crop(C, 0, Height(C)/3,   Width(C), Height(C)/3).PointResize(Width(C)/2, Height(C)/3), \
        Crop(C, 0, Height(C)/3*2, Width(C), Height(C)/3).PointResize(Width(C)/2, Height(C)/3), \
        Crop(C, 0, 0,             Width(C), Height(C)/3) \
    )
}


function YUY2_To_PlanarYUV422(clip C)
{
    # This function assumes YV12 input
    C = C.ConvertToYUY2()
    U_sep = C.UToY().AssumeFrameBased().SeparateFields()
    V_sep = C.VToY().AssumeFrameBased().SeparateFields()

    return StackVertical \
    ( \
        C.Greyscale().ConvertToYV12(), \
        StackHorizontal(U_sep.SelectEven(), U_sep.SelectOdd()).ConvertToYV12(), \
        StackHorizontal(V_sep.SelectEven(), V_sep.SelectOdd()).ConvertToYV12() \
    )
}

function PlanarYUV422_To_YUY2(clip C)
{
    #This function assumes greyscale input channels
    C = C.ConvertToYUY2()
    U_wrp = Crop(C, 0, Height(C)/2, Width(C), Height(C)/4)
    U1 = Crop(U_wrp, 0,          0, Width(C)/2, 0)
    U2 = Crop(U_wrp, Width(C)/2, 0, Width(C)/2, 0)
    V_wrp = Crop(C, 0, Height(C)*3/4, Width(C), Height(C)/4)
    V1 = Crop(V_wrp, 0,          0, Width(C)/2, 0)
    V2 = Crop(V_wrp, Width(C)/2, 0, Width(C)/2, 0)

    return YToUV \
    ( \
        Weave(AssumeFieldBased(Interleave(U1, U2))) , \
        Weave(AssumeFieldBased(Interleave(V1, V2))) , \
        Crop(C, 0, 0, Width(C), Height(C)/2) \
    )
}


function YV12_To_PlanarYUV420YV12(clip C)
{
    # This function assumes YUV input
    C = C.ConvertToYV12()
    U_sep = C.UToY().AssumeFrameBased().SeparateFields()
    V_sep = C.VToY().AssumeFrameBased().SeparateFields()

    return StackVertical \
    ( \
        Greyscale(C).ConvertToYV12(), \
        StackHorizontal(U_sep.SelectEven(), U_sep.SelectOdd()).ConvertToYV12(), \
        StackHorizontal(V_sep.SelectEven(), V_sep.SelectOdd()).ConvertToYV12() \
    )
}

function PlanarYUV420YV12_To_YV12(clip C)
{
    #This function assumes greyscale input channels
    C = C.ConvertToYV12()
    U_wrp = Crop(C, 0, Height(C)*4/6, Width(C), Height(C)/6)
    U1 = Crop(U_wrp, 0,          0, Width(C)/2, 0)
    U2 = Crop(U_wrp, Width(C)/2, 0, Width(C)/2, 0)
    V_wrp = Crop(C, 0, Height(C)*5/6, Width(C), Height(C)/6)
    V1 = Crop(V_wrp, 0,          0, Width(C)/2, 0)
    V2 = Crop(V_wrp, Width(C)/2, 0, Width(C)/2, 0)

    return YToUV \
    ( \
        Weave(AssumeFieldBased(Interleave(U1, U2))) , \
        Weave(AssumeFieldBased(Interleave(V1, V2))) , \
        Crop(C, 0, 0, Width(C), Height(C)*2/3) \
    )
}

function YV12_To_PlanarYUV420IMC2(clip C)
{
    # This function assumes YUV input
    C = C.ConvertToYV12()

    return StackVertical \
    ( \
        Greyscale(C).ConvertToYV12(), \
        StackHorizontal(VToY(C).ConvertToYV12(), UToY(C).ConvertToYV12()) \
    )
}

function PlanarYUV420IMC2_To_YV12(clip C)
{
    #This function assumes greyscale input channels
    C = C.ConvertToYV12()

    return YToUV \
    ( \
        C.Crop(Width(C)/2, Height(C)/3*2, Width(C)/2, 0), \
        C.Crop(         0, Height(C)/3*2, Width(C)/2, 0), \
        C.Crop(0, 0, 0, Height(C)/3*2) \
    )
}
