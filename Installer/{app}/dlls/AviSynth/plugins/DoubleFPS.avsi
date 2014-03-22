#########################
###
### DoubleFPS()
### 
#########################
###
###    v.0.3 fixed typo
###          changed defaults
###          improved accuracy
###
### Function for doubling framerate from original FPS through frame interpolation.
### Useful for better motion smoothness or slow motion. It is prone to artefacting
### so is probably better to fine tune settings apart from function parameters and
### do some craft work.
### 
### Didée function adapted by Dogway (23/02/2011) from following documentation:
### http://forum.doom9.org/showpost.php?p=1409324&postcount=18
### http://www.avsforum.com/avs-vb/showthread.php?p=20045304
### 
### It is recommended to supply a clean source to feed this function. It is slow.
###
###
### mode [default: 2]
### -------------------
### Interpolation method:
### 1 = MBlockFps  (block interpolation)
### 2 = MFlowFps   (pixel interpolation)
### You might want to play with ThSCD.
###
### mopro [default: false]
### -------------------
### motion protection; it duplicates the last frame when there are big
### changes (prone to artifacting), useful for scenechanges, motion blur...
### you may not want it as it might create stutter. [true, false]
###
###
### bias [default: 128]
### -------------------
### Threshold for frame difference detection.
### You wouldn't want to set it higher from
### default value. [0...255]
###
###
### show [default: false]
### -------------------
### Shows a "dot" in the interpolated frames. [true, false]
###
###_________________________________
###                                 |
### Example:                        |
###                                 |
###  DoubleFPS(bias=32,show=true)   |
###_________________________________|
###  
###
###   FEEL FREE TO REMOVE THIS USELESS HELP  :P
##############################################################



function DoubleFPS(clip clp, int "mode", bool "mopro", int "bias", bool "show") {

mode    = default( mode,         2 )
mopro   = default( mopro,     false) 
bias 	= string(default(bias, 128))
showdot = default( show,     false )

V = addborders(clp,16,16,16,16)
o = v.assumefps(FramerateNumerator(clp)) ox=v.width() oy=v.height()
S = showdot ? v.subtitle(".",x=32,y=24).MSuper(pel=4, hpad=16, vpad=16, rfilter=4) : v.MSuper(pel=4, hpad=16, vpad=16, rfilter=4)
A = S.MAnalyse(isb=true, blksize=8, overlap=2,plevel=0, search=5, searchparam=8,badrange=(-24))
B = S.MAnalyse(isb=false,blksize=8, overlap=2,plevel=0, search=5, searchparam=8,badrange=(-24))
C = S.MRecalculate(A, blksize=8, search=5, searchparam=2)
D = S.MRecalculate(B, blksize=8, search=5, searchparam=2)
E = S.MRecalculate(C, blksize=4, search=5, searchparam=1)
F = S.MRecalculate(D, blksize=4, search=5, searchparam=1)
double =  (mode==1) ?  V.MBlockFps(S, E, F, num=FramerateNumerator(v)*2, den=FramerateDenominator(v), mode=0, blend=false,ThSCD1=220)
\       : (mode==2) ?  V.MFlowFps(S, E, F,  num=FramerateNumerator(V)*2, den=FramerateDenominator(V), mask=2, ml=10000, blend=false,ThSCD1=220)
\       :  NOP()

diff2next = mt_makediff(o,o.selectevery(1,1)).mt_lut("x "+bias+" - abs 32 / 1 2.0 / ^ 128 *",U=-128,V=-128)
diff2next = mt_lutf(diff2next,diff2next,yexpr="x",mode="average").pointresize(32,32)
diff2next = interleave(diff2next.selectevery(4,0).tsg(2),diff2next.selectevery(4,1).tsg(2),
 \                     diff2next.selectevery(4,2).tsg(2),diff2next.selectevery(4,3).tsg(2))

max = diff2next.mt_logic(diff2next.selectevery(1,-3),"max")
 \             .mt_logic(diff2next.selectevery(1,-2),"max")
 \             .mt_logic(diff2next.selectevery(1,-1),"max")
 \             .mt_logic(diff2next.selectevery(1, 1),"max")
 \             .mt_logic(diff2next.selectevery(1, 2),"max")
 \             .mt_logic(diff2next.selectevery(1, 3),"max")
ismax = mt_lutxy(diff2next,max,"x y < 255 0 ?",U=-128,V=-128).pointresize(ox,oy) #swap 255 0 to interpolate only on big changes.
themask = interleave(o.mt_lut("0"),ismax)
interleave(o,o).mt_merge(double,themask,luma=true,U=3,V=3)

mopro ? last.crop(16,16,-16,-16)
\     : double.crop(16,16,-16,-16)}


function tsg(clip c, int t) { c
t<5?last:last.temporalsoften(1,255,0,255,2).merge(last,0.25)
t<4?last:last.temporalsoften(1,255,0,255,2).merge(last,0.25)
t<3?last:last.temporalsoften(1,255,0,255,2).merge(last,0.25)
t<2?last:last.temporalsoften(1,255,0,255,2).merge(last,0.25)
t<1?last:last.temporalsoften(1,255,0,255,2).merge(last,0.25) }