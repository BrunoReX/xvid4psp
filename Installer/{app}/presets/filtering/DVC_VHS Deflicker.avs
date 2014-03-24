#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#warpsharp.dll
#Fluxsmooth.dll
#avstp.dll
#flash3kyuu_deband.dll
#dither.dll
#dither.avsi
#mt_xxpand_multi.avsi
#AddGrainC.dll
#LimitedSharpenFaster mod.avs


# setmtmode(2)
# setmemorymax(768)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=1,off_u=-0,off_v=-0) # коррекци€ €ркости при кодировании XviD

# ===== подавление цветового шума камкодеров =====
ConvertToRGB32().CamCD(9,1).converttoyv12() # подавление цветового шума VHS

rest = last
w = rest.width()
h = rest.height()
calm = rest.temporalsoften(1,255,255,32,2).merge(rest,0.25).repair(rest,1).removegrain(11)
calm = calm.temporalsoften(1,255,255,16,2).merge(calm,0.25)

LOP = calm.bicubicresize(w/4,h/4).bicubicresize(w,h,1,0)
HIP = rest.bicubicresize(w/4,h/4).bicubicresize(w,h,1,0)

HIP = mt_makediff(rest,HIP)
mix = LOP.mt_adddiff(HIP,U=2,V=2)

blksize = 16
overlap = blksize/2
chroma = true
planes = chroma?4:0  
tr = 2   # Temporal radius
thSAD = 400
thSAD2 = 150
dct = 5

sup1 = mix.removegrain(11).MSuper(pel=2, sharp=2, rfilter=2)
sup2 = rest.MSuper(pel=2, sharp=2, levels=1)
multi_vec = MAnalyse (sup1, multi=true, delta=tr, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, dct=dct)
rest.MDegrainN (sup2, multi_vec, tr, thSAD=thSAD, thSAD2=thSAD2, plane=planes, lsb=true)

# ==== DEBANDING ====
# GradFun3 (thr=1.4*0.3, smode=2, radius=12, lsb_in=true, lsb=true)
# DB =  last.Dither_add_grain16 (var=0.05, uvar=0, soft=2)
DB = last.f3kdb(16, 56, 40, 40, 0, 0, dynamic_grain=true, dither_algo=3, input_mode=1, output_mode=1)
output = DB.DitherPost(mode=-1).FluxsmoothST(5,5)
  
# ==== SHARPENING ====
sharp8 = output.LSFMod(strength=70, smode=3).LSFMod(strength=30, smode=1)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
lsb_out = lsbctr.DitherPost(mode=6, ampo=1, ampn=1) # for XviD encode  
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out
 

# ƒл€ обработки проблемных материалов интерлейсных камкодеров или VHS c повышенным мерцанием 
