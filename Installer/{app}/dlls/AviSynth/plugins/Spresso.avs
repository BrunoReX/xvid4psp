function SPresso(clip clp, int "limit", int "bias", int "RGmode", int "limitC", int "biasC", int "RGmodeC")
{
limit   = default( limit,   2 )
limitC  = default( limitC,  3 )
bias    = default( bias,   27 )
biasC   = default( biasC,  27 )
RGmode  = default( RGmode,  17 )
RGmodeC = default( RGmodeC, 17 )

yy = (RGmode ==0) ? 2 : 3
uv = (RGmodeC==0) ? 2 : 3
LIM1  = (limit>0) ? string( round(limit*100.0/bias-1.0) ) : string( round(100.0/bias) )
LIM2  = (limit<0) ? "1" : string(limit)
BIA   = string(bias)
LIM1c = (limitC>0) ? string( round(limitC*100.0/biasC-1.0) ) : string( round(100.0/biasC) )
LIM2c = (limitC<0) ? "1" : string(limitC)
BIAc  = string(biasC)

expr  = (limit<0) ?   "x y - abs "+LIM1+" < x x 1 x y - x y - abs / * - ?"
 \                :   "x y - abs 0 <= x x "+LIM1+" + y < x "+LIM2+" + x "+LIM1+" - y > x "+LIM2+" - " \ 
                    + "x 100 "+BIA+" - * y "+BIA+" * + 100 / ? ? ?"
exprC = (limit<0) ?   "x y - abs "+LIM1c+" < x x 1 x y - x y - abs / * - ?"
 \                :   "x y - abs 0 <= x x "+LIM1c+" + y < x "+LIM2c+" + x "+LIM1c+" - y > x "+LIM2c+" - " \ 
                    + "x 100 "+BIAc+" - * y "+BIAc+" * + 100 / ? ? ?"

# For (old) MaskTools v1.5.8 :
# yv12lutxy( clp, clp.removegrain(RGmode,RGmodeC), expr,exprC,exprC, Y=yy,U=uv,V=uv)

# For (new) MaskTools v2.x :
mt_lutxy( clp, clp.removegrain(RGmode,RGmodeC), yexpr=expr,uexpr=exprC,vexpr=exprC, Y=yy,U=uv,V=uv)

return( last )
}
