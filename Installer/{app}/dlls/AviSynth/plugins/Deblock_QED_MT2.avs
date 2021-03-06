# Changes 2008-08-18: (Did�e)
# - Replaced the ugly stackXXX cascade with mt_LutSpa() (requires MaskTools v2.0a35)
# - Changed Quant and Offset defaults to 24,28,2,4,4,8

# Changes 2010-05-25:
# - Explicitly specified parameters of mt_LutSpa()
#   (required due to position of new "biased" parameter, starting from MaskTools 2.0a43)
# - Non-mod 16 input is now padded with borders internally

function Deblock_QED ( clip clp, int "quant1", int "quant2", 
 \                     int "aOff1", int "bOff1", int "aOff2", int "bOff2", int "uv" )
{

quant1 = default( quant1, 24 ) # Strength of block edge deblocking. 
quant2 = default( quant2, 28 ) # Strength of block internal deblocking. 

aOff1 = default( aOff1, 2 ) # halfway "sensitivity" and halfway a strength modifier for borders
bOff1 = default( bOff1, 4 ) # "sensitivity to detect blocking" for borders
aOff2 = default( aOff2, 4 ) # halfway "sensitivity" and halfway a strength modifier for block interiors
bOff2 = default( bOff2, 8 ) # "sensitivity to detect blocking" for block interiors

uv    = default( uv, 3 )    # u=3 -> use proposed method for chroma deblocking
                            # u=2 -> no chroma deblocking at all (fastest method)
                            # u=1|-1 -> directly use chroma debl. from the normal|strong deblock()

# add borders if clp is not mod 8
padX = clp.width%8 == 0 ? 0 : (8 - clp.width%8)
padY = clp.height%8 == 0 ? 0 : (8 - clp.height%8)
clp=clp.addborders(0, 0, padX, padY)

# block
block = clp.mt_LutSpa(relative=false, expr="x 1 + 8 % 1 < x 8 % 1 < y 1 + 8 % 1 < y 8 % 1 < | | | 255 0 ?", U=3, V=3)

# create normal deblocking (for block borders) and strong deblocking (for block interiour)
normal = clp.deblock(quant=quant1,aOffset=aOff1,bOffset=bOff1)
strong = clp.deblock(quant=quant2,aOffset=aOff2,bOffset=bOff2)

# build difference maps of both
normalD = mt_makediff(clp,normal,chroma=uv>2?"process":"ignore") 
strongD = mt_makediff(clp,strong,chroma=uv>2?"process":"ignore") 

# separate border values of the difference maps, and set the interiours to '128'
normalD2 = mt_lutxy(normalD,block,expr="y 255 == x 128 ?",U=uv,V=uv)
strongD2 = mt_lutxy(StrongD,block,expr="y 255 == x 128 ?",U=uv,V=uv)

# interpolate the border values over the whole block: DCTFilter can do it. (Kiss to Tom Barry!)
# (Note: this is not fully accurate, but a reasonable approximation.)
# add borders if clp is not mod 16
remX = strongD2.width%16 == 0 ? 0 : (16 - strongD2.width%16)
remY = strongD2.height%16 == 0 ? 0 : (16 - strongD2.height%16)
strongD3 = strongD2.addborders(0, 0, remX, remY).mt_lut(expr="x 128 - 1.01 * 128 +",U=uv,V=uv)\
                     .dctfilter(1.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0).crop(0, 0, -remX, -remY)

# apply compensation from "normal" deblocking to the borders of
# the full-block-compensations calculated from "strong" deblocking ... 
strongD4 = mt_lutxy(strongD3,normalD2,expr="y 128 == x y ?",U=uv,V=uv)

# ... and apply it.
deblocked= mt_makediff(clp,strongD4,chroma=uv>2?"process":"ignore") 

# simple decisions how to treat chroma
deblocked = (uv<0) ? deblocked.mergechroma(strong) : uv<2 ? deblocked.mergechroma(normal) : deblocked

deblocked.crop(0, 0, -padX, -padY) # remove mod 8 borders
return( last )
}

