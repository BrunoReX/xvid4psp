function MCDegrain(clip c, int "frames", clip "srch", bool "soft", int "thSAD")
{
frames = default(frames, 2)
srch   = default(srch,c)
soft   = default(soft,false)
thSAD  = default(thSAD,400)
bs = (c.width>960) ? 16 : 8
rg = (c.width<640) ? 11 : (c.width<1200) ? 11 : 20
rg = soft ? rg : 0
super = srch.MSuper(pel=2, sharp=1)
super2 = soft ? c.mt_adddiff(mt_makediff(c,c.removegrain(rg)),U=2,V=2).MSuper(pel=2,sharp=1,levels=1)
 \            : c.MSuper(pel=2,sharp=1,levels=1)
bvec3 = MAnalyse(super, isb = true, delta = 3, blksize=bs, overlap=bs/2)
bvec2 = MAnalyse(super, isb = true, delta = 2, blksize=bs, overlap=bs/2)
bvec1 = MAnalyse(super, isb = true, delta = 1, blksize=bs, overlap=bs/2)
fvec1 = MAnalyse(super, isb = false, delta = 1, blksize=bs, overlap=bs/2)
fvec2 = MAnalyse(super, isb = false, delta = 2, blksize=bs, overlap=bs/2)
fvec3 = MAnalyse(super, isb = false, delta = 3, blksize=bs, overlap=bs/2)
(frames<=0) ? c :\
(frames==1) ? c.removegrain(rg).MDegrain1(super2, bvec1,fvec1,thSAD=thSAD) :\
(frames==2) ? c.removegrain(rg).MDegrain2(super2, bvec1,fvec1,bvec2,fvec2,thSAD=thSAD) :\
              c.removegrain(rg).MDegrain3(super2, bvec1,fvec1,bvec2,fvec2,bvec3,fvec3,thSAD=thSAD)
return(last) }