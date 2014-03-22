#############################################################################
# Temporal Degrain V1.18b (April 5th, 2008)                                 #
# Function by Sagekilla, original script created by Didee, mod by thetoof   #
#                                                                           #
# Works as a simple temporal degraining function that'll remove MOST grain  #
# from video sources, including dancing grain, like the grain found on 300. #
# Is currently capable of utilizing MVDegrain 1, 2, or 3 for degraining     #
# Also note, the parameters don't need to be tweaked much.                  #
#                                                                           #
# Required plugins: FFT3DFilter.dll / mt_masktools / MVtools.dll            #
#                   HQdn3D.dll / RemoveGrain.dll / Repair.dll               #
#                                                                           #
# FFT3DFilter: http://bag.hotmail.ru/fft3dfilter/fft3dfilter.dhtml          #
# mt_masktools: http://manao4.free.fr/mt_masktools.html                     #
# MVtools: http://avisynth.org.ru/mvtools/mvtools.html                      #
# RemoveGrain: http://www.removegrain.de.tf/                                #
# Repair: See above                                                         #
# HQdn3D: http://akuvian.org/src/avisynth/hqdn3d/                           #
#############################################################################

########################################################
# Description of functions                             #
# denoise = Denoised clip for detecting motion vectors #
# pel = MVAnalyse Subpixel accuracy                    #
# blksize = MVAnalyse block size                       #
# ov = MVAnalyse block overlap                         #
# search = MVAnalyse search effort                     #
# dct = use of DCT for motion vector calculation       #
# SAD1 = MVDegrain thSAD                               #
# SAD2 = MVDegrain thSAD                               #
# degrain = MVDegrain with 1, 2, or 3 vectors          #
# HQ = Additional filtering after MVDegrain            #
########################################################

function TemporalDegrainmt ( clip input, clip "denoise", int "pel", int "blksize", int "ov", int "degrain", int "limit", int "SAD1", int "SAD2", int "HQ", int "search", int "dct", bool "truemotion", int "tr")
                       
{
o       = input
pel     = default( pel,       4) # Higher values increase motion vector quality at the cost of speed
blksize = default( blksize,   8 ) # Higher values are faster, less accurate, and degrain less
ov      = default( ov,        4 ) # Increase for better motion vectors but slower speed
degrain = default( degrain,   3 ) # MVDegrain 1, 2 or 3
limit   = default( limit,   255 ) # Limits maximum change of a pixel. Default means no limit
SAD1    = default( SAD1,    400 ) # Threshold for degraining. Decrease if you suffer from ghosting
SAD2    = default( SAD2,    300 ) # See above
HQ      = default( HQ,        0 ) # Additional filtering after MVDegrain 
search  = default( search,    2 ) # MVAnalyse search effort
dct     = default( dct,       0 ) # Use of DCT for motion vector calculation
truemotion=default(truemotion,true)
tr=default(tr,15)

# "srch" is a prefiltered clip on which the motion search is done.
srch   = denoise


# "spat" is a prefiltered clip which is used to limit the effect of the 1st MV-denoise stage.
spat   = denoise
spatD  = mt_makediff(o,spat)


# Motion vector search (With very basic parameters. Add your own parameters as needed.)
mvectors = srch.MVAnalyseMulti(refframes=tr, pel=pel, overlap=ov, idx=1, blksize=blksize, dct=dct, search=search,truemotion=truemotion)
 
# First MV-denoising stage. Usually here's some temporal-medianfiltering going on.
# For simplicity, we just use MVDegrain.
NR1    = o.MVDegrainMulti(mVectors,thSAD=SAD1,idx=2,limit=limit)

NR1D   = mt_makediff(o,NR1)


# Limit NR1 to not do more than what "spat" would do.
DD     = mt_lutxy(spatD,NR1D,"x 128 - abs y 128 - abs < x y ?")
NR1x   = o.mt_makediff(DD,U=2,V=2)


# Second MV-denoising stage. We use MVDegrain2.
NR2    = NR1x.MVDegrainMulti(mVectors,thSAD=SAD2,idx=3,limit=limit) 

NR2 = (HQ==1) ? NR2.HQDn3D(1,1,4,1) : NR2 # Temporal filter to remove last bits of dancing pixels
NR2 = (HQ>=1) ? NR2.HQDn3D(2,1,6,1) : NR2 # A stronger version if the default isn't strong enough.

# Contra-sharpening: sharpen the denoised clip, but don't add more than what was removed previously.
# Here: A simple area-based version with relaxed restriction. The full version is more complicated.
s      = NR2.minblur(1,1)                    # Damp down remaining spots of the denoised clip.
allD   = mt_makediff(o,NR2)                  # The difference achieved by the denoising.
ssD   = mt_makediff(s,s.removegrain(11,-1)) # The difference of a simple kernel blur.
ssDD   = ssD.repair(allD,1)                  # Limit the difference to the max of what the denoising removed locally.
ssDD   = SSDD.mt_lutxy(ssD,"x 128 - abs y 128 - abs < x y ?") # abs(diff) after limiting may not be bigger than before.

#s      = NR2.minblur(1,1)                    
#allD   = mt_makediff(o,NR2)                  
#SsD    = mt_makediff(s,s.removegrain(11,-1)).removegrain(20,-1)  # Larger radius for VHS
#ssDD   = ssD.repair(ssD.repair(allD,1),1)                        # Larger radius for VHS
#ssDD   = ssDD.mt_lutxy(ssD,"x 128 - abs y 128 - abs < x y ?")  

NR2.mt_adddiff(ssDD,U=2,V=2) # Apply the limited difference. (Sharpening is just inverse blurring.)

output = last
return(output)
}