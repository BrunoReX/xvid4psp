#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#AddGrainC.dll
#Dither.dll
#Dither.avsi
#Ylevels.avs
#mt_xxpand_multi.avsi
#DeHalo_alpha.avs
#LimitedSharpenFaster mod.avs


setmtmode(2)
# setmemorymax(640)

#ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)

source = last
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_halo = m_edge.mt_expand().mt_expand().mt_lutxy(m_edge, "x y -")

dha = source.DeHalo_alpha(rx=2.0,ry=2.0,darkstr=0.5,brightstr=1.0,ss=1.5) # значения darkstr и brightstr подбирать

dha_super = dha.MSuper(pel=2, sharp=2, rfilter=2)
ssuper = source.MSuper(pel=2, sharp=2, levels=1)
tr = 2
multi_vec = MAnalyse (dha_super, multi=true, delta=tr, blksize=16, overlap=8, chroma=true, truemotion=false, dct=5)
source.MDegrainN (ssuper, multi_vec, tr, thSAD=400, thSAD2=150, lsb=true)

# DEBANDING
f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)
# GradFun3 (thr=0.35, smode=0, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.1, uvar=0, soft=2)
output = DB.DitherPost(mode=-1)

# sharpening
den = DB.DitherPost(mode=-1)
output = mt_merge(den, dha, m_halo) 
sharp8 = output.LSFmod(defaults="slow", preblur="ON", strength=90)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=0)  
lsb_out
YlevelsS(0,1.0,255,0,255,false) 


# Назначение: для обработки проблемного DVD с уменьшением ореолов на контрастных контурах изображения скриптом DeHalo_Alpha
# Тип предварительного шумоподавителя: DeHalo_alpha
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain2
# Тип шарпера: Contrasharpening
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная         



