# Y'et A'nother H'alo R'educing script
function yahr( clip clp, int "warpdepth" ) {
        warpdepth=default(warpdepth,32)
        b1    = clp.minblur(2).removegrain(12,-1)
        b1D   = mt_makediff(clp,b1)
        w1    = clp.aWarpSharp2(depth=warpdepth,blur=2)
        w1b1  = w1.minblur(2,1).removegrain(11,-1)
        w1b1D = mt_makediff(w1,w1b1)
        DD    = b1D.repair(w1b1D,13)
        DD2   = mt_makediff(b1D,DD)
        clp.mt_makediff(DD2,U=2,V=2)
}

function yahrmask(clip c, int "expand", int "warpdepth") {
        c
        expand=default(expand,5)
        warpdepth=default(warpdepth,32)
        vEdge=mt_lutxy(last,mt_expand().mt_expand(),"x y - abs 8 - 7 <<")
        mt_merge(yahr(warpdepth),vEdge.binomialblur(expand*2,u=1,v=1).mt_lut("x 4 <<").mt_logic(vEdge.removegrain(12).mt_invert(),"min"),true)
}

# Nifty Gauss/Median combination
function MinBlur(clip clp, int r, int "uv")
{
uv = default(uv,3)
uv2 = (uv==2) ? 1 : uv
rg4 = (uv==3) ? 4 : -1
rg11 = (uv==3) ? 11 : -1
rg20 = (uv==3) ? 20 : -1
medf = (uv==3) ? 1 : -200


RG11D = (r==1) ? mt_makediff(clp,clp.removegrain(11,rg11),U=uv2,V=uv2)
\ : (r==2) ? mt_makediff(clp,clp.removegrain(11,rg11).removegrain(20,rg20),U=uv2,V=uv2)
\ : mt_makediff(clp,clp.removegrain(11,rg11).removegrain(20,rg20).removegrain(20,rg20),U=uv2,V=uv2)
RG4D = (r==1) ? mt_makediff(clp,clp.removegrain(4,rg4),U=uv2,V=uv2)
\ : (r==2) ? mt_makediff(clp,clp.medianblur(2,2*medf,2*medf),U=uv2,V=uv2)
\ : mt_makediff(clp,clp.medianblur(3,3*medf,3*medf),U=uv2,V=uv2)
DD = mt_lutxy(RG11D,RG4D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",U=uv2,V=uv2)
clp.mt_makediff(DD,U=uv,V=uv)
return(last)
}

function rg114(clip c) {
d=mt_makediff(c,c.removegrain(11)).repair(mt_makediff(c,c.removegrain(4)),1)
c.mt_makediff(d,U=2,V=2) }

# "use highpass of a blur's difference" - function
function sbr(clip c) {
rg11D=mt_makediff(c,c.removegrain(11,-1))
rg11DD=mt_makediff(rg11D,rg11D.removegrain(11,-1)).mt_lutxy(rg11D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?")
c.mt_makediff(rg11DD,U=2,V=2) }

function m4(float x) {return(x<16?16:int(round(x/4.0)*4))}