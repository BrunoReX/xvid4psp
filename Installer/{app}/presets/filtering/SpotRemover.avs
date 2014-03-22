#mvtools2.dll
#SpotRemover.vdf
#vdf_arguments:SpotRemover:11
#descratch.dll
#DeFlicker.dll
#mt_masktools-26.dll
#RemovegrainSSE2.dll
#RemovegrainTSSE2.dll
#RemoveDirt.dll
#RepairSSE2.dll
#warpsharp.dll
#AddGrainC.dll
#GradFun2DB.dll
#Ylevels.avs
#SpotRemover.avsi
#Gradfun2dbmod 1.5.avsi
#LimitedSharpenFaster mod.avs


setmtmode(2)
# setmemorymax(640)

# Удаление полос и царапин
 turnleft() 
 DeScratch(mindif=4, maxgap=20, minlen=300, blurlen=50, keep=100, border=0, maxangle=0)
 turnright()

SpotRemover(mcradius=6, mdg=true, blksize=8, overlap=4, dct=0)

LSFmod(defaults="slow", strength=100)
#greyscale().YlevelsS(18,1.0,230,0,235)
GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=0.8,strC=0.0,temp=50,adapt=64)
trim(1,0)