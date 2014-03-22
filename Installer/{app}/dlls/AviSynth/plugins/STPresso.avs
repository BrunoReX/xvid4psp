function STPresso(clip clp, int "limit", int "bias", int "RGmode", int "tthr", int "tlimit", int "tbias", int "back")
{
limit  = default( limit,   3 )  # spatial limit:  the spatial part won't change a pixel more than this
bias   = default( bias,   24 )  # bias: the percentage of the spatial filter that will apply
RGmode = default( RGmode,  4 )  # the spatial filter is RemoveGrain, this is its mode
tthr   = default( tthr,   12 )  # temporal threshold for fluxsmooth. Can be set "a good bit bigger" than usually
tlimit = default( tlimit,  3 )  # the temporal filter won't change a pixel more than this
tbias  = default( tbias,  49 )  # the percentage of the temporal filter that will apply
back   = default( back,    1 )  # after all changes have been calculated, reduce all pixel changes by this value. (Shift "back" towards original value)

LIM1  = (limit>0) ? string( round(limit*100.0/bias-1.0) ) : string( round(100.0/bias) )
LIM2  = (limit<0) ? "1" : string(limit)
BIA   = string(bias)
BK = string(back)
TLIM1  = (tlimit>0) ? string( round(tlimit*100.0/tbias-1.0) ) : string( round(100.0/tbias) )
TLIM2  = (tlimit<0) ? "1" : string(tlimit)
TBIA   = string(tbias)

expr  = (limit<0) ?   "x y - abs "+LIM1+" < x x 1 x y - x y - abs / * - ?"
 \                :   "x y - abs 1 < x x "+LIM1+" + y < x "+LIM2+" + x "+LIM1+" - y > x "+LIM2+" - " \ 
                    + "x 100 "+BIA+" - * y "+BIA+" * + 100 / ? ? ?"
texpr  = (limit<0) ?   "x y - abs "+TLIM1+" < x x 1 x y - x y - abs / * - ?"
 \                :   "x y - abs 1 < x x "+TLIM1+" + y < x "+TLIM2+" + x "+TLIM1+" - y > x "+TLIM2+" - " \ 
                    + "x 100 "+TBIA+" - * y "+TBIA+" * + 100 / ? ? ?"

bzz = clp.removegrain(RGmode)
mt_lutxy( clp, bzz, expr, U=3,V=3)
tthr==0 ? last : mt_lutxy(last,last.mt_makediff(mt_makediff(bzz,bzz.fluxsmootht(tthr),U=3,V=3),U=3,V=3),texpr,U=3,V=3)
back==0 ? last : mt_lutxy(last,clp,"x "+BK+" + y < x "+BK+" + x "+BK+" - y > x "+BK+" - y ? ?",U=2,V=2)
}