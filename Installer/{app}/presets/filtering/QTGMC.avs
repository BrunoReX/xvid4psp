#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#ColorMatrix.dll
#TDeInt.dll
#mvtools2.dll
#dfttest.dll
#TIVTC.dll
#fft3dfilter.dll
#EEDI2.dll
#EEDI3.dll
#nnedi.dll
#nnedi2.dll
#nnedi3.dll
#Cnr2.dll
#AddGrainC.dll
#Depan.dll
#SSE2Tools.dll
#DepanEstimate.dll
#mt_masktools-26.dll
#srestore.avs
#QTGMC.avs


   ColorMatrix(interlaced=true, clamp=0, threads=0)
   ConvertToYV12(interlaced=true)
   #setmtmode(2)
#  setmemorymax(768)

#  W = 720 # 1440 or 1920
#  H = 576 # 480 or 1080
#  Cnr2("oxx",8,16,191,100,255,32,255,false) # ������ �������� ��� ����������

#  ConvertToRGB32(interlaced=true)
#  CamCD(9,1)    # ������ �������� ��� ����������, ��� ��������� � ������� QTGMC ����� ���������� ��� ���������� �������� ChromaMotion=false
#  converttoyv12(interlaced=true)

# ���������� ����� �������������� TR2 = 1 ��� ������� ��������� � TR2 = 2 ��� TR2 = 3 ��� ������������ ���������, �� ��������� �������� �������

# ====  Sharpness ====
# QTGMC( Preset="Fast", SourceMatch=1, Sharpness=0.4, Edithreads=1, TR2=1 )               # ������� �����, �������
# QTGMC( Preset="Slow", SourceMatch=1, Lossless=2, Sharpness=0.4, Edithreads=1, TR2=2)    # ������� ��������, �����������, � ��������� �������
# QTGMC( Preset="Slow", SourceMatch=2, Sharpness=0.4, Edithreads=1, TR2=2 )               # ������� ��������, ���������, ��� �������
# QTGMC( Preset="Slower", SourceMatch=3, Lossless=2, Sharpness=0.4, Edithreads=1, TR2=2 ) # �������� ��������, ����� ���������, � ��������������� ��������� �������

# ==== Basic ====
# QTGMC( Preset="Slow", Edithreads=1, SourceMatch=1 )                # ������� ������� source-match. ��������� ��������� ����� � ���������.
# QTGMC( Preset="Slow", Edithreads=1, SourceMatch=1, Sharpness=0.4 ) # ������� source-match, �� �������� (�� 0.2). ������ ��������� � ��������, �� ������� ������ �� ���������� ������ 
# QTGMC( Preset="Slow", Edithreads=1, SourceMatch=1, Lossless=2 )    # ������� source-match � "���������" lossless. ����������� ��������� �� ��������, ����� �������� � �������������� �������

# QTGMC( Preset="Medium", Edithreads=1, SourceMatch=2, TR2=2 )       # ��������� �� ����� source-match, ����� � ���������, �� ��� �������, ���������. ���������� TR2 ��������� ���
# QTGMC( Preset="Slower", Edithreads=1, SourceMatch=3 )              # ������� ������� source-match, ���� �������� ��� ����� 2, �� ����� ��� ����� ���������
# QTGMC( Preset="Slower", Edithreads=1, SourceMatch=3, Lossless=2 )  # ������� ������� source-match � ��������� lossless. ����� ���������� ������ ��������� � ��������������� �����������
# QTGMC( Preset="Slower", Edithreads=1, SourceMatch=3, Lossless=1 )  # ������� ������� source-match � ��������� lossless. ������ �����������, �� ����������� ��������� �������� ������� � �������� 

# QTGMC( Preset="Slow", SourceMatch=3, Lossless=2, Edithreads=1, MatchEnhance=0.75 ) # ���������� ���������� �����������, ��������� ������� ����, ������� ����� ������, ����� ���� ������ �����
# QTGMC( Preset="Slow", SourceMatch=3, Lossless=2, Edithreads=1, MatchEnhance=0.75, NoiseProcess=1, NoiseRestore=0.7, Sigma=1.5 ) # ��� � ����, �������������� �������, ����� ������ �������� ����
  
# QTGMC( Preset="Slower", MatchPreset="Very Fast", Edithreads=1, SourceMatch=1 ) # ������� ������� source-match ������ (� ��� 3 ���� ������� ��� ��������� ������)
# QTGMC( Preset="Slower", MatchPreset="Faster", Edithreads=1, MatchPreset2="Ultra Fast", SourceMatch=3 ) # ������� � �������� source-match ������, ����� �����(� ��� 3 ���� ������� ��� ��������� ������)
# QTGMC( Preset="Slower", MatchPreset="Slow", Edithreads=1, MatchPreset2="Slow", SourceMatch=3 ) # ��� ����������� ��������� source-match �������(������ �� �����)

# ==== Noise Bypass / Denoising ====
# �������������� ���������
# QTGMC( Preset="Slower", EZDenoise=2.5, Edithreads=1, NoisePreset="Slow"   ) # �������������� ��������������, �������� ����� ������� ��������������, ������ ��������� �� ��������/��������
# QTGMC( Preset="Slower", EZKeepGrain=1.0, Edithreads=1, NoisePreset="Faster" ) # �������������� ���������� ����� - ��������� ��� �������� �����

# ��������������
# QTGMC( Preset="Slower", NoiseProcess=1, NoiseRestore=0.0, Edithreads=1, Sigma=4.0 ) # ��������� ��������������, ���� �������������� ������� �� ��������� Sigma
# QTGMC( Preset="Slower", NoiseProcess=1, NoiseRestore=0.0, Denoiser="dfttest", DenoiseMC=true, NoiseTR=2, Edithreads=1, Sigma=4.0 ) # ����� "����������" �������������� (����� ���������)

# ������� ���� / �����
# QTGMC( Preset="Slower", NoiseProcess=1, NoiseRestore=1.0, Edithreads=1, Sigma=2.0 ) # ��������� *����* ��� / ���������� �����������, ��� ����� ������� ���������
# QTGMC( Preset="Slower", NoiseProcess=1, GrainRestore=1.0, Edithreads=1, Sigma=2.0 ) # ������� ���������������, �� ������ ��������� "����� ����������" ������� �������� (������� �� TR2), 
 
# ���������� �����������  / �����
# QTGMC( Preset="Slower", NoiseProcess=2, GrainRestore=0.5, NoiseRestore=0.1, Edithreads=1, Sigma=2.5 ) # ���������� ����� ������� ����� 2, ��������� ��� � ����������� �������� ������� 

  QTGMC( Preset="Slower", NoiseProcess=2, GrainRestore=0.4, NoiseRestore=0.2, Edithreads=1, Sigma=1.8, \
           NoiseDeint="Generate", StabilizeNoise=true )  # ��� ����, �� � ������ ���������, ����� ���������� ������������ � ������

# �������������� ������� � ������ �������������

# SelectEven() # �������������� � ������� ���������
# SRestore(frate=25.000)
# SRestore(frate=23.976)

# ===== ��������� ������������ ����������� =====
# source1=last
# stab_reference= source1.crop(40,40,-40,-40).tweak(cont=1.07).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
# mdata = DePanEstimate(stab_reference,trust=1.0,dxmax=20,dymax=20)
# stab1 = DePanStabilize(source1,data=mdata,cutoff=0.5,dxmax=20,dymax=20,method=1,mirror=15)
# stab = stab1.crop(20,20,-20,-20)
# stab.levels(0,1.0,255,0,255).tweak(sat=1.1)#.spline36resize(W, H)

# ChangeFPS(50.000)      #  for PAL, ������� ��� ������������� ������� � ��������� �������
# ChangeFPS(60000,1001)  #  for NTSC ������� ��� ������������� ������� � ��������� �������


# ����������: ��� ������������� ������������ ���������� DV, HDV ��� AVCHD � ������������ ���������� ��������� ������������ �����������
# ��������� ��� ��������� �����, ��� �������������
# ��������������: �����������, ������������ � ������(� ������� ���������� STABILIZING) , ������������ XviD 4XvidPSP 5.0 ������!!!



