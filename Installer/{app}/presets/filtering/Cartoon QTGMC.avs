#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#tcanny.dll
#fft3dfilter.dll
#nnedi3.dll
#dither.dll
#SangNom.dll
#TEdgeMask.dll
#medianblur.dll
#Fluxsmooth.dll
#MSharpen.dll
#flash3kyuu_deband.dll
#SSE2Tools.dll
#mt_masktools-26.dll
#QTGMC.avs
#srestore.avs
#mt_xxpand_multi.avsi
#Dither.avsi
#HQDeringmod.avsi
#ContraSharpen_mod.avsi


setmtmode(2)
# setmemorymax(768)
 
AssumeTFF()
# AssumeBFF()
QTGMC(preset="Placebo", Edithreads=1)
SelectEven()
# srestore(Frate=23.976)
# srestore(Frate=25.000)

CSmod(chroma=false, ss_w=1.50, ss_h=1.50, thr=0, filter_ss="AA") # Sharpening
HQDeringmod()               # DeRing
f3kdb(16, 52, 36, 36, 0, 0) # DeBanding




