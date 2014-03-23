#ColorMatrix.dll
#RgTools.dll
#reduceflicker.dll
#mvtools2.dll
#TIVTC.dll
#EEDI2.dll
#EEDI3.dll
#nnedi.dll
#nnedi2.dll
#nnedi3.dll
#Yadifmod.dll
#tdeint.dll
#mt_masktools-26.dll
#SangNom.dll
#LeakKernelDeint.dll
#QTGMC.avs


SetMTmode(2)
# setmemorymax(1024)

AssumeTFF() # для DVD, HDV, AVCHD
#AssumeBFF() # для DV камер

#ColorMatrix(interlaced=true, clamp=0, threads=0)
ConvertToYV12(interlaced=true) 

o = last

bobb = o.bob(0,0.5)
QTGMC = o.QTGMC( preset="slower", edimode="NNEDI3")
yad = o.yadifmod(mode=1,edeint=o.nnedi3(field=-2))
LK = o.LeakKernelBob(order=1)#

vv=blankclip(bobb,width=4,height=bobb.height,color=$808080)

stackvertical(
 \  stackhorizontal( bobb.subtitle("bob(0,0.5)"), vv,
  \                   QTGMC.subtitle("QTGMC")          
 \                  ).crop(0,2,0,0).addborders(0,0,0,4,color=$808080),
 \  stackhorizontal( LK.subtitle("LeakKernel"),       vv,
 \                   yad.subtitle("YadifMod*NNEDI3")
 \                  ).crop(0,2,0,0)
 \            )

return(last)


# Назначение: Для подбора качественного деинтерлейса
# Предупреждение: деинтерлейс и колориметрию , выставляемые XviD 4XvidPSP 5.0 убрать!!!



