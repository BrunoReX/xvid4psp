#Anti-aliasing with contra-sharpening by Didée, modded by Terranigma for nnedi and by thetoof for merge
function daa3(clip c) {
dbl   = merge(c.nnedi3(field = 1, nns = 1),c.nnedi3(field = 0, nns = 1))
dblD = mt_makediff(c,dbl,U=3,V=3)
shrpD = mt_makediff(dbl,dbl.removegrain(11),U=3,V=3)
DD = shrpD.repair(dblD,13)
return dbl.mt_adddiff(DD,U=3,V=3) }