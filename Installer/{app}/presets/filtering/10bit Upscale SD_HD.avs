#avstp.dll
#RgTools.dll
#nnedi3.dll
#mvtools2mod.dll
#AddGrainC.dll
#mt_masktools-26.dll
#SmoothAdjust.dll
#dfttestmod.dll
#awarpsharp2.dll
#dither.dll
#dither.avsi
#flash3kyuu_deband.dll
#mt_xxpand_multi.avsi
#MSRmod.avs
#MSR_mod.avs
#Down10.avs
#HighPassSharp.avs


# SetMTMode(2)
# setmemorymax(1280)

# MSRmod( W=1280, H=720, HPS=true, str=4, r=0.15, GF3=false, lsb=true)
MSR_mod( W=1280, H=720, HPS=true, r=0.15, smode=2, radius=12, var=1, uvar=0, lsb=true)

OUTPUT_BIT_DEPTH = 10                       # �������� 10 �� 8 ��� ������� ��� ���������� 16 ��� ��������� ������� ����� ��������

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-���
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-���
""") : Down10(8)                           #8-���  

# ��� upscale SD � HD ��������� � ������������ 8 ������� ��������� � 16 ������
#
###### �������������� ######
# ���������� � ���������� ����������: ������� ����\������ ����� ����������
# ������� � ���������� ������ AVC profile: High 10 Profile

