#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#fft3dgpu.dll
#degrainmedian.dll
#VagueDenoiser.dll
#RgTools.dll
#AddGrainC.dll
#GradFun2DB.dll
#mt_masktools-26.dll
#SeeSaw.avs
#GradFun2DBmod 1.5.avsi


# setmemorymax(256)

# удаление радужности и цветового шума
# fft3dgpu(bw=32,bh=32,oh=16,ow=16,sigma=2.5,sigma2=1.75,sigma3=4.5,sigma4=2.5,bt=4,sharpen=0.7,plane=3,mode=1,precision=2)
setmtmode(2)
ConvertToRGB32().CamCD(3,1).ConvertToYV12() 

a = last
b = a.degrainmedian(limitY=7, limitUV=7,mode=3).VagueDenoiser(method=4, nsteps=8, wavelet=2, Wiener=true, auxclip=a, percent=95, chromaT=1.0, wratio=0.75, threshold=0.6)

b = assumefps(b,b,true) #### knock1 ####  

setmtmode(5)
SeeSaw(a,b, NRlimit=3, NRlimit2=4, Sstr=1.3, Slimit=5, Spower=5, Sdamplo=6, Szp=16, sootheS=20)
# SeeSaw(a,b, NRlimit=0, NRlimit2=5, Sstr=2.24, Szp=1, Slimit=50, Sdamplo=16, Spower=1, sootheT=95, SdampHi=29)

SetMTMode(2)     #### knock2 ####
temporalsoften(3,2,2,6,2)   #### knock2 ####

GradFun2DBmod(thr=1.21,thrC=1.4,mode=2,str=0.3,strC=0.0,temp=50,adapt=64)
# назначение: повышение резкости при замыленных исходниках