#avstp.dll
#RgTools.dll
#Fluxsmooth.dll
#Dither.dll
#mt_masktools-26.dll
#SmoothAdjust.dll
#flash3kyuu_deband.dll
#AddGrainC.dll
#TEdgeMask.dll
#dither.avsi
#f3kgrain_v0.4.avsi
#GrainFactoryLite_v1.2.avsi
#LumaDBLite_v0.7.avsi
#mt_xxpand_multi.avsi
#SPresso.avs
#STpresso.avs
#O16mod.avsi
#Dither.avsi
#mt_xxpand_multi.avsi
 

# SetMTMode(2)
# setmemorymax(768)

W = width(last)
H = height(last)

# ==== Soft Denoiced ====
Spresso(4,24,2).STpresso(4,24,4,12,3,49,1)#.sharpen(0.1)
U16()  # 8 -> 16 

# ==== DeBanding ===              
# setmtmode(5)
# LumaDBL(g1str=3, g2str=2, g3str=0, g1soft=5, g2soft=10, g3soft=20, g1size=1.1, g2size=0.9, g3size=0.7, lsb_in=true, lsb=true)
# setmtmode(2)

# GradFun3(smode=0, thr=0.35, radius=12, lsb_in=true, lsb=true)
 
# GradFun3 (thr=0.45, smode=0, radius=16, lsb_in=true, lsb=true)
# Dither_add_grain16 (var=0.05, uvar=0, soft=2) # ���������� ������������� �����

f3kdb(16, 56, 36, 36, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)#.Dither_limit_dif16(last, thr=0.60, Y=3, U=3, V=3)
 
# ==== ������ 16-������� ����� ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                      # �������� 10 �� 8 ��� ������� ��� ���������� 16 ��� ��������� ������� ����� ��������

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-���
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-���
""") : Down10(8)                           #8-���  

# ��� ������ � �������� �������������� � ����������� 8-������� ��������� � 16 ��� c ����������� 
#
###### �������������� ######
# ���������� � ���������� ����������: ������� ����\������ ����� ����������
# ������� � ���������� ������ AVC profile: High 10 Profile
