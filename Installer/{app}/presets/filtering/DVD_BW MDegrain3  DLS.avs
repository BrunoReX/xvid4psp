#DeScratch.dll
#RgTools.dll
#mvtools2.dll
#HQDn3D.dll
#fft3dfilter.dll
#fft3dgpu.dll
#FluxSmooth.dll
#WarpSharp.dll
#mt_masktools-26.dll
#AddGrainC.dll
#Gradfun2db.dll
#minblur.avs
#GradFun2DBmod 1.5.avsi
#TemporalDegrain_ChromaMod V1.0.avs
#LimitedSharpenFaster mod.avs


# setmtmode(2)
# setmemorymax(768)

DeScratch(mindif=4, maxgap=20, minlen=300, blurlen=50, keep=100, border=0, maxangle=0) # �������� ������� � ����� ������ ���������

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

TemporalDegrain_ChromaMod(GPU=false,sigma=16,pel=2,degrain=3,limit=235,SAD1=500,SAD2=300,HQ=1,chroma=false).FluxSmoothST(7,0)
LSFmod(defaults="fast", strength=75)
GradFun2DBmod(thr=1.6,thrC=1.01,str=1.0,strC=0.0,temp=50,adapt=64)
greyscale()
levels(20,1.0,225,0,235) # ���������� ������ ������ ��� ���� ��������


# ����������: ��� ����� ������������ ��������� �����-������ ���� DVD
# ��� ���������������� ��������������: fft3dfilter ��� fft3dgpu
# ��� ��������� ��������������: �� ������ ���������� ������� ������ �� �������������� MDegrain3
# ��� �������: LimitedSharpenFaster
# ������� ������� DeBaning �� ���������: �����������
# �������� ���������: ��������� 