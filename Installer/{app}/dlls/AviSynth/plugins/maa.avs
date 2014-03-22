#Anti-aliasing with edge masking by martino, mask using "sobel" taken from Kintaro's useless filterscripts and modded by thetoof for spline64
function maa(clip input, int "mask") {
mask=default(mask,1)
assert(mask==1 || mask== 2, "Please use mask = 1 or 2")
mask= (mask==1) ? input.mt_edge("sobel",7,7,5,5).mt_inflate() : input.mt_edge("roberts",0,4,0,4).mt_inflate()
aa_clip=input.spline36Resize(width(input)*2,height(input)*2).TurnLeft().SangNom(28).TurnRight().SangNom(28).spline36Resize(width(input),height(input)).MergeChroma(input) 
return mt_merge(input,aa_clip,mask) }

