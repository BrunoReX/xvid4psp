# Version 1.1
# Date 26.05.2010
# Powered by Jenyok & C
#
# Video_Size_Edition.avs
#
# Convert (resize) PAL (PAR=1:1 SAR=4:3 768x576), 720HD (1280x720), Full HD (1920x1080) AVI video
# and    640x480, 320x240  video formats between each other
#
# functions:
#
#   Convert to PAL (PAR=1:1 SAR=4:3 768x576)
#
#   Convert_320x240_to_768x576(clip c)                      *
#   Convert_640x480_to_768x576(clip c)                      *
#
#   Convert_1280x720_to_768x576_AddBorders(clip c)          *
#   Convert_1280x720_to_768x576_Crop(clip c, int "Right")   *
#
#   Convert_1920x1080_to_768x576_AddBorders(clip c)         *
#   Convert_1920x1080_to_768x576_Crop(clip c, int "Right")  *
#
#
#   Convert to Full HD (1920x1080)
#
#   Convert_320x240_to_1920x1080_AddBorders(clip c)         *
#   Convert_320x240_to_1920x1080_Crop(clip c, int "Bottom") *
#
#   Convert_640x480_to_1920x1080_AddBorders(clip c)         *
#   Convert_640x480_to_1920x1080_Crop(clip c, int "Bottom") *
#
#   Convert_768x576_to_1920x1080_AddBorders(clip c)         *
#   Convert_768x576_to_1920x1080_Crop(clip c, int "Bottom") *
#
#   Convert_1280x720_to_1920x1080(clip c)
#
#
#   Convert to 720HD (1280x720)
#
#   Convert_320x240_to_1280x720_AddBorders(clip c)          *
#   Convert_320x240_to_1280x720_Crop(clip c, int "Bottom")  *
#
#   Convert_640x480_to_1280x720_AddBorders(clip c)          *
#   Convert_640x480_to_1280x720_Crop(clip c, int "Bottom")  *
#
#   Convert_768x576_to_1280x720_AddBorders(clip c)          *
#   Convert_768x576_to_1280x720_Crop(clip c, int "Bottom")  *
#
#   Convert_1920x1080_to_1280x720(clip c)                   *
#
#
#   Date 11.05.2010
#   Special function that crops video 768x576 to 480x384 and than converts to 768x576
#   for restoring old 8mm film
#
#   Convert_768x576_to_768x576_Crop(clip c, int "Left", int "Bottom")   *

# Global constants

global Video_Width    = 1920   # ! Do not change this constant
global Video_Height   = 1080   # ! Do not change this constant
 
global Video_Width1   = 1280   # ! Do not change this constant
global Video_Height1  = 720    # ! Do not change this constant
 
global Video_Width2   = 768    # ! Do not change this constant
global Video_Height2  = 576    # ! Do not change this constant
 
global Video_Width3   = 640    # ! Do not change this constant
global Video_Height3  = 480    # ! Do not change this constant
 
global Video_Width4   = 320    # ! Do not change this constant
global Video_Height4  = 240    # ! Do not change this constant
 
global Video_Width5   = 480    # ! Do not change this constant
global Video_Height5  = 360    # ! Do not change this constant
 

# Local constants

global Video_Width00  = 1440   # ! Do not change this constant    4:3  1440x1080
global Video_Width11  = 960    # ! Do not change this constant    4:3   960x720
global Video_Height21 = 432    # ! Do not change this constant   16:9   768x432
global Video_Height31 = 360    # ! Do not change this constant   16:9   640x360
global Video_Height41 = 180    # ! Do not change this constant   16:9   320x180

global edge           = 100    # Default = 100, Coefficient [20 .. 500] for function EdgeSharpen()


# Resize functions
# Convert to PAL (720x576)

function Convert_640x480_to_768x576(clip c)
{
   w  = Width(c)
   h  = Height(c)
 
#   k  = Float(Video_Width2) / Float(Video_Height2)
#   w1 = Round(Video_Height3 * k)
#   w2 = Round((Video_Width3 - w1) / 2)
#   c = ((w == Video_Width3) && (h == Video_Height3)) ? Crop(c, w2, 0, -1 * w2, 0) : c
 
   c = ((w == Video_Width3) && (h == Video_Height3)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   c = ((w == Video_Width3) && (h == Video_Height3)) ? \
   BicubicResize(c, Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c), 0, 0.5) : c 
#   Spline64Resize(c, Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c)) : c
   return c
}
 
 
function Convert_320x240_to_768x576(clip c)
{
   w = Width(c)
   h = Height(c)
   c = ((w == Video_Width4) && (h == Video_Height4)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   c = ((w == Video_Width4) && (h == Video_Height4)) ? \
   c.Convert_640x480_to_768x576() : c
   return c
}
 
 
function Convert_1920x1080_to_768x576_AddBorders(clip c)
{
   w  = Width(c)
   h  = Height(c)
   k  = Float(Video_Width2) / Float(Video_Height2)
   h1 = Round(Video_Width / k)
   b  = Round((h1 - Video_Height) / 2)
   c  = ((w == Video_Width) && (h == Video_Height)) ? c.AddBorders(0, b, 0, b) : c
   c  = ((w == Video_Width) && (h == Video_Height)) ? \
   c.BicubicResize(Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c), 0, 0.5) : c 
#   c.Spline64Resize(Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c)) : c
   return c
}
 
 
function Convert_1920x1080_to_768x576_Crop(clip c, int "Right")
{
   Right = default(Right, 50)
   Right = Abs(Right)
   Right = (Right < 0) ? 0 : Right
   Right = (Right > 100) ? 100 : Right
   w     = Width(c)
   h     = Height(c)
   r0    = Video_Width - Video_Width00
   b0    = Round(Float(r0) * Float(Right) / 100.0)   # Size of crop right
   t0    = r0 - b0 - 1                               # Size of crop left
   b0    = -1 * (b0 + 1)
   c     = ((w == Video_Width) && (h == Video_Height)) ? \
   c.Crop(t0, 0, b0, 0) : c
   c     = ((w == Video_Width) && (h == Video_Height)) ? \
   c.BicubicResize(Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c), 0, 0.5) : c 
#   c.Spline64Resize(Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c)) : c 
   return c
}
 
 
function Convert_1280x720_to_768x576_AddBorders(clip c)
{
   w  = Width(c)
   h  = Height(c)
   k  = Float(Video_Width2) / Float(Video_Height2)
   h1 = Round(Video_Width1 / k)
   b  = Round((h1 - Video_Height1) / 2)
   c  = ((w == Video_Width1) && (h == Video_Height1)) ? c.AddBorders(0, b, 0, b) : c
   c  = ((w == Video_Width1) && (h == Video_Height1)) ? \
   c.BicubicResize(Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c), 0, 0.5) : c
#   c.Spline64Resize(Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c)) : c
   return c
}
 
 
function Convert_1280x720_to_768x576_Crop(clip c, int "Right")
{
   Right = default(Right, 50)
   Right = Abs(Right)
   Right = (Right < 0) ? 0 : Right
   Right = (Right > 100) ? 100 : Right
   w      = Width(c)
   h      = Height(c)
   r1     = Video_Width1 - Video_Width11
   b1     = Round(Float(r1) * Float(Right) / 100.0)    # Size of crop right
   t1     = r1 - b1                                    # Size of crop left
   b1     = -1 * b1
   c      = ((w == Video_Width1) && (h == Video_Height1)) ? \
   c.Crop(t1, 0, b1, 0) : c
   c      = ((w == Video_Width1) && (h == Video_Height1)) ? \
   c.BicubicResize(Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c), 0, 0.5) : c 
#   c.Spline64Resize(Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c)) : c 
   return c
}
 
 
# Special function that crops video 768x576 to 480x384 and than converts to 768x576
# for restoring 8mm old film

function Convert_768x576_to_768x576_Crop(clip c, int "Left", int "Bottom")
{
   x      = Video_Width2 - Video_Width5
   y      = Video_Height2 - Video_Height5
   Bottom = Default(Bottom, -4)
   Bottom = (Bottom >= y) ? y : Bottom
   Bottom = (Bottom > 0) ? -1 * Bottom : Bottom
   Left   = Default(Left, 4)
   Left   = (Left < 0) ? Abs(Left) : Left
   Left   = (Left >= x) ? x : Left
   Right  = -1 * (x - Left)
   Right  = (Right > 0) ? -1 * Right : Right
   Top    = y + Bottom
   w      = Width(c)
   h      = Height(c)
   c      = ((w == Video_Width2) && (h == Video_Height2)) ? \
   c.Crop(Left, Top, Right, Bottom) : c
   c      = ((w == Video_Width2) && (h == Video_Height2)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   c      = ((w == Video_Width2) && (h == Video_Height2)) ? \
   c.BicubicResize(Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c), 0, 0.5) : c 
#   c.Spline64Resize(Video_Width2, Video_Height2, src_width=Width(c), src_height=Height(c)) : c 
   return c
}
 

# Resize functions
# Convert to Full HD (1920x1080)

function Convert_640x480_to_1920x1080_AddBorders(clip c)
{
   w  = Width(c)
   h  = Height(c)
   k  = Float(Video_Height) / Float(h)
   w1 = Round(Float(w) * k)
   b  = Round((Video_Width - w1) / 2)
   c  = ((w == Video_Width3) && (h == Video_Height3)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   c  = ((w == Video_Width3) && (h == Video_Height3)) ? \
   c.Lanczos4Resize(w1, Video_Height, src_width=Width(c), src_height=Height(c)). \
   AddBorders(b, 0, b, 0) : c
#   c.Spline64Resize(w1, Video_Height, src_width=Width(c), src_height=Height(c)). \
   return c
}
 
 
function Convert_640x480_to_1920x1080_Crop(clip c, int "Bottom")
{
   Bottom = default(Bottom, 50)
   Bottom = Abs(Bottom)
   Bottom = (Bottom < 0) ? 0 : Bottom
   Bottom = (Bottom > 100) ? 100 : Bottom
   w      = Width(c)
   h      = Height(c)
   r3     = Video_Height3 - Video_Height31
   b3     = Round(Float(r3) * Float(Bottom) / 100.0)   # Size of crop bottom
   t3     = r3 - b3                                    # Size of crop top
   b3     = -1 * b3
   c      = ((w == Video_Width3) && (h == Video_Height3)) ? \
   c.Crop(0, t3, 0, b3) : c
   c      = ((w == Video_Width3) && (h == Video_Height3)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   c      = ((w == Video_Width3) && (h == Video_Height3)) ? \
   c.Spline64Resize(Video_Width, Video_Height, src_width=Width(c), src_height=Height(c)) : c 
   return c
}
 
 
function Convert_320x240_to_1920x1080_AddBorders(clip c)
{
   w = Width(c)
   h = Height(c)
   c = ((w == Video_Width4) && (h == Video_Height4)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   c = ((w == Video_Width4) && (h == Video_Height4)) ? \
   c.Convert_640x480_to_1920x1080_AddBorders() : c
   return c
}
 
 
function Convert_320x240_to_1920x1080_Crop(clip c, int "Bottom")
{
   w = Width(c)
   h = Height(c)
   c = ((w == Video_Width4) && (h == Video_Height4)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   c = ((w == Video_Width4) && (h == Video_Height4)) ? \
   c.Convert_640x480_to_1920x1080_Crop(Bottom) : c
   return c
}
 
 
function Convert_768x576_to_1920x1080_AddBorders(clip c)
{
   w  = Width(c)
   h  = Height(c)
   k  = Float(Video_Height) / Float(h)
   w1 = Round(Float(w) * k)
   b  = Round((Video_Width - w1) / 2)
   c  = ((w == Video_Width2) && (h == Video_Height2)) ? \
   c.Lanczos4Resize(w1, Video_Height, src_width=Width(c), src_height=Height(c)). \
   AddBorders(b, 0, b, 0) : c
#   c.Spline64Resize(w1, Video_Height, src_width=Width(c), src_height=Height(c)). \
   return c
}
 
 
function Convert_768x576_to_1920x1080_Crop(clip c, int "Bottom")
{
   Bottom = default(Bottom, 50)
   Bottom = Abs(Bottom)
   Bottom = (Bottom < 0) ? 0 : Bottom
   Bottom = (Bottom > 100) ? 100 : Bottom
   w      = Width(c)
   h      = Height(c)
   r2     = Video_Height2 - Video_Height21
   b2     = Round(Float(r2) * Float(Bottom) / 100.0)   # Size of crop bottom
   t2     = r2 - b2                                    # Size of crop top
   b2     = -1 * b2
   c      = ((w == Video_Width2) && (h == Video_Height2)) ? \
   c.Crop(0, t2, 0, b2) : c
   c      = ((w == Video_Width2) && (h == Video_Height2)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   c      = ((w == Video_Width2) && (h == Video_Height2)) ? \
   c.Spline64Resize(Video_Width, Video_Height, src_width=Width(c), src_height=Height(c)) : c 
   return c
}
 
 
function Convert_1280x720_to_1920x1080(clip c)
{
   w = Width(c)
   h = Height(c)
   c = ((w == Video_Width1) && (h == Video_Height1)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   c = ((w == Video_Width1) && (h == Video_Height1)) ? \
   c.Lanczos4Resize(Video_Width1, Video_Height1, src_width=Width(c), src_height=Height(c)) : c 
#   c.Spline64Resize(Video_Width1, Video_Height1, src_width=Width(c), src_height=Height(c)) : c 
   return c
}
  
 
#
# Resize functions
# Convert to 720HD (1280x720)
#
function Convert_640x480_to_1280x720_AddBorders(clip c)
{
   w  = Width(c)
   h  = Height(c)
   k  = Float(Video_Height1) / Float(h)
   w1 = Round(Float(w) * k)
   b  = Round((Video_Width1 - w1) / 2)
   c  = ((w == Video_Width3) && (h == Video_Height3)) ? \
   c.Lanczos4Resize(w1, Video_Height1, src_width=w, src_height=h). \
   AddBorders(b, 0, b, 0) : c
#   c.Spline64Resize(w1, Video_Height1, src_width=w, src_height=h). \
   return c
}
 
 
function Convert_640x480_to_1280x720_Crop(clip c, int "Bottom")
{
   Bottom = default(Bottom, 50)
   Bottom = Abs(Bottom)
   Bottom = (Bottom < 0) ? 0 : Bottom
   Bottom = (Bottom > 100) ? 100 : Bottom
   w      = Width(c)
   h      = Height(c)
   r3     = Video_Height3 - Video_Height31
   b3     = Round(Float(r3) * Float(Bottom) / 100.0)   # Size of crop bottom
   t3     = r3 - b3                                    # Size of crop top
   b3     = -1 * b3
   c      = ((w == Video_Width3) && (h == Video_Height3)) ? \
   c.Crop(0, t3, 0, b3) : c
   c      = ((w == Video_Width3) && (h == Video_Height3)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   return c
}
 
 
function Convert_320x240_to_1280x720_AddBorders(clip c)
{
   w = Width(c)
   h = Height(c)
   c = ((w == Video_Width4) && (h == Video_Height4)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   c = ((w == Video_Width4) && (h == Video_Height4)) ? \
   c.Convert_640x480_to_1280x720_AddBorders() : c
   return c
}
 
 
function Convert_320x240_to_1280x720_Crop(clip c, int "Bottom")
{
   w = Width(c)
   h = Height(c)
   c = ((w == Video_Width4) && (h == Video_Height4)) ? \
   c.ConvertToYV12().BlowUp().ConvertToYUY2() : c
#   c.ConvertToYV12(). \
#   nnedi2_rpow2(rfactor=2, cshift="lanczos4resize", nsize=0, qual=3).EdgeSharpen(edge). \
#   ConvertToYUY2() : c
   c = ((w == Video_Width4) && (h == Video_Height4)) ? \
   c.Convert_640x480_to_1280x720_Crop(Bottom) : c
   return c
}
 
 
function Convert_768x576_to_1280x720_AddBorders(clip c)
{
   w  = Width(c)
   h  = Height(c)
   k  = Float(Video_Height1) / Float(h)
   w1 = Round(Float(w) * k)
   b  = Round((Video_Width1 - w1) / 2)
   c  = ((w == Video_Width2) && (h == Video_Height2)) ? \
   c.Lanczos4Resize(w1, Video_Height1, src_width=Width(c), src_height=Height(c)). \
   AddBorders(b, 0, b, 0) : c
#   c.Spline64Resize(w1, Video_Height1, src_width=Width(c), src_height=Height(c)). \
   return c
}
 
 
function Convert_768x576_to_1280x720_Crop(clip c, int "Bottom")
{
   Bottom = default(Bottom, 50)
   Bottom = Abs(Bottom)
   Bottom = (Bottom < 0) ? 0 : Bottom
   Bottom = (Bottom > 100) ? 100 : Bottom
   w      = Width(c)
   h      = Height(c)
   r2     = Video_Height2 - Video_Height21
   b2     = Round(Float(r2) * Float(Bottom) / 100.0)   # Size of crop bottom
   t2     = r2 - b2                                    # Size of crop top
   b2     = -1 * b2
   c      = ((w == Video_Width2) && (h == Video_Height2)) ? \
   c.Crop(0, t2, 0, b2) : c
   c      = ((w == Video_Width2) && (h == Video_Height2)) ? \
   c.Lanczos4Resize(Video_Width1, Video_Height1, src_width=Width(c), src_height=Height(c)) : c 
#   c.Spline64Resize(Video_Width1, Video_Height1, src_width=Width(c), src_height=Height(c)) : c 
   return c
}
 
 
function Convert_1920x1080_to_1280x720(clip c)
{
   w = Width(c)
   h = Height(c)
   c = ((w == Video_Width) && (h == Video_Height)) ? \
   c.BicubicResize(Video_Width1, Video_Height1, src_width=w, src_height=h, 0, 0.5) : c 
#   c.Spline64Resize(Video_Width1, Video_Height1, src_width=w, src_height=h) : c 
   return c
}
