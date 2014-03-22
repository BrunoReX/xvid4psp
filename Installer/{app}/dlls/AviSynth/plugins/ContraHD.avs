Function ContraHD(clip denoised, clip orig, clip cb1, clip cf1, int "overshoot")
{
overshoot = default(overshoot,0)
pmax = orig.mt_logic(cb1, "max").mt_logic(cf1, "max")
pmin = orig.mt_logic(cb1, "min").mt_logic(cf1, "min")

s = denoised.minblur(2,1)                   
allD = mt_makediff(orig,denoised)                 
ssD = mt_makediff(s,s.removegrain(20,-1).removegrain(20,-1))
ssDD = ssD.repair(ssD.repair(allD,1),12)
ssDD = ssDD.mt_lutxy(ssD,"x 128 - abs y 128 - abs < x y ?")
mt_adddiff(denoised,ssDD,U=2,V=2)
mt_clamp(last,pmax,pmin,overshoot,overshoot,chroma="copy first")

Return(last)
}
