#Suggested by Mystery Keeper in "Denoise of tv-anime" thread
function ediaa(clip a) {return a.EEDI2(field=1).TurnRight().EEDI2(field=1).TurnLeft().spline36resize(a.width,a.height,-0.5,-0.5,2*a.width+.001,2*a.height+.001)}

#Anti-aliasing with contra-sharpening by Didée
FUNCTION daa(clip c) {
dbl   = merge(c.nnedi3(field = 1, nns = 1),c.nnedi3(field = 0, nns = 1))
dblD 	= mt_makediff(c,dbl,U=3,V=3)
shrpD 	= mt_makediff(dbl,dbl.removegrain((width(c)>1100) ? 20 : 11),U=3,V=3)
DD 	= shrpD.repair(dblD,13)
return dbl.mt_adddiff(DD,U=3,V=3) }

#Simple Anti-aliasing by Soulhunter
FUNCTION saa(Clip Clp,Int"SS",Bool"CP") {
OX = Clp.Width
OY = Clp.Height
SS = Default(SS,2)
CP = Default(CP,True)
Clp = Clp.IsYV12() ? Clp : Clp.ConvertToYV12()
Clp.PointResize(OX*SS,OY*SS).SangNom().TurnRight()
\  .SangNom().TurnLeft().BilinearResize(OX,OY)
CP ? Last : MergeChroma(Clp)
Return(Last) }

#Anti-aliasing with edge masking by martino, mask using "sobel" taken from Kintaro's useless filterscripts and modded by thetoof for spline36
FUNCTION maa(clip input, int "mask") {
mask = input.mt_edge("sobel",7,7,5,5).mt_inflate()
aa_clip=input.spline36Resize(width(input)*2,height(input)*2).TurnLeft().SangNom().TurnRight().SangNom().spline36Resize(width(input),height(input)).MergeChroma(input) 
return mt_merge(input,aa_clip,mask) }

#AnimeAntiAliasing - Thanks to @ Didée, mf, Akirasuto, SpikeSpiegel & ScharfisBrain
FUNCTION AAA(clip clp, int "Xres", int "Yres", int "Xshrp", int "Yshrp", 
 \ 	 int "US", int "DS", bool "chroma")
       {
         clp = clp.isYV12() ? clp : clp.ConvertToYV12()
         ox = clp.width
         oy = clp.height
         Xres  = default(Xres,  ox)
         Yres  = default(Yres,  oy)
         us  = default(us, 1)
	 ds = default(ds, 2)
         Xshrp = default(Xshrp, 15)
         Yshrp = default(Yshrp, 15)
	 chroma = default(chroma, false)
         
         us==0 ? clp.PointResize(ox*2,oy*2) : clp.LanczosResize(ox*2,oy*2)

         TurnLeft()
         SangNom()

         TurnRight()
         SangNom()

         ds==0 ? BilinearResize(Xres,Yres) : 
 \	 ds==1 ? BicubicResize(Xres,Yres) : 
 \	 LanczosResize(Xres,Yres)

         Unfilter(Xshrp,Yshrp)

         chroma ? MergeChroma(clp.Lanczosresize(Xres,Yres)) : last }

#Normal Anti-aliasing by Didée
FUNCTION antialiasing(clip orig,int "th_luma",int "th_croma",string "type",int "aath") {

# "th_luma" & "th_croma" are the edge detection thres.: lower values=more edges filtered
# "type" is the matrix used for edge detection: with "sobel" (default) only the 
#     hi-contrast edges, where artefacts are more noticeable, are filtered. If you want
#     to test other matrices, read the MaskTools Guide for more info.
# "aath" = anti-aliasing strenght (default should be fine)

th_luma  = Default(th_luma, 20)
th_croma = Default(th_croma, 20)
type     = Default(type, "sobel")
aath     = Default(aath, 48)
ox = orig.width
oy = orig.height
dx = orig.width * 2
dy = orig.height * 2
clp = orig.IsYV12() ? orig : orig.ConvertToYV12()

a=clp
b=clp.Lanczos4Resize(dx,dy).TurnLeft().SangNom(aa=aath).TurnRight().SangNom(aa=aath) \
.LanczosResize(ox,oy)
c=clp.EdgeMask(th_luma,th_luma,th_croma,th_croma,type)
MaskedMerge(a,b,c) }

# Written by MisterHatt, based off of Soulhunter's SAA() and martino's excellent MAA(), and is slightly
# faster at times for some reason or another. These functions work by generally supersampling, usually with
# nnedi2, and then running a deinterlacer (sangnom and nnedi2 respectively) to get rid of most jaggies.
# I have no idea how destructive these are on whatever random thing people care to throw them at.
# For large supersamples, avs2yuv bitches for no real reason and requires assumeframebased() in your script.
# Requires nnedi2, sangnom, o9k hours of your life.
FUNCTION splinaa(Clip Clp,Int"SS",Bool"CP") {
OX = Clp.Width
OY = Clp.Height
SS = Default(SS,2)
CP = Default(CP,True)
Clp = Clp.IsYV12() ? Clp : Clp.ConvertToYV12()
Clp.PointResize(OX*SS,OY*SS).SangNom().TurnRight()
\  .SangNom().TurnLeft().Spline36Resize(OX,OY)
CP ? Last : MergeChroma(Clp)

Return(Last) }

FUNCTION supaa(Clip Clp,Int"SS",Bool"CP") {
OX = Clp.Width
OY = Clp.Height
SS = Default(SS,2)
CP = Default(CP,True)
Clp = Clp.IsYV12() ? Clp : Clp.ConvertToYV12()
Clp.nnedi3_rpow2(rfactor=SS,cshift="spline36resize",qual=2).SangNom().TurnRight()
\  .SangNom().TurnLeft().Spline36Resize(OX,OY)
CP ? Last : MergeChroma(Clp)

Return(Last) }

FUNCTION naa(Clip Clp,Int"SS",Bool"CP") {
OX = Clp.Width
OY = Clp.Height
SS = Default(SS,2)
CP = Default(CP,True)
Clp = Clp.IsYV12() ? Clp : Clp.ConvertToYV12()
Clp.nnedi3_rpow2(rfactor=SS,cshift="spline36resize",qual=2).nnedi3(qual=2).TurnRight()
\  .nnedi3(qual=2).TurnLeft().Spline36Resize(OX,OY)
CP ? Last : MergeChroma(Clp)

Return(Last) }

FUNCTION shaarp(clip input, int "mask", int "type") {
mask = Default(mask,1)
type = Default(type,1)
Assert(mask == 1 || mask == 2, "Please use mask = 1 or 2")
Assert(type == 1 || type == 2, "Please use type = 1 or 2")
aa_clip = (type == 1) ? input.spline36Resize(width(input)*2,height(input)*2) : input.nnedi2_rpow2(rfactor=2,qual=3)
aa_clip = aa_clip.TurnLeft().nnedi2().TurnRight().nnedi2().spline36Resize(width(input),height(input)).MergeChroma(input)
mask = (mask==1) ? input.mt_edge("sobel",7,7,5,5).mt_inflate() : input.mt_edge("roberts",0,4,0,4).mt_inflate()

return mt_merge(input,aa_clip,mask) }

function aaf(clip input, float "aam", int "aay", "aax", bool "rep")
{
input =	input.isYV12() ? input : input.converttoyv12()

aam	= default(aam, -0.6)
aar	= aam<0 ? (aam-1)*0.25 : (aam+1)*0.25
aay	= default(aay, 28)
aax	= default(aax, aay)
rep	= default(rep, true)

sx	= width(input)
sy	= height(input)

aa	= aar<0 ? input.LanczosResize(sx,int(sy*abs(aar))*4) :
	\	aar==0.5 ? input.Pointresize(sx*2, sy*2) :
	\	input.LanczosResize(int(sx*abs(aar)*4),int(sy*abs(aar))*4)
aa	= aay>0 ? aa.SangNom(aa=aax) : input
aa	= aar<0 && aax>0 ? aa.LanczosResize(int(sx*abs(aar))*4,sy) : aa
aa	= aax>0 ? aa.turnright().SangNom(aa=aax).Turnleft() : aa
aa	= aa.LanczosResize(sx,sy)

return rep==true ? aa.repair(input,18) : aa
}


# set "order = 0" for Top Field First; order = 1 --> Bottom Field First
# aath = anti-aliasing strenght (default should be fine)
# multipler, use for automatic scaling. (720->1080 with multipler 1.5)
# mtype - "prewitt", "cartoon", "min/max", "sobel", "roberts" and "laplace".
# extype - "square", "horizontal", "vertical" and "both".
# required plugins - MaskTools v2a36, Sangnom, awarpsharp2, MSharpen, SplineResize (advanced).
# authors - Didee (original idea), Eivind, Varies, Slobodan.
#
function aaSW(\
clip orig,float "multipler",int "dx",int "dy",int "LOffset",int "ROffset",int "BOffset"\
,int "TOffset",int "order",int "aath",bool "warp",int "adepth",int "athresh",int "ablur"\
,bool "addsharp",string "sharper",string "mtype",int "mY1",int "mY2",int "mC1",int "mC2"\
,bool "expnd",int "exthY",int "exthC",string "extype",int "AmergeY",int "AmergeV",int "AmergeU",bool "showmask") 
{
multipler = Default(multipler, 2)
dx = Default(dx,int(orig.width *multipler))
dy = Default(dy,int(orig.height * multipler))
LOffset     =  Default(LOffset, 0)
ROffset     =  Default(ROffset, 0)
BOffset     =  Default(BOffset, 0)
TOffset     =  Default(TOffset, 0)
order     =  Default(order, 0)
aath     = Default(aath, 48)
warp = Default(warp, false)
adepth   = Default(adepth, 3)
athresh = Default(athresh, 45)
ablur     = Default(ablur, 1)
addsharp   = Default(addsharp, false)
sharper = Default(sharper, "MSharpen(12,35,true,false,false)")
mtype = Default(mtype, "prewitt")
mY1     = Default(mY1, 100)
mY2     = Default(mY2, 100)
mC1     = Default(mC1, 5)
mC2     = Default(mC2, 10)
expnd = Default(expnd, true)
extype = Default(extype, "square")
exthY     = Default(exthY, 255)
exthC     = Default(exthC, 255)
AmergeY = Default(AmergeY, 3)
AmergeV = Default(AmergeV, 2)
AmergeU = Default(AmergeU, 2)
showmask = Default(showmask, false)

orig
ox = orig.width
oy = orig.height

a=last
#b = spline144resize(dx, dy).TurnLeft().SangNom(order,aath).TurnRight().SangNom(order,aath)
b = blackmanresize(dx, dy, taps=8).TurnLeft().SangNom(order,aath).TurnRight().SangNom(order,aath)
b = warp?b.awarpsharp2(type=1, thresh=athresh,chroma=4, depth=adepth, blur=ablur) : b
b = addsharp?Eval("b."+sharper) : b
d = mt_edge(mtype,mY1,mY2,mC1,mC2,offx=LOffset,offy=TOffset,w=width-roffset-loffset,h=height-toffset-boffset,y=AmergeY,v=AmergeV,u=AmergeU)
d = expnd? d.mt_expand(exthY,exthC,extype,y=AmergeY,v=AmergeV,u=AmergeU) : d
#b = b.spline144resize(ox,oy)
b = b.blackmanresize(ox,oy, taps=8)
mt_merge(a,b,d,y=AmergeY,v=AmergeV,u=AmergeU)
showmask? d : last
}