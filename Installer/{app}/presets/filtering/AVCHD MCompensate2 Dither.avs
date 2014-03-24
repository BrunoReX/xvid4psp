#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#mt_masktools-26.dll
#DePan.dll
#DePanEstimate.dll
#avstp.dll
#Cnr2.dll
#AddGrainC.dll
#fft3dgpu.dll
#medianblur.dll
#dfttestmod.dll
#mvtools2mod.dll
#flash3kyuu_deband.dll
#dither.avsi
#Dither.dll
#HighPassSharp.avs
#Dither.avsi
#mt_xxpand_multi.avsi
#minblur.avs
#ContraHD.avs
#GradFun2DBmod 1.5.avsi


# setmtmode(2)
# setmemorymax(1280)

  RemoveGrain(0)            # No-Op filter, just to do frame request
  ChangeFPS(last,last,true) # initiate a small forward buffer
  RemoveGrain(0)            # not sure if this 2nd one is needed. But surely it doesn't hurt

# ==== удаление цветового шума камкодера ====
# setmtmode(5)
# fft3dgpu(wintype=1,bt=1,bw=32,bh=32,oh=16,ow=16,degrid=1,sigma=3.0,sigma2=2.0,sigma3=8.0,sigma4=3.0,plane=3,mode=1,precision=2,sharpen=0.3)
# setmtmode(2)
# ConvertToRGB32().CamCD(5,1).converttoyv12()  # удаление цветового шума 2-й вариант
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
crop(dxmax, dymax, -dxmax, -dymax)
Blackmanresize(W, H, taps=4) 

# ==== Denoiced ====
base = last
str = 0.8
blendv = mt_lut(base, Y=Round(str*255), U=-128,V=-128)
psuper = base.blur(0.6).MSuper(pel=1, sharp=2, rfilter=2)
ssuper = base.MSuper(pel=1, sharp=2, rfilter=2, levels=1)
b2v = MAnalyse(psuper,isb=true, delta= 2, blksize=16, overlap=8, truemotion=true, search=5, sadx264=3)
b1v = MAnalyse(psuper,isb=true, delta= 1, blksize=16, overlap=8, truemotion=true, search=5, sadx264=3)
f1v = MAnalyse(psuper,isb=false,delta= 1, blksize=16, overlap=8, truemotion=true, search=5, sadx264=3)
f2v = MAnalyse(psuper,isb=false,delta= 2, blksize=16, overlap=8, truemotion=true, search=5, sadx264=3)
cf2 = MCompensate(base, ssuper, f2v, thSAD=135, thSCD1=300)
cf1 = MCompensate(base, ssuper, f1v, thSAD=135, thSCD1=300)
cb1 = MCompensate(base, ssuper, b1v, thSAD=135, thSCD1=300)
cb2 = MCompensate(base, ssuper, b2v, thSAD=135, thSCD1=300)
interleave(cb2, cb1, base, cf1, cf2)
dfttest(sigma=6.0, sbsize=12, sosize=8, tbsize=5, lsb=true, threads=1)
# interleave(cb2, cb1, source.MDegrain2(super,b1v,f1v,b2v,f2v,thSAD=96), cf1, cf2)
# dfttest(sigma=3.0, sbsize=12, sosize=8, tbsize=5, lsb=true, threads=1)
Selectevery(5,2)

# ==== DeBanding ====
  DB = last.f3kdb(20, 52, 36, 36, 0, 0, input_mode=1, output_mode=1)#.Dither_limit_dif16(last, thr=0.35, Y=3, U=3, V=3)
# GradFun3 (thr=1.4*0.3, smode=0, radius=16, lsb_in=true, lsb=true)
# DB = last.Dither_add_grain16 (var=0.08, uvar=0, soft=2)

# Soft Sharpening
den = DB.DitherPost(mode=-1)
output = mt_merge(den, base, blendv, luma=true) 
sharp8 = output.HighPassSharp(r=0.15)
# sharp8 = ContraHD(output, base, cf1, cb1, 0)

lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
# lsb_out = lsbctr.DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out 


# Назначение: для устранения шума AVCHD
# Тип предварительного шумоподавителя: ccd_sse2, fft3dfilter или Cnr2
# Тип основного шумоподавителя: MCompensate + fft3dgpu
# Тип шарпера: ContraHD, HighPassSharp 
# Скорость обработки: средняя
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,2) и рекомендуемое ограничение потребления памяти при threads=4 
