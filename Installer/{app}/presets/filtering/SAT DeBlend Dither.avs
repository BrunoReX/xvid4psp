#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#mt_masktools-26.dll
#NNEDI3.dll
#RemoveGrainSSE2.dll
#RepairSSE3.dll
#SmoothAdjust-ICL-x86.dll
#mvtools2mod.dll
#flash3kyuu_deband.dll
#ttempsmooth.dll
#Bifrost.dll
#Dither.dll
#Gradfun2db.dll
#minblur.avs
#Dither.avsi
#mt_xxpand_multi.avsi
#Contrasharpening.avs


# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
  
o = last
bob1 = o.nnedi3(field=-2)
bob2 = o.sharpen(0,1).nnedi3(field=-2)
max = bob1.mt_logic(bob1.selectevery(1,-1),"max",U=3,V=3).mt_logic(bob1.selectevery(1,1),"max",U=3,V=3)
min = bob1.mt_logic(bob1.selectevery(1,-1),"min",U=3,V=3).mt_logic(bob1.selectevery(1,1),"min",U=3,V=3)
clamped = bob2.mt_clamp(max,min,0,0,U=3,V=3)
clamped.selectevery(2,-1).trim(1,0)

setmtmode(2)
# ConvertToRGB32().CamCD(3,1).ConvertToYV12() # удаление радужности и цветового шума
  Bifrost(interlaced=false)
  
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=-1) # -1 -automatic choice, 1- SSE2 CPU, 2 - Sandy Bridge CPU

blksize = 16
overlap = blksize/2
chroma = false
planes = chroma?4:0  
tr = 2   # Temporal radius
thSAD = 256
thSAD2 = 96

rest = last
w = rest.width()
h = rest.height()
calm = rest.temporalsoften(1,255,255,32,2).merge(rest,0.25).repair(rest,1).removegrain(11)
calm = calm.temporalsoften(1,255,255,16,2).merge(calm,0.25)

LOP = calm.bicubicresize(w/4,h/4).bicubicresize(w,h,1,0)
HIP = rest.bicubicresize(w/4,h/4).bicubicresize(w,h,1,0)

HIP = mt_makediff(rest,HIP)
mix = LOP.mt_adddiff(HIP,U=2,V=2)

psuper = mix.removegrain(11).MSuper(pel=2, sharp=2, rfilter=2, chroma=chroma)
rsuper = rest.MSuper(pel=2, sharp=2, levels=1, chroma=chroma)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, lambda=1536, dct=5)
rest.MDegrainN (rsuper, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# DeBanding
# DB =  last.GradFun3(smode=0, thr=0.35, radius=12, lsb_in=true, lsb=true)
  DB =  last.f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, dither_algo=3, input_mode=1, output_mode=1)

DB.DitherPost(mode=-1)
den = mergechroma(last) 
Diff1 = mt_makediff(rest,den,U=3,V=3)
NR  = den.ttempsmoothf(maxr=5,strength=4,lthresh=3,cthresh=4)
Diff2 = mt_makediff(rest,NR,U=3,V=3)
lutxy = mt_lutxy(Diff1,Diff2,"x 128 - abs y 128 - abs < x y ?")
output = rest.mt_makediff(lutxy,U=3,V=3)

# Contrasharp
sharp8 = Contrasharpening(output, rest) 
lsbctr = Dither_merge16_8(DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=1) # for XviD encode  
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out 


# дл€ обработки проблемных исходников DVB с наличием флюктации(шевелени€) строк и повышенным мерцанием по €ркости
# убирает бленды и лесенку на контурах
# отключить деинтерлейс, выставл€емый автоматически XviD 4PSP !!!

