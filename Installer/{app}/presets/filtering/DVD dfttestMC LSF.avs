#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#degrainmedian.dll
#dfttest.dll
#MaskTools149.dll
#deen.dll
#WarpSharp.dll
#mt_masktools-26.dll
#Gradfun2db.dll
#AddGrainC.dll
#Gradfun2dbmod.avs
#dfttestMC.avs
#Ylevels.avs
#HQDering.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
setmemorymax(768)
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)

dfttestMC(sigma=4.0,tbsize=3,f0beta=1.0,pp=1,ppstr=3,mdg=true,mcradius=2,blksize=8,pel=2,thSAD=300,thSCD1=320,thSCD2=90)
LSFmod(defaults="slow", preblur="ON", strength=90)#.HQDering() 
Gradfun2dbmod(thr=1.4,thrC=1.6,str=0.3,temp=50,adapt=64) # сглаживает градиенты цветовых переходов, но излишне расходует битрейт
YlevelsS(0,1.0,255,0,255,false) 
   
   
# Назначение: Для качественной обработки DVD
# Тип предварительного шумоподавителя: degrainmedian
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на базе скрипта dfttestMC
# Тип шарпера: LSFmod 
# Наличие фильтра DeBanding по умолчанию: включено
# Скорость обработки: медленная                      
