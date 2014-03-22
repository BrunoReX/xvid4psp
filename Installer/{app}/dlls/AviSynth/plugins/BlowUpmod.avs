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

function BlowUpmod(clip clp, float "sstr", int "thSAD", int "thSAD2", int "g1str", int "g2str", int "g3str", int "g1size", int "g2size", int "g3size", \
                int "tr", int "strength",  int "W", int "H", bool "nnu", bool "edu", bool "exsharp", bool "lsb", bool "LSF", int "smode")
{
sstr    = default(sstr, 1.0)       # sharpening strength
strength = default(strength, 300)  # LSF strength 
thSAD    = default(thSAD, 400)     # averaging strength 1
thSAD2   = default(thSAD, 150)     # averaging strength 2

g1str   = Default( g1str,  4.0 )   # [ 0 - ???] strength of luma grain / for dark areas
g2str   = Default( g2str,  3.0 )   # [ 0 - ???] strength of luma grain / for midtone areas
g3str   = Default( g3str,  3.0 )   # [ 0 - ???] strength of luma grain / for bright areas
g1size  = Default( g1size, 1.3 )   # [0.5 - 4.0] size of grain / for dark areas
g2size  = Default( g2size, 1.0 )   # [0.5 - 4.0] size of grain / for mid-tone areas
g3size  = Default( g3size, 0.7 )   # [0.5 - 4.0] size of grain / for bright areas
  
tr      = default(tr, 2)           # how many frames are averaged 
nnu     = default(nnu, true)       # false = use Lanczos/Repair or true = NNEDI3 to upsize
edu     = default(edu, true)       # false = use Lanczos/Repair or true = EEDI3 to upsize
exsharp = default(exsharp, true)   # use higher quality sharpener
LSF     = default(LSF, false)      # sharpening Limitedsharpenfaster or FineSharp
W       = default(W,  1280)       
H       = default(H,   720)        
smode   = default(smode, 0)        # mode GradFun3
lsb     = default(lsb, false) 

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
DB = last.GradFun3(smode=smode, thr=0.5, radius=12, lsb=true, lsb_in=true)
DB.DitherPost(mode=-1)
Temporalsoften(2,2,2,6,2)
mt_merge(last, sharp, maskstar)
mergechroma( awarpsharp2(depth=12,thresh=255,blur=3) )

# ==== AddGrain ====
GrainFactory3(g1str,g2str,g3str,60,66,80,g1size,g2size,g3size,0,0,0,0,0,25,56,128,160)

Dither_convert_8_to_16()                        
DB.Dither_limit_dif16 (last,thr=1.0,elast=2.0)  

Dither_Resize16(W, H)
Dither_convert_yuv_to_rgb (matrix="601", output="rgb48y", lsb_in=true)
r = SelectEvery (3, 0)
g = SelectEvery (3, 1)
b = SelectEvery (3, 2)
output = ( lsb == true ) ? Dither_convert_rgb_to_yuv (r, g, b, matrix="709", lsb=true,  mode=7, ampn=1, ampo=0, output="YV16") : \
                             Dither_convert_rgb_to_yuv (r, g, b, matrix="709", lsb=false, mode=6, ampn=1, ampo=0)
return (output) 
}