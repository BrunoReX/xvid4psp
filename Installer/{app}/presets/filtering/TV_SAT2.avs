#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Deblock.dll
#dctfilter.dll
#degrainmedian.dll
#RgTools.dll
#mvtools2.dll
#fft3dgpu.dll
#Warpsharp.dll
#mt_masktools-26.dll
#Gradfun2db.dll
#AddGrainC.dll
#SangNom.dll
#vinverse.dll
#SmoothAdjust.dll
#maa.avs
#Gradfun2dbmod 1.5.avsi
#Deblock_QED_MT2.avs
#LimitedSharpenFaster Mod.avs


# setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

ConvertToRGB32().CamCD(15,1).converttoyv12()  # �������� ���������� � ��������� ����

# Deblock_QED(uv=3) # ��������� ���������� � ������ ��������� ���������

  SmoothCurve(Ycurve="0-0;8-0;244-255;255-255", Ucurve="0-0;8-0;248-255;255-255", Vcurve="0-0;8-0;248-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# ==== �������������� ��� ������������ ����-������ ������ ====
# str=4
# thr=32
# SmoothCurve(Ucurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr+str)+";128-128;"+string(128+thr)+"-"+string(128+thr-str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255"\
#           ,Vcurve="0-0;"+string(128-2*thr)+"-"+string(128-2*thr)+";"+string(128-thr)+"-"+string(128-thr-str)+";128-128;"+string(128+thr)+"-"+string(128+thr+str)+";"+string(128+2*thr)+"-"+string(128+2*thr)+";255-255") 
 

# ApplyRange(x,y,"maa") # ��� x � y ������ � ��������� ���� ������������������, �� ������� ��������� ������������� �� ������������� �� ������
source = last
spat = source.degrainmedian(mode=2,limity=5,limituv=6)
spatD = mt_makediff(source,spat)

frames = 2
sigma = 12
s2 = sigma * 0.625
s3 = sigma * 0.375
s4 = sigma * 1.5

# setmtmode(5)
preNR = spat.fft3dgpu(bw=16,bh=16,ow=8,oh=8,bt=4,sigma=sigma,sigma2=s2,sigma3=s3,sigma4=s4,plane=4)

# setmtmode(2)
preNR_super = preNR.MSuper(pel=2, sharp=2,rfilter=4, chroma=false)
source_super = source.MSuper(pel=2, sharp=2, chroma=false, levels=1)
vb2 = MAnalyse(preNR_super, isb=true,truemotion=false,delta=2,blksize=16,overlap=8,lambda=2000,search=3,chroma=false,DCT=5)
vb1 = MAnalyse(preNR_super, isb=true,truemotion=false,delta=1,blksize=16,overlap=8,lambda=2000,search=3,chroma=false,DCT=5)
vf1 = MAnalyse(preNR_super,isb=false,truemotion=false,delta=1,blksize=16,overlap=8,lambda=2000,search=3,chroma=false,DCT=5)
vf2 = MAnalyse(preNR_super,isb=false,truemotion=false,delta=2,blksize=16,overlap=8,lambda=2000,search=3,chroma=false,DCT=5)
NR1 = source.MDegrain2(source_super,vb1,vf1,vb2,vf2,thSAD=400,plane=0)
NR1D = mt_makediff(source,NR1)
DD = mt_lutxy(spatD,NR1D,"x 128 - abs y 128 - abs < x y ?")
NR1x = NR1.mt_makediff(DD,U=2,V=2)
NR1x_super = NR1x.MSuper(pel=2, levels=1, chroma=false)
NR1x.MDegrain2(NR1x_super,vb1,vf1,vb2,vf2,thSAD=240,plane=0)

# SHARPENING
LSFmod(defaults="fast",preblur="ON", strength=100)

# ENHANCING
GradFun2DBmod(thr=1.4,thrC=1.8,mode=1,str=0.8,strC=0.0,temp=50,adapt=64,mask=false,show=false)


# ����������: ������� ������ ��� ��������� TV, SAT � ����������� DVD ��������� �� �������������� SmoothLevels � ����������� ��������� ����������� � ����-a���������
# ��� ���������������� ��������������: fft3dgpu
# ��� ��������� ��������������: �� ������ ���������� ������� ������ �������� �� ����������� �������������� MDegrain2 
# ��� �������: LSFmod
# ������� ������� DeBanding: �������
# �������� ���������: ���������  

