#RgTools.dll
#mvtools2.dll
#fft3dfilter.dll
#fft3dgpu.dll
#HQDn3D.dll
#mt_masktools-26.dll
#minblur.avs
#TemporalDegrain_ChromaMod V1.0.avs
#Gradfun2db.dll
#AddGrainC.dll
#Gradfun2dbmod 1.5.avsi
  
  
# setmtmode(2)
# setmemorymax(768)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

#GPU     = default( GPU,   false ) # bcgjkmpeqnt FFT3DGPU ���� � ��� ������ � ������� GPU
#sigma   = default( sigma,    16 ) # ������� �������������� �������� FFT3D
#bw      = default( bw,       16 ) # FFT3D ������ �����
#bh      = default( bh,       16 ) # FFT3D ������ �����
#pel     = default( pel,       2 ) # �������� ��������������� �������� � MAnalyse
#blksize = default( blksize,   8 ) # ������ ����� � MAnalyse, ����������� 16 ��� ������� �������� , ��� ��� HD resolutions like 1080p
#ov      = default( ov, blksize/2) # Increase for better motion vectors but slower speed. Max is blksize/2
#degrain = default( degrain,   2 ) # MVDegrain 1, 2 ��� 3
#limit   = default( limit,   255 ) # ������ ������������� ��������� �������. �� ��������� ����� �� ��������� 255
#SAD1    = default( SAD1,    400 ) # ����� ��� degraining. ����������, ���� �� ������ ���� � ������������ ����������
#SAD2    = default( SAD2,    300 ) # ��. ����
#HQ      = default( HQ,        1 ) # ������������ ������� ����� ��� ������ ���������� ��������
#s2      = floor ( sigma * 0.625 ) # �� sigma
#s3      = floor ( sigma * 0.375 ) # �� sigma
#s4      = floor ( sigma * 0.250 ) # �� sigma
#ow      = bw / 2                  
#oh      = bh / 2                  
#ov      = blksize/2 
#chroma  = default( chroma, true ) # ����� �������������� ��������� ������, �� false

TemporalDegrain_ChromaMod(GPU=true,sigma=16,pel=2,degrain=3,limit=235,SAD1=450,SAD2=256,HQ=1,chroma=false)
Gradfun2dbmod(thr=1.6,thrC=2.3,mode=1,str=1.0,temp=50)

# ����������: ��� ������������ ��������� ������ ��������� ������� ������� ���������� �� ���� ������� TemporalDegrain_ChromaMod
# ��� ���������������� ��������������: fft3dfilter ��� fft3dgpu � HQdn3D
# ��� ��������� ��������������: �� ������ ���������� ������� ������ �������� �� ����������� �������������� MDegrain1,2 ��� 3
# ��� �������: ContraSharpening
# ������� ������� DeBanding �� ���������: �������
# �������� ���������: ���������                    
