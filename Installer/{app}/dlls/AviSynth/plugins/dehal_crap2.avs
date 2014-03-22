function dehal_crap2(clip clp) {    rr = clp.mt_convolution(horizontal=" -4 -8 44 -20 -12 384 -12 -20 44 8 -4  ", vertical=" 1 ", u=2, v=2)
    rr = rr.yahr()
    return mt_merge(rr.mt_convolution(horizontal=" 0 -12 -28 128 -28 -12 0 ", vertical=" 1 ", u=2, v=2).\
    mergechroma(rr, 1), rr.mt_convolution(horizontal=" 0 0 4 40 -2 -8 128 -8 -2 40 8 -4 2 ", vertical=" 1 ", u=2, v=2).\
    yahr().mergechroma(rr, 1), rr.mt_convolution(horizontal=" -4 -8 44 -20 -12 128 -12 -20 44 8 -4  ", vertical=" 1 ", u=2, v=2).\
    halomask1(ss=1.5, rad=7).frfun7(1.49, 256, 0))
}


function halomask1(clip c, int "rad", float "ss"){


  ss = default(ss, 1.5)
  rad = default(rad, 7)
  owidth = c.width
  oheight = c.height


  ssample = spline36resize(c, round((c.width*SS)/4)*4, round((c.height*SS)/4)*4)
  mask1 = mt_lutxy(ssample, Xsharpen(ssample, 127, 255), "x y - abs 1 - 63 *", u=1, v=1)
  mask2 = (rad >= 1) ? mask1.mt_expand(u=1, v=1) : mask1
  mask2 = (rad >= 2) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 3) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 4) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 5) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 6) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 7) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 8) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 9) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 10) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 11) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 12) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 13) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 14) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 15) ? mask2.mt_expand(u=1, v=1) : mask2
  mask2 = (rad >= 16) ? mask2.mt_expand(u=1, v=1) : mask2
  mask3 = mt_lutXY(mask1, mask2, "y x - 63 - 1.5 *", u=1, v=1).spline36resize(owidth, oheight)


  return(mask3)
}


function halomaskM(clip c, int "hthr", int "hbias", int "agmrad"){

hthr = default(hthr, 256)
hbias = default(hbias, -128)
agmrad = default(agmrad, 1)

s = c
Mblur = (agmrad==1) ? s.removegrain(4,-1) : s.Quantile(radius_y=agmrad,radius_u=-1,radius_v=-1)
gblur = (agmrad<=5) ? s.binomialblur(vary=agmrad, varc=0) : s.gaussianblur(vary=agmrad, varc=0)
maskM = mt_lutxy(Mblur, Gblur, "y x - abs "+string(hthr)+" * "+string(hbias)+" +", U=1, V=1)

return(maskM)}



function halomaskMR(clip c, int "hthr", int "hbias"){

hthr = default(hthr, 256)
hbias = default(hbias, -128)

s = c
Ablur = s.removegrain(4)
gblur = s.gaussianblur(vary=1, varc=0)
mask3 = mt_lutxy(Ablur, Gblur, "y x - abs "+string(hthr)+" * "+string(hbias)+" +", U=1, V=1)

return(mask3)}