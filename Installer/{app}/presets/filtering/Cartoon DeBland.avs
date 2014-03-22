#RemoveGrainSSE2.dll
#RepairSSE2.dll
#ColorMatrix.dll
#TDeInt.dll
#mvtools2.dll
#TDeint.dll
#TIVTC.dll
#fft3dgpu.dll
#flash3kyuu_deband.dll
#medianblur.dll
#mt_masktools-26.dll
#minblur.avs
#vinverse.avs
#srestore.avs
#ContraHD.avs



SetMTmode(2)
# setmemorymax(640)

vinverse()
srestore(omode=2, cache=10)
tdecimate()

source = last
psuper = source.blur(0.8).MSuper(pel=2, sharp=2, rfilter=2)
ssuper = source.MSuper(pel=2, sharp=2, levels=1)
b2v = MAnalyse(psuper,isb=true, truemotion=false,delta=2,blksize=16,overlap=8,search=4)
b1v = MAnalyse(psuper,isb=true, truemotion=false,delta=1,blksize=16,overlap=8,search=4)
f1v = MAnalyse(psuper,isb=false,truemotion=false,delta=1,blksize=16,overlap=8,search=4)
cf1 = MCompensate(source, ssuper, f1v, thSCD1=400)
cb1 = MCompensate(source, ssuper, b1v, thSCD1=400)
cb2 = MCompensate(source, ssuper, b2v, thSCD1=400)
interleave(cb2, cb1, source, cf1)
setmtmode(5)
fft3dgpu(bw=16,bh=16,ow=8,oh=8,bt=4,sigma=2.0,sigma2=2.5,sigma3=3.5,sigma4=3.0,plane=4,mode=1,precision=2) 
setmtmode(2)
selectevery(4,2)

# SHARPENING
ContraHD(last,source,cf1,cb1,0)

# DeBanding
f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)


# для обработки старых советских грузинских мультфильмов при обратном трансфере NTSC=>PAL
# Выбрать тип деинтерлейса TFM : TFM(order=-1, mode=1, pp=6, slow=1, cthresh=6, MI=35)