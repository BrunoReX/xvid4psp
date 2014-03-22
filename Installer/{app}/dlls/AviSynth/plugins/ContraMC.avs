Function ContraMC(clip denoised, clip orig, clip cb1, clip cf1, int "overshoot")
{
overshoot = default(overshoot,0)

pmax = orig.MT_Logic(cb1,"max").MT_Logic(cf1,"max")
pmin = orig.MT_Logic(cb1,"min").MT_Logic(cf1,"min")

Interleave(denoised,denoised.RemoveGrain(12,-1),denoised.RemoveGrain(4,-1))
Clense(reduceflicker=false,grey=true)
SelectEvery(3,1)

MT_MakeDiff(last,last.RemoveGrain(12,-1))
MT_LUTxy(denoised,last,"y 128 - 1.5 * x +",chroma="copy first")
MT_Clamp(last,pmax,pmin,overshoot,overshoot,chroma="copy first")

Return(last)
}
