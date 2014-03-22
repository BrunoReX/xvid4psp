#############################################
#                                           #
#      Adaptive Lens Blur Repair 1.0.2      #
#            by Francois Visagie            #
#                                           #
#  Selective motion-compensated deblurring  #
#   using frame-adaptive repair mask and    #
#       multi-stage artifact removal        #
#                                           #
#############################################


#-------------------------------------------
# Rationale
#
#   With heavily and/or variably blurred (e.g. progressive centre-to-edge) video, Unsharp Mask sharpening usually has the following limitations:
#       *   The very first thing it does is further blurring, destroying already fragile motion vectors and creating distorted motion
#       *   It sharpens the whole frame equally much with unattractive results for variably blurred video
#   Variable blur is an especially big problem when it also moves around temporally, e.g. luma flares caused by bright objects in the frame.
#   In such cases even a selective sharpening mask is inadequate because it remains static between frames.
#
#   In an attempt to address these issues, this script
#       *   Works with motion vectors carefully, saving them before anything else
#       *   Uses edge detection to create a frame-adaptive repair mask for identifying flat vs. detailed areas
#       *   Provides a choice of sharpeners
#       *   Inserts motion compensation/denoising between repair stages using motion vectors refined with MRecalculate()
#
#   Various operating modes are available
#       *   Adaptive MC sharpening as described
#       *   Blanket (repair mask inactive) MC sharpening with denoising
#       *   MC temporal denoising only
#
#   To assist with tuning motion vector detection and repair mask parameters, various output modes are available.
#   Settings can be displayed in each output mode.
#
#
# Prototype, parameters and defaults
#
#   ALBR(clip a, string "mode", \
#        int "rc", int "thshlow", int "thshhi", float "vmdb", \
#        string "sharpnr", bool "shrpchr", int "rshy", int "rshc", float "strsh", int "thL", int "thU", int "type", int "map", int "lim", \
#        float "hue", float "sat", float "bright", float "cont", \
#        int "degrain", int "hpad", int "vpad", int "pel", int "rfilter", \
#        int "blksizA", int "ovrlapA", bool "temporl", int "lambda", int "pnew", \
#        int "blksizR", int "ovrlapR", int "thSADR", \
#        string "output", int "mvscale", bool "shosets")
#
#   Mode Setting
#   ------------
#
#   Available modes:
#       "AdSharp"   :   adaptive repair mask sharpening with denoising, all functionality and settings active
#       "Sharpen"   :   blanket sharpening (no repair mask) and denoise, Repair Mask Settings inactive
#       "Denoise"   :   temporally denoise only, Repair Mask and Sharpening Settings inactive
#
# mode    = Default(mode,   "AdSharp")
#
#   Repair Mask Settings
#   --------------------
#
# rc      = Default(rc,     50        )   # Radius for consolidating repair mask detailed and flat areas
# thshlow = Default(thshlow,22        )   # Repair mask low threshold - sharpen all detail BELOW this level
# thshhi  = Default(thshhi, 34        )   # Repair mask high threshold - sharpen no detail ABOVE this level
#                                         # - intermediate levels are sharpened proportionately
# vmdb    = Default(vmdb,   16.0      )   # Blur variance for debanding repair mask
#
#   Sharpening Settings
#   -------------------
#
#   Available sharpeners:
#       "Unsharpen" :   unsharpen() from VariableBlur.txt, almost identical to next, 3.1 fps
#       "Unsharp"   :   unsharp() from VariableBlur.txt, almost identical to previous, 3.1 fps
#       "SMSSQME"   :   Based on simplified multi-scale sampled quasi-median enhancer at http://forum.doom9.org/showthread.php?p=1595531#post1595531,
#                       less good than unsharp/en() on badly blurred source, 2.8 fps
#       "QMENoTopo" :   Above without topological reconstruction, slightly sharper on badly blurred source, 2.8 fps
#       "TUnSharp"  :   Does not work well for badly blurred source, 2.8 fps
#
# sharpnr = Default(sharpnr,"Unsharp" )   # Sharpener to use
# shrpchr = Default(shrpchr, true)        # Sharpen also chroma (true) or luma only (false), ignored by TUnSharp
#     Sharpener presets:                     Unsharpen   Unsharp     SMSSQME     QMENoTopo   TUnSharp
#         (NOTE: radius settings are internally converted to variance values for functions using those)
# rshy    = Default(rshy,   Select(shrpnum,  31,         31,         12,         12,         3        ))  # Unsharp mask Y radius/TUnSharp radius
# rshc    = Default(rshc,   Select(shrpnum,  31,         31,         8,          8,          0        ))  # Unsharp mask C radius, unused by TUnSharp
# strsh   = Default(strsh,  Select(shrpnum,  1.13,       1.13,       1.62,       1.62,       100      ))  # Sharpening strength
# thL     = Default(thL,    Select(shrpnum,  0,          0,          0,          0,          1        ))  # TUnSharp lower edge magnitude threshold,
#                                                                                                         # unused by others
# thU     = Default(thU,    Select(shrpnum,  0,          0,          0,          0,          5        ))  # TUnSharp upper edge magnitude threshold,
#                                                                                                         # unused by others
# type    = Default(type,   Select(shrpnum,  0,          0,          0,          0,          1        ))  # TUnSharp sharpening/unsharpmasking operator,
#                                                                                                         # unused by others
# map     = Default(map,    Select(shrpnum,  0,          0,          0,          0,          0        ))  # TUnSharp output map type, unused by others
# lim     = Default(lim,    Select(shrpnum,  0,          0,          0,          0,          2        ))  # TUnSharp sharpening limit, unused by others
# hue     = Default(hue,    Select(shrpnum,  0.0,        0.0,        0.0,        0.0,        0.0      ))  # Post-sharpening hue normalisation
# sat     = Default(sat,    Select(shrpnum,  0.65,       0.65,       1.0,        1.0,        1.16     ))  # Post-sharpening saturation normalisation
# bright  = Default(bright, Select(shrpnum,  35.3,       35.3,       23.5,       23.5,       0.0      ))  # Post-sharpening brightness normalisation
# cont    = Default(cont,   Select(shrpnum,  0.7,        0.7,        0.8,        0.8,        1.0      ))  # Post-sharpening contrast normalisation
#
#   Motion Vector Settings
#   ----------------------
#
# degrain = Default(degrain,3         )   # temporal radius for denoising/structural consolidation
# hpad    = Default(hpad,   16        )   # Need hpad and vpad this size for blksizA below
# vpad    = Default(vpad,   16        )
# pel     = Default(pel,    2         )   # MSuper() motion estimation accuracy
# rfilter = Default(rfilter,4         )   # Gives better results than default of 2
# blksizA = Default(blksizA,16        )   # Block size for analysing MVs
# ovrlapA = Default(ovrlapA,blksizA/2 )   # Overlap for analysing MVs
# temporl = Default(temporl,false     )   # Seems not to affect output, incompatible with SetMTMode when true
# lambda  = Default(lambda, 500       )   # For blurry source choose lambda and pnew values that slightly relax coherence,
# pnew    = Default(pnew,   25        )   # to prevent too many MVs being discarded and causing motion distortion
# blksizR = Default(blksizR,8         )   # Block size for refining MVs
# ovrlapR = Default(ovrlapR,blksizR/2 )   # Overlap for refining MVs
# thSADR  = Default(thSADR, 400       )   # Ditto relax re-estimation threshold
#
#   Tuning Aids
#   -----------
#
#   Available outputs:
#       "Result"    :   script result
#       "MVs"       :   motion vector overlay
#       "Mask"      :   repair mask
#       
# output  = Default(output, "Result"  )   # What to output
# mvscale = Default(mvscale,2         )   # Scale at which to display motion vectors
# shosets = Default(shosets,false     )   # Shows settings when true, also shows pixel values for output == "Result"
#
#
# Usage
#
#   ALBR(output="MVs", shosets=true)                      # Display motion vectors and settings for tuning purposes
#   ALBR(output="Mask", shosets=true)                     # Display repair mask and settings for tuning purposes
#   ALBR(sharpnr="TUnSharp", map=2, shosets=true)         # Display TUnSharp sharpening map (1/2) for tuning purposes
#   ALBR(shosets=true)                                    # Display result and settings for sharpener tuning
#   a=ALBR()                                              # Adaptively MC-sharpen with default sharpener and settings,
#   b=ALBR(mode="Denoise")                                #   denoise original by same amount,
#   splicelist="75:25, 150:25, 200:25, 400:25, 426:25"    #   specify splices (blends in this case) as needed,
#   SpliceFiltered(b, a, splicelist)                      #   selectively blend in sharpened material
#   ALBR(mode="Sharpen", sharpnr="SMSSQME", strsh=0.5)    # Blanket MC-sharpen cleaner source with high-quality enhancer
#
#
# Limitations
#
#   Repair mask -   although edge detection is much better than nothing, it also includes actual detail-less areas for sharpening
#   Not intended for sharpening motion blur
#
#
# Requirements
#
#   YV12 colourspace
#   From http://avisynth.org/mediawiki/External_filters:
#       MaskTools
#       MedianBlur
#       MVTools v2
#       RemoveGrain
#       TUnSharp
#       VariableBlur
#   Optional
#       SpliceFiltered from http://forum.doom9.org/showthread.php?t=166627
#
#
# Version history
#
#   1.0.2
#       Sharpening artifact removal now skipped when only denoising
#       MV recalculation between stages now disabled when only denoising
#
#   1.0.1
#       Expanded usage scenarios
#
#   1.0.0
#       Wrapped in function
#       Documented parameters and use
#       Added additional operating modes for blanket MC sharpening as well as MC temporal denoising
#
#   0.2.3
#       Added QMENoTopo sharpener
#       Added soure frame plus frame pixel values to Result settings display
#       Completed evaluation & characterisation of provided sharpeners & updated sharpener defaults accordingly
#       Various small improvements
#
#   0.1.1
#       Initial version
#
#-------------------------------------------


#-------------------------------------------
# TODO
#
#   try Winhisto() - MRecalculate() problem after RGB32-YV12 conversion
#   try MergeLuma() with Winhisto() to help match its luma to input
#   get larger radius + chroma processing for TUnSharp
#   investigate possible speed improvements
#   evaluate other area masking approaches (e.g. try to directly identify luma flares)
#   try replacing Tweak() with feed-forward to automatically restore original levels after sharpening
#   investigate Laplacian of Gaussian (http://homepages.inf.ed.ac.uk/rbf/HIPR2/unsharp.htm & http://homepages.inf.ed.ac.uk/rbf/HIPR2/log.htm)
#   investigate Adaptive Unsharp Masking (http://homepages.inf.ed.ac.uk/rbf/HIPR2/unsharp.htm)
#
#-------------------------------------------


function ALBR(clip a, string "mode", \
             int "rc", int "thshlow", int "thshhi", float "vmdb", \
             string "sharpnr", bool "shrpchr", int "rshy", int "rshc", float "strsh", int "thL", int "thU", int "type", int "map", int "lim", \
             float "hue", float "sat", float "bright", float "cont", \
             int "degrain", int "hpad", int "vpad", int "pel", int "rfilter", \
             int "blksizA", int "ovrlapA", bool "temporl", int "lambda", int "pnew", \
             int "blksizR", int "ovrlapR", int "thSADR", \
             string "output", int "mvscale", bool "shosets") {


#-------------------------------------------
# Settings
#


#   Mode Setting
#   ------------
#
#   Available modes:
#       "AdSharp"   :   adaptive repair mask sharpening with denoising, all functionality and settings active
#       "Sharpen"   :   blanket sharpening (no repair mask) and denoise, Repair Mask Settings inactive
#       "Denoise"   :   temporally denoise only, Repair Mask and Sharpening Settings inactive
#
mode    = Default(mode,   "AdSharp")
Assert((mode == "AdSharp") ? true : \
       (mode == "Sharpen") ? true : \
       (mode == "Denoise") ? true : \
       false, """'mode' choice """" + mode + """" is invalid""")


#   Repair Mask Settings
#   --------------------
#
rc      = Default(rc,     50        )   # Radius for consolidating repair mask detailed and flat areas
thshlow = Default(thshlow,22        )   # Repair mask low threshold - sharpen all detail BELOW this level
thshhi  = Default(thshhi, 34        )   # Repair mask high threshold - sharpen no detail ABOVE this level
                                        # - intermediate levels are sharpened proportionately
vmdb    = Default(vmdb,   16.0      )   # Blur variance for debanding repair mask


#   Sharpening Settings
#   -------------------
#
#   Available sharpeners:
#       "Unsharpen" :   unsharpen() from VariableBlur.txt, almost identical to next, 3.1 fps
#       "Unsharp"   :   unsharp() from VariableBlur.txt, almost identical to previous, 3.1 fps
#       "SMSSQME"   :   Based on simplified multi-scale sampled quasi-median enhancer at http://forum.doom9.org/showthread.php?p=1595531#post1595531,
#                       less good than unsharp/en() on badly blurred source, 2.8 fps
#       "QMENoTopo" :   Above without topological reconstruction, slightly sharper on badly blurred source, 2.8 fps
#       "TUnSharp"  :   Does not work well for badly blurred source, 2.8 fps
#
sharpnr = Default(sharpnr,"Unsharp" )   # Sharpener to use
shrpnum = (sharpnr == "Unsharpen") ? 0 : \
          (sharpnr == "Unsharp"  ) ? 1 : \
          (sharpnr == "SMSSQME"  ) ? 2 : \
          (sharpnr == "QMENoTopo") ? 3 : \
          (sharpnr == "TUnSharp" ) ? 4 : 5
Assert(shrpnum < 5, """'sharpnr' choice """" + sharpnr + """" is invalid""")
shrpchr = Default(shrpchr, true)        # Sharpen also chroma (true) or luma only (false), ignored by TUnSharp
ush     = (shrpchr == true) ? 3 : 2     # Set specified chroma sharpening
vsh     = (shrpchr == true) ? 3 : 2
#   Sharpener presets:                     Unsharpen   Unsharp     SMSSQME     QMENoTopo   TUnSharp
#       (NOTE: radius settings are internally converted to variance values for functions using those)
rshy    = Default(rshy,   Select(shrpnum,  31,         31,         12,         12,         3        ))  # Unsharp mask Y radius/TUnSharp radius
rshc    = Default(rshc,   Select(shrpnum,  31,         31,         8,          8,          0        ))  # Unsharp mask C radius, unused by TUnSharp
strsh   = Default(strsh,  Select(shrpnum,  1.13,       1.13,       1.62,       1.62,       100      ))  # Sharpening strength
thL     = Default(thL,    Select(shrpnum,  0,          0,          0,          0,          1        ))  # TUnSharp lower edge magnitude threshold,
                                                                                                        # unused by others
thU     = Default(thU,    Select(shrpnum,  0,          0,          0,          0,          5        ))  # TUnSharp upper edge magnitude threshold,
                                                                                                        # unused by others
type    = Default(type,   Select(shrpnum,  0,          0,          0,          0,          1        ))  # TUnSharp sharpening/unsharpmasking operator,
                                                                                                        # unused by others
map     = Default(map,    Select(shrpnum,  0,          0,          0,          0,          0        ))  # TUnSharp output map type, unused by others
lim     = Default(lim,    Select(shrpnum,  0,          0,          0,          0,          2        ))  # TUnSharp sharpening limit, unused by others
hue     = Default(hue,    Select(shrpnum,  0.0,        0.0,        0.0,        0.0,        0.0      ))  # Post-sharpening hue normalisation
sat     = Default(sat,    Select(shrpnum,  0.65,       0.65,       1.0,        1.0,        1.16     ))  # Post-sharpening saturation normalisation
bright  = Default(bright, Select(shrpnum,  35.3,       35.3,       23.5,       23.5,       0.0      ))  # Post-sharpening brightness normalisation
cont    = Default(cont,   Select(shrpnum,  0.7,        0.7,        0.8,        0.8,        1.0      ))  # Post-sharpening contrast normalisation
#   Convert radius to variance for functions using that
vshy    = Pow((rshy+1)/Sqrt(Log(255)/Log(2)), 2)
vshc    = Pow((rshc+1)/Sqrt(Log(255)/Log(2)), 2)
ysh     = 3


#   Motion Vector Settings
#   ----------------------
#
degrain = Default(degrain,3         )   # temporal radius for denoising/structural consolidation
hpad    = Default(hpad,   16        )   # Need hpad and vpad this size for blksizA below
vpad    = Default(vpad,   16        )
pel     = Default(pel,    2         )   # MSuper() motion estimation accuracy
rfilter = Default(rfilter,4         )   # Gives better results than default of 2
blksizA = Default(blksizA,16        )   # Block size for analysing MVs
ovrlapA = Default(ovrlapA,blksizA/2 )   # Overlap for analysing MVs
temporl = Default(temporl,false     )   # Seems not to affect output, incompatible with SetMTMode when true
lambda  = Default(lambda, 500       )   # For blurry source choose lambda and pnew values that slightly relax coherence,
pnew    = Default(pnew,   25        )   # to prevent too many MVs being discarded and causing motion distortion
blksizR = Default(blksizR,8         )   # Block size for refining MVs
ovrlapR = Default(ovrlapR,blksizR/2 )   # Overlap for refining MVs
thSADR  = Default(thSADR, 400       )   # Ditto relax re-estimation threshold


#   Tuning Aids
#   -----------
#
#   Available outputs:
#       "Result"    :   script result
#       "MVs"       :   motion vector overlay
#       "Mask"      :   repair mask
#       
output  = Default(output, "Result"  )   # What to output
Assert((output == "Result") ? true : \
       (output == "MVs"   ) ? true : \
       (output == "Mask"  ) ? true : \
       false, """'output' choice """" + output + """" is invalid""")
mvscale = Default(mvscale,2         )   # Scale at which to display motion vectors
shosets = Default(shosets,false     )   # Shows settings when true, also shows pixel values for output == "Result"


#-------------------------------------------
# Treat any detail and detectable motion in blurry source with kid gloves - do not denoise up front
#


#-------------------------------------------
# Save source clip motion vectors
#
#   Identify large moving areas using larger blocks
#   For blurry source choose lambda and pnew values that slightly relax coherence to prevent too many MVs being discarded and causing motion distortion
#
a.MSuper(hpad=hpad, vpad=vpad, pel=pel, rfilter=rfilter)
bvec3   = (degrain == 3) ? \
          MAnalyse(isb=true, delta=3, blksize=blksizA, overlap=ovrlapA, temporal=temporl, lambda=lambda, pnew=pnew) : BlankClip()
bvec2   = (degrain >= 2) ? \
          MAnalyse(isb=true, delta=2, blksize=blksizA, overlap=ovrlapA, temporal=temporl, lambda=lambda, pnew=pnew) : BlankClip()
bvec1   = MAnalyse(isb=true, delta=1, blksize=blksizA, overlap=ovrlapA, temporal=temporl, lambda=lambda, pnew=pnew)
fvec1   = MAnalyse(isb=false, delta=1, blksize=blksizA, overlap=ovrlapA, temporal=temporl, lambda=lambda, pnew=pnew)
fvec2   = (degrain >= 2) ? \
          MAnalyse(isb=false, delta=2, blksize=blksizA, overlap=ovrlapA, temporal=temporl, lambda=lambda, pnew=pnew) : BlankClip()
fvec3   = (degrain == 3) ? \
          MAnalyse(isb=false, delta=3, blksize=blksizA, overlap=ovrlapA, temporal=temporl, lambda=lambda, pnew=pnew) : BlankClip()
#   Refine motion vectors using smaller blocks to capture fine motion detail, edges and more complex motion
#   For blurry source relax re-estimation threshold to prevent too many MVs being discarded and causing motion distortion
bvec3   = (degrain == 3) ? \
          MRecalculate(bvec3, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : bvec3
bvec2   = (degrain >= 2) ? \
          MRecalculate(bvec2, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : bvec2
bvec1   = MRecalculate(bvec1, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew)
fvec1   = MRecalculate(fvec1, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew)
fvec2   = (degrain >=2 ) ? \
          MRecalculate(fvec2, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : fvec2
fvec3   = (degrain == 3) ? \
          MRecalculate(fvec3, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : fvec3
#   Save copies of motion vector data for display and tuning purposes
a_super = last
afvec   = fvec1


#-------------------------------------------
# Create frame-adaptive repair mask
#
#   Identify detailed vs. flat areas (luma only)
#
edgemsk = a.mt_edge(mode="hprewitt", thY1=thshlow, thY2=thshhi, y=3, u=-128, v=-128)
#   Consolidate detailed and flat areas
consmsk = edgemsk.medianblur(rc, 0, 0)
#   Normalise mask levels to around full range to prevent sharp transitions around mask edges
consmsk.Levels(Max(0, thshlow-1), 1.000, Min(255,(thshhi+1)), 0, 255, coring=false)
#   Deband mask
binomialBlur(vmdb, 0.0, 3, 2, 2, true)
albmask = mt_invert(y=3, u=-128, v=-128)


#-------------------------------------------
# Create sharpened clip
#
#   Purposely try to "sharpen" chroma too
#
Eval(Select(shrpnum, \
        """a.gaussianblur(varY=vshy, varC=vshc, y=ysh, u=ush, v=vsh).mt_lutxy(a, "y x - " + String(strsh) + " * y +", y=ysh, u=ush, v=vsh)""", \
        """a.unsharp(varY=vshy, varC=vshc, strength=strsh, y=ysh, u=ush, v=vsh)""", \
        """a.mt_lutxy(a.repair(a.repair(a.repair(a.repair(a.repair(a.repair(a.repair(a.repair(a.medianblur(rshy, rshc, rshc), 4), 4), 4), 4), 4), 4), 4), 4), \
           "x x y - abs " + string(strsh, "%#.2f") + " 2 ^ / 1 " + string(strsh, "%#.2f") + " / ^ " + string(strsh, "%#.2f") + " 3 ^ * x y - x y - abs " \
           + string(strsh, "%#.2f") + " + / * +", y=ysh, u=ush, v=vsh)""", \
        """a.mt_lutxy(a.medianblur(rshy, rshc, rshc), "x x y - abs " + string(strsh, "%#.2f") + " 2 ^ / 1 " + string(strsh, "%#.2f") + " / ^ " \
           + string(strsh, "%#.2f") + " 3 ^ * x y - x y - abs " + string(strsh, "%#.2f") + " + / * +", y=ysh, u=ush, v=vsh)""", \
        """a.TUnSharp(strength=Int(strsh), thresholdL=thL, thresholdU=thU, type=type, map=map, lim=lim, radius=rshy, gui=false)""" \
    ) \
)
#   Normalise levels somewhat after including chroma above
shrp    = ((hue != 0.0) || (sat != 1.0) || (bright != 0.0) || (cont != 1.0)) ? Tweak(hue=hue, sat=sat, bright=bright, cont=cont, coring=false) : last


#-------------------------------------------
# Use motion-compensated averaging to temporally smooth sharpening artifacts and remove some noise
#
shrp_super  = shrp.MSuper(hpad=hpad, vpad=vpad, pel=pel, rfilter=rfilter, levels=1)
#   Recalculate vectors to account for improved structure
bvec3   = (degrain == 3) ? \
          shrp_super.MRecalculate(bvec3, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : bvec3
bvec2   = (degrain >= 2) ? \
          shrp_super.MRecalculate(bvec2, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : bvec2
bvec1   = shrp_super.MRecalculate(bvec1, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew)
fvec1   = shrp_super.MRecalculate(fvec1, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew)
fvec2   = (degrain >= 2) ? \
          shrp_super.MRecalculate(fvec2, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : fvec2
fvec3   = (degrain == 3) ? \
          shrp_super.MRecalculate(fvec3, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : fvec3
#   Leave thSAD high enough (400) for only really bad vectors potentially to be re-evaluated - balance against introducing noise
sharpnd = (degrain == 3) ? shrp.MDegrain3(shrp_super, bvec1, fvec1, bvec2, fvec2, bvec3, fvec3) : \
          (degrain == 2) ? shrp.MDegrain2(shrp_super, bvec1, fvec1, bvec2, fvec2) : \
                           shrp.MDegrain1(shrp_super, bvec1, fvec1)


#-------------------------------------------
# Mode decision
#
#   "AdSharp"   :   use repair mask to merge original with sharpened clip
#   "Sharpen"   :   continue with sharpened clip directly
#   "Denoise"   :   continue with input clip
#
mrgd    = (mode == "AdSharp") ? mt_merge(a, sharpnd, albmask, luma=false, y=ysh, u=ush, v=vsh) : \
          (mode == "Sharpen") ? sharpnd : \
          a
          


#-------------------------------------------
# Reduce reconstruction noise in merged clip by adding light motion-compensated degraining
#
mrg_super   = mrgd.MSuper(hpad=hpad, vpad=vpad, pel=pel, rfilter=rfilter, levels=1)
#   Update motion vectors for (merged) sharpened clip; not when we're denoising only
bvec3   = ((mode != "Denoise") && (degrain == 3)) ? \
          mrg_super.MRecalculate(bvec3, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : bvec3
bvec2   = ((mode != "Denoise") && (degrain >= 2)) ? \
          mrg_super.MRecalculate(bvec2, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : bvec2
bvec1   = (mode != "Denoise") ? \
          mrg_super.MRecalculate(bvec1, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : bvec1
fvec1   = (mode != "Denoise") ? \
          mrg_super.MRecalculate(fvec1, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : fvec1
fvec2   = ((mode != "Denoise") && (degrain >= 2)) ? \
          mrg_super.MRecalculate(fvec2, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : fvec2
fvec3   = ((mode != "Denoise") && (degrain == 3)) ? \
          mrg_super.MRecalculate(fvec3, thSAD=thSADR, blksize=blksizR, overlap=ovrlapR, lambda=lambda, pnew=pnew) : fvec3
#   First MC degraining stage
DG1     = (degrain == 3) ? mrgd.MDegrain3(mrg_super, bvec1, fvec1, bvec2, fvec2, bvec3, fvec3) : \
          (degrain == 2) ? mrgd.MDegrain2(mrg_super, bvec1, fvec1, bvec2, fvec2) : \
                           mrgd.MDegrain1(mrg_super, bvec1, fvec1)
#   Second MC degraining stage
DG1_super   = DG1.MSuper(hpad=hpad, vpad=vpad, pel=pel, rfilter=rfilter, levels=1)
DG2     = (degrain == 3) ? DG1.MDegrain3(DG1_super, bvec1, fvec1, bvec2, fvec2, bvec3, fvec3) : \
          (degrain == 2) ? DG1.MDegrain2(DG1_super, bvec1, fvec1, bvec2, fvec2) : \
                           DG1.MDegrain1(DG1_super, bvec1, fvec1)


#-------------------------------------------
# Prepare and produce output
#
settins = (output == "Result") ? "Output: Final result" + \
                                 "\n--------------------" + \
                                 "\nFar left: source" + \
                                 "\nLeft:     result" : \
          (output == "MVs"   ) ? "Output: Motion vectors" + \
                                 "\n----------------------" + \
                                 "\n" + \
                                 "\n1st value: mean SAD after compensation" + \
                                 "\n2nd value: number of bad blocks" : \
          (output == "Mask"  ) ? "" + \
                                 "\n-----------------------" + \
                                 "\n" + \
                                 "\nTop left:  edge detection output" + \
                                 "\nTop right: consolidated detailed and flat areas" + \
                                 "\nLeft:      final normalised, debanded and inverted mask" + \
                                 "\n" + \
                                 "\nFrame-step fw<->bw to toggle between mask and source" : \
          "You should not see this result.\nThere is a bug in the script!"
settins = (shosets == false) ? settins : \
    settins + \
    "\n" + \
    "\nRepair Mask Settings:" + \
    "\nrc="+String(rc)+", thshlow="+String(thshlow)+", thshhi="+String(thshhi)+", vmdb="+String(vmdb,"%.2f") + \
    "\n" + \
    "\nSharpening Settings:" + \
    "\nsharpnr='"+String(sharpnr)+"', shrpchr="+String(shrpchr)+", rshy="+String(rshy)+", rshc="+String(rshc)+", strsh="+String(strsh,"%.2f") + \
    "\nthL="+String(thL)+", thU="+String(thU)+", type="+String(type)+", map="+String(map)+", lim="+String(lim) + \
    "\nhue="+String(hue,"%.2f")+", sat="+String(sat,"%.2f")+", bright="+String(bright,"%.2f")+", cont="+String(cont,"%.2f") + \
    "\n" + \
    "\nMotion Vector Settings:" + \
    "\ndegrain="+String(degrain)+", hpad="+String(hpad)+", vpad="+String(vpad)+", pel="+String(pel)+", rfilter="+String(rfilter) + \
    "\nblksizA="+String(blksizA)+", ovrlapA="+String(ovrlapA)+", temporl="+String(temporl)+", lambda="+String(lambda)+", pnew="+String(pnew) + \
    "\nblksizR="+String(blksizR)+", ovrlapR="+String(ovrlapR)+", thSADR="+String(thSADR) + \
    "\n" + \
    "\nTuning Aids:" + \
    "\noutput='"+output+"', mvscale="+String(mvscale)+", shosets="+String(shosets)
#   Select result
result  = (output == "Result") ? DG2                                                : \
          (output == "MVs"   ) ? MShow(a_super, afvec, scale=mvscale, showsad=true) : \
          (output == "Mask"  ) ? albmask                                            : \
          a.Subtitle("You should not see this result.\nThere is a bug in the script!", font="Lucida Console", size=18, lsp=20)
#   Prepare settings display
setclip = result.BlankClip().Subtitle(settins, font="Lucida Console", size=18, lsp=20)
#   Add heading and source frame number for interleaved mask tuning clip
setclip = (output == "Mask") \
            ? setclip.ScriptClip("""Subtitle("Output: Sharpening mask [source frame #"+String(current_frame)+"]", font="Lucida Console", size=18, lsp=20)""") \
            : setclip
#   Add source clip and pixel values when viewing results with settings
result  = ((output == "Result") && (shosets == true)) ? StackHorizontal(a.PixelValues(), result.PixelValues()) : result
#   For mask always display at least description
result  = ((output == "Mask") || (shosets == true))? StackHorizontal(result, setclip) : result
#   Complete mask display if needed
result  = (output == "Mask") \
            ? Interleave(StackVertical(StackHorizontal(edgemsk, consmsk), result), StackVertical(StackHorizontal(a, a), StackHorizontal(a, setclip))) \
            : result
return(result)
}


#-------------------------------------------
# Helper functions
#

# PixelValues: superimpose pixel values on specified clip
function PixelValues (clip c) {
    return(c.ScriptClip("""Subtitle("AvgLuma: "+String(AverageLuma(), "%.2f") + \
                                    "\nAvgChrU: "+String(AverageChromaU(), "%.2f") + \
                                    "\nAvgChrV: "+String(AverageChromaV(), "%.2f") \
                                    , font="Lucida Console", size=18, lsp=20)"""))
}
