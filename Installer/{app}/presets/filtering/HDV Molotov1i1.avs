#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#fft3dfilter.dll
#RgTools.dll
#mt_masktools-26.dll
#GradFun2DB.dll
#SimpleResize.dll
#mvtools2.dll
#AutoYUY2.dll
#hipsharp.avs
#YUY2ToYV12i.avs


# setmtmode(2) 
# setmemorymax(1024)
W = 1440 # 1920 for AVCHD
H = 1080

ConvertToRGB32(interlaced=true).CamCD(7,1).converttoyv12(interlaced=true) # ���������� ��������� ���� ����������

fields = last.AssumeTFF().SeparateFields() # �������� ���������� ������� �����
super = fields.MSuper(pel=2, sharp=2, rfilter=2)
vb2 = MAnalyse(super,isb =true, delta=2, blksize=16, overlap=8, truemotion=false, search=5, sadx264=3)
vf2 = MAnalyse(super,isb=false, delta=2, blksize=16, overlap=8, truemotion=false, search=5, sadx264=3)
fields.MDegrain1(super, vb2,vf2,thSAD=240)

FFT3DFilter(wintype=1,bt=3,bw=32,bh=32,oh=16,ow=16,degrid=1,sigma=2.4,sigma2=1.5,sigma3=1.5,sigma4=1.5,plane=0,interlaced=true)
hipsharp()
GradFun2DB(1.4)
Weave()
AutoYUY2() # ���������� ��� InterlacedResize
InterlacedResize (W, H) # ������ ������������� �����
YUY2ToYV12i() # ���������� ��� �264, ������� ������ ��� Rhozet Carbon Coder

# ����������: ��� ��������� ������ ������������ ������������� ��������� HDV � ����������� � ������������ ����
# ��� ��������� ��������������: MDegrain1 + FFT3DFilter
# ��� �������: hipsharp 
# �������� ���������: ���������
# ��������������: �����������, �������������� ���� � ������, ������������ ���������, ���������� �264 �� ���������� ������ Encode interlaced(Megui\x264) ��� ������ � ��������� ������ --interlaced --colormatrix "bt709" --sar 4:3 (for HDV)
# � ����� => ���������/������� ������ �������� �������� �����, ��� �������������
# ����� ������� �������� ����� �������� � ������ #setmtmode(5,2) � ������������� ����������� ����������� ������ ��� threads=4 