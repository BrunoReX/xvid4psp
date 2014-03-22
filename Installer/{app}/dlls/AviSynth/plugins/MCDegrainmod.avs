# this function constantly changes. Not to be taken as a reference out in the wild.

function MCDegrain(clip c, int "frames", clip "srch", int "RG1", int "RG2", int "thSAD", int "pel", int "bs")
{
frames = default(frames, 2)
srch   = default(srch,c)
RG1    = default(RG1, 0)
RG2    = default(RG2, 0)
thSAD  = default(thSAD,400)
_pel   = default(pel, 2)
_bs = (c.width>960) ? 16 : 8
bs = default(_bs,bs)
super = srch.MSuper(pel=_pel, sharp=1)
super2 = (RG2==0) ? c.MSuper(pel=_pel,sharp=1,levels=1)
 \                : c.mt_adddiff(mt_makediff(c,c.removegrain(rg2)),U=2,V=2).MSuper(pel=_pel,sharp=1,levels=1)
bvec3 = MAnalyse(super, isb = true, delta = 3, blksize=bs, overlap=bs/2, truemotion=false,search=5,searchparam=8,pelsearch=2,DCT=5)
bvec2 = MAnalyse(super, isb = true, delta = 2, blksize=bs, overlap=bs/2, truemotion=false,search=5,searchparam=8,pelsearch=2,DCT=5)
bvec1 = MAnalyse(super, isb = true, delta = 1, blksize=bs, overlap=bs/2, truemotion=false,search=5,searchparam=8,pelsearch=2,DCT=5)
fvec1 = MAnalyse(super, isb = false, delta = 1, blksize=bs, overlap=bs/2, truemotion=false,search=5,searchparam=8,pelsearch=2,DCT=5)
fvec2 = MAnalyse(super, isb = false, delta = 2, blksize=bs, overlap=bs/2, truemotion=false,search=5,searchparam=8,pelsearch=2,DCT=5)
fvec3 = MAnalyse(super, isb = false, delta = 3, blksize=bs, overlap=bs/2, truemotion=false,search=5,searchparam=8,pelsearch=2,DCT=5)
(frames<=0) ? c :\
(frames==1) ? c.removegrain(rg1).MDegrain1(super2, bvec1,fvec1,thSAD=thsad) :\
(frames==2) ? c.removegrain(rg1).MDegrain2(super2, bvec1,fvec1,bvec2,fvec2,thSAD=thsad) :\
              c.removegrain(rg1).MDegrain3(super2, bvec1,fvec1,bvec2,fvec2,bvec3,fvec3,thSAD=thsad)
return(last) }