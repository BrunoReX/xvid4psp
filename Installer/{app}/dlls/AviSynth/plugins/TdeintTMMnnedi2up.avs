function TdeintTMMnnedi2up(clip c, int "qual")
{
qual = default( qual, 1)
GetParity(c) ? AssumeTFF(c) : AssumeBFF(c)
edeint=nnedi2(c,field=-2,qual=qual).degrainx(X = 3)
Tdeint(c,mode=1,emask=TMM(mode=1),edeint=edeint)
}

function DegrainX (clip o, int "calm", int "rep0", int "X", int "SAD1", int "bs", int "limit", bool "external_denoiser")
{
# makes MDegrain1-3 for deinterlace
# Calm function is needed

X = default( X, 3 ) # MVDegrain 1, 2 or 3
calm = default( calm, 1) # use calm() for predenoising as default
bs = default( bs, 16 ) # blocksize
SAD1 = default( SAD1, 400 ) # Threshold for degraining. Decrease if you see ghosting
limit = default( limit, 255 ) # Limits maximum change of a pixel. Default means no limit
ov = bs/2 #overlap
rep0 = default (rep0, 4)


calm=(calm==1) ? o.Calm(rep0): o

o_super = o.MSuper(pel=2, hpad=16, vpad=16, levels=1) # create the source superclip
srch_super = calm.MSuper(pel=2, hpad=16, vpad=16) # create the calm superclip

bv3 = (X==3) ? srch_super.MAnalyse(isb=true , delta=3, blksize=bs, overlap=ov) : BlankClip
bv2 = (X>=2) ? srch_super.MAnalyse(isb=true , delta=2, blksize=bs, overlap=ov) : BlankClip
bv1 = srch_super.MAnalyse(isb=true , delta=1, blksize=bs, overlap=ov)

fv1 = srch_super.MAnalyse(isb=false, delta=1, blksize=bs, overlap=ov)
fv2 = (X>=2) ? srch_super.MAnalyse(isb=false, delta=2, blksize=bs, overlap=ov) : BlankClip
fv3 = (X==3) ? srch_super.MAnalyse(isb=false, delta=3, blksize=bs, overlap=ov) : BlankClip


NR = (X==3) ? o.MDegrain3(o_super, bv1, fv1, bv2, fv2, bv3, fv3, thSAD=SAD1, limit=limit) :
\ (X==2) ? o.MDegrain2(o_super, bv1, fv1, bv2, fv2, thSAD=SAD1, limit=limit) :
\ o.MDegrain1(o_super, bv1, fv1, thSAD=SAD1, limit=limit)



NR.mt_lutxy(NR.removegrain(11),"x x y - "+string(0.45)+" * +",U=3,V=3)
#NR.sharpen(0,0.4)
return (last)
#return (NR)
}



function Calm (clip clp, int "rep0")
{
##################################
# PREPARES CLIP FOR MOTION SEARCH
#################################
#needs VCRep

rep0 = default (rep0, 4) # repair temporalsoften-defects for searchclip
ed0 = rep0<10 ? rep0 : rep0/10
od0 = rep0<10 ? 0 : rep0-ed0*10
ox = clp.width()
oy = clp.height()

# create linearily weighted temporal averaging
ts1 = clp.temporalsoften(1,255,255,28,2)
ts2 = clp.temporalsoften(2,255,255,28,2)

# construct temporal gaussian average from linear averages
t = ts1.merge(ts2,0.357).merge(clp,0.125)

# IF rep0=true: Allow only bob-typical vertical differences
t2 = (rep0!=0) ? t.VCRep(clp,ed=ed0,od=od0) : t

# Create clip for motion search.
t3=mt_lutxy(t2,clp,"x 3 + y < x 3 + x 3 - y > x 3 - y ? ?",U=3,V=3) # small cheat for better motion search
searchclip = t2.removegrain(11).gaussresize(ox,oy,0,0,ox+.0001,oy+.0001,p=2)
\ .merge(t2,0.1).mt_lutxy(t3,"x 7 + y < x 2 + x 7 - y > x 2 - x 51 * y 49 * + 100 / ? ?",U=3,V=3)
return (searchclip)
}



