#degrainmedian.dll
#RgTools.dll
#mvtools2SVP.dll
#fft3dgpu.dll
#WarpSharp.dll
#mt_masktools-26.dll
#Average.dll
#VagueDenoiser.dll
#AddGrainC.dll
#GradFun2DB.dll
#Gradfun2dbmod 1.5.avsi
#Ylevels.avs
#DoubleFPS.avsi
#InterFrame.avsi
#LimitedSharpenFaster Mod.avs


# setmemorymax(640)

Try { InterFrame() }
 Catch(FlowPath)
 {
 FlowPath = MidStr(FlowPath, FindStr(FlowPath, "(") + 1)
 FlowPath = MidStr(FlowPath, 1, FindStr(FlowPath, "\InterFrame"))
 }

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

blksize = 16
overlap = blksize/2
hpad = blksize
vpad = blksize
lambda = 1000
thSAD = 300
thSADC = thSAD 
thSCD1 = 300
thSCD2 = 102
chroma = true
planes = chroma?4:0 
ch31 = chroma?3:1 
ch21 = chroma?2:1 
search = 5

source = last
setmtmode(5)
preNR = source.fft3dgpu(wintype=1,degrid=1,bw=16,bh=16,ow=8,oh=8,bt=4,sigma=2.75,sigma2=1.75,sigma3=2.0,sigma4=0.5,plane=4)
setmtmode(2)
preNR_super = preNR.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2, chroma=chroma)
source_super = source.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, chroma=chroma, levels=1)
vb2 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=2, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vf2 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=2, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
maskp1 = MMask(vf1, kind=1, ysc=255).UtoY()
maskp2 = MMask(vf2, kind=1).UtoY()
maskp3 = MMask(vb1, kind=1, ysc=255).UtoY()
maskp4 = MMask(vb2, kind=1).UtoY()
tmask = average(maskp1, 0.25, maskp2, 0.25, maskp3, 0.25, maskp4, 0.25).spline36resize(source.width, source.height)
smooth = preNR.GradFun2DB(1.01)
source2 = mt_merge(source,smooth,tmask,Y=3,U=ch31,V=ch31)
NR = source2.MDegrain2(source_super,vb1,vf1,vb2,vf2,thSAD=thSAD,thSADC=thSADC,thSCD1=thSCD1,thSCD2=thSCD2,plane=planes)

pD  = mt_makediff(source,smooth,U=ch31,V=ch31) 
smD = mt_makediff(source,NR,U=ch31,V=ch31)
DD  =  mt_lutxy(pD,smD,"x 128 - abs y 128 - abs < x y ?",U=ch31,V=ch31)
den = source.mt_makediff(DD,U=ch31,V=ch31)
 
# PROTECTING
threshold = 16
cutoff = 64
maxdiff = 4
rg17 = den.removegrain(17,-1)
iOB  = source.mt_lut("x "+string(cutoff)+" >= x 0 ?",U=1,V=1)
mB   = mt_makediff(iOB,rg17,U=1,V=1).mt_binarize(128+threshold,upper=false,U=1,V=1).removegrain(5,-1)
lB   = mt_lutxy(den,source,"x y - abs "+string(maxdiff)+" <= x x y - 0 < y "+string(maxdiff)+" - x ? ?",U=1,V=1)
smB  = mt_merge(den,lB,mB,U=2,V=2)

# EDGECLEANING
mP = mt_edge(smB,"prewitt",0,255,0,0,V=1,U=1)
mS = mP.mt_expand(mode=mt_square(radius=2),U=1,V=1).mt_inflate(U=1,V=1)
mD = mt_lutxy(mS,mP.mt_inflate(U=1,V=1),"x y - "+string(32)+" <= 0 x y - ?",U=1,V=1).mt_inflate(U=1,V=1).removegrain(20,-1)
smE = mt_merge(smB,Eval("smB." + "Removegrain(2,0)"),mD,luma=true,U=3,V=3)

# MASKING
mE = mt_edge(smE,"prewitt",0,255,0,0,V=1,U=1).mt_lut(expr="x 1.8 ^",U=1,V=1).removegrain(4,-1).mt_inflate(U=1,V=1) 
mL = mt_logic(tmask.invert(),mE,"min",U=1,V=1).removegrain(20,-1) 
mF = mt_logic(tmask,mE,"max",U=1,V=1).removegrain(20,-1)

# SHARPENING
b1c = source.MCompensate(source_super,vb1)
f1c = source.MCompensate(source_super,vf1)
Sclp = smE.LSFmod(defaults="slow", preblur="ON", strength=100)
# Sclp = ContraHD(smB,source,b1c,f1c,0)
Tmax = source.mt_logic(f1c,"max",U=1,V=1).mt_logic(b1c,"max",U=1,V=1)
Tmin = source.mt_logic(f1c,"min",U=1,V=1).mt_logic(b1c,"min",U=1,V=1)
shrp = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)
sL = mt_merge(smB,shrp,mL,U=ch21,V=ch21)

# ENHANCING
GFc = sL.GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=0.8,strC=0.0,temp=50,adapt=64)
Frs = mt_merge(GFc,sL,mF,luma=true,U=ch31,V=ch31)
Frs#.mergechroma(den)
YlevelsS(0,1.0,255,0,255,false)

# INTERPOLATOR FPS
# DoubleFPS( mode=2, mopro=false, bias=128, show=false)
  InterFrame(Preset="Fast", GPU=false, NewNum=50, NewDen=1, FlowPath=FlowPath)      # for PAL
# InterFrame(Preset="Fast", GPU=false, NewNum=48000, NewDen=1001, FlowPath=FlowPath) # for NTSC
# InterFrame(Preset="Fast", GPU=false, NewNum=48000, NewDen=1001, FlowPath=FlowPath) # for NTSC
  YlevelsS(0,1.0,255,0,255,false)

# Назначение: Для качественной обработки DVD, выполняет удвоение частоты выходного сигнала для режима плавного просмотра 
# Тип предварительного шумоподавителя: fft3dgpu
# Тип основного шумоподавителя: на основе векторного анализа оценки движения c масками движения на шумоподавителе MDegrain2
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленный 
# Для Win7 x64 прописать путь FlowPath="c:\Program Files (x86)\XviD4PSP 5\dlls\AviSynth\plugins\"
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,4), а вслучае ошибки вообще setmtmode(5,3) при threads=4 