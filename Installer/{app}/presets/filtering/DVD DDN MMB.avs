#avstp.dll
#FluxSmooth.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mt_masktools-26.dll
#mvtools2mod.dll
#NNEDI3.dll
#VagueDenoiser.dll
#dither.dll
#AddGrainC.dll
#GradFun2DB.dll
#Gradfun2DBMod 1.5.avsi
#sbr.avs
#MinMapBlur.avs


setmtmode(2)
# setmemorymax(768)

# o = last
# nnedi3(field=-2,nsize=0,nns=3)
# merge(selecteven(),selectodd())
# D1 = mt_makediff(o,last)
# D2 = mt_makediff(last,last.removegrain(11,-1))
# last.mt_adddiff(D2.repair(D1,13,-1).mt_lutxy(D2,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?"),U=2,V=2)

source = last
x1   = source.fluxsmootht(3)
x2   = source.removegrain(11,-1)
x22  = source.mt_makediff(mt_makediff(x2,x2.removegrain(20,-1))).MinMapBlur()
x222 = x22.removegrain(4,-1)
x222 = x222.sbr().merge(x222,0.51)
enhD = mt_lutxy(x22,x222,"128 x y - abs 2 / 1 1.6 / ^ 2.51 * x y - x y - abs 0.1 + / * +",U=2,V=2)
enh  = source.mt_adddiff(enhD,U=2,V=2)

BLK  = 16 # 8
ME1  = 5
ME2  = 2  # 8
_DCT = 5

sup1 = x1.removegrain(11).MSuper(hpad=16, vpad=16, pel=2, sharp=0)
sup2 = enh.MSuper(hpad=16, vpad=16, pel=2, levels=1,sharp=1)
bv2  = MAnalyse(sup1,delta=2,truemotion=false,global=true,blksize=BLK,overlap=BLK/2,search=ME1,searchparam=ME2,isb=true, dct=_DCT)
bv1  = MAnalyse(sup1,delta=1,truemotion=false,global=true,blksize=BLK,overlap=BLK/2,search=ME1,searchparam=ME2,isb=true, dct=_DCT)
fv1  = MAnalyse(sup1,delta=1,truemotion=false,global=true,blksize=BLK,overlap=BLK/2,search=ME1,searchparam=ME2,isb=false,dct=_DCT)
fv2  = MAnalyse(sup1,delta=2,truemotion=false,global=true,blksize=BLK,overlap=BLK/2,search=ME1,searchparam=ME2,isb=false,dct=_DCT)
den = source.MDegrain2(sup2,bv1,fv1,bv2,fv2,thsad=321,thSCD1=256,thSCD2=96)
Diff1 = mt_makediff(source,den,U=3,V=3)
NR  = den.VagueDenoiser(method=4, nsteps=10, wavelet=2, Wiener=true, auxclip=x1, percent=95, chromaT=0.8, wratio=0.75, threshold=0.5)
Diff2 = mt_makediff(source,NR,U=3,V=3)
lutxy = mt_lutxy(Diff1,Diff2,"x 128 - abs y 128 - abs < x y ?")
source.mt_makediff(lutxy,U=3,V=3)

GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=0.5,strC=0.0,temp=50,adapt=64)

# Для обработки DVD и прочих видеоматериалов с танцующим(пляшущим) характером шума



