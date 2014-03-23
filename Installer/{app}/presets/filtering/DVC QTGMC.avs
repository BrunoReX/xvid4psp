#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Depan.dll
#DepanEstimate.dll
#RgTools.dll
#ColorMatrix.dll
#Bifrost.dll
#awarpsharp2.dll
#mvtools2.dll
#warpsharp.dll
#fft3dfilter.dll
#nnedi3.dll
#AGC.dll
#Fluxsmooth.dll
#LimitedSupport_09Jan06B.dll
#deen.dll
#SSE2Tools.dll
#mt_masktools-26.dll
#AddGrainC.dll
#GradFun2DB.dll
#QTGMC.avs
#Gradfun2dbmod 1.5.avsi
#LimitedSharpenFaster.avs


setmtmode(2)
# setmemorymax(640)

# ColorMatrix(interlaced=true)

# chroma denoised & DeRainbow of the digital camcoders
  ConvertToRGB32(interlaced=true).CamCD(7,1).converttoyv12(interlaced=true)
# fft3dfilter(bw=32,bh=32,oh=16,ow=16,sigma=2.5,sigma2=1.5,sigma3=6.0,sigma4=2.5,bt=3,plane=3,sharpen=0.3,interlaced=true,ncpu=4)
# bifrost(interlaced=true)
  
AssumeTFF() # верхнее поле первым 
# AssumeBFF()   # нижнее поле первым
QTGMC( Preset="Slower", Sharpness=0.9, tr2=2, thSAD1=400, Edithreads=1)
mergechroma( awarpsharp2(depth=12,thresh=255,blur=3) )

mdg = last
W = mdg.width()
H = mdg.height()

# ==== —табилизаци€ изображени€ ====
dxmax = 40 
dymax = 30
mdata = DePanEstimate(mdg, dxmax=dxmax, dymax=dymax, improve=true, zoommax=1.05, range=2, trust=4.0, pixaspect=1.094) # trust подобрать от 1 до 100
stab1 = DepanStabilize(mdg, data=mdata, cutoff=0.5, damping=0.9, initzoom=1.0, addzoom=true, prev=2, next=2, mirror=15, blur=50, \
                       dxmax=dxmax, dymax=dymax, zoommax=1.05, rotmax=0.5, subpixel=2, pixaspect=1.094, fitlast=0, tzoom=3.0, info=false)

pre = stab1.blur(0.6)
Super = pre.MSuper()
vectors = MAnalyse(Super,  blksize=16, overlap=4, isb=false, delta=1, truemotion=false, search=4, searchparam=6)
globalmotion = MDepan(pre, vectors, zoom=true, rot=true, pixaspect=1.094, error=15.0, info=false,    \
                      wrong=10.0, zerow=0.05, range=2, thSCD1=400, thSCD2=130) 
stab = DepanStabilize(stab1, data=globalmotion, cutoff=0.5, damping=0.9, initzoom=1.0, addzoom=true, prev=2, next=2, mirror=15, blur=300, \ 
                       dxmax=dxmax, dymax=dymax, zoommax=1.05, rotmax=0.5, subpixel=2, pixaspect=1.094, fitlast=0, tzoom=3.0, info=false)
stab.tweak(sat=1.05).crop(dxmax, dymax, -dxmax, -dymax)

Limitedsharpenfaster(ss_x=1.0,ss_y=1.0,strength=24)
mergeluma(removegrain(11,-1).removegrain(11,-1).removegrain(11,-1),0.11)

# Debanding
GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=0.3,strC=0.0,temp=50,adapt=64)
coloryuv(off_U=-0,off_V=-0).levels(0,1.0,255,0,255).Lanczos4Resize(W, H)


# Ќазначение: ƒл€ качественной обработки интерлейсного материала с средним уровнем шума с возможностью частичной стабилизации изображени€
# ѕредупреждение: деинтерлейс, и колориметрию , выставл€емые XviD 4XvidPSP 5.0 убрать!!!



