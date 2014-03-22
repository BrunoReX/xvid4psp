##########################################################
## A simple upsizing function based on an idea by Didée ## 
## version 0.2 alpha 30 April 2012                      ##
## author : McCauley & Tempter57                        ##
##########################################################
## MVTools2.dll 
## NNEDI3.dll 
## mt_masktools-25.dll or mt_masktools-26.dll
## Removegrain.dll, AddGrainC.dll
## Repair.dll 
## GradFun2DB.dll
## VagueDenoiser.dll
## warsharp.dll 
## splineresize.dll
## DeHalo_alpha.avs
## LimitedSharpemFaster.avs
## FineSharp.avs
## GrainFactory3.avs
##########################################################

# function BlowUp()
# Resize function with noise reduction and sharpening
# Limitedsharpenfaster for 1280x720, FineSharp for 1920x1080
function BlowUp(clip clp, float "sstr", int "avgstr", int "g1str", int "g2str", int "g3str", int "avg", int "strength", \
                bool "preblow", bool "nnu", bool "edu", bool "exsharp", bool "ag", bool "LSF", bool "FS")
{
sstr    = default(sstr, 0.85)      # sharpening strength
strength = default(strength, 300)  # LSF strength 
avgstr  = default(avgstr, 400)     # averaging strength
g1str   = default(g1str,  5)       # strength of grain / for dark areas 
g2str   = default(g2str,  5)       # strength of grain / for midtone areas
g3str   = default(g3str,  6)       # strength of grain / for bright areas
avg     = default(avg, 2)          # how many frames are averaged 
preblow = default(preblow, true)   # upsize before sharpening averaging
nnu     = default(nnu, true)       # false = use Lanczos/Repair or true = NNEDI3 to upsize
edu     = default(edu, true)       # false = use Lanczos/Repair or true = EEDI3 to upsize
exsharp = default(exsharp, true)   # use higher quality sharpener
ag      = default(ag, true)        # add grain to the final output
LSF     = default(LSF, true)       # sharpening Limitedsharpenfaster
FS      = default(FS, false)       # sharpening FineSharp
 
ox      = clp.width
oy      = clp.height
blk     = blankclip(clp)
 
# setting up the clip for the averageing
# --------------------------------------
 
upsized = (nnu == true && preblow == true && LSF == true && FS == false) ? clp.nnedi3_rpow2(rfactor=2, cshift="Spline36resize", nsize=0, qual=2).DeHalo_alpha(rx=1.5,ry=1.5) : \
          (nnu == true && preblow == true && LSF == false && FS == true) ? clp.nnedi3_rpow2(rfactor=4, cshift="Spline36resize", nsize=0, qual=1).DeHalo_alpha(rx=1.5,ry=1.5) : \
          (preblow == true && nnu == false) ? clp.Spline36resize(ox * 2, oy * 2).Repair(clp.Gaussresize(ox * 2, oy * 2, p=100), 1) : \
                                              clp
 
# choosing the sharpening method:
# -------------------------------
sharp = (exsharp == true && preblow == true && LSF ==true && FS == false) ? upsized.LSFmod(defaults="slow", strength=strength)  : \
        (exsharp == true && preblow == true && LSF ==false && FS == true) ? upsized.FineSharp()  : \
                           (preblow == true) ? upsized.Sharpen(sstr) : upsized.Sharpen(0.75 * sstr) 
 
# doing the temporal averaging
# ----------------------------
src_super   = upsized.MSuper(pel=2)
sharp_super = sharp.MSuper(pel=2, levels=1)
 
bv2 = (avg == 2) ? src_super.MAnalyse(isb=true, delta=2, blksize=16, overlap=4, truemotion=false, search=5, sadx264=3) : blk
bv1 =  src_super.MAnalyse(isb=true, delta=1, blksize=16, overlap=4, truemotion=false, search=5, sadx264=3)
fv1 =  src_super.MAnalyse(isb=false,delta=1, blksize=16, overlap=4, truemotion=false, search=5, sadx264=3)
fv2 = (avg == 2) ? src_super.MAnalyse(isb=false,delta=2, blksize=16, overlap=4, truemotion=false, search=5, sadx264=3) : blk

# Use the vectors to create motion and static masks, we use these for prefilter and sharpening masks
maskstar = upsized.mt_binarize(upper=false)
denoiced = (avg == 1) ? upsized.MDegrain1(sharp_super, bv1, fv1, avgstr) : \
           (avg == 2) ? upsized.MDegrain2(sharp_super, bv1, fv1, bv2, fv2, avgstr) : blk
denoiced.VagueDenoiser(method=4, nsteps=8, wavelet=2, Wiener=true, percent=95, chromaT=0.8, wratio=0.75, threshold=0.4)			 
smooth_clp = mt_merge(last, upsized, maskstar)
 
# upsize the clip if it has not been done before
# ----------------------------------------------
blow_clp = (preblow == false) ? smooth_clp.Spline36resize(ox * 2, oy * 2).Repair(clp.Gaussresize(ox * 2, oy * 2, p=100), 1) : \
                                smooth_clp
 
# adding grain to create the illusion of detail
# ---------------------------------------------
grain_clp = (ag == true) ? blow_clp.GradFun2DB(1.4).GrainFactory3(g1str,g2str,g3str,60,66,80,1.2,0.9,0.6,0,0,0,0,0,25,56,128,160) : blow_clp
 
return (grain_clp) 
}