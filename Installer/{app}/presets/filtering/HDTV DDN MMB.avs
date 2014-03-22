#avstp.dll
#FluxSmooth.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mt_masktools-26.dll
#mvtools2mod.dll
#VagueDenoiser.dll
#Undot.dll
#NNEDI3.dll
#dither.dll
#AddGrainC.dll
#GradFun2DB.dll
#SmoothAdjust-ICL-x86.dll
#flash3kyuu_deband.dll
#mt_xxpand_multi.avsi
#Dither.avsi
#sbr.avs
#MinMapBlur.avs


setmtmode(2)
# setmemorymax(1024)

Undot()
ChangeFPS(last,last,true) # initiate a small forward buffer

# o = last
# nnedi3(field=-2,nsize=0,nns=3)
# merge(selecteven(),selectodd())
# D1 = mt_makediff(o,last)
# D2 = mt_makediff(last,last.removegrain(11,-1))
# last.mt_adddiff(D2.repair(D1,13,-1).mt_lutxy(D2,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?"),U=2,V=2)
 
source = last
x1 = source.fluxsmootht(3)
x2 = source.removegrain(11,-1)
x22 = source.mt_makediff(mt_makediff(x2,x2.removegrain(20,-1))).MinMapBlur()
enhD = mt_lutxy(x22,x22.removegrain(4,-1).sbr(),"128 x y - abs 2 / 1 1.6 / ^ 2.51 * x y - x y - abs 0.1 + / * +",U=2,V=2)
enh = source.mt_adddiff(enhD,U=2,V=2)

tr = 2
chroma = true
planes = chroma?4:0
sup1 = x1.removegrain(11).MSuper(hpad=16, vpad=16, pel=1, sharp=0, chroma=chroma)
sup2 = enh.MSuper(hpad=16, vpad=16, pel=1, levels=1, sharp=1, chroma=chroma)
multi_vec = MAnalyse (sup1, multi=true, delta=tr, blksize=16, overlap=4, chroma=chroma, truemotion=true, search=5, sadx264=3, dct=5)
source.MDegrainN (sup2, multi_vec, tr, thSAD=135, thSAD2=96, lsb=true, plane=planes)

# ==== DEBANDING ====
f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, dither_algo=3, input_mode=1, output_mode=1)
# GradFun3 (thr=0.45, smode=0, radius=16, lsb_in=true, lsb=true)
# Dither_add_grain16 (var=0.1, uvar=0, soft=2)
DitherPost(mode=6,ampo=0,ampn=1)

SmoothLevels(gamma=1.0, useopt=-1)

# Для обработки HDTV и прочих видеоматериалов с танцующим(пляшущим) характером шума



