#avstp.dll
#degrainmedian.dll
#RgTools.dll
#mvtools2mod.dll
#fft3dgpu.dll
#AvsFilterNet.dll
#WarpSharp.dll
#average.dll
#fft3dfilter.dll
#VagueDenoiser.dll
#mt_masktools-26.dll
#AddGrainC.dll
#GradFun2DB.dll
#Ylevels.avs
#Chubbyrain2.avs
#Gradfun2DBMod 1.5.avsi
#LimitedSharpenFaster Mod.avs


# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

blksize = 16
overlap = blksize/2
hpad = blksize
vpad = blksize
lambda = 1600
thSAD = 400
thSADC = thSAD 
thSCD1 = 400
thSCD2 = 115
chroma = true
planes = chroma?4:0 
ch31 = chroma?3:1 
ch21 = chroma?2:1 
search = 5

 source = last
 #setmtmode(5)
  preNR = source.fft3dgpu(bw=16,bh=16,ow=8,oh=8,bt=4,sigma=3.0,sigma2=2.0,sigma3=2.5,sigma4=1.0,sharpen=0.3,plane=4)
# preNR = source.NLMeansCL(A=4, S=2, B=1, aa=1.0, h=1.8, plane=4) # for VC NVIDIA
# setmtmode(2)
# preNR = source.fft3dfilter(bw=32,bh=32,ow=16,oh=16,bt=1,sigma=2.75,sigma2=2.0,sigma3=1.75,sigma4=0.8,sharpen=0.3,plane=4,ncpu=1)
preNR_super = preNR.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2, chroma=chroma)
source_super = source.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, chroma=chroma, levels=1)
vb3 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=3, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vb2 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=2, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vf2 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=2, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vf3 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=3, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
maskp1 = MMask(vf1, kind=1, ysc=255).UtoY()
maskp2 = MMask(vf2, kind=1).UtoY()
maskp3 = MMask(vf3, kind=1).UtoY()
maskp4 = MMask(vb1, kind=1, ysc=255).UtoY()
maskp5 = MMask(vb2, kind=1).UtoY()
maskp6 = MMask(vb3, kind=1).UtoY()
Frames = 3
divdr=1/(Frames * 2.0)
tmask = average(maskp1,divdr,maskp2,divdr,maskp3,divdr,maskp4,divdr,maskp5,divdr,maskp6,divdr).spline36resize(source.width,source.height)
smooth = preNR.GradFun2DB(1.01)
source2 = mt_merge(source,smooth,tmask,Y=3,U=ch31,V=ch31)
KEEP = "0.23" # какое количество HiFreq-зерна надо сохранить. 0.0=ничего не сохраняем, 1.0=оставляем всё. !! String -это заданная величина !!
NR = source2.MDegrain3(source_super,vb1,vf1,vb2,vf2,vb3,vf3,thSAD=thSAD,thSADC=thSADC,thSCD1=thSCD1,thSCD2=thSCD2,plane=planes)
   \. VagueDenoiser(method=4, nsteps=8, wavelet=2, Wiener=true, auxclip=preNR, percent=95, chromaT=1.0, wratio=0.75, threshold=0.6)
   \. mt_adddiff(mt_makediff(source,smooth,U=ch31,V=ch31).mt_lut("x 128 - abs 1 < x x 128 - abs 1 - "+KEEP+" * x 128 - x 128 - abs 0.001 + / * 128 + ?",U=ch21,V=ch21),U=ch31,V=ch31)

Diff = mt_makediff(source,NR,U=ch31,V=ch31)
den = source.mt_makediff(Diff,U=ch31,V=ch31)

# EDGECLEANING
mP = mt_edge(den,"prewitt",0,255,0,0,V=1,U=1)
mS = mP.mt_expand(mode=mt_square(radius=2),U=1,V=1).mt_inflate(U=1,V=1)
mD = mt_lutxy(mS,mP.mt_inflate(U=1,V=1),"x y - "+string(28)+" <= 0 x y - ?",U=1,V=1).mt_inflate(U=1,V=1).removegrain(20,-1)
smE = mt_merge(den,Eval("den." + "Removegrain(2,2)"),mD,luma=true,U=3,V=3)

# MASKING
mE = mt_edge(smE,"prewitt",0,255,0,0,V=1,U=1).mt_lut(expr="x 1.8 ^",U=1,V=1).removegrain(4,-1).mt_inflate(U=1,V=1) 
mL = mt_logic(tmask.invert(),mE,"min",U=1,V=1).removegrain(20,-1) 
mF = mt_logic(tmask,mE,"max",U=1,V=1).removegrain(20,-1)

# SHARPENING
b1c = source.MCompensate(source_super,vb1)
f1c = source.MCompensate(source_super,vf1)
Sclp = smE.LSFmod(defaults="slow", preblur="ON", strength=140)
Tmax = source.mt_logic(f1c,"max",U=1,V=1).mt_logic(b1c,"max",U=1,V=1)
Tmin = source.mt_logic(f1c,"min",U=1,V=1).mt_logic(b1c,"min",U=1,V=1)
shrp = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)
sL = mt_merge(smE,shrp,mL,U=ch21,V=ch21)

# ENHANCING
GFc = sL.GradFun2DBmod(thr=1.6,thrC=1.8,mode=2,str=1.0,strC=0.0,temp=50,adapt=64)
Frs = mt_merge(GFc,sL,mF,luma=true,U=ch31,V=ch31)
Frs#.mergechroma(den)
YlevelsS(0,1.0,255,0,255,false)
 
# -- visualisations --
# stackvertical(source,last)
# interleave(source,last)

# Назначение: Для очень качественной обработки DVD с повышенным уровнем шума
# Тип предварительного шумоподавителя: fft3dgpu
# Тип основного шумоподавителя: на основе векторного анализа оценки движения c масками движения на шумоподавителе MDegrain3
# Тип шарпера: LSFmod  
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленный 
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,3), а вслучае ошибки вообще setmtmode(5,2) при threads=4 