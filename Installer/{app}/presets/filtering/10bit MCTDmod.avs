#avstp.dll
#FFT3DFilter.dll
#FFT3dgpu.dll
#RgTools.dll
#dfttestmod.dll
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
#TEdgeMask.dll
#flash3kyuu_deband.dll
#SmoothAdjust.dll
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#Deblock_QEDmod.avsi
#dither.avsi
#mt_xxpand_multi.avsi
#Gradfun2dbmod.avs
#LimitedSharpenFaster MOD.avs
#MCTDmod.avsi
#Down10.avs


# Setmtmode(2)
# setmemorymax(1280)

W = width(last)
H = height(last)

# MCTD(settings="Low",   gpu=true, enhance=true, dbF="""LumaDBL(lsb=true, ditherC="f3kdb_dither()")""") # for DVDRip-AVC
  MCTD(settings="VERY LOW", gpu=true, enhance=true, dbF="""LumaDBL(g1str=5, g2str=3, g3str=2, g1soft=4, g2soft=10, g3soft=20, g1size=1.2, g2size=0.9, g3size=0.7, lsb=true)""") # for BDRip

# MCTD(settings="Low", sigma=8, stabilize=true, gpu=true, edgeclean=true, enhance=true, ECrad=4, ECthr=24, dbF="LumaDBL(lsb=true)") # for Cartoon
# MCTD(settings="VERY LOW", sigma=4, stabilize=true, gpu=true, edgeclean=true, enhance=true, ECrad=4, ECthr=24, AA=true, dbF="LumaDBL(lsb=true)") # for anime

# ==== ������ 16-������� ����� ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                        # �������� 10 �� 8 ��� ������� ��� ���������� 16 ��� ��������� ������� ����� ��������

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-���
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-���
""") : Down10(8)                           #8-��� 


# ����������: ��� ������������ ��������� DVD � BD � ������������ 8 ������� ��������� � 16 ������
# ��� ���������������� ��������������: fft3dfilter
# ��� ��������� ��������������: �� ������ ���������� ������� ������ �������� �� ���� ������� MCTDmod
# ��� �������: LSFmod 
# ������� ������� DeBanding �� ���������: �������
# �������� ���������: ���������
#
###### �������������� ######
# ���������� � ���������� ����������: ������� ����\������ ����� ����������
# ������� � ���������� ������ AVC profile: High 10 Profile
# ���������� ����� ��������������� ��� threads=4, ��� setmtmode(3,4)




