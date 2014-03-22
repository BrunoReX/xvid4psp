FUNCTION makediff16(clip a, clip b, int "Y", int "U", int "V"){
  Y = Default(Y, 3)
  U = Default(U, 3)
  V = Default(V, 3)

  addend = b.Dither_lut16("65536 x -", Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1)
  wrap   = b.Dither_lut16("x 0 == 1 0 ?", Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1)

  diff = Dither_add16(a, addend, Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1, dif=true)
  \     .Dither_add16(wrap, Y=Y==3?3:1, U=U==3?3:1, V=V==3?3:1, dif=false)

  diff = ( Y==2 || U==2 || V==2 ) ? mt_lutxy( diff, a, Y=(Y==2?4:2), U=(U==2?4:2), V=(V==2?4:2) ) : diff
  diff = ( Y==4 || U==4 || V==4 ) ? mt_lutxy( diff, b, Y=(Y==4?4:2), U=(U==4?4:2), V=(V==4?4:2) ) : diff

  return ( Y<=0 || U<=0 || V<=0 ) ? diff.Dither_lut16( Y=(Y<=0?Y:2), U=(U<=0?U:2), V=(V<=0?V:2) )
  \                               : diff
}
