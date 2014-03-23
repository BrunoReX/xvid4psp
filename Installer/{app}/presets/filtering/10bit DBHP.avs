#avstp.dll
#RgTools.dll
#AddGrainC.dll
#dither.dll
#frfun7.dll
#dfttestmod.dll
#SmoothAdjust.dll
#flash3kyuu_deband.dll
#mt_masktools-26.dll
#HighPassSharp.avs
#dither.avsi
#Down10.avs
#mt_xxpand_multi.avsi
 

SetMTMode(2)
setmemorymax(1280)

W = width(last)
H = height(last)

# frfun7(1.01,8,1)
# Dither_convert_8_to_16 ()

dfttest(sigma=1.5, tbsize=1, threads=1, lsb=true) # soft spatial denoiced

Dither_convert_yuv_to_rgb (matrix="709", chromak="spline36", a1=0.0, a2=0.0, output="rgb48y", tv_range=true, lsb_in=true)
Dither_resize16 (W, H, kernel="spline36", a1=0.0, a2=0.0, Y=3, U=3, V=3)
r = SelectEvery (3, 0)
g = SelectEvery (3, 1)
b = SelectEvery (3, 2)
Dither_convert_rgb_to_yuv (r, g, b, matrix="709", chromak="spline36", a1=0.0, a2=0.0, lsb=true, tv_range=true)

DB = last.f3kdb(Y=52,Cb=36,Cr=36,grainY=0,grainC=0,sample_mode=2,input_mode=1,input_depth=16,output_mode=1,dither_algo=3,output_depth=16)
# DB = last.GradFun3(thr=0.35, radius=12, smode=0, lsb_in=true, lsb=true, mode=6, debug=0) # DeBanding

f = last.DitherPost (mode=-1)
s = f.HighPassSharp(r=0.22)   # blur
s16 = s.Dither_convert_8_to_16 ()
# mask = mt_lutxy (s, f, "x y != 255 0 ?", u=0, v=0) #  8, 8 ->  8
s16  = s.Dither_convert_8_to_16 ()                   #  8 -> 16
DB.Dither_limit_dif16 (s16, thr=1.0, elast=2.0)
# Dither_merge16_8 (DB, s16, mask)                   # 16, 16, 8 -> 16  

# ==== ресайз 16-битного видео ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                        # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-бит
""") : Down10(8)                           #8-бит  


# Для конвертации 8 битного исходника в 16 бит с небольшим шумоподалением и DeBanding для обработки клипов с природой
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile
