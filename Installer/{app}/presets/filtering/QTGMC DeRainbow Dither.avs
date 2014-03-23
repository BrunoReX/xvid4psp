#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#nnedi3.dll
#dfttestmod.dll
#AddGrainC.dll
#awarpsharp2.dll
#dither.dll
#mt_masktools-25.dll
#flash3kyuu_deband.dll
#SSE2Tools.dll
#dither.avsi
#mt_xxpand_multi.avsi
#QTGMC-3.33d.avsi


SetMTmode(2)
# setmemorymax(640)
  
AssumeTFF() 
# AssumeBFF()
QTGMC( Preset="Slow", Sharpness=0.7, FPSDivisor=2, Edithreads=1, lsb=true)

mergechroma (  awarpsharp2(depth=12,thresh=255,blur=3) )
  
# ==== DEBANDING ====
  f3kdb(16, 52, 36, 36, 0, 0, dynamic_grain=true, dither_algo=3, input_mode=0, output_mode=1)
# GradFun3 (thr=0.35, smode=0, radius=12, lsb=true)
Dither_add_grain16 (var=0.05, uvar=0, soft=2)

DitherPost(mode=6, ampo=1, ampn=1)


# Назначение: Для качественного деинтерлейса видеоматериалов с повышенным уровнем радужности
# Предупреждение: деинтерлейс, выставляемый XviD 4XvidPSP 5.0 убрать!!!



