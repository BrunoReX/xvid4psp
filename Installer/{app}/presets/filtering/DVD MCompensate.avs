#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#fft3dgpu.dll
#flash3kyuu_deband.dll
#mt_masktools-26.dll
#Warpsharp.dll
#medianblur.dll
#AddGrainC.dll
#GradFun2DB.dll
#minblur.avs
#Gradfun2dbmod.avs
#ContraHD.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

source = last
blksize = 16 # для скорости обработки задайте 16
overlap = blksize/2
chroma = true
lambda = 1024
planes = chroma?4:0
search = 5

psuper = source.blur(1.0).MSuper(pel=2, sharp=2, chroma=chroma)
ssuper = source.MSuper(pel=2, sharp=2, chroma=chroma, levels=1)
vb2 = MAnalyse(psuper, isb=true, truemotion=false, delta=2, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vb1 = MAnalyse(psuper, isb=true, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vf1 = MAnalyse(psuper,isb=false, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
cf1 = MCompensate(source, ssuper, vf1, thSCD1=300)
cb1 = MCompensate(source, ssuper, vb1, thSCD1=300)
cb2 = MCompensate(source, ssuper, vb2, thSCD1=300)

# Use the vectors to create motion and static masks, we use these for prefilter and sharpening masks
maskstar = source.mt_binarize(upper=false)
maskmotion1 = source.mmask(kind=0, vb1, gamma=1, ml=130)
maskmotion1 = mt_adddiff(maskmotion1, mt_makediff(maskmotion1,source))
maskmotion2 = source.mt_motion(thy1=5,thy2=10,thc1=5,thc2=10,u=3,v=3).mt_lut(expr="x 255 == x 156 - 0 ?")
maskmotion  =  mt_lutxy(maskmotion1,maskmotion2,expr="x 0 == 0 x y < y x ? ?") 
maskstatic  = mt_invert(maskmotion)

interleave(cb2, cb1, source, cf1)
setmtmode(5)
fft3dgpu(bw=16,bh=16,oh=8,ow=8,sigma=1.75,sigma2=1.5,sigma3=2.3,sigma4=0.8,bt=4,plane=planes,mode=1,precision=2)
setmtmode(2)
selectevery(4,2)
output = mt_merge(last, source, maskstar)
# don't sharpen motion, dark area or starfield areas
maskstatic = mt_lutxy(output,maskstatic,"x 32 < 0 y ?")

# SHARPENING
# Sclp = ContraHD(output,source,cf1,cb1,3) 
Sclp = output.LSFmod(defaults="slow", preblur="ON", strength=80)
Tmax = source.mt_logic(cf1,"max",U=1,V=1).mt_logic(cb1,"max",U=1,V=1)
Tmin = source.mt_logic(cf1,"min",U=1,V=1).mt_logic(cb1,"min",U=1,V=1)
shrp = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)
mt_merge(output, shrp, maskstatic)

# DeBanding
  f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)
# GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=0.3,strC=0.0,temp=50,adapt=64)


# Назначение: Один из самых качественных пресетов для обработки DVD 
# Тип основного шумоподавителя: на основе векторного анализа оценки движения c масками движения и конечным шумоподавителем MCompensate+fft3dgpu 
# Тип шарпера: ContraHD или LSFmod
# Наличие фильтра DeBanding по умолчанию: GradFun2DBmod включен
# Скорость обработки: средняя

