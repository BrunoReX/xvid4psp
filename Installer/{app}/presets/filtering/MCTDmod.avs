#FFT3DFilter.dll
#FFT3dgpu.dll
#RgTools.dll
#mvtools2T.dll
#TTempsmooth.dll
#EEDI2.dll
#Deblock.dll
#DctFilter.dll
#Sangnom.dll
#Gradfun2db.dll
#WarpSharp.dll
#mt_masktools-26.dll
#Gradfun2db.dll
#AddGrainC.dll
#dither.dll
#Deblock_QEDmod.avsi
#Gradfun2dbmod 1.5.avsi
#Ylevels.avs
#LimitedSharpenFaster MOD.avs
#MCTDmod.avsi

# Setmtmode(2)
# setmemorymax(768)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# for DeBlocking
# MCTD(settings="high", radius=3, sigma=8, limit=-1, limit2=4, chroma=false, twopass=true, useTTmpSm=false, GPU=false, fixband=true, pp=true, protect=true, deblock=true, useQED=true, enhance=true, sharp=true)
  
# MCTD(settings="low", enhance=true, gpu=true)       
# MCTDsettings="very low", enhance=true, gpu=true)  
  MCTD(settings="medium", sigma=4, gpu=true, enhance=true) 
# MCTD(settings="medium", sigma=4, gpu=true, enhance=true, useTTmpSm=true) 
# MCTD(settings="high", sigma=4, bwbh=8, owoh=4, overlap=4, blksize=8, enhance=true, gpu=true)       
# MCTD(settings="very high", sigma=4, enhance=true, gpu=true)

# ����������: ��� ����� ������������ ��������� DVD � BD
# ��� ���������������� ��������������: fft3dfilter
# ��� ��������� ��������������: �� ������ ���������� ������� ������ �������� �� ���� ������� MCTDmod
# ��� �������: LSFmod 
# ������� ������� DeBanding �� ���������: �������
# �������� ���������: ���������



