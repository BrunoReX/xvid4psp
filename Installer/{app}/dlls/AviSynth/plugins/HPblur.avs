function HPblur(clip o) {
rg11=o.removegrain(11)
rg11D=mt_makediff(o,rg11)
xD=mt_lutxy(rg11D,rg11D.removegrain(11,-1),"x 128 - y 128 - * 0 < x y + 128 - x 128 - abs y 128 - abs < x y ? ?")
o.mt_makediff(xD,U=2,V=2) }