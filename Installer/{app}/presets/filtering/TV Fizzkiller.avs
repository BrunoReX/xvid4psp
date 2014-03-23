#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#RemoveDirt.dll
#mvtools2.dll
#vinverse.dll
#FFT3Dfilter.dll
#SmoothAdjust.dll
#mt_masktools-26.dll
#deen.dll
#warpsharp.dll
#FluxSmooth.dll
#Defreq.dll
#Deblock.dll
#dctfilter.dll
#AddGrainC.dll
#GradFun2DB.dll
#LGhost.dll
#RemoveDirtMC_03.avs
#Deblock_QED_MT2.avs
#Fizzkiller.avs
#GradFun2DBmod 1.5.avsi
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(640)

vinverse() # удаление остатков гребЄнки

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# ==== удаление наводок ====
# метод 1
# soft = last.defreq(cutx=5,cuty=5,plane=0)#.defreq(cutx=10,cuty=10,plane=1).defreq(cutx=10,cuty=10,plane=2)
# overlay(last,soft,opacity=0.2)

# метод 2
o = last
spline36resize(240,height)
x = mt_luts(last,last,mode="median",pixels="-1 0 0 0 1 0",yexpr="y",uexpr="y",vexpr="y",U=3,V=3)
mt_makediff(last,x,U=3,V=3).spline36resize(o.width,height)
mt_lut(expr="x 128 - abs 1 x 128 - abs 6 / 4 ^ + / x 128 - x 128 - abs 0.0001 + / * 128 +",U=3,V=3)
o.mt_makediff(last,U=3,V=3)

# ==== удаление радужности и цветового шума ====
ConvertToRGB32().CamCD(12,1).ConvertToYV12()

# ==== удаление €ркостной наводки ====
# LGhost(2, 4, 12, 2, 7, 10, 1, -4, -15, 1, -7, -5)  # подобрать параметры начина€ с mode
#### Sintax: LGhost(clip, mode0, shift0, intensity0, ... , mode17, shift17, intensity17)
#### mode 0 : (default), 1 : 2 : 3 : 4 
#### shift (-clip.width Вclip.width, default 0)   
#### intensity (-128 В 127, default 0)

# LEVELS
SmoothCurve(Ycurve="0-0;8-0;244-255;255-255", Ucurve="0-0;8-0;248-255;255-255", Vcurve="0-0;8-0;248-255;255-255", interp=0) 
SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# Deblock_QED(uv=3) # деблокинг подключить в случае блочности исходника

source=last
filtered = source.RemoveDirt(false,10)
# filtered = RemoveDirtMC(source,40)

dark   = 32
bright = 196
mask1  = mt_lut(source,"x "+string(dark)+" < 255 x "+string(bright)+" > 255 0 ? ?",U=1,V=1).removegrain(19,-1,-1)

min   = 16
max   = 255
mask2 = mt_lutxy(source,filtered,"x y - abs "+string(min)+" < 0 x y - abs "+string(max)+" > 0 255 ? ?",U=1,V=1).removegrain(19,-1,-1)
mt_merge(source,filtered,mt_logic(mask1,mask2,"min"),luma=true)

Fizzkiller(degrain=2,blksize=16,thSAD=300,thSCD1=450,chroma=true)

# SHARPENING
LSFmod(defaults="fast", strength=100)

# DeBanding
GradFun2DBmod(thr=1.6,thrC=2.0,mode=2,str=1.0,strC=0.0,temp=50,adapt=64)


# Ќазначение: прекрасный пресет дл€ обработки сильно зашумленного TV сигнала 
# “ип основного шумоподавител€: на основе векторного анализа оценки движени€ на шумоподавителе Fizzkiller и FFT3Dfilter
# —корость обработки: медленна€       



