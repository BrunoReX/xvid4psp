#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Cnr2.dll
#RgTools.dll
#mvtools2.dll
#Deblock.dll
#DctFilter.dll
#WarpSharp.dll
#mt_masktools-26.dll
#VagueDenoiser.dll
#degrainmedian.dll
#aWarpsharp2.dll
#Msharpen.dll
#MipSmooth.dll
#descratch.dll
#TDeint.dll
#nnedi2.dll
#TMM.dll
#msharpen.dll
#DeFreq.dll
#awarpsharp2.dll
#ChromaShift.dll
#Gradfun2db.dll
#AddGrainC.dll
#mipsmooth.dll
#Gradfun2dbmod.avs
#Deblock_QED_MT2.avs
#RemoveColorBleeding.avs
#SeeSaw.avs
#Soothe.avs
#deVCR.avs
#DeRainbow.avs
#Fizzkiller.avs
#LimitedSharpenfaster.avs

# setmtmode(2)
# setmemorymax(768)

# Деинтерлейс
#AssumeTFF()
#AssumeBFF()
#TDeint(edeint=nnedi2(),emask=TMM())

# Cnr2("oxx",8,16,191,100,255,32,255,false) # подавление цветового шума VHS
# Cnr2("xxx", 4, 5, 255)
  
ConvertToRGB32().CamCD(20,1).converttoyv12()

DeRainbow(10)

# Применить для удаления блочности
# Deblock_QED(uv=3) 
# DeFreq(fx=30,fy=-40)

# Удалить Colorbleeding (размытость цветовых контуров)
 RemoveColorBleeding() 
 
# Удалить VHS colorshift (цветовой сдвиг)
Vshift=2  # 2 пикселя на ленте 
Hshift=0 
mergechroma(last.awarpsharp2(depth=16,thresh=255,blur=3).crop(Hshift,Vshift,0,0, align=true).addborders(0,0,Hshift,Vshift)) 

# Удаление широких горизонтальных полос и царапин
# turnleft() 
# descratch(mindif=12, maxgap=170, minlen=25, blurlen=5, keep=100, border=0, maxangle=1, modey=2)
# turnright()

# Убираем горизонтальные линии нарезки VHS
  deVCR(last,30)

source = last
preNR = source.degrainmedian(mode=1,limity=3,limituv=4)
preNR_super = preNR.MSuper(pel=2, sharp=2, rfilter=2)
source_super = source.MSuper(pel=2, sharp=2, levels=1)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=1, blksize=16, overlap=4, lambda=2000, search=3)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=1, blksize=16, overlap=4, lambda=2000, search=3)
source.MDegrain1(source_super,vb1,vf1,thSAD=250,thSCD1=300,thSCD2=90,plane=3)
MDegrain1(source_super,vb1,vf1,thSAD=250,thSCD1=300,thSCD2=90,plane=0)

# Fizzkiller
NR = last.Fizzkiller(degrain=2, blksize=16, chroma=false) 

# Повышение резкости 
a = NR.degrainmedian(mode=2,limity=5,limituv=6).VagueDenoiser(threshold=0.8, method=1, nsteps=6, chromaT=0.8) 
SeeSaw(NR, a, NRlimit=3, NRlimit2=4, Sstr=1.5, Slimit=5, Spower=5, Sdamplo=6, Szp=16) 
dull = last
sharp = dull.LimitedSharpenfaster(ss_x=3.0,ss_y=3.0,smode=3,strength=270,overshoot=3) 
#sharp = dull.Limitedsharpenfaster(strength=300,overshoot=0, Smode=3, soft=-1) 
Soothe(sharp,dull,15)
Gradfun2dbmod(thr=1.4,thrC=1.6,str=0.8,temp=50,adapt=64)

# Пресет предназначен для обработки старых VHS видеокассет

