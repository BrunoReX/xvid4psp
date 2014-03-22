#ColorMatrix.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#deblock.dll
#NNEDI3.dll
#degrainmedian.dll
#awarpsharp2.dll
#AddGrainC.dll
#mt_masktools-26.dll
#SmoothAdjust-ICL-x86.dll
#mvtools2mod.dll
#Bifrost.dll
#Dither.dll
#gsharp.avs
#minblur.avs
#Dither.avsi
#mt_xxpand_multi.avsi
#Contrasharpening.avs


setmtmode(2)
# setmemorymax(640)

ColorMatrix(interlaced=true, clamp=0, threads=0)
ConvertToYV12(interlaced=true)
   
o = last
x  = o.separatefields().deblock()

x0 = x.gsharp(str=0.41)
x  = x.mergeluma(x.removegrain(11).removegrain(11),0.0999).mt_lutxy(x,"x y < x 1 + x y > x 1 - x ? ?",U=2,V=2)
x  = x.mergechroma(x.blur(1))
x1 = x.mergechroma(x.lanczos4resize(x.width,x.height*2).awarpsharp2(depth=6,thresh=128,blur=2).bicubicresize(x.width,x.height, 0.5))
x2 = x.mergechroma(x.lanczos4resize(x.width,x.height*2).awarpsharp2(depth=10,thresh=192,blur=2).bicubicresize(x.width,x.height,0.5))
o = mt_merge(x0,x1,x2,Y=2,U=4,V=5).weave()  #  no mask-merging, just joining 3 channels ;-)

bob1 = o.nnedi3(field=-2)
bob2 = o.sharpen(0,1).nnedi3(field=-2)
max = bob1.mt_logic(bob1.selectevery(1,-1),"max",U=3,V=3).mt_logic(bob1.selectevery(1,1),"max",U=3,V=3)
min = bob1.mt_logic(bob1.selectevery(1,-1),"min",U=3,V=3).mt_logic(bob1.selectevery(1,1),"min",U=3,V=3)
clamped = bob2.mt_clamp(max,min,0,0,U=3,V=3)
clamped.selectevery(2,-1).trim(1,0)
# gnoise(1,0.6).gnoise(1,1.25)

  Bifrost(interlaced=false)
  
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=-1) # -1 -automatic choice, 1- SSE2 CPU, 2 - Sandy Bridge CPU

source = last

blksize = 16
overlap = blksize/2
chroma = false
planes = chroma?4:0  
tr = 2   # Temporal radius
thSAD = 320
thSAD2 = 125
chroma = false
planes = chroma?4:0

filtered = source.degrainmedian(limitY=2,limitUV=3,mode=1)
psuper = filtered.MSuper(pel=2, sharp=2, rfilter=2, chroma=chroma)
ssuper = source.MSuper(pel=2, sharp=2, levels=1, chroma=chroma)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, lambda=1200)
source.MDegrainN (ssuper, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# DeBanding
DB = last.GradFun3 (thr=0.35, smode=0, radius=12, lsb_in=true, lsb=true)

# Contrasharp
output = DB.DitherPost(mode=-1) 
sharp8 = Contrasharpening(output, source) 
lsbctr = Dither_merge16_8(DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=1) # for XviD encode  
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out 


# дл€ обработки DVD и SATRemux концертов и спортивных передач, а также низкобитрейтных телеканалов: »нтер, RenTV, RTVI c наличием блочности в исходнике
# ƒеинтерлейс, выставл€емый XviD 4PSP 5.0 и цветопередачу, ”Ѕ–ј“№!!!!



