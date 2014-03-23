#ColorMatrix.dll
#AutoYUY2.dll
#RgTools.dll
#GradFun2DB.dll
#medianblur.dll
#FluxSmooth.dll
#mt_masktools-26.dll
#minblur.avs


Global NewHeight = 576 # 480 for NTSC
Global NewWidth  = 720

setmtmode(2)
# setmemorymax(1024)

AssumeTFF()
SeparateFields()

Shift = (GetParity() ? -0.25 : 0.25) * (Height()/Float(NewHeight/2)-1.0)

E    = SelectEven() . BicubicResize(NewWidth, NewHeight/2, 0, 0.5, 0,    Shift)
O    = SelectOdd()  . BicubicResize(NewWidth, NewHeight/2, 0, 0.5, 0,   -Shift)
Echr = SelectEven() . BicubicResize(NewWidth, NewHeight/2, 0, 0.5, 0,  2*Shift)
Ochr = SelectOdd()  . BicubicResize(NewWidth, NewHeight/2, 0, 0.5, 0, -2*shift)

Interleave(E, O)
MergeChroma(Interleave(Echr, Ochr))

o = last
f = o.MinBlur(1,2).MinBlur(2,2).RemoveGrain(11,-1)
f.FluxSmoothT(7).mt_AddDiff(mt_MakeDiff(o,f,U=1,V=1),U=4,V=4) 
# eventually, limit the maximum pixel change to +/- 2 :
mt_LutXY(last,o,"x 2 + y < x 2 + x 2 - y > x 2 - x ? ?",U=2,V=2)

# ==== DeBanding ====
GradFun2DB(1.41)

AutoYUY2()
#ColorMatrix(mode="Rec.709->Rec.601", inputFR=true, clamp=0) # for DV by Cedocida
ColorMatrix(mode="Rec.709->Rec.601", clamp=0) # for DVD

Weave()


# Назначение: для конвертации HDV в DV с сохранением интерлейса
# Установить тип исходного видео как прогрессивное
# Предупреждение: деинтерлейс в программе XviD 4PSP 5.0 НЕ ПОДКЛЮЧАТЬ!!!! Следует также отключить AutotoYV12 и ресайз, помимо указанного в пресете
# Пресет предназначен исключительно для формирования скрипта в XviD 4PSP 5.0 и передачи его в Rhozet Carbon Coder или ССE SP2

