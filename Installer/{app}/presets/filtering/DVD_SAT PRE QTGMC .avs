#ColorMatrix.dll
#RgTools.dll
#deblock.dll
#dctfilter.dll
#mvtools2.dll
#fft3dfilter.dll
#SmoothAdjust.dll
#NNEDI3.dll
#Cnr2.dll
#awarpsharp2.dll
#AddGrainC.dll
#flash3kyuu_deband.dll
#SSE2Tools.dll
#AutoAdjust.dll
#mt_masktools-26.dll
#gsharp.avs
#QTGMC.avs
#Deblock_QED_MT2.avs
#SmoothContrast.avsi


# setmtmode(2)
# setmemorymax(640)

ColorMatrix(interlaced=true, clamp=0, threads=0)
ConvertToYV12(interlaced=true)
   
o = last
x  = o.separatefields().deblock(30)

x0 = x.gsharp(str=0.51)
x  = x.mergeluma(x.removegrain(20).removegrain(20),0.0999).mt_lutxy(x,"x y < x 1 + x y > x 1 - x ? ?",U=2,V=2)
x  = x.mergechroma(x.blur(1))
x1 = x.mergechroma(x.lanczos4resize(x.width,x.height*2).awarpsharp2(depth=6,thresh=128,blur=2).bicubicresize(x.width,x.height, 0.5))
x2 = x.mergechroma(x.lanczos4resize(x.width,x.height*2).awarpsharp2(depth=10,thresh=192,blur=2).bicubicresize(x.width,x.height,0.5))
mt_merge(x0,x1,x2,Y=2,U=4,V=5).weave()  #  no mask-merging, just joining 3 channels ;-)

AssumeTFF()
# AssumeBFF()
QTGMC(Preset="Slow", Sharpness=0.6, TR2=2, FPSDivisor=2, Edithreads=1)
mergechroma( last) 

AutoAdjust(auto_gain=true, dark_limit=1.5, bright_limit=1.5, gamma_limit=1.35, input_tv=true, output_tv=true)

gnoise(1, 0.7).gnoise(1, 1.25)
 
SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code 

# ==== цветокоррекция при преобладании жёлто-зелёных цветов ====
# str=4
# thr=32
# SmoothCurve(Ucurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr+str)+";128-128;"+string(128+thr)+"-"+string(128+thr-str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255"\
#           ,Vcurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr-str)+";128-128;"+string(128+thr)+"-"+string(128+thr+str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255") 

# Debanding
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)


# для обработки DVD и SATRemux концертов и спортивных передач, а также низкобитрейтных телеканалов: Интер, RenTV, RTVI c наличием блочности в исходнике
# Деинтерлейс, выставляемый XviD 4PSP 5.0 и цветопередачу, УБРАТЬ!!!!



