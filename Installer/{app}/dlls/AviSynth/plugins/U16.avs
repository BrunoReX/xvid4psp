Function U16( clip c, bool "tvRange", bool "stack" ){ 

  tvRange = Default( tvRange, true )
  stack   = Default( stack,   true )
  
  Expr    = "0-0;128-32768;255-65535;65535-65535"
  
  up      =  tvRange ? c.Dither_convert_8_to_16()
  \                  : StackVertical(c.Gen_null_lsb(), c).SmoothCurve16(Ycurve=Expr, Ucurve=Expr, Vcurve=Expr, interp=0,
  \                                                                     limiter=false, TVrange=0, smooth=0, dither=-1)
  
  return stack ? up : up.Dither_out()
}