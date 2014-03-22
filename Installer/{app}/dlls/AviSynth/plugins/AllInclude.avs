Function ExBorders( clip c)
{
w = c.width()
h = c.height()
vflip = c.FlipVertical()
hflip = c.FlipHorizontal()
c
stackhorizontal( hflip.crop( w-16, 0, 16, h ).addborders( 0, 16, 0, 16 ),
\ stackvertical( vflip.crop( 0, h-16, w, 16 ), c, vflip.crop( 0, 0, w, 16 ) ),
\ hflip.crop( 0, 0, 16, h ).addborders( 0, 16, 0, 16 ) )
Return last
}


function OnDark(clip source)
{
#filtred = source.FrameCache(9).GradFunkMirror(3.0).MCTemporalDenoise(settings="medium", blksize=8, overlap=4,radius=2, sigma=4, strength=100)#.vmToon(strength=85, thinning=0)
filtred = source.FrameCache(9).MCTemporalDenoise(settings="medium", blksize=8, overlap=4, radius=2, sigma=4, strength=100)#.vmToon(strength=85, thinning=0)
th_low  = 1
th_high = 96
dmask = source.levels(th_low,1,th_high,255,0,false).blur(1.58).blur(1.58)
#return dmask
return mt_merge(source, filtred, dmask, U=3, V=3, luma=true)
}

function OnDark2(clip source)
{
#filtred = source.FrameCache(9).GradFunkMirror(3.0).MCTemporalDenoise(settings="high", usigma=4, strength=100)#.vmToon(strength=85, thinning=0)
filtred = source.FrameCache(9).dfttestMC(sigma=6.0,sigma2=5.0,tbsize=3,f0beta=1.0,pp=2,ppstr=3,mdg=true,mcradius=2,blksize=8,pel=2,thSAD=240,thSCD1=320,thSCD2=64)#.vmToon(strength=85, thinning=0)
th_low  = 1
th_high = 96
dmask = source.levels(th_low,1,th_high,255,0,false).blur(1.58).blur(1.58)
#return dmask
return mt_merge(source, filtred, dmask, U=3, V=3, luma=true)
}

function OnLigt(clip i)
{
i
Dark = FastLineDarkenMOD2(thinning=0)
#Dark = invert()
th_low = 1
th_high = 128
dmask = levels(th_low, 1.0, th_high, 255, 0, false).invert().blur(1.5)
return mt_merge(Dark, dmask, U=3, V=3, luma=true)
}


function FOrder(clip c) {
fo= GetParity(c)? 1:0
return fo
}


function HavyBandDark(clip i, float "set", float "thr", bool "Show")
{
 set     = Default(set, 3.0)
 thr     = Default(thr, 190)
 Show    = Default(Show, false)
i
Dark = (Show==true) ? Invert() : FrFun7(1.1,2.5,1.5).GradFun2DBmod(set, str=1.5, temp=0)
#Dark = Invert()#GradFun2DBmod(3.0)
th_low = 1
th_high = 128
dmask = levels(th_low, 1.0, th_high, 255, 0, false).blur(1.5).blur(1.5).mt_binarize(threshold=thr)
return mt_merge(Dark, dmask, U=3, V=3, luma=true)
}


function SoftBandDark(clip i, float "set", bool "Show")
{
 set     = Default(set, 3.0)
 Show    = Default(Show, false)
i
Dark = (Show==true) ? Invert() : GradFun2DBmod(set, temp=0)
#Dark = Invert()#GradFun2DBmod(3.0)
th_low = 1
th_high = 128
dmask = levels(th_low, 1.0, th_high, 255, 0, false).blur(1.5).blur(1.5)
return mt_merge(Dark, dmask, U=3, V=3, luma=true)
}


function Soft2BandDark(clip i, float "set", bool "Show")
{
 set     = Default(set, 3.0)
 Show    = Default(Show, false)
i
Dark = (Show==true) ? Invert() : FrFun7(1.1,2.5,1.5).GradFun2DBmod(set, str=1.5, temp=0)
#Dark = Invert()#GradFun2DBmod(3.0)
th_low = 1
th_high = 192
dmask = levels(th_low, 1.0, th_high, 255, 0, false).blur(1.5).blur(1.5)
return mt_merge(Dark, dmask, U=3, V=3, luma=true)
}


function HavyBand(clip i)
{
return GradFun2DBmod(i, thr=4, str=3, temp=0)
}


function mtoon(clip i)
{
return vmToon(i, thinning=0)
}


function mtoon2(clip i)
{
return FastLineDarkenMOD(thinning=0)#mfToon2(i, strength=32)
}