#avstp.dll
#EEDI2.dll
#nnedi3.dll
#mt_masktools-26.dll
#SangNom.dll
#TEdgeMask.dll
#tcanny.dll
#MSharpen.dll
#mvtools2.dll
#RgTools.dll
#warpsharp.dll
#variableblur.dll
#dfttestmod.dll
#SmoothAdjust.dll
#flash3kyuu_deband.dll
#AddGrainC.dll
#Toon-v1.1.dll
#awarpsharp2.dll
#dither.dll
#TEdgeMask.dll
#EdgeCleaner.avs
#dither.avsi
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#Soothe.avs
#LimitedSharpenFaster mod.avs
#TAA.avsi
#MCAA.avsi
#mt_xxpand_multi.avsi
#Down10.avs


# setmtmode(2)
# setmemorymax(1280)

W = width(last)
H = height(last)

MCAA(aafilter="taa(aatype=-3, preaa=-1, mtype=0, sharp=140, postaa=false)", sharptype="slow", predown=true, predownMC=true,\
     Tradius=2, aarepair=24, stabilize=true)
EdgeCleaner(smode=1,strength=17)

# DeBanding
# LumaDBL(lsb=true) 
GradFun3(smode=1, thr=0.5, radius=12, lsb=true)

# ==== ������ 16-������� ����� ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                        # �������� 10 �� 8 ��� ������� ��� ���������� 16 ��� ��������� ������� ����� ��������

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-���
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-���
""") : Down10(8)                           #8-��� 


# ��� ������������� �������������� ����� c� ����� �� ������������ ����������� c ��������� �������� ������ �������� � ������������ � 16 ���
# ��� ������������� �� ���������: TAA
# ��� ��������������: �� ������ ���������� ������� ������ �������� �� ������� MDegrain
# ��� �������: LSFmod  
# ������� ������� DeBanding �� ���������: LumaDBL
# �������� ���������: ���������
#
###### �������������� ######
# ���������� � ���������� ����������: ������� ����\������ ����� ����������
# ������� � ���������� ������ AVC profile: High 10 Profile

