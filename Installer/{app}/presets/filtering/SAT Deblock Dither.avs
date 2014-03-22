#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RemoveGrainSSE2.dll
#RepairSSE3.dll
#deen_1.0.dll
#Deblock.dll
#dctfilter.dll
#mt_masktools-26.dll
#defreq.dll
#warpsharp.dll
#SmoothAdjust-ICL-x86.dll
#flash3kyuu_deband.dll
#mvtools2mod.dll
#Dither.dll
#Dither.avsi
#mt_xxpand_multi.avsi
#ab16.avs
#Soothe.avs
#Deblock_QED_MT2.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# удаление наводок
# soft = last.defreq(cutx=5,cuty=5,plane=0).defreq(cutx=10,cuty=10,plane=1).defreq(cutx=10,cuty=10,plane=2)
# overlay(last,soft,opacity=0.25)

# удаление радужности и цветового шума
  ConvertToRGB32().CamCD(5,1).ConvertToYV12() 

  # LEVELS
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=-1) # -1 -automatic choice, 1- SSE2 CPU, 2 - Sandy Bridge CPU

# ==== цветокоррекция при преобладании жёлто-зелёных цветов ====
# str=3
# thr=32
# SmoothCurve(Ucurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr+str)+";128-128;"+string(128+thr)+"-"+string(128+thr-str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255"\
#           ,Vcurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr-str)+";128-128;"+string(128+thr)+"-"+string(128+thr+str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255") 

  clp = last
# calculate the appropriate borders so its width and height are mod 16, these will be removed later
  x_temp      = ab16(clp.width)
  x1          = round(x_temp / 2.0)
  x0          = int(x_temp - x1)
  y_temp      = ab16(clp.height)
  y1          = round(y_temp / 2.0)
  y0          = int(y_temp - y1)
  
# add blank borders (to improve frame edge processsing and make the clip mod 16), we will remove these at the end.  
# clp = clp.addborders(x0,y0,x1,y1)
clp.pointresize( clp.width()+x_temp, clp.height()+y_temp, -x0, -y0, clp.width()+x_temp+.001, clp.height()+y_temp+.001 )
  
# Deblock with Re-Sharp
  source = last
# dbl = source.Deblock_QED(uv=3)                               # variant 1
  dbl = source.Deblock(25)                                     # variant 2
# dbl = source.deen("a2d",7,7,7,7,7,7/77.).gradfun2db(77/7/7.) # variant 3
dblD = mt_makediff(source,dbl,U=3,V=3)
shrpD = mt_makediff(dbl,dbl.removegrain(11),U=3,V=3)
DD = shrpD.repair(dblD,13)
d = dbl.mt_adddiff(DD,U=3,V=3) 
fin = Soothe(d,dbl) # успокоение, если не нужно, можно убрать

chroma = false
planes = chroma?4:0
ch31 = chroma?3:1
dbl_super = dbl.blur(1.0).MSuper(pel=2, sharp=2, rfilter=2, chroma=false) 
fin_super = fin.MSuper(pel=2, sharp=2, levels=1, chroma=false)
vf2 = MAnalyse(dbl_super, isb=false, truemotion=true, blksize=8, overlap=4, delta=2, search=4, chroma=chroma)
vf1 = MAnalyse(dbl_super, isb=false, truemotion=true, blksize=8, overlap=4, delta=1, search=4, chroma=chroma)
vb1 = MAnalyse(dbl_super, isb= true, truemotion=true, blksize=8, overlap=4, delta=1, search=4, chroma=chroma)
vb2 = MAnalyse(dbl_super, isb= true, truemotion=true, blksize=8, overlap=4, delta=2, search=4, chroma=chroma)
fin.MDegrain2(fin_super,vb1,vf1,vb2,vf2,thSAD=350,plane=planes,lsb=true)

# DEBANDING
# DB = last.GradFun3(smode=0, thr=0.35, radius=12, lsb_in=true, lsb=true)
DB = last.f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, dither_algo=3, input_mode=1, output_mode=1)
output = DB.DitherPost(mode=-1)

# sharpening
sharp8 = output.LSFmod(defaults="slow", preblur="ON", strength=80) 
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost() # for XviD encode  
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out.crop(x0,y0,-x1,-y1) 


# Назначение: для обработки проблемного старого DVD с уменьшением блочности изображения 
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain2
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: f3kdb
# Скорость обработки: медленная                    



