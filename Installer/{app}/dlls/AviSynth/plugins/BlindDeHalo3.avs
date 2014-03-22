function BlindDeHalo3( clip clp, float "rx", float "ry", int "strength",
 \                     float "lodamp", float "hidamp", float "sharpness", float "tweaker",
 \                     int "PPmode", int "PPlimit", bool "interlaced")
{
rx =         default( rx,           3.0 )
ry =         default( ry,           3.0 )
strength =   default( strength,     125 )
lodamp =     default( lodamp,       0.0 )
hidamp =     default( hidamp,       0.0 )
sharpness =  default( sharpness,    0.0 )
tweaker =    default( tweaker,      0.0 )
PPmode =     default( PPmode,         0 )
PPlimit =    default( PPlimit,        0 )
interlaced = default( interlaced, false )

sharpness = (sharpness>1.58) ? 1.58 : sharpness
tweaker   = (tweaker > 1.00) ? 1.00 : tweaker
strength  = float(strength)*(1.0+sharpness*0.25)
RR   = string((rx+ry)/2.0)
ST   = string(float(strength)/100.0)
LD   = string(lodamp)
HD   = string(pow(hidamp,2))
TWK0 = "x y - 12 "+ST+" / "+RR+" / /"
TWK  = "x y - 12 "+ST+" / "+RR+" / / abs"
TWK_HLIGHT = "x y = 128 "+TWK+" 128 "+TWK+" - "+TWK+" 128 / * + "+TWK0+" "+TWK+" "+LD+" + / * "
 \         + "128 "+TWK+" - 20 / 2 ^ 128 "+TWK+" - 20 / 2 ^ "+HD+" + / * 128 + ?"

i     = (interlaced==false) ? clp : clp.separatefields()
oxi   = i.width
oyi   = i.height
sm    = i.bicubicresize(m4(oxi/rx),m4(oyi/ry))
mm    = yv12lutxy(sm.expand,sm.inpand,"x y - 4 *").expand.deflate.blur(1.58).bicubicresize(oxi,oyi,1.0,.0)
sm    = sm.bicubicresize(oxi,oyi,1.0,.0)
smd   = yv12lutxy(i.sharpen(tweaker),sm,TWK_HLIGHT)
smd   = (sharpness==0.0) ? smd : smd.blur(sharpness)
clean = yv12lutxy(i,smd,yexpr="x y 128 - -").mergechroma(i)
clean = maskedmerge(i,clean,mm)

LL    = string(PPlimit)
LIM   = "x "+LL+" + y < x "+LL+" + x "+LL+" - y > x "+LL+" - y ? ?"

small = (PPmode>0) ? clean.bicubicresize(m4(oxi/2.125),m4(oyi/2.125))
 \                 :    i .bicubicresize(m4(oxi/2.125),m4(oyi/2.125))
ex1 = small.expand.blur(.5)
in1 = small.inpand.blur(.5)
hull = logic( yv12lutxy( ex1.expand.blur(1), ex1, "x y - 1 1 / * 1.0 ^ 1 - 4 *" )
 \           ,yv12lutxy( in1, in1.inpand.blur(1), "x y - 1 1 / * 1.0 ^ 1 - 4 *" )
 \           ,"max", U=-128, V=-128)
 \     .bicubicresize(oxi,oyi,1.0,.0)
postclean = (PPmode== 1) ?  maskedmerge(clean,small.bicubicresize(oxi,oyi,1.0,.0),hull)
 \        : (PPmode== 2) ?  maskedmerge(clean,clean.DEdgeMask(0,255,0,255,"2 3 2 3 0 3 2 3 2"),hull)
 \        : (PPmode==-1) ?  maskedmerge(i,small.bicubicresize(oxi,oyi,1.0,.0),hull)
 \        : (PPmode==-2) ?  maskedmerge(i,i.DEdgeMask(0,255,0,255,"2 3 2 3 0 3 2 3 2"),hull)
 \        :                 clean
postclean = (PPlimit==0) ?  postclean
 \        :                 yv12lutxy(clean,postclean,LIM,U=2,V=2)

(PPmode==0) ? clean   : postclean
interlaced  ? weave() : last

return( last )
}
#---------------------------------------------------------
function m4(float x) {return(x<16?16:int(round(x/4.0))*4)}
