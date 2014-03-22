########################################################
#                                                      #
# LUTDeCrawl, a dot crawl removal script by Scintilla  #
# Created 10/3/08				       #
# Last updated 10/3/08                                 #
#                                                      #
########################################################
#
# Syntax:
# LUTDeCrawl(clip input, int "ythresh", int "cthresh", int "maxdiff",
#	\ int "scnchg", bool "usemaxdiff", bool "mask")
#
# Requires YV12 input, frame-based only.
# Is of average speed (faster than VagueDenoiser, slower than HQDN3D).
# Suggestions for improvement welcome: scintilla@aquilinestudios.org
#
# Required plugins:
# MaskTools 2.0 (MT_MaskTools)
#
# Arguments:

# ythresh (default=10) - This determines how close the luma values of the
#	pixel in the previous and next frames have to be for the pixel to
#	be hit.  Higher values (within reason) should catch more dot crawl,
#	but may introduce unwanted artifacts.  Probably shouldn't be set
#	above 20 or so.
#
# cthresh (default=10) - This determines how close the chroma values of the
#	pixel in the previous and next frames have to be for the pixel to
#	be hit.  Just as with ythresh.
#
# maxdiff (default=50) - This is the maximum difference allowed between the
#	luma values of the pixel in the CURRENT frame and in each of its
#	neighbour frames (so, the upper limit to what fluctuations are
#	considered dot crawl).  Lower values will reduce artifacts but may
#	cause the filter to miss some dot crawl.  Obviously, this should
#	never be lower than ythresh.  Meaningless if usemaxdiff = false.
#
# scnchg (default=25) - Scene change detection threshold.  Any frame with
#	total luma difference between it and the previous/next frame greater
#	than this value will not be processed.
#
# usemaxdiff (default=true) - Whether or not to reject luma fluctuations
#	higher than maxdiff.  Setting this to false is not recommended, as
#	it may introduce artifacts; but on the other hand, it produces a
#	30% speed boost.  Test on your particular source.
#
# mask (default=false) - When set true, the function will return the mask
#	instead of the image.  Use to find the best values of cthresh,
#	ythresh, and maxdiff.
#	(The scene change threshold, scnchg, is not reflected in the mask.)
#
###################
#
# Changelog:
#
# 10/3/08: Is this thing on?
#
###################

function LUTDeCrawl(clip input, int "ythresh", int "cthresh", int "maxdiff", 
	          \ int "scnchg", bool "usemaxdiff", bool "mask") {

Assert(input.IsYV12(),"LUTDeCrawl: YV12 input only")

cthresh=default(cthresh,15)
ythresh=default(ythresh,10)
cthr=string(cthresh)
ythr=string(ythresh)
scnchg=default(scnchg,25)
sc=string(scnchg)
maxdiff=default(maxdiff,50)
md=string(maxdiff)
usemaxdiff=default(usemaxdiff,true)
org=input

org_minus=org.Trim(0,-1)+org.Trim(0,org.framecount-1)
org_plus=org.Trim(1,0)+org.Trim(org.framecount,0)

org_y=org.Greyscale()
org_minus_y=org_minus.Greyscale()
org_minus_u=UToY(org_minus)
org_minus_v=VToY(org_minus)
org_plus_y=org_plus.Greyscale()
org_plus_u=UToY(org_plus)
org_plus_v=VToY(org_plus)

average_u=mt_lutxy(org_minus_u,org_plus_u,"x y - abs "+cthr+" < 255 0 ?")
average_v=mt_lutxy(org_minus_v,org_plus_v,"x y - abs "+cthr+" < 255 0 ?")
average_y=mt_lutxy(org_minus_y,org_plus_y,"x y - abs "+ythr+" < x y + 2 / 0 ?")

diffplus_y =  mt_lutxy(org_plus_y,  org, "x y - abs "+md+" < 255 0 ?")
diffminus_y = mt_lutxy(org_minus_y, org, "x y - abs "+md+" < 255 0 ?")
diffs_y = mt_logic(diffplus_y, diffminus_y, "and").Greyscale()

ymask=average_y.mt_Binarize(threshold=0,upper=false)
ymask=usemaxdiff ? mt_logic(ymask, diffs_y, "and") : ymask
cmask=mt_logic(average_u.mt_Binarize(upper=false),average_v.mt_Binarize(upper=false),"and")
cmask=cmask.PointResize(cmask.Width()*2, cmask.Height()*2)

themask=mt_logic(ymask,cmask,"and")

fixed_y=mt_lutxy(average_y,org_y,"x y + 2 /",y=3,u=2,v=2)

output=MergeChroma(mt_Merge(org_y,fixed_y,themask),org)
output=ConditionalFilter(org, org, output, "YDifferenceFromPrevious()", ">", sc)
output=ConditionalFilter(org, org, output, "YDifferenceToNext()", ">", sc)

return (default(mask,false)?themask:output)

}
