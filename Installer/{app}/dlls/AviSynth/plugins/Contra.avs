Function Contra(clip denoised, clip orig) {
# re-write of Didee's contra sharpening routine from TemporalDegrain.avs
Interleave(denoised,denoised.RemoveGrain(12,-1),denoised.RemoveGrain(4,-1))
Clense(reduceflicker=false,grey=true)
SelectEvery(3,1)
MT_MakeDiff(last,last.RemoveGrain(12,-1).RemoveGrain(12,-1))
last.Repair(MT_MakeDiff(orig,denoised),1,-1).MT_LUTxy(last,"x 128 - abs y 128 - abs < x y ?")
denoised.MT_AddDiff(last,chroma="copy first")
Return(last)
}
