#svpflow2.dll
#svpflow1.dll
#RgTools.dll
#mt_masktools-26.dll
#mvtools2SVP.dll
#nnedi3.dll
#FluxSmooth.dll
#AvsFilterNet.dll
#awarpsharp2.dll
#AddGrainC.dll
#GradFun2DB.dll
#SmoothAdjust.dll
#TGMC_SVP_Test.avs
#GradFun2DBmod 1.5.avsi


# SetMTMode(2)
# setmemorymax(640)

AssumeTFF() 
# AssumeBFF()
TGMC_SVP_Test(SVP=true)
SelectEven()
mergechroma( awarpsharp2(depth=12,thresh=255,blur=3) )
FluxSmoothST(3,5)

# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# ==== �������������� ��� ������������ ����-������ ������ ====
# str=2 # �������� ���������
# thr=32
# SmoothCurve(Ucurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr+str)+";128-128;"+string(128+thr)+"-"+string(128+thr-str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255"\
#           ,Vcurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr-str)+";128-128;"+string(128+thr)+"-"+string(128+thr+str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255") 
    
# DeBanding
GradFun2DBmod(thr=1.4,thrC=1.6,str=0.3,strC=0.0,temp=50,adapt=64)