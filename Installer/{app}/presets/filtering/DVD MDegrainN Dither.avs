#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mvtools2mod.dll
#WarpSharp.dll
#dfttestmod.dll
#fft3dgpu.dll
#VagueDenoiser.dll
#GradFun2DB.dll
#AddGrainC.dll
#Dither.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#SangNom.dll
#maa.avs
#minblur.avs
#Dither.avsi
#mt_xxpand_multi.avsi
#ContraSharpening.avs
#LimitedSharpenFaster Mod.avs

setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
 
# ApplyRange(x,y,"maa") # где x и y первый и последний кадр последовательности, на которую применяем антиайлиазинг по необходимости на титрах

# ==== Denoiced =====
blksize = 16
overlap = blksize/2
chroma = true
planes = chroma?4:0  
ch31 = chroma?3:1 
tr = 3   # Temporal radius
thSAD = 400
thSAD2 = 150

source = last

setmtmode(5)
preNR = source.fft3dgpu(bw=16,bh=16,ow=8,oh=8,bt=1,sigma=2.5,sigma2=1.8,sigma3=2.3,sigma4=0.8,sharpen=0.3,plane=4)
setmtmode(2)

# preNR = source.dfttest(sigma=8,tbsize=1,lsb=true,threads=1).ditherpost(mode=6)
smooth = preNR.GradFun2DB()
psuper = preNR.MSuper(pel=2, sharp=2, rfilter=2, chroma=chroma)
ssuper = source.MSuper(pel=2, sharp=2, chroma=chroma, levels=1)
multi_vec = MAnalyse(psuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, chroma=chroma, truemotion=true, search=5)
source.MDegrainN (ssuper, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# ==== DEBANDING ====
f3kdb(16, 56, 36, 36, 0, 0, dynamic_grain=false,keep_tv_range=true,input_mode=1, output_mode=1)
# GradFun3 (thr=0.45, smode=0, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.07, uvar=0, soft=2)

den = DB.DitherPost(mode=-1).\
      VagueDenoiser(method=4, nsteps=8, wavelet=2, Wiener=true, auxclip=smooth, percent=95, chromaT=1.0, wratio=0.75, threshold=0.5)
Diff = mt_makediff(source,den,U=ch31,V=ch31)
output = source.mt_makediff(Diff,U=ch31,V=ch31)

# sharp8 = Contrasharpening(output, source)
  sharp8 = output.LSFmod(defaults="slow", preblur="ON", strength=130)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
# lsb_out = lsbctr.DitherPost(mode=6,ampn=1,ampo=1) # for XviD 
lsb_out = lsbctr.DitherPost(mode=7,ampn=1,ampo=0) # for x264
lsb_out


# Назначение: качественный пресет для создания DVDRip 
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrainN + Dither
# Тип шарпера: Contrasharpening
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная

