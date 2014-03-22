# NNEDI3resize function 
#
# PARAMETERS:
# -----------
# ox = destination width
# oy = destination height
# nsize,qual,cshift = nnedi3 parameters
#
# ABOUT RESOLUTION:
# -----------------
# if output > input : use nnedi3 resizer + "cshift" resizer
# if output = input : do nothing
# if output < input : use "cshift" resizer
#
# EXAMPLE:
# --------
# NNEDI3resize(1280,720)
# NNEDI3resize(1920,1080,qual=1,cshift="spline16resize")

function NNEDI3resize(clip clp, int ox, int oy, int "nsize", int "qual", string "cshift")
{
 nsize  = default( nsize,  0                )
 qual   = default( qual,   2                )
 cshift = default( cshift, "spline36resize" )

ix = clp.width()
iy = clp.height()

rx = float(ox)/float(ix)
ry = float(oy)/float(iy)
rf = (rx > ry) ? rx : ry

clp = ( rf > 1.0 ) ? clp.nnedi3_rpow2(rfactor=ceil(rf/2.0)*2, nsize=nsize, qual=qual, cshift=cshift, fwidth=ox, fheight=oy)
\   : ( rf < 1.0 ) ? Eval( "clp." + cshift + "(" + string(ox) + "," + string(oy) + ")" )
\   :                clp

return clp
}