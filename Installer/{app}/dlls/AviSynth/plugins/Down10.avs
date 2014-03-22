Function Down10( clip clp, int "depth", int "dither", int "ditherm", int "smooth", bool "tvRange", bool "stack" ){

  tvRange = Default( tvRange, true )
  depth   = Default( depth,     10 ) # bit-depth of output clip
  smooth  = Default( smooth,     0 ) # use smooth or not
  dither  = tvRange ? Default(dither, -3) : Default(dither, 50) # use dither or not, -4 use Dither_quantize instead of f3kdb
  ditherm = Default( ditherm,    6 ) # dither mode for DitherPost/Dither_quantize
  stack   = Default( stack,   true ) # output stacked msb/lsb or interleaved msb/lsb
  
  Assert( dither>=-4 && dither<=100 , """Down10: "dither" ranges from -4 to 100!""" )
  Assert( ditherm>=-1 && ditherm<=8 , """Down10: "ditherm" ranges from -1 to 8!"""  )
  Assert( depth>=8   && depth<=16   , """Down10: "depth" ranges from 8 to 16!"""    )
  Assert( !(dither==-4 && depth==15), """Down10: "depth" can't be 15 when "dither" is -4""" )
  
  shift   = int( Pow( 2, depth - 8 ) )
  ycFloor = int( 16  * shift )
  neutral = int( 128 * shift )
  yCeil   = int( 235 * shift )
  cCeil   = int( 240 * shift )
  ycRge   = int( Pow( 2, depth ) - 1 )
  
  yExpr   = tvRange ? ( "0-0;4096-"+String(ycFloor)+";32768-"+String(neutral)+";60160-"+String(yCeil)+";65535-"+String(ycRge) )
  \                 : ( "0-0;65535-"+String(ycRge) )
  cExpr   = tvRange ? ( "0-0;4096-"+String(ycFloor)+";32768-"+String(neutral)+";61440-"+String(cCeil)+";65535-"+String(ycRge) )
  \                 : ( "0-0;65535-"+String(ycRge) )
  
  smoothDown = clp.SmoothCurve16( Ycurve=yExpr, Ucurve=cExpr, Vcurve=cExpr, interp=0, smooth=smooth,
  \                               dither=( (dither>-1) ? dither : -1 ), limiter=false, TVrange=0 )
  
  ditherDown = dither==-4 ? stack ? clp.Dither_quantize( depth, reducerange=true, mode=ditherm )
  \                               : clp.Dither_quantize( depth, reducerange=true, mode=ditherm ).C16
  \          : dither>=-1 ? stack ? clp.Round10( depth=depth ) : clp.Round10( depth=depth ).C16
  \                       :         clp.f3kdb( Y=0, Cb=0, Cr=0, grainY=0, grainC=0, dither_algo=(-dither), input_mode=1,
  \                                            output_depth=depth, output_mode=( (depth>8) ? stack ? 1 : 2 : 0 ) )
  
  down    = ( dither<-1 || ( dither==-1 && smooth==0 && tvRange ) ) ? ( depth==8 ) ? clp.DitherPost( mode=ditherm )
  \                                                                                : ditherDown
  \                                                                 : ( depth==8 ) ? smoothDown.Get_lsb()
  \                                                                                : stack ? smoothDown
  \                                                                                        : smoothDown.C16

  return ( depth==16 ) ? stack ? clp : clp.C16 : down
}

Function Round10( clip c, int "depth" ){

  depth   = Default( depth,     10 )
  
  Assert( depth>=8   && depth<=16   , """Round10: "depth" ranges from 8 to 16!"""    )
  
  divisor = int( Pow( 2, 16-depth ) )
  
  return depth==16 ? c : depth==8 ? c.DitherPost(mode=-1) : c.Dither_lut16("x " +String(divisor)+ " /", U=3, V=3)
}

Function C16( clip c ){
  return c.Dither_out()
 }