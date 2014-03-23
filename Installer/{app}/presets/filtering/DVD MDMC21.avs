#avstp.dll
#RgTools.dll
#TTempSmooth.dll
#mvtools2mod.dll
#AddGrainC.dll
#hqdn3d.dll
#mt_masktools-26.dll
#medianblur.dll
#gradfun2db.dll
#minblur.avs
#ContraHD.avs
#GradFun2DBmod 1.5.avsi


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

source = last
thSAD = 256
psuper = source.blur(1.0).MSuper(pel=2,sharp=2,rfilter=2)
ssuper = source.MSuper(pel=2,sharp=2,rfilter=2, levels=1)
vf2 = MAnalyse(psuper, isb=false, blksize=8, overlap=4, delta=2, truemotion=true, search=4, dct=5)
vf1 = MAnalyse(psuper, isb=false, blksize=8, overlap=4, delta=1, truemotion=true, search=4, dct=5)
vb1 = MAnalyse(psuper, isb= true, blksize=8, overlap=4, delta=1, truemotion=true, search=4, dct=5)
vb2 = MAnalyse(psuper, isb= true, blksize=8, overlap=4, delta=2, truemotion=true, search=4, dct=5)

maskf2 = source.MMask(vf2, kind=1, ml=thSAD, gamma=0.999, Ysc=255)
maskf1 = source.MMask(vf1, kind=1, ml=thSAD, gamma=0.999, Ysc=255)
maskb1 = source.MMask(vb1, kind=1, ml=thSAD, gamma=0.999, Ysc=255)
maskb2 = source.MMask(vb2, kind=1, ml=thSAD, gamma=0.999, Ysc=255)
b = BlankClip(source,color_yuv=$008080)
mask_film = interleave(maskf2, maskf1, b, maskb1, maskb2)

NR = source.MDegrain2(ssuper,vb1,vf1,vb2,vf2,thSAD=thSAD)
NR_super = NR.MSuper(pel=2,levels=1,chroma=true)

b2c = MCompensate(NR, NR_super, vb2, thSCD1=400)
b1c = MCompensate(NR, NR_super, vb1, thSCD1=400)
f1c = MCompensate(NR, NR_super, vf1, thSCD1=400)
f2c = MCompensate(NR, NR_super, vf2, thSCD1=400)
interleave(f2c, f1c, NR, b1c, b2c)
TTempSmooth(2,4,5,3,4,strength=3,pfclip=mask_film,fp=false,scthresh=12)
SelectEvery(5,2)

# SHARPENING
ContraHD(last,source,f1c,b1c,0)

# ENHANCING
GradFun2DBmod(thr=1.4,thrC=1.6,str=0.5,strC=0.0,temp=50,adapt=64)


# Назначение: для качественной обработки зашумленных DVD со стабилизацией по яркости
# Тип основного шумоподавителя: на основе векторного анализа оценки движения c последовательным временнЫм и пространственно-временным шумоподавителем
# Тип шарпера: ContraHD
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная






