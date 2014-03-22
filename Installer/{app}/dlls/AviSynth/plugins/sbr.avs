function sbr(clip o) {
rg11=o.removegrain(11)
rg11D=mt_makediff(o,rg11)
rg11DD=mt_makediff(rg11D,rg11D.removegrain(11)).mt_lutxy(rg11D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?")
o.mt_makediff(rg11DD,U=2,V=2)
}

function sbrV(clip o) {
rg11=o.mt_convolution("1","1 2 1")
rg11D=mt_makediff(o,rg11)
rg11DD=mt_makediff(rg11D,rg11D.mt_convolution("1","1 2 1")).mt_lutxy(rg11D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?")
o.mt_makediff(rg11DD,U=2,V=2)
}