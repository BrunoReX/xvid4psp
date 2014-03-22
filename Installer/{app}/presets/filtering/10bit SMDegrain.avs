#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mvtools2mod.dll
#mt_masktools-26.dll
#dfttestmod.dll
#AddGrainC.dll
#dither.dll
#SmoothAdjust-ICL-x86.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#dither.avsi
#mt_xxpand_multi.avsi
#Down10.avs
#LimitedSharpenFaster MOD.avs
#SMDegrain.avsi


SetMTMode(2)
# setmemorymax(1280)

W = width(last)
H = height(last)

# ==== DENOICED ====
# Variant 1
# SMDegrain(tr=1, thSAD=200, refinemotion=true, prefilter=1, lsb_in=false, lsb_out=true, contrasharp=80)
# SMDegrain(tr=1, thSAD=150, blksize=16, str=3.0, amp=0.07, RefineMotion=True, prefilter=0, Contrasharp=true, overlap=4, pel=1, lsb_in=false, lsb_out=true) # для HD разрешений

# Variant 2 : 16bit pipeline, and reference a prior state of the script for the contrasharpening process
# sharp=last
# dfttest(tbsize=1,sigma=10,threads=1,lsb=true)
# SMDegrain(tr=2,thSAD=300,CClip=sharp,lsb_in=true,lsb_out=true)

# Variant 3
SMDegrain(lsb_in=false, lsb=true, lsb_out=true, plane=0, prefilter=3, tr=2, Contrasharp=true, RefineMotion=true, Str=1.5, thSAD=300, thSADC=150, thSCD1=300, thSCD2=104, Truemotion=false, Chroma=true, limit=4, limitC=2).Dither_repair16(last.Dither_convert_8_to_16(), 13, 0)

# ==== DEBANDING ====
  f3kdb(16, 64, 36, 36, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1) # for Films
# GradFun3(smode=1, thr=0.5,  radius=16, lsb_in=true, lsb=true) # for anime & Cartoon
# GradFun3 (thr=1.4*0.3, smode=0, lsb_in=true, lsb=true)        # for films  
  Dither_add_grain16 (var=0.1, uvar=0, soft=2) 

# ==== ресайз 16-битного видео ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                        # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-бит
""") : Down10(8)                           #8-бит 


# Назначение: Для очень качественной обработки DVD и BD с конвертацией 8 битного исходника в 16 битный
# Тип предварительного шумоподавителя: dfttest
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на базе скрипта SMDegrain
# Тип шарпера: LSFmod и ContraSharpening
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile

