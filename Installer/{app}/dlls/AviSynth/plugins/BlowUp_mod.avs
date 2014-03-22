##########################################################
## A simple upsizing function                           ## 
## version 0.3 alpha 16 november 2012                   ##
##########################################################
## MVTools2m.dll v.6.0.5
## NNEDI3.dll 
## mt_masktools-25.dll or mt_masktools-26.dll
## RemovegrainSSE2.dll
## RepairSSE2.dll 
## dfttest.dll v.1.3.2
## awarpsharp2.dll
## AddGrainC.dll
## dither.dll
## GradFun2DB.dll
## GrainFactory3.avs
## Dither.avsi
## DeHalo_alpha.avs
## mt_xxpand_multi.avsi
## LSFmod.avsi
## HighPassSharp.avs
##########################################################

# function BlowUpmod()
# Resize function with noise reduction and sharpening
# Limitedsharpenfaster for 1280x720, HighPassSharp for 1920x1080

function BlowUp_mod(clip clp, float "sstr", int "thSAD", int "thSAD2", float "var", float "uvar", int "tr", int "strength", \
                int "W", int "H", bool "nnu", bool "edu", bool "exsharp", bool "LSF", int "smode", int "radius")
{
sstr    = default(sstr, 1.0)       # sharpening strength
strength = default(strength, 300)  # LSF strength 
thSAD    = default(thSAD, 256)     # averaging strength 1
thSAD2   = default(thSAD,  96)     # averaging strength 2

var   = Default( var,   3.0 )      # strength of luma grain Dither_add_grain16
uvar  = Default( uvar,  0.0 )      # strength of chroma grain Dither_add_grain16
  
tr      = default(tr, 2)           # how many frames are averaged 
nnu     = default(nnu, true)       # false = use Lanczos/Repair or true = NNEDI3 to upsize
edu     = default(edu, true)       # false = use Lanczos/Repair or true = EEDI3 to upsize
exsharp = default(exsharp, true)   # use higher quality sharpener
LSF     = default(LSF, false)      # sharpening Limitedsharpenfaster or FineSharp
W       = default(W,  1280)       
H       = default(H,   720)        
smode   = default(smode, 0)        # mode GradFun3
radius  = default(radius, 12)      # radius GradFun3

ox      = clp.width
oy      = clp.height
blk     = blankclip(clp)
 
# setting up the clip for the averageing
# --------------------------------------
brc   = BilinearResize(clp, ox * 2, oy * 2)
super = MSuper(brc, hpad=8, vpad=8, pel=2, sharp=2, rfilter=4)
multi_vec = MAnalyse (super, multi=true, delta=2, truemotion=false, blksize=16, blksizeV=8, overlap=8, overlapV=4, search=5, searchparam=3, pelsearch=2, lambda=1024, dct=5) 

upsized = (nnu == true && LSF == true ) ? clp.nnedi3_rpow2(rfactor=2,cshift="LanczosResize",nsize=0,nns=0,qual=2,threads=1) : \
          (nnu == true && LSF == false) ? clp.nnedi3_rpow2(rfactor=2,cshift="LanczosResize",nsize=0,nns=0,qual=2,threads=1) : \
                                          clp.Spline36resize(ox * 2, oy * 2).Repair(clp.Gaussresize(ox * 2, oy * 2, p=100), 1)

    
# choosing the sharpening method
# -------------------------------
sharp = (exsharp == true && LSF == true ) ? upsized.DeHalo_alpha(rx=1.5,ry=1.5).LSFmod(defaults="slow", strength=strength)  : \
        (exsharp == true && LSF == false) ? upsized.HighPassSharp(r=0.15)  : \
                                            upsized.Sharpen(sstr)
 
# doing the temporal averaging
# ----------------------------
maskstar = sharp.mt_binarize(upper=false)
shsuper = sharp.MSuper(pel=2, levels=1)
sharp.MDegrainN (shsuper, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, lsb=true) 
GradFun3 (thr=1.4*0.3, smode=smode, radius=radius, lsb_in=true, lsb=true)
Dither_add_grain16 (var=var, uvar=uvar, soft=2)

Dither_Resize16(W, H)
Dither_convert_yuv_to_rgb (matrix="601", output="rgb48y", lsb_in=true)
r = SelectEvery (3, 0)
g = SelectEvery (3, 1)
b = SelectEvery (3, 2)
# Dither_convert_rgb_to_yuv (r, g, b, matrix="709", lsb=true, mode=6, output="YV16") # 16 bit output
Dither_convert_rgb_to_yuv (r, g, b, matrix="709", lsb=false, mode=6) # 8 bit output
return (last) 
}