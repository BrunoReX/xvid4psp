#avstp.dll
#RgTools.dll
#MedianBlur.dll
#FluxSmooth.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#mvtools2mod.dll
#SangNom.dll
#AddGrainC.dll
#dither.dll
#dither.avsi
#mt_xxpand_multi.avsi
#maa.avs
#sbr.avs
#minblur.avs
#minblur3.avs
#Ylevels.avs
#LimitedSharpenFaster.avs


setmtmode(2)
# setmemorymax(768)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# ApplyRange(x,y,"maa") # где x и y первый и последний кадр последовательности, на которую применяем антиайлиазинг по необходимости на титрах

source = last
ox = source.width()
oy = source.height()

mb2     = source.sharpen(0.35).minblur(2)
mb2a    = mb2.sbr()
e1      = mb2.mt_edge("prewitt",0,255,0,255).mt_inflate().mt_inflate().mt_expand().mt_inflate().mt_inflate().greyscale
e2      = e1.mt_edge("prewitt",0,255,0,255).mt_deflate().mt_expand().greyscale
e3      = mt_lutxy(e2,e2.mt_expand().mt_inpand(),"y x - 2 *").mt_inflate()
dh      = source.mt_merge(mb2a.addgrainc(14),e2)
pre     = mb2.sbr().fluxsmootht(4)
shrp    = dh.mt_adddiff(mt_makediff(dh,dh.minblur(2).sbr()),U=2,V=2)
shrp    = shrp.sharpen(0.25).mt_merge(shrp,e2.mt_inflate().mt_inflate().removegrain(11).mt_logic(e3,"max"))
shrp    = mt_lutxy(shrp,shrp.gaussresize(48,32,p=16).gaussresize(ox,oy,p=5),expr="x x y - abs 1 2.618 / ^ 0.618 * x y - 3 ^ x y - abs 3 ^ 1.618 + / * +",
 \                                                                         yexpr="x x y - abs 1 2.618 / ^ 0.786 * x y - 3 ^ x y - abs 3 ^ 1.618 + / * +",U=3,V=3)
shrpD   = mt_makediff(shrp,dh,U=3,V=3).sbr()
shrpDD  = mt_makediff(shrpD,shrpD.removegrain(4),U=3,V=3)
shrpDD  = mt_makediff(shrpDD,shrpDD.removegrain(11),U=3,V=3)
shrp    = shrp.mt_adddiff(shrpDD,U=3,V=3)
shrp    = shrp.minblur3()

# ==== Denoiced =====
blksize = 16
overlap = 8
thSAD = 256
thSAD2 = 96
chroma = true
planes = chroma?4:0  
tr = 2   # Temporal radius
presup  = pre.msuper(pel=2,sharp=2,chroma=chroma)
shrpsup = shrp.MSuper(pel=2,levels=1,chroma=chroma)
multi_vec = MAnalyse (presup, multi=true, delta=tr, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma)
dh.MDegrainN (shrpsup, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# DEBANDING
# GradFun3(smode=0, thr=0.35, lsb_in=true, lsb=true)
f3kdb(16, 64, 40, 40, 0, 0, input_mode=1, output_mode=1)#.Dither_limit_dif16(last, thr=0.60, Y=3, U=3, V=3)

DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
# DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode

Limitedsharpenfaster(ss_x=1.0,ss_y=1.0,strength=24)
mergeluma(removegrain(11,-1).removegrain(11,-1).removegrain(11,-1),0.11)

YlevelsS(0,1.0,255,0,255,false)


# Назначение: для зашумленного DVD c ореолами на контурах с повышением резкости изображения, улучшением детализации и одновременным подавлением ореолов
# Тип предварительного шумоподавителя: Fluxsmooth
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на MDegrain3
# Тип шарпера: sharpen + median sharpen + Limitedsharpenfaster
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: очень медленный
# перед строкой загрузки видео вписуйте в скрипт setmtmode(5,3), а вслучае ошибки вообще setmtmode(5,2) при threads=4 