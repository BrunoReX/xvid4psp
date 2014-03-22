function minblur3(clip c) {
rgD = mt_makediff(c,c.removegrain(3))
sbD = mt_makediff(c,c.sbr())
DD  = mt_lutxy(rgD,sbD,"x 128 - y 128 - * 0 < x y + 2 / x 128 - abs y 128 - abs < x y ? ?")
c.mt_makediff(DD,U=2,V=2)   }

