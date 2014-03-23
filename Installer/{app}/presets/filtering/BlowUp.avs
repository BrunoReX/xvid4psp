#avstp.dll
#RgTools.dll
#nnedi3.dll
#EEDI3.dll
#mvtools2mod.dll
#AddGrainC.dll
#mt_masktools-26.dll
#GradFun2DB.dll
#WarpSharp.dll
#VagueDenoiser.dll
#DeHalo_alpha.avs
#Colormatrix.dll
#splineresize.dll
#BlowUp.avs
#FineSharp.avs
#Limitedsharpenfaster mod.avs
#GrainFactory3.avs


setmtmode(2)
# setmemorymax(1280)

ColorMatrix(mode="Rec.601->Rec.709") # открыть привставках в BDRip

BlowUp(preblow=true,nnu=true,exsharp=true,ag=true,avgstr=400,avg=2,LSF=true,FS=false,strength=300,g1str=3,g2str=3,g3str=3).spline144resize(1280,720, 0, 0, -0, -0)
# BlowUp(preblow=true,nnu=true,exsharp=true,ag=true,sstr=0.85,avgstr=256,avg=1,LSF=false,FS=true,g1str=5,g2str=5,g3str=5).spline144resize(1920,1080, 0, 0, -0, -0)
# BlowUp(preblow=false).spline36resize(1280,720, 0, 0, -0, -0)


# предназначен для UpScale с шумоподавлением и повышением резкости
# все кропы и ресайзеры от XviD 4PSP Убрать!!!

