#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#TTempSmooth.dll
#SmoothAdjust.dll
#mvtools2mod.dll
#AddGrainC.dll
#mt_masktools-26.dll
#medianblur.dll
#gradfun2db.dll
#vinverse.dll
#minblur.avs
#ContraHD.avs
#GradFun2DBmod.avs


# setmtmode(2)
# setmemorymax(640)

# vinverse() # удаление остатков гребёнки
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
  
# удаление радужности и цветового шума
  ConvertToRGB32().CamCD(5,1).ConvertToYV12() 

source = last
thSAD = 256
psuper = source.blur(1.0).MSuper(pel=2,sharp=2,rfilter=2,chroma=false)
ssuper = source.MSuper(pel=2,sharp=2,levels=1,chroma=false)
vf2 = MAnalyse(psuper, isb=false, blksize=16, overlap=8, delta=2, truemotion=false, search=4,chroma=false)
vf1 = MAnalyse(psuper, isb=false, blksize=16, overlap=8, delta=1, truemotion=false, search=4,chroma=false)
vb1 = MAnalyse(psuper, isb= true, blksize=16, overlap=8, delta=1, truemotion=false, search=4,chroma=false)
vb2 = MAnalyse(psuper, isb= true, blksize=16, overlap=8, delta=2, truemotion=false, search=4,chroma=false)

maskf2 = source.MMask(vf2, kind=1, ml=thSAD, gamma=0.999, Ysc=255)
maskf1 = source.MMask(vf1, kind=1, ml=thSAD, gamma=0.999, Ysc=255)
maskb1 = source.MMask(vb1, kind=1, ml=thSAD, gamma=0.999, Ysc=255)
maskb2 = source.MMask(vb2, kind=1, ml=thSAD, gamma=0.999, Ysc=255)
b = BlankClip(source,color_yuv=$008080)
mask_film = interleave(maskf2, maskf1, b, maskb1, maskb2)

NR = source.MDegrain2(ssuper,vb1,vf1,vb2,vf2,thSAD=thSAD,plane=0)
NR_super = NR.MSuper(pel=2,levels=1,chroma=false)

b2c = MCompensate(NR, NR_super, vb2, thSCD1=400)
b1c = MCompensate(NR, NR_super, vb1, thSCD1=400)
f1c = MCompensate(NR, NR_super, vf1, thSCD1=400)
f2c = MCompensate(NR, NR_super, vf2, thSCD1=400)
interleave(f2c, f1c, NR, b1c, b2c)
TTempSmooth(2,4,5,3,4,strength=3,pfclip=mask_film,fp=false,scthresh=12)
SelectEvery(5,2)

# SHARPENING
ContraHD(last,source,f1c,b1c,0)

# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# ==== цветокоррекция при преобладании жёлто-зелёных цветов ====
#str=3 # значение подобрать
#thr=32
#SmoothCurve(Ucurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr+str)+";128-128;"+string(128+thr)+"-"+string(128+thr-str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255"\
#           ,Vcurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr-str)+";128-128;"+string(128+thr)+"-"+string(128+thr+str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255") 

# ENHANCING
GradFun2DBmod(thr=1.4,thrC=1.6,str=0.5,strC=0.0,temp=50,adapt=64)


# Назначение: для качественной обработки зашумленных SATRemux
# Тип предварительного шумоподавителя: hqdn3d
# Тип основного шумоподавителя: на основе векторного анализа оценки движения c последовательным временнЫм и пространственно-временным шумоподавителем
# Тип шарпера: ContraHD
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная






