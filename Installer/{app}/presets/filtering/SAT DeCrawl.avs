#avstp.dll
#RgTools.dll
#SmoothAdjust.dll
#mt_masktools-26.dll
#mvtools2mod.dll
#flash3kyuu_deband.dll
#dither.dll
#dither.avsi
#mt_xxpand_multi.avsi


# setmtmode(2)
# setmemorymax(640)
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

blksize = 16
overlap = blksize/2
chroma = true
planes = chroma?4:0  
tr = 3   # Temporal radius
thSAD = 600
thSAD2 = 200
dct = 5
o = last
pre = o.removegrain(4).merge(o,0.5).removegrain(4).removegrain(11)
sup1 = pre.MSuper(pel=2,sharp=2,chroma=chroma)
sup2 = o.MSuper(pel=2,sharp=2,chroma=chroma,levels=1)
multi_vec = MAnalyse (sup1,multi=true,delta=tr,blksize=blksize,overlap=overlap,truemotion=true,chroma=chroma,dct=dct,search=5,searchparam=6)
o.MDegrainN (sup2, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# DEBANDING
# GradFun3(smode=0, thr=0.35, radius=12, lsb_in=true, lsb=true)
f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, dither_algo=3, input_mode=1, output_mode=1)
mdg = last.DitherPost()
  
diff = mt_makediff(o,mdg,U=3,V=3)
diff2 = mt_lutxy(diff,diff.removegrain(4).merge(diff,0.5).removegrain(4).removegrain(11),
                  \  "x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?")

mdg.mt_adddiff(diff2,U=2,V=2)

# LEVELS
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code



# Ќазначение:  ачественный, наиболее основной пресет дл€ обработки DVB повышенным точечным шумом
# “ип основного шумоподавител€: на основе векторного анализа оценки движени€ c масками движени€ и конечным шумоподавителем MDegrain3 
# Ќаличие фильтра DeBanding по умолчанию: включен
# —корость обработки: медленна€
