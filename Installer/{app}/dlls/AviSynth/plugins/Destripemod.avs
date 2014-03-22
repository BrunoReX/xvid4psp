Function destripe(clip c){
  c
  w  = width
  h  = height
  de = Destripe(360, 4, 3, 3)
  \    .FastLineDarkenMOD(strength=18, thinning=0).aWarpSharp2(thresh=48, depth=4)
  \    .nnedi3(dh=true, field=1, nsize=0, nns=4, qual=2)
  Repair(de.Spline64Resize(w, h),
  \      de.GaussResize(w, h, p=100), 1)

  # HQDering
  em = mt_edge("prewitt",0,255,0,0).mt_lut("x 24 <= x 1 >> x 1.4 ^ ?").RemoveGrain(4,-1).mt_inflate
  taa(aatype=1, preaa=0, postaa=false, mclip=em, sharp=0)
  taa(aatype=1, preaa=0, postaa=false, mclip=em, sharp=-50)
}