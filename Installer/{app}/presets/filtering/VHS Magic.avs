#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#nnedi3.dll
#HQdn3D.dll
#awarpsharp2.dll
#fft3dgpu.dll
#fft3dfilter.dll
#Deblock.dll
#flash3kyuu_deband.dll
#AddGrainC.dll
#Gradfun2db.dll
#awarpsharp2.dll
#mt_masktools-26.dll
#SSE2Tools.dll
#sbr.avs
#minblur.avs
#TemporalDegrain_beta.avs
#Gradfun2dbmod 1.5.avsi
#QTGMC.avs


# SetMTmode(2)
# setmemorymax(1024)
  
AssumeTFF()
ConvertToYV12(interlaced=true)

# Bobben
QTGMC(Preset="Fast",Sharpness=0.5,Edithreads=1)

mt_edge("0 0 0 0 0 0 0 2 0 2",0,255,0,255,Y=2,U=3,V=3)
mt_edge("0 0 0 0 0 0 0 2 0 2",0,255,0,255,Y=2,U=3,V=3)

o =	last
nnedi3(field=-2,nsize=2)
merge(selecteven,selectodd)
bb0 = last
D1  = mt_makediff(o,bb0,U=3,V=3)
D2  = mt_makediff(bb0,bb0.removegrain(20),U=3,V=3).mt_lut("x 128 - 2.51 * 128 +",U=3,V=3)
DD  = D2.repair(d1,13)
bb0.mt_adddiff(DD,U=3,V=3)

# Deblock(quant=30).mt_lutxy(last,"x y < x 1 + x y > x 1 - x ? ?",U=3,V=3)
 
bb1 = last
mt_lutxy(bicubicresize(64*4,48*4).bicubicresize(width,height,1,0),"x 2 + y < x 1 - x 2 - y > x 1 + x ? ?",U=2,V=2)
mt_lutxy(bicubicresize(64*2,48*2).bicubicresize(width,height,1,0),"x 1 + y < x 1 - x 1 - y > x 1 + x ? ?",U=2,V=2)
mt_lutxy(bicubicresize(64*1,48*1).bicubicresize(width,height,1,0),"x y < x 1 - x y > x 1 + x ? ?",U=2,V=2)
mergeluma(bb1,0.49)
awarpsharp2(type=1,depth=4,thresh=144,blur=2)
x  = removegrain(11)
xD = mt_lutxy(x,x.removegrain(4),"x y - abs 1 1.6 / ^ 4.51 * x y - x y - abs 1.9 + / * 128 +")
last.mt_adddiff(xD,U=2,V=2).mt_lutxy(x,"x y < x 1 + x y > x 1 - x ? ?",U=3,V=3)

grain =	mt_lut(Y=-128,U=-128,V=-128).pointresize(512,400).addgrain(7).bicubicresize(width,height,-.4,.7)
last.mt_adddiff(grain,U=2,V=2)

sup1 = bb0.sbr().MSuper()
sup2 = last.MSuper(levels=1,sharp=1)
bv2  = MAnalyse(sup1, isb=true, delta=2,truemotion=false,global=true,blksize=16,overlap=8,search=5,searchparam=4,DCT=5)
bv1  = MAnalyse(sup1, isb=true, delta=1,truemotion=false,global=true,blksize=16,overlap=8,search=5,searchparam=4,DCT=5)
fv1  = MAnalyse(sup1, isb=false,delta=1,truemotion=false,global=true,blksize=16,overlap=8,search=5,searchparam=4,DCT=5)
fv2  = MAnalyse(sup1, isb=false,delta=2,truemotion=false,global=true,blksize=16,overlap=8,search=5,searchparam=4,DCT=5)
last.mdegrain2(sup2,bv1,fv1,bv2,fv2,thSAD=400,thSCD1=400,thSCD2=135)

Letterbox(2, 10, 10, 16)
TemporalDegrain_beta(gpu=false, degrain=2)

Gradfun2dbmod(thr=1.51,thrC=1.8,mode=2,str=0.8,temp=50)
# f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, dither_algo=3, input_mode=0, output_mode=0)
  
# Reinterlace
#SeparateFields().SelectEvery(4, 0, 3).Weave()


# Для обработки VHS
# Предупреждение: деинтерлейс, выставляемый XviD 4XvidPSP 5.0 убрать!!!



