# RemoveColorBleeding (by Didée)
function RemoveColorBleeding(clip input) {
o=input
warp1=o.mergechroma(o .blur(1.0).unsharpmask(255,1,1).aWarpSharp2(depth=30, thresh=192, type=0, blur=3,chroma=4))
warp2=o.mergechroma(warp1.blur(1.0).unsharpmask(255,1,1).aWarpSharp2(thresh=192, type=0, blur=2,depth=18,chroma=4))
# interleave(o,warp1,warp2) # visualization
return warp2
}