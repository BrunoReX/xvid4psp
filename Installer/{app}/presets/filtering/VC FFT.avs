#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Cnr2.dll
#Depan.dll
#DepanEstimate.dll
#RgTools.dll
#mvtools2.dll
#WarpSharp.dll
#mt_masktools-26.dll
#FluxSmooth.dll
#fft3dgpu.dll
#flash3kyuu_deband.dll
#LimitedSharpenfaster.avs

# setmtmode(2)
# setmemorymax(640)

W = 720
H = 576

Strength = 33
S1 = Strength/10
S2 = Strength/18
S3 = Strength/15
S4 = floor(S3*1.5)

ConvertToRGB32()
CamCD(9,1)       # ���������� ��������� ���� ����������
converttoyv12()

#Cnr2("oxx",8,16,191,100,255,32,255,false) # ���������� ��������� ���� ����������

source= last

#STABILIZING
stab_reference= source.crop(40,40,-40,-40).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata=DePanEstimate(stab_reference,trust=3.0,dxmax=20,dymax=20) # trust=1...100 ��������� ����� �����
stab1=DePanStabilize(source,data=mdata,cutoff=1.0,dxmax=20,dymax=20,pixaspect=1.094,mirror=15) # or pixaspect=0.911 for NTSC
stab= stab1.crop(20,20,-20,-20)

super = stab.MSuper(pel=2, sharp=1, rfilter=2)
bw = MAnalyse(super, isb = true, truemotion=false, delta=1, blksize=16, overlap=8, search=3)
fw = MAnalyse(super,isb = false, truemotion=false, delta=1, blksize=16, overlap=8, search=3)
cb1 = MCompensate(stab, super, bw, thSCD1=400)
cf1 = MCompensate(stab, super, fw, thSCD1=400)
interleave(cb1, stab.MDegrain1(super, bw, fw, thSAD=400).MDegrain1(super, bw, fw, thSAD=400), cf1)

# setmtmode(5)
fft3dgpu(sigma=S1,sigma2=S2,sigma3=S3,sigma4=S4,bw=24,bh=24,ow=12,oh=12,bt=3,plane=0,mode=1,precision=2)
# setmtmode(2)
SelectEvery(3,1)
den = last
super1 = den.MSuper(pel=2, chroma=true, levels=1)
den.MDegrain1(super1, bw, fw, thSAD=240).FluxSmoothST(5,5)

LimitedSharpenfaster(ss_x=1.5,ss_y=1.5,smode=3,strength=100,dest_x=W,dest_y=H)
f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=64,cb=64,cr=64,grainY=0,grainC=0)
coloryuv(off_U=-0,off_V=-0).levels(0,1.0,255,0,255)

# ����������:  ��� ������������ ��������� ��������� VC (���������� ����������) � ������������ ��������� DVC (�������� ����������) � ��������� ������ ��������� � ��������� ������������� �����������
# ������� ������� ���������� ���������� ����������� � ��������� ����: �������
# ��� ��������� ��������������: �� ������ MAnalyse � ���������������:  1-� ���� - ������� MDegrain1, 2-� ���� -���������� �������� MCompensate � fft3dfilter
# ��� ������������: ���������������-��������� FluxSmooth � Temporalsoften
# ����������: �� ��������� ����� ����� ���������� ������� MCompensate � �������� ������������ ������ Temporalsoften
# ��� �������: LimitedSharpenfaster
# �������� ���������: ���������
# ��������������: ������ �������� ����� �� �������������� DeSpot ���������� � ������ ������� �������������, ����������� ��������� ��� ���������� ������.
# ������������� ����������� Smooth DeInterlase 