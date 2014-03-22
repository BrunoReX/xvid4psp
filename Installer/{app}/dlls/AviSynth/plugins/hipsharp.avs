function hipsharp(clip c) {
rg11D=mt_makediff(c,c.removegrain(20,-1))
rg11DD=mt_lutxy(rg11D,rg11D.removegrain(20,-1),"x y - x 128 - * 0 < 128 x y - abs x 128 - abs < x y - 128 + x ? ?")
c.mt_adddiff(rg11DD,U=2,V=2) }
