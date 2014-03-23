#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#Bifrost.dll
#mvtools2mod.dll
#SmoothAdjust.dll
#fft3dfilter.dll
#nnedi3.dll
#Warpsharp.dll
#AddGrainC.dll
#GradFun2DB.dll
#SangNom.dll
#awarpsharp2.dll
#flash3kyuu_deband.dll
#SSE2Tools.dll
#mt_masktools-26.dll
#vinverse.dll
#maa.avs
#QTGMC.avs
#GradFun2DBmod.avs
#SmoothContrast.avsi


setmtmode(2)
# setmemorymax(640)

# vinverse() # удаление остатков гребЄнки

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0) 
  
# ==== удаление радужности и цветового шума ====
# ConvertToRGB32().CamCD(3,1).ConvertToYV12()
  Bifrost(interlaced=false)

# ApplyRange(x,y,"maa") # где x и y первый и последний кадр последовательности, на которую примен€ем антиайлиазинг по необходимости на титрах

  dct = 0 # dct=5 в случае мерцани€ по €ркости
  QTGMC(Preset="Slow",InputType=1,SLrad=3,SLMode=2,Sharpness=0.8,Edithreads=1,DCT=dct) # DeFlickering прогрессивного материала
# QTGMC(Preset="Slower",InputType=1,SLrad=3,SLMode=2,Sharpness=0.9,Edithreads=1,DCT=dct)
# QTGMC(Preset="Very Slow",InputType=1,SLrad=3,SLMode=2,Sharpness=1.0,Edithreads=1,DCT=dct)

mergechroma( awarpsharp2(depth=12,thresh=255,blur=3) )

# LEVELS
# SmoothContrast(contrast=0.02)
SmoothLevels(useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# ==== цветокоррекци€ при преобладании жЄлто-зелЄных цветов ====
# str=4
# thr=32
# SmoothCurve(Ucurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr+str)+";128-128;"+string(128+thr)+"-"+string(128+thr-str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255"\
# ,Vcurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr-str)+";128-128;"+string(128+thr)+"-"+string(128+thr+str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255")

# ==== DeBanding ====
  GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=0.4,strC=0.0,temp=50,adapt=64)
# f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=36,cb=20,cr=20,grainY=0,grainC=0)


# дл€ обработки убитых DVD и SATRemux с повышенным крупно-зернистым шумом, мерцанием по €ркости и повышенным шевелением строк (интерливом)