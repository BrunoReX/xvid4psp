#avstp.dll
#RgTools.dll
#Dither.dll
#flash3kyuu_deband.dll
#SmoothAdjust.dll
#mt_masktools-26.dll
#Dither.avsi
#O16mod.avsi

 

# SetMTMode(2)
# setmemorymax(640)

W = width(last)
H = height(last)

U16()

# ==== ������ 16-������� ����� ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                      # �������� 10 �� 8 ��� ������� ��� ���������� 16 ��� ��������� ������� ����� ��������

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-���
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-���
""") : Down10(8)                           #8-��� 


# ��� ����������� 8 ������� ��������� � 16 ���
#
###### �������������� ######
# ���������� � ���������� ����������: ������� ����\������ ����� ����������
# ������� � ���������� ������ AVC profile: High 10 Profile

