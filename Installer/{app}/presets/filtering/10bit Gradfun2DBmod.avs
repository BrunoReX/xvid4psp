#avstp.dll
#RgTools.dll
#Dither.dll
#flash3kyuu_deband.dll
#SmoothAdjust.dll
#O16mod.avsi
#mt_masktools-26.dll
#dfttestmod.dll
#AddGrainC.dll
#Gradfun2DB.dll
#Dither.avsi
#Gradfun2DBmod.avs
#mt_xxpand_multi.avsi
 

# SetMTMode(2)
# setmemorymax(512)

W = width(last)
H = height(last)

U16 () # ������������ �� 8 � 16 ���
s16 = last
DitherPost (mode=-1) #  ������������ ����� � 8 ��� ��� ���������� 8-������� �������
gradfun2dbMod(thr=1.4,thrC=1.4,mode=2,str=0.3,strC=0.0,temp=50,adapt=64)    # ��������� 8 ������ �������� ��� Film
# gradfun2dbMod(thr=1.4,thrC=1.4,mode=2,str=0.3,strC=0.0,temp=100,adapt=64) # ��������� 8 ������ �������� ��� Anime
Dither_convert_8_to_16 ()                         # ������������ ����� � 16 ���
s16.Dither_limit_dif16 (last, thr=0.5, elast=2.0) # 16 ������ s16 c ������� ������� Dither_limit_dif16 ��������� � 16-������ ��� � ����������

# ==== ������ 16-������� ����� ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                        # �������� 10 �� 8 ��� ������� ��� ���������� 16 ��� ��������� ������� ����� ��������

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-���
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-���
""") : Down10(8)                           #8-��� 


# ��� ����������� 8 ������� ��������� � 16 ��� c ����������� Gradfun2dDBMod
#
###### �������������� ######
# ���������� � ���������� ����������: ������� ����\������ ����� ����������
# ������� � ���������� ������ AVC profile: High 10 Profile
