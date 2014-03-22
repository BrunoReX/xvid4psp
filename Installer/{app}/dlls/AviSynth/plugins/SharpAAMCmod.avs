function SharpAAMCmod(clip orig, float "dark", int "thin", int "sharp", int "smooth", bool "stabilize", int "tradius", int "aapel", int "aaov", int "aablk", string "aatype")
{
dark	= default ( dark,     0.2 ) # strokes darkening strength
thin	= default ( thin,      10 ) # Presharpening
sharp	= default ( sharp,    150 ) # Postsharpening
smooth	= default ( smooth,    -1 ) # Postsmoothing
stabilize= default ( stabilize,false ) # Use post stabilization with Motion Compensation
Tradius	= default ( Tradius,    2 ) # 2 = MDegrain2 / 3 = MDegrain3 
aapel	= default ( aapel,      1 ) # accuracy of the motion estimation (Value can only be 1, 2 or 4. 1 means a precision to the pixel. 2 means a precision to half a pixel, 4 means a precision to quarter a pixel, produced by spatial interpolation (better but slower).)
aaov	= default ( aaov,       (orig.width>1100) ? 8 : 4 ) # block overlap value (horizontal). Must be even and less than block size. (Higher = more precise & slower)
aablk	= default ( aablk,      (orig.width>1100) ? 16 : 8 ) # Size of a block (horizontal). It's either 4, 8 or 16 ( default is 8 ). Larger blocks are less sensitive to noise, are faster, but also less accurate.
aatype	= default ( aatype, "Sangnom" ) # Use Sangnom, EEDI2, maa, daa, ediaa, aaa, ssa, splinaa, supaa, naa, shaarp, nnedi3 or antialiasing for aatype

w=width(orig)
h=height(orig)
m=mt_logic( orig.DEdgeMask(0,255,0,255,"5 10 5 0 0 0 -5 -10 -5", divisor=4,Y=3,U=3,V=3)
 \       ,orig.DEdgeMask(0,255,0,255,"5 0 -5 10 0 -10 5 0 -5", divisor=4,Y=3,U=3,V=3)
 \       ,"max").mt_lut("x 128 / 0.86 ^ 255 *")
preaa=(thin==0 && dark==0) ? orig : (thin==0) ? orig.Toon(dark) : (dark==0) ? orig.awarpsharp2(depth=thin) : orig.Toon(dark).awarpsharp2(depth=thin)
aa = (aatype=="EEDI2") ? preaa.TurnLeft().EEDI2().TurnRight().EEDI2().spline64resize(w,h,0.5,-0.5,2*w+.001,2*h+.001) : (aatype=="Sangnom") ? preaa.spline36resize(w*2,h*2).TurnLeft().SangNom(aa=255).TurnRight().SangNom(aa=255).spline36resize(w,h) : (aatype=="maa") ? preaa.maa() : (aatype=="daa") ? preaa.daa() : (aatype=="ediaa") ? preaa.ediaa() : (aatype=="aaa") ? preaa.aaa() : (aatype=="saa") ? preaa.SAA() : (aatype=="splinaa") ? preaa.splinaa() : (aatype=="supaa") ? preaa.supaa() : (aatype=="naa") ? preaa.naa() : (aatype=="shaarp") ? preaa.shaarp()  : (aatype=="nnedi2") ? preaa.nnedi2(dh=true,field=1) : (aatype=="antialiasing") ? preaa.antialiasing() : blankclip(pixel_type="YV12").subtitle("Please use Sangnom, EEDI2, maa, daa, ediaa, aaa, ssa, splinaa, supaa, naa, shaarp, nnedi2 or antialiasing for aatype")
postsh=(sharp==0 && smooth==0) ? aa : aa.lsfmod(edgemode=1,strength=sharp,overshoot=1,soft=smooth)
merged=mt_merge(orig,postsh,m,Y=3,U=3,V=3)

sD=mt_makediff(orig,merged)

origsuper= orig.MSuper(pel=aapel)
sDsuper  = sD.  MSuper(pel=aapel, levels=1)


fv3 = tradius==3 ? origsuper.MAnalyse(isb=false,delta=3,overlap=aaov,blksize=aablk) : nop()
fv2 = tradius>=2 ? origsuper.MAnalyse(isb=false,delta=2,overlap=aaov,blksize=aablk) : nop()
fv1 = tradius>=1 ? origsuper.MAnalyse(isb=false,delta=1,overlap=aaov,blksize=aablk) : nop()
bv1 = tradius>=1 ? origsuper.MAnalyse(isb=true, delta=1,overlap=aaov,blksize=aablk) : nop()
bv2 = tradius>=2 ? origsuper.MAnalyse(isb=true, delta=2,overlap=aaov,blksize=aablk) : nop()
bv3 = tradius==3 ? origsuper.MAnalyse(isb=true, delta=3,overlap=aaov,blksize=aablk) : nop()
sDD = tradius==1 ? sD.MDegrain1(sDsuper,bv1,fv1) : tradius==2 ? sD.MDegrain2(sDsuper,bv1,fv1,bv2,fv2) : sD.MDegrain3(sDsuper,bv1,fv1,bv2,fv2,bv3,fv3)

reduc = 0.4
sDD = mt_lutxy(sD,sDD,"x 128 - abs y 128 - abs < x y ?").mergeluma(sDD,1.0-reduc)

return stabilize ? orig.mt_makediff(sDD,U=2,V=2) : merged
}

#Suggested by Mystery Keeper in "Denoise of tv-anime" thread
FUNCTION ediaa(clip a) {
return a.EEDI2(field=1).TurnRight().EEDI2(field=1).TurnLeft().spline36resize(a.width,a.height,-0.5,-0.5) }

#Anti-aliasing with contra-sharpening by Didée
FUNCTION daa(clip c) {
nn	= c.nnedi3(field=-2)
dbl   	= mt_average(selecteven(nn),selectodd(nn),U=3,V=3)
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
aa_clip = (type == 1) ? input.spline36Resize(width(input)*2,height(input)*2) : input.nnedi3_rpow2(rfactor=2,qual=2)
aa_clip = aa_clip.TurnLeft().nnedi3().TurnRight().nnedi3().spline36Resize(width(input),height(input)).MergeChroma(input)
mask = (mask==1) ? input.mt_edge("sobel",7,7,5,5).mt_inflate() : input.mt_edge("roberts",0,4,0,4).mt_inflate()

return mt_merge(input,aa_clip,mask) }