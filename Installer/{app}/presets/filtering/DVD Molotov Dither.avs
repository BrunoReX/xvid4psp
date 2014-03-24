#avstp.dll
#RgTools.dll
#degrainmedian.dll
#fft3dgpu.dll
#mvtools2mod.dll
#WarpSharp.dll
#AddGrainC.dll
#Gradfun2DB.dll
#mt_masktools-26.dll
#dither.dll
#Dither.avsi
#mt_xxpand_multi.avsi
#Ylevels.avs
#Gradfun2DBmod 1.5.avsi
#LimitedSharpenFaster Mod.avs

# setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
tr = 3
source = last
preNR = source.degrainmedian(limitY=3,limitUV=3,mode=1)
psuper = preNR.MSuper(pel=2, sharp=2, rfilter=4)
ssuper = source.MSuper(pel=2, sharp=2, levels=1)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=8, overlap=4, chroma=true, truemotion=true, search=5)
den = source.MDegrainN (ssuper, multi_vec, tr, thSAD=400, thSAD2=150, lsb=true)

f = den.DitherPost(mode=-1)
# setmtmode(5)
output = f.fft3dgpu(bw=24,bh=24,ow=12,oh=12,bt=3,sigma=2.5,sigma2=1.75,sigma3=2.5,sigma4=2,plane=4)
# setmtmode(2)

sharp = output.LSFmod(defaults="slow", preblur="ON", strength=100)
DB8 = sharp.Gradfun2DBmod(thr=1.51,thrC=1.8,mode=2,str=1.0,strC=0.0,temp=50,adapt=64)
lsbctr = Dither_merge16_8 (den,DB8.Dither_convert_8_to_16(), DitherBuildMask(DB8, output))
lsb_out = lsbctr.DitherPost(mode=6,ampn=1, ampo=1) 
lsb_out

YlevelsS(0,1.0,255,0,255,false)


# Назначение: для зашумленного DVD или DVC
# Тип предварительного шумоподавителя: degrainmedian 
# Тип основного шумоподавителя: на основе векторного анализа оценки движения: 1-й этап на MDegrainN, 2-й - FFT3Dfilter обработка яркостного сигнала,deen-обработка цветоразностных
# Тип шарпера: LSFmod 
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленный 
