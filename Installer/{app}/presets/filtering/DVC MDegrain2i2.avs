#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Cnr2.dll
#Warpsharp.dll
#mvtools2.dll
#ColorMatrix.dll
#AutoYUY2.dll
#MDegrain2i2.avs
#YV12ToYUY2i.avs


#  setmemorymax(640)
   
# Cnr2("oxx",8,16,191,100,255,32,255,false)  # �������� ���������� � ��������� ���� ��� VHS
# Cnr2("oxx",8,14,191,75,255,20,255,false)   # �������� ���������� � ��������� ���� ��� Laserdisc
  ConvertToRGB32(interlaced=true).CamCD(9,1) # �������� ���������� � ��������� ����

# ==== �������������� ====
# RGBAdjust(r=1.05, g=1.05, b=1.0, rb=0, gb=0, bb=0, rg=1.0, gg=1.0, bg=1.0)  # ����� ���� �������� �����������, ����� ������ ����� ����� �������
# RGBAdjust(r=1.0, g=1.05, b=1.05, rb=0, gb=0, bb=0, rg=1.0, gg=1.0, bg=1.0)  # ����� ���� �������� �����������, ����� ������ ����� ������� �������
# RGBAdjust(r=1.0, g=1.0, b=1.0, rb=0, gb=0, bb=0, rg=0.95, gg=0.95, bg=1.05) # ����� ���� �������� �����, �� ����� ������ ����� ��������
# RGBAdjust(r=1.1, g=1.1, b=1.1, rb=-10, gb=-10, bb=-10, rg=0.95, gg=0.95, bg=1.05) # ׸���� ���� �������� ����-�����, ����� ������������ ������, ����� ������ ����� ��������
# RGBAdjust(r=1.1, g=1.1, b=1.1, rb=-10, gb=-10, bb=-10, rg=1.05, gg=1.05, bg=1.15) # �� �� �� �����, �� ����� ���������� ����� �������
 
  ConvertToYV12(interlaced=true)

  chroma = last
  MDegrain2i2(chroma,8,4,5)

# ColorMatrix(mode="Rec.709->Rec.601", inputFR=false, clamp=0,interlaced=true)
# ConvertToYUY2(interlaced=true)
# AutoYUY2()
  YV12ToYUY2i()

