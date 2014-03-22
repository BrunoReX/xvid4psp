function ContraSharpening (clip denoised, clip original)
{
s = denoised.minblur(1,1) # Damp down remaining spots of the denoised clip.
allD = mt_makediff(original,denoised) # The difference achieved by the denoising.
ssD = mt_makediff(s,s.removegrain(11,-1)) # The difference of a simple kernel blur.
ssDD = ssD.repair(allD,1) # Limit the difference to the max of what the denoising removed locally.
ssDD = SSDD.mt_lutxy(ssD,"x 128 - abs y 128 - abs < x y ?") # abs(diff) after limiting may not be bigger than before.

denoised.mt_adddiff(ssDD,U=2,V=2) # Apply the limited difference. (Sharpening is just inverse blurring.)

return( last )
}
