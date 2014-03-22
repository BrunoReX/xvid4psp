# SPresso
# fixed to work with MaskTools v2
#
# SPresso stands for Spatial Pressdown.
# Basically, it's just a both weighted and limited version of "RemoveGrain(mode=??)". In effect, it does a more gentle reduction, opposed to a plain RemoveGrain, which does a median-like "all-or-nothing" within the bounds of the chosen mode.
# Note: Chroma is not touched at all. SPresso works only on the luma channel.
#
# On my usual, usual-noisy DVB sources, compression gain usually is from 2% to 3% (light settings -> changes almost invisible) up to 10 to 12% (stronger settings -> slight, gentle softening, not very obvious).
#
# Format:
# SPresso( limit, bias, [RGmode] )
# "limit" tells the maximum change to do to any pixel
# "bias" is, well, something like "aggressivity": '20' is a very light setting, '33' is already quite strong.
# "RGmode" tells the RemoveGrain mode to use. The default of "4" is the best in most cases.
#
# Required Plugins:
# - MaskTools v2
# - RemoveGrain (the pre-1.0 version!)

function SPresso(clip clp, int "limit", int "bias", int "RGmode")
{
limit  = default( limit,  2 )
bias   = default( bias,  25 )
RGmode = default( RGmode, 4 )

LIM1  = (limit>0) ? string( round(limit*100.0/bias-1.0) ) : string( round(100.0/bias) )
LIM2  = (limit<0) ? "1" : string(limit)
BIA   = string(bias)

expr  = (limit<0) ?   "x y - abs "+LIM1+" < x x 1 x y - x y - abs / * - ?"
 \                :   "x y = x x "+LIM1+" + y < x "+LIM2+" + x "+LIM1+" - y > x "+LIM2+" - " \ 
                    + "x 100 "+BIA+" - * y "+BIA+" * + 100 / ? ? ?"

mt_lutxy( clp, clp.removegrain(RGmode,-1), expr, U=2,V=2)

return( last )
}
