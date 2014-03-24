#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#Warpsharp.dll
#mt_masktools-26.dll
#AddGrainC.dll
#flash3kyuu_deband.dll
#dither.dll
#dither.avsi
#mt_xxpand_multi.avsi
#Ylevels.avs
#dehalo_alpha_2BD.avs
#Limitedsharpenfaster mod.avs


# setmtmode(2)
# setmemorymax(640)

#ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)
 
o = last
m_edge = o.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_halo = m_edge.mt_expand().mt_expand().mt_lutxy(m_edge, "x y -")

dh3  = o.dehalo_alpha_2BD(rx=2.0,ry=1.7,darkstr=1.00,brightstr=1.00*0.8)
 \      .dehalo_alpha_2BD(rx=2.5,ry=1.9,darkstr=0.85,brightstr=0.85*0.6)
 \      .dehalo_alpha_2BD(rx=3.0,ry=2.1,darkstr=0.74,brightstr=0.74*0.4) #  dh3 = 3-fold dehalo_alpha
e3   = mt_lutxy(dh3.mt_expand().mt_expand(),dh3.mt_inpand().mt_inpand(),"x y - 10 - 4 *").mt_expand()
mrg  = o.mt_merge(dh3,e3,U=2,V=2)
x1   = mrg.removegrain(11)
fin1 = mrg.mt_adddiff(mt_makediff(x1,x1.rg114()).mt_lut("x 128 - 1.501 * 128 +"),U=2,V=2)
x2   = x1.sbr()
fin2 = fin1.mt_adddiff(mt_makediff(x2,x2.rg114()).mt_lut("x 128 - 1.499 * 128 +"),U=2,V=2) # fin2 = dh3 with 2-step mediansharpen (free)

mrgD = mt_makediff(mrg,o)
fin2D= mt_makediff(mrg,fin2)
DD   = fin2D.repair(mrgD,1)
fin3 = mrg.mt_makediff(DD,U=2,V=2) #fin3 = fin2 with sharpness limiting "visually best" is fin2, the others are just for comparison

blksize = 16
overlap = blksize/2
chroma = true
planes = chroma?4:0  
tr = 2   # Temporal radius
thSAD = 400
thSAD2 = 150
dct = 5
psuper = dh3.MSuper(pel=2, sharp=2, rfilter=4)
osuper = o.MSuper(pel=2, sharp=2, levels=1)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, dct=dct)
o.MDegrainN (osuper, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# ==== DEBANDING ====
f3kdb(16, 64, 48, 48, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)
# GradFun3 (thr=0.35, smode=0, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.1, uvar=0, soft=2)
den = DB.DitherPost(mode=-1)
output = mt_merge(den, fin3, m_halo)
  
# ==== SHARPENING ====
sharp8 = output.LSFmod(defaults="slow", preblur="ON", strength=90)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out


# Назначение: для обработки проблемного BD с уменьшением ореолов на контрастных контурах изображения скриптом Dehalo_alpha_2BD
# Тип предварительного шумоподавителя: dehalo_alpha_2BD
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain2
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: нет
# Скорость обработки: медленная         



