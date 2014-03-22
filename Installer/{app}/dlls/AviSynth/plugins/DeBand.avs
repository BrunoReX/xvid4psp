Function DeBand(clip clp, float thr, float thrC)

{ 
     w = clp.width()  + 32
     h = clp.height() + 32
   
   RDY = clp.pointresize(w,h,-16,-16,w,h)

   LUM = RDY.gradfun2db(thr).Crop(16,16,-16,-16)
   CHR = RDY.gradfun2db(thrC).Crop(16,16,-16,-16)

Dither = thr==1.0 && thrC==1.0 ? CLP
   \   : thr==thrC             ? LUM
   \   : thr!=1.0 && thrC==1.0 ? LUM.mergechroma(CLP)
   \   : thr==1.0 && thrC!=1.0 ? CLP.mergechroma(CHR)
   \   :                         LUM.mergechroma(CHR)

  Mask = mt_luts(clp,clp,mode="range",pixels=mt_square(2),expr="y",u=1,v=1).\
	 mt_lut(expr="255 x 1 2 / * 2 ^ /",u=1,v=1).removegrain(19,-1)

Output = mt_merge(clp,Dither,Mask,luma=true,u=3,v=3)

Return (Output) 

}