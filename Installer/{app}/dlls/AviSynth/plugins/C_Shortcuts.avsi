

##############################
### Upsize by a factor of 2.
Function ResX2(last)
{
spline64resize(width*2,height*2)
RETURN (last)
}

##############################
### Reduceby2 is an internal avisynth function

#______________________________________________


##############################
### Convert to yv12 in case it isn't already.
Function yv12(clip Clp)
{
Clp = Clp.IsYV12() ? Clp : Clp.ConvertToYV12()
Clp
}

##############################
### Convert to RGB in case it isn't already.
Function rgb(clip Clp)
{
Clp = Clp.IsRGB() ? Clp : Clp.ConvertToRGB32()
Clp
}

#______________________________________________


##############################
### Loads an .amp curve by using GiCoCU
function Curve(clip c, string curve){
c.ConvertToRGB24
GiCoCU(curve,photoshop=true)
ConvertToYV12}


##############################
### Adjust source to mod(n) size by adding borders.
### From this thread: http://forum.doom9.org/showthread.php?p=1453641#post1453641
Function mmod(clip c, int "modH", int "modV", int "color")
{
	modH = Default(modH, 16)
	modV = Default(modV, modH)
	color = default(color,$000000) 
	bh = modH - ((c.Width()-1)%modH + 1)
	bv = modV - ((c.Height()-1)%modV + 1)

	l = bh/2
       l = c.IsYUV() && l%2 != 0 ? l-1 : l
	r = bh - l
	t = bv/2
       t = c.IsYV12() && t%2 != 0 ? t-1 : t
	b = bv - t
	c.AddBorders(l,t,r,b,color=color)
}


#______________________________________________


##############################
### antialiaser of NNEDI3 with workaround by Didée
### from this thread: http://forum.doom9.org/showthread.php?t=153485
### call like: NNEDI3AA().turnleft().NNEDI3AA().turnright()
function NNEDI3AA(clip o) {
o.NNEDI3(field=-2, qual=2)
dbl   = Merge(SelectEven(),SelectOdd())
dblD  = mt_MakeDiff(o,dbl,U=3,V=3)
shrpD = mt_MakeDiff(dbl,dbl.RemoveGrain(20),U=3,V=3)
DD    = shrpD.Repair(dblD,13)
dbl.mt_AddDiff(DD,U=3,V=3)    }




##############################
### Nifty Gauss/Median combination
function MinBlur(clip clp, int r, int "uv")
{
uv   = default(uv,3)
uv2  = (uv==2) ? 1 : uv
rg4  = (uv==3) ? 4 : -1
rg11 = (uv==3) ? 11 : -1
rg20 = (uv==3) ? 20 : -1
medf = (uv==3) ? 1 : -200

RG11D = (r==1) ? mt_makediff(clp,clp.removegrain(11,rg11),U=uv2,V=uv2)
 \    : (r==2) ? mt_makediff(clp,clp.removegrain(11,rg11).removegrain(20,rg20),U=uv2,V=uv2)
 \    :          mt_makediff(clp,clp.removegrain(11,rg11).removegrain(20,rg20).removegrain(20,rg20),U=uv2,V=uv2)
RG4D  = (r==1) ? mt_makediff(clp,clp.removegrain(4,rg4),U=uv2,V=uv2)
 \    : (r==2) ? mt_makediff(clp,clp.medianblur(2,2*medf,2*medf),U=uv2,V=uv2)
 \    :          mt_makediff(clp,clp.medianblur(3,3*medf,3*medf),U=uv2,V=uv2)
DD    = mt_lutxy(RG11D,RG4D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",U=uv2,V=uv2)
clp.mt_makediff(DD,U=uv,V=uv)
return(last)
}