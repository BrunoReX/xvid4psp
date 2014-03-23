#avstp.dll
#fft3dgpu.dll
#fft3dfilter.dll
#RgTools.dll
#mvtools2mod.dll
#dfttestmod.dll
#WarpSharp.dll
#VagueDenoiser.dll
#GradFun2DB.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#average.dll
#AddGrainC.dll
#Dither.dll
#Dither.avsi
#mt_xxpand_multi.avsi
#Ylevels.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(1024)
 
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

blksize = 16 # для увеличения скорости обработки установите 16
overlap = blksize/2
hpad = blksize
vpad = blksize
thSAD = 320 
halfblksize = blksize/2                    
halfoverlap = overlap/2                    
halfthSAD   = thSAD/2
search = 5
lambda = 1024
thSADC = thSAD 
thSCD1 = 300
thSCD2 = 104
chroma = true
planes = chroma?4:0 
ch31 = chroma?3:1 
ch21 = chroma?2:1 

 
source = last 

# setmtmode(5)
# preNR = source.fft3dgpu(bw=16,bh=16,ow=8,oh=8,bt=1,sigma=2.5,sigma2=1.8,sigma3=2.3,sigma4=0.8,sharpen=0.3,plane=4)
# setmtmode(2)

# preNR = source.fft3dfilter(bw=32,bh=32,ow=16,oh=16,bt=1,sigma=2.0,sigma2=1.3,sigma3=1.5,sigma4=0.5,sharpen=0.3,plane=4,ncpu=1)
preNR = source.dfttest(sstring="0.0:2.0 0.18:6.8 0.36:5.6 1.0:8.0",tbsize=1,lsb=true,threads=1).ditherpost(mode=6)
psuper = preNR.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2, chroma=chroma)
ssuper = source.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, chroma=chroma, levels=1)
Rsuper = preNR.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, levels=1, chroma=chroma)
vb2 = MAnalyse(psuper, isb=true, truemotion=false, delta=2, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vb1 = MAnalyse(psuper, isb=true, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vf1 = MAnalyse(psuper,isb=false, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vf2 = MAnalyse(psuper,isb=false, truemotion=false, delta=2, blksize=blksize, overlap=overlap, search=search, chroma=chroma, lambda=lambda)
vbr2 = MRecalculate(Rsuper, vb2, overlap=halfoverlap, blksize=halfblksize, thSAD=halfthSAD, search=search, chroma=chroma)
vbr1 = MRecalculate(Rsuper, vb1, overlap=halfoverlap, blksize=halfblksize, thSAD=halfthSAD, search=search, chroma=chroma)
vfr1 = MRecalculate(Rsuper, vf1, overlap=halfoverlap, blksize=halfblksize, thSAD=halfthSAD, search=search, chroma=chroma)
vfr2 = MRecalculate(Rsuper, vf2, overlap=halfoverlap, blksize=halfblksize, thSAD=halfthSAD, search=search, chroma=chroma)
maskp1 = MMask(vfr1, kind=1, ysc=255).UtoY()
maskp2 = MMask(vfr2, kind=1).UtoY()
maskp3 = MMask(vbr1, kind=1, ysc=255).UtoY()
maskp4 = MMask(vbr2, kind=1).UtoY()
tmask = average(maskp1, 0.25, maskp2, 0.25, maskp3, 0.25, maskp4, 0.25).spline36resize(source.width, source.height)
smooth = preNR.GradFun2DB(1.01)
source2 = mt_merge(source,smooth,tmask,Y=3,U=ch31,V=ch31)
source2.MDegrain2(ssuper,vbr1,vfr1,vbr2,vfr2,thSAD=thSAD,thSADC=thSADC,thSCD1=thSCD1,thSCD2=thSCD2,plane=planes,lsb=true)

# ==== DEBANDING ====
f3kdb(16, 64, 48, 48, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)
# GradFun3 (thr=0.45, smode=0, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.06, uvar=0, soft=2)

den = DB.DitherPost(mode=-1)
  \.VagueDenoiser(method=4, nsteps=8, wavelet=2, Wiener=true, auxclip=preNR, percent=95, chromaT=1.0, wratio=0.75, threshold=0.5)
Diff = mt_makediff(source,den,U=ch31,V=ch31)
output = source.mt_makediff(Diff,U=ch31,V=ch31)
 
# MASKING
mE = mt_edge(output,"prewitt",0,255,0,0,V=1,U=1).mt_lut(expr="x 1.8 ^",U=1,V=1).removegrain(4,-1).mt_inflate(U=1,V=1) 
mL = mt_logic(tmask.invert(),mE,"min",U=1,V=1).removegrain(20,-1) 

# SHARPENING
b1c = source.MCompensate(ssuper,vbr1,thSCD1=thSCD1)
f1c = source.MCompensate(ssuper,vfr1,thSCD1=thSCD1)
Sclp = output.LSFmod(defaults="slow", preblur="ON", strength=90)
Tmax = source.mt_logic(f1c,"max",U=1,V=1).mt_logic(b1c,"max",U=1,V=1)
Tmin = source.mt_logic(f1c,"min",U=1,V=1).mt_logic(b1c,"min",U=1,V=1)
shrp = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)
sharp8 = mt_merge(output,shrp,mL,U=ch21,V=ch21)

lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out

YlevelsS(0,1.0,255,0,255,false)