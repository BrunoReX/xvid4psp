#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Depan.dll
#DepanEstimate.dll
#mvtools2.dll
#mvtools2svp.dll
#RgTools.dll
#fft3dfilter.dll
#fft3dgpu.dll
#nnedi3.dll
#addgrainC.dll
#HQDn3D.dll
#mt_masktools-26.dll
#FluxSmooth.dll
#WarpSharp.dll
#GradFun2DB.dll
#GradFun2DBmod 1.5.avsi
#minblur.avs
#TemporalDegrain_ChromaMod V1.0.avs
#InterFrame.avsi


# setmtmode(2)
# setmemorymax(640)

Try { InterFrame() }
 Catch(FlowPath)
 {
 FlowPath = MidStr(FlowPath, FindStr(FlowPath, "(") + 1)
 FlowPath = MidStr(FlowPath, 1, FindStr(FlowPath, "\InterFrame"))
 }

ConvertToRGB32().CamCD(9,1).converttoyv12() # ���������� ��������� ���� ����������

# ==== ��������� ������������ ����������� ====
source = last
stab_reference = source.crop(64,48,-64,-48).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata = DePanEstimate(stab_reference,trust=4.0,pixaspect=1.094,dxmax=32,dymax=24) # trust=1...100 ��������� ����� �����
stab = DePanStabilize(source,data=mdata,cutoff=1.0,dxmax=32,dymax=24,pixaspect=1.094,method=0,mirror=15) # or pixaspect=0.911 for NTSC
stab.tweak(sat=1.05).crop(24,18,-24,-18)

# ==== �������������� ====
TemporalDegrain_ChromaMod(GPU=true,sigma=16,pel=2,degrain=3,limit=235,SAD1=400,SAD2=256,HQ=1)

# ==== Upscale ====
# nnedi3_rpow2(rfactor=2,cshift="spline36resize")

# ==== Sharpening ====
unsharpmask(60,1,0)
#sharpen(0.4).sharpen(0.4).blur(0.2)

# ������������ �������
# InterFrame(Preset="Fast", GPU=false, FlowPath=FlowPath) # ������� �������� ������� ������
# InterFrame(Preset="Fast", GPU=false, NewNum=30000, NewDen=1001, FlowPath=FlowPath) # for NTSC-film
# InterFrame(Preset="Fast", GPU=false, NewNum=25, NewDen=1, FlowPath=FlowPath) # for PAL-film

GradFun2DBmod(thr=1.6,thrC=2.0,str=1.0,strC=0.0,temp=50,adapt=64)
coloryuv(off_U=-0,off_V=-0).levels(0,1.0,255,0,255)
 


# ����������: ��� ������������ ��������� ��������� DVC (�������� ����������) � ��������� ������������� ����������� � ������������ ������������ �������
# ������� ������� ���������� ���������� ����������� � ��������� ����: �������
# ��� ���������������� ��������������: fft3dgpu ��� fft3dfilter
# ��� ��������� ��������������: �� ������ ���������� ������� ������ �������� �� ���� ������� TemporalDegrain_beta
# ��� ������������: ���������������-��������� FluxSmooth 
# �������������� ��������� ����������� HDRAGC
# ��� �������: ContraSharpening + unsharpmask
# �������� ���������: ���������
# ������������� ����������� SmoothDeInterlace ��� YadifmodNNEDI3 (�2)


