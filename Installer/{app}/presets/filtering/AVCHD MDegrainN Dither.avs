#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#DePan.dll
#DePanEstimate.dll
#Cnr2.dll
#fft3dgpu.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mvtools2mod.dll
#mvtools2SVP.dll
#AddGrainC.dll
#splineresize.dll
#Dither.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#minblur.avs
#ContraSharpening.avs
#Dither.avsi
#DoubleFPS.avsi
#InterFrame.avsi
#mt_xxpand_multi.avsi
#FineSharp.avs
#HighPassSharp.avs


  setmtmode(2)
# setmemorymax(1280)

Try { InterFrame() }
 Catch(FlowPath)
 {
 FlowPath = MidStr(FlowPath, FindStr(FlowPath, "(") + 1)
 FlowPath = MidStr(FlowPath, 1, FindStr(FlowPath, "\InterFrame"))
 }

RemoveGrain(0)            # No-Op filter, just to do frame request
ChangeFPS(last,last,true) # initiate a small forward buffer

# ==== удаление цветового шума камкодера ====
  setmtmode(5)
  fft3dgpu(bw=32,bh=32,oh=16,ow=16,bt=4,sigma=3.0,sigma2=2.0,sigma3=8.0,sigma4=3.0,plane=3,sharpen=0.3,mode=1,precision=2)
  setmtmode(2)
# ConvertToRGB32().CamCD(7,1).converttoyv12()  # удаление цветового шума 2-й вариант
# Cnr2("oxx",8,14,191,75,255,20,255,false)     # цветового шума 3-й вариант

# Частичная стабилизация изображения
source = last
W = 1280 # W = source.width()
H = 720  # H = source.height()
vectors = source.MSuper(pel=1).MAnalyse(blksize=16, isb=false)
globalmotion = MDepan(source, vectors, pixaspect=1.0, thSCD1=400) 
stab = DepanStabilize(source, data=globalmotion, cutoff=2.0, mirror=15, method=1, pixaspect=1.0)

dxmax=106  dymax=60
stab_reference = stab.crop(dxmax*2,dymax*2,-dxmax*2,-dymax*2).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata = DePanEstimate(stab_reference, dxmax=dxmax, dymax=dymax, trust=4.0, pixaspect=1.0) # trust подобрать от 1 до 100
DepanStabilize(stab, data=mdata, cutoff=1.0, mirror=15, dxmax=dxmax, dymax=dymax, pixaspect=1.0)
spline144resize(W, H, dxmax, dymax, -dxmax, -dymax) 

blksize = 16 
overlap = blksize/2
hpad = blksize
vpad = blksize
thSAD = 256
thSAD2 = 104
chroma = false
planes = chroma?4:0
search = 5
dct = 5
sadx264 = 3 # для CPU Intel Core2 sadx264 = 7
tr = 2   # Temporal radius

base = last
psuper = base.blur(0.8).MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2, chroma=chroma)
ssuper = base.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2, chroma=chroma, levels=1)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, chroma=chroma, truemotion=false, search=search, sadx264=sadx264, dct=dct)
base.MDegrainN (ssuper, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# ==== DeBanding ====
DB = last.f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,input_depth=16,output_depth=16,y=52,cb=36,cr=36,grainY=0,grainC=0)
# GradFun3 (thr=1.4*0.3, smode=0, radius=16, lsb_in=true, lsb=true)
# DB = last.Dither_add_grain16 (var=0.05, uvar=0, soft=2)


# ==== Sharpening ====
output = DB.DitherPost(mode=-1) 
sharp8 = output.HighPassSharp(r=0.15) 
# sharp8 = Contrasharpening(output, base) 
# sharp8 = output.FineSharp() # for 1920x1080
Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
DitherPost(mode=7,ampo=0,ampn=1)

# ==== INTERPOLATOR FPS ====
# DoubleFPS( mode=2, mopro=false, bias=128, show=false)
# InterFrame(Preset="Fast", GPU=false, NewNum=50, NewDen=1, FlowPath=FlowPath)       # for PAL
# InterFrame(Preset="Fast", GPU=false, NewNum=60000, NewDen=1001, FlowPath=FlowPath) # for NTSC

# Blackmanresize(W, H, taps=4)  
 
 
# Назначение: для устранения шума AVCHD камкодеров с возможностью интерполяции частоты кадров
# Тип шумоподавителя цветового шума камкодеров: CamCD, fft3dgpu или Cnr2
# Тип основного шумоподавителя: MDegrain2
# Тип шарпера: Contrasharpening, HighPassSharp или FineSharp
# Скорость обработки: медленная
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 
# Для Win7 x64 прописать путь для FlowPath="c:\Program Files (х86)\XviD4PSP 5\dlls\AviSynth\plugins\"