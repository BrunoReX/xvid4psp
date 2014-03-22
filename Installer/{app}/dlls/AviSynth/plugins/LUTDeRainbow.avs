#####################################################
#                                                   #
# LUTDeRainbow, a derainbowing script by Scintilla  #
# Last updated 10/3/08                              #
#                                                   #
#####################################################
#
# Syntax:
# LUTDeRainbow(clip input, float "cthresh", float "ythresh", bool "y",
#	\ bool "linkUV", bool "mask")
#
# Requires YV12 input, frame-based only.
# Is of reasonable speed (faster than aWarpSharp, slower than DeGrainMedian).
# Suggestions for improvement welcome: scintilla@aquilinestudios.org
#
# Required plugins:
# MaskTools 2.0 (MT_MaskTools)
#
# Arguments:

# cthresh (default=10) - This determines how close the chroma values of the
#	pixel in the previous and next frames have to be for the pixel to
#	be hit.  Higher values (within reason) should catch more rainbows,
#	but may introduce unwanted artifacts.  Probably shouldn't be set
#	above 20 or so.
#
# ythresh (default=10) - If the y parameter is set true, then this
#	determines how close the luma values of the pixel in the previous
#	and next frames have to be for the pixel to be hit.  Just as with
#	cthresh.
#
# y (default=true) - Determines whether luma difference will be considered
#	in determining which pixels to hit and which to leave alone.
#
# linkUV (default=true) - Determines whether both chroma channels are
#	considered in determining which pixels in each channel to hit.
#	When set true, only pixels that meet the thresholds for both U and
#	V will be hit; when set false, the U and V channels are masked
#	separately (so a pixel could have its U hit but not its V, or vice
#	versa).
#
# mask (default=false) - When set true, the function will return the mask
#	(for combined U/V) instead of the image.  Formerly used to find the
#	best values of cthresh and ythresh.  If linkUV=false, then this
#	mask won't actually be used anyway (because each chroma channel
#	will have its own mask).
#
###################
#
# Changelog:
#
# 6/23/05: Is this thing on?
# 6/24/05: Replaced whole mask mechanism; new mask checks to see that BOTH channels
# 	of the chroma are within the threshold from previous frame to next
# 7/1/05: Added Y option, to take luma into account when deciding whether to use the
#	averaged chroma; added ythresh and cthresh parameters, to determine how close
#	the chroma/luma values of a pixel have to be to be considered the same
#	(y=true is meant to cut down on artifacts)
# 9/2/05: Suddenly realized this wouldn't work for YUY2 and made it YV12 only;
#	added linkUV option, to decide whether to use a separate mask for each chroma
#	channel or use the same one for both.
# 10/3/08: Fixed "cthresh" typos in documentation; killed repmode since I realized I
#	wasn't using Repair anymore; finally upgraded to MaskTools 2.
#
###################


function LUTDeRainbow(clip input, float "cthresh", float "ythresh", bool "y", bool "linkUV", bool "mask") {

Assert(input.IsYV12(),"LUTDeRainbow: YV12 input only")

cthresh=default(cthresh,10)
ythresh=default(ythresh,10)
cthr=string(cthresh)
ythr=string(ythresh)
#repmode=default(repmode,11)
org=input #.SeparateFields()

org_minus=org.Trim(0,-1)+org.Trim(0,org.framecount-1)
org_plus=org.Trim(1,0)+org.Trim(org.framecount,0)

org_u=UToY(org)
org_v=VToY(org)
org_minus_y=org_minus.Greyscale()
org_minus_u=UToY(org_minus)
org_minus_v=VToY(org_minus)
org_plus_y=org_plus.Greyscale()
org_plus_u=UToY(org_plus)
org_plus_v=VToY(org_plus)

average_u=mt_lutxy(org_minus_u,org_plus_u,"x y - abs "+cthr+" < x y + 2 / 0 ?").Greyscale()
average_v=mt_lutxy(org_minus_v,org_plus_v,"x y - abs "+cthr+" < x y + 2 / 0 ?").Greyscale()
average_y=mt_lutxy(org_minus_y,org_plus_y,"x y - abs "+ythr+" < 255 0 ?").Greyscale().ReduceBy2()

umask=average_u.mt_Binarize(threshold=20,upper=false).Greyscale()
umask=(default(y,true)?mt_Logic(umask,average_y,"and").Greyscale():umask)
vmask=average_v.mt_Binarize(threshold=20,upper=false).Greyscale()
vmask=(default(y,true)?mt_Logic(vmask,average_y,"and").Greyscale():vmask)

themask=mt_Logic(average_u.mt_Binarize(threshold=20,upper=false),average_v.mt_Binarize(threshold=20,upper=false),"and").Greyscale()
themask=(default(y,true)?mt_Logic(themask,average_y,"and").Greyscale():themask)

fixed_u=mt_lutxy(average_u,org_u,"x y + 2 /",y=3,u=2,v=2)
fixed_v=mt_lutxy(average_v,org_v,"x y + 2 /",y=3,u=2,v=2)

output_u=mt_Merge(org_u,fixed_u,default(linkUV,true)?themask:umask)#.Repair(org_u,repmode)
output_v=mt_Merge(org_v,fixed_v,default(linkUV,true)?themask:vmask)#.Repair(org_v,repmode)

output=YToUV(output_u,output_v,org)

return (default(mask,false)?themask.PointResize(org.width,org.height):output)

}
