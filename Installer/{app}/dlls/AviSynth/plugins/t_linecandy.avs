function t_linecandy(clip c)
 {
 c
 vLines=mt_lutxy(binomialblur(5,u=1,v=1),"x 8 + y < y x - 16 * 0 ?").mt_expand.removegrain(4,-1)
 vSkip=awarpsharp2(depth=127).mt_expand.mt_lut("100 x - 255 *").mt_inpand.mt_inpand.mt_inpand.mt_inpand.removegrain(4,-1).mt_hysteresis(c.mt_lut("128 x - 2 *").removegrain(4,-1)).mt_expand.mt_expand.mt_expand.mt_expand
 mt_clamp(FastLineDarkenMOD(0,thinning=40).asharp(8,8).maa,last,mt_inpand.binomialblur(3,u=1,v=1).mt_lut("x 16 - 0.8 * 16 +"),u=2,v=2)
 mt_merge(FastLineDarkenMOD(0,thinning=24),mt_lutxy(vLines.binomialblur(25,u=1,v=1),"x 128 > 0 x 96 < 1 128 x - 32 / ? ? y *",u=-128,v=-128).mt_expand,true,u=2,v=2)
 spline144resize(width*2,height*2)
 Xsharpen(200, 155)
 spline64resize(width/2,height/2)
 awarpsharp2(100,32,1,16,2)
 dehalo_alpha(2,2,0,1)
 c.mt_merge(last,vLines.mt_lutxy(vSkip,"x y 1.5 / -").binomialblur(10,u=1,v=1),true)
 aaSW()
 mergechroma(awarpsharp2(depth=16))
 yahrmask(5,64)
 }
