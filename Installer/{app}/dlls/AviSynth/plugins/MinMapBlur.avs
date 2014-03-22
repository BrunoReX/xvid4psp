function MinMapBlur(clip c) {
map=mt_lutxy(c.mt_expand(),c.mt_inpand(),"x y - 1 3 / * 3 +")
a = c.removegrain(4,-1)
b = c.mt_mappedblur(map,"1 2 1 2 8 2 1 2 1","dump")
aD=mt_makediff(c,a)
bD=mt_makediff(c,b)
return(c.mt_makediff(mt_lutxy(aD,bD,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?"),U=2,V=2))
}
