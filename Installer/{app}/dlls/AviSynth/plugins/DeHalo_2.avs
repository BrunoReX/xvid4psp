Function DeHalo_2(clip i)
{
e1 = i.mt_edge("min/max",0,255,0,255).mt_lut("x 4 - 4 *")#.greyscale
e2 = e1.mt_expand().mt_expand()
e2 = e2.mergeluma(e2.mt_expand(),0.5).mt_inflate()
e3 = e2.mergeluma(e2.mt_expand(),0.5).mt_lutxy(e1.mt_deflate(),"x y 1.2 * -").mt_inflate()#.greyscale
# e3 = e2.mergeluma(e2.mt_expand(),0.5).mt_lutxy(e1.mt_deflate().mt_deflate(),"x y 1.2 * -").mt_inflate().mt_inflate().greyscale
# e3 = e3.nnedi3_rpow2(2,cshift="bicubicresize").bicubicresize(presharp.width,presharp.height)

blurr = i.minblur(1).removegrain(11,-1).removegrain(11,-1)

dh1  = i.repair(i.removegrain(2),1).mt_merge(blurr,e3,U=2,V=2)
dh1D = mt_makediff(i,dh1)
tmp  = dh1.sbr()
med2D = mt_makediff(tmp,tmp.medianblur(2,0,0))
DD  = mt_lutxy(dh1D,med2D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs 2 * < x y 128 - 2 * 128 + ? ?")
dh2 = dh1.mt_adddiff(DD,U=2,V=2)
#interleave(i,dh2)
dh2
return(last)
}

#======================

function sbr(clip o) {
rg11 = o.removegrain(11)
rg11D = mt_makediff(o,rg11)
rg11DD= mt_makediff(rg11D,rg11D.removegrain(11)).mt_lutxy(rg11D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?")
o.mt_makediff(rg11DD,U=2,V=2)
}

#======================

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

# "rg114" -- use removegrain(11), but maximally as much as removegrain(4) did in the 3x3 neighborhood

function rg114(clip c) {
d=mt_makediff(c,c.removegrain(11)).repair(mt_makediff(c,c.removegrain(4)),1)
c.mt_makediff(d,U=2,V=2) }

function m4(float x) {return(x<16?16:int(round(x/4.0)*4))}
