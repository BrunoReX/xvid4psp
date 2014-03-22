function FSx(clip c, int "mode", float "sstr", float "cstr", float "xstr", float "lstr", float "pstr")
{
 
mode  = default(mode, 1   )   #  1 to 3, weakest to strongest. When negative -1 to -3, a broader kernel for equalisation is used.
sstr  = default(sstr, 2.0 )   #  strength of sharpening, 0.0 up to ??
 
_cstr = spline(sstr, 0,0, 0.5,0.1, 1.0,0.6, 2.0,0.9, 2.5,1.09, 3.0,1.15, 3.5,1.19, 4.0,1.249, 8.0,1.5, 255.0,2.0)

cstr  = default(cstr, _cstr)
xstr  = default(xstr, 0.19 )

lstr  = default(lstr, 4.0 )
pstr  = default(pstr, 1.6) 

str1  = sstr
str2  = cstr
SSTR  = string(abs(sstr))
CSTR  = string(abs(cstr))
LSTR  = string(abs(lstr))
PSTR  = string(abs(pstr))
rg=mode>0?11:20
 
b = (abs(mode)==1) ? c.removegrain(11,-1).removegrain(4,-1)
\ : (abs(mode)==2) ? c.removegrain(4,-1).removegrain(11,-1)
\ : (abs(mode)==3) ? c.removegrain(4,-1).removegrain(11,-1).removegrain(4,-1) : c
 
shrpD = mt_lutxy(c,b,"x y - abs "+LSTR+" / 1 "+PSTR+" / ^ "+LSTR+" * "+SSTR+" * x y - x y - abs 0.001 + / * x y - 2 ^ x y - 2 ^ "+SSTR+" 4.0 * + / * 128 +")
 
shrp = (str1<0.01) ? c : c.mt_adddiff(shrpD,U=2,V=2)

bzzD = (str2>0.0) ? shrpD.mt_lut("x 128 - "+CSTR+" * 128 +").removegrain(rg,-1)  
 \                : shrpD.mt_lut("x 128 - "+CSTR+" * 128 +").removegrain(11,-1).removegrain(20*1,-1)
shrp = (abs(str2)<0.01) ? shrp : shrp.mt_makediff(bzzD,U=2,V=2)

shrp = (xstr<0.01) ? shrp
\    : mt_lutxy(shrp,shrp.removegrain(20,-1),"x x y - 9.9 * +").repair(shrp,12,0).mergeluma(shrp,1.0-xstr)

return(shrp)
}