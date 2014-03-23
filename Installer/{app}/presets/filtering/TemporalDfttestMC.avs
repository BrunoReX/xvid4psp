#RgTools.dll
#mvtools2.dll
#degrainmedian.dll
#dfttest.dll
#MaskTools.dll
#mt_masktools-26.dll
#Gradfun2db.dll
#AddGrainC.dll
#Gradfun2dbmod 1.5.avsi
#TemporalDfttestMC.avs

setmtmode(2)
# setmemorymax(768)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# dfttest-related options
#Y = default(Y, true)
#U = default(U, true)
#V = default(V, true)
#ftype = default(ftype, 0)
#sigma = default(sigma, 16.0)
#sigma2 = default(sigma2, 16.0)
#pmin = default(pmin, 0.0)
#pmax = default(pmax, 500.0)
#sbsize = default(sbsize, 12)
#smode = default(smode, 1)
#sosize = default(sosize, 9)
#tbsize = default(tbsize, 5)
#tmode = default(tmode, 0)
#tosize = default(tosize, 0)
#swin = default(swin, 0)
#twin = default(twin, 7)
#sbeta = default(sbeta, 2.5)
#tbeta = default(tbeta, 2.5)
#zmean = default(zmean, true)
#f0beta = default(f0beta, 1.0)

# mvtools-related options
#mcradius = default(mcradius, 2)
#mdg = default(mdg, false)
#pp = default(pp, 1)
#ppstr = default(ppstr, (pp>=2) ? 16 : (pp==1) ? 1 : 9001)
#mdgthSAD = default(thSAD, 400)
#thSAD = default(thSAD, 10000)
#thSCD1 = default(thSCD1, 400)
#thSCD2 = default(thSCD2, 130)
#blksize = default(blksize, 8)
#pel = default(pel, 2)
#overlap = default(overlap, 2)
#dct = default(dct, 0)
#search = default(search, 5)

Temporal_DfttestMC(sigma=3.2,sigma2=4.0,tbsize=3,f0beta=1.0,pp=1,ppstr=3,mdg=true,mcradius=2,blksize=16,pel=2,thSAD=180,thSCD1=220,thSCD2=32)
Gradfun2dbmod(thr=1.51,thrC=1.8,mode=2,str=0.8,temp=90)

# Назначение: Для очень качественной обработки любого типа зушумленного видео методом подстройки параметров
# Тип предварительного шумоподавителя: degrainmedian
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на базе скрипта TemporalDfttestMC 
# Тип шарпера: ContraSharpening
# Наличие фильтра DeBanding по умолчанию: отсутствует
# Скорость обработки: очень медленная  