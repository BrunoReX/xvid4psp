#FFT3dGPU.dll
#flash3kyuu_deband.dll



# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
# setmtmode(5)
FFT3DGPU(wintype=1,bt=4,bw=16,bh=16,oh=8,ow=8,degrid=1,sigma=2.0,sigma2=1.75,sigma3=3.0,sigma4=1.5,plane=4,mode=1,precision=2,sharpen=0.5)
# setmtmode(2)
# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)


# ����������: ������� ������ ��� �������� DVDRip � SATRip ��������, ��������� �������, �������������� � ��������������� �������
# ��� ���������������� ��������������: �����������
# ��� ��������� ��������������: ��������������-��������� �������������� FFT3DGPU � ������ ������� ������� GPU � �������� ������ �������������� ��� ������ ���� ���� ����������� sigma
# ��� �������:����������
# �������� ���������: �������, �� ���� ��������� CPU ���������� ������ GPU
