#avstp.dll
#mvtools2mod.dll
#RgTools.dll
#AddGrainC.dll
#Gradfun2db.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#McDegrainSharp.avs
#Gradfun2DBMod 1.5.avsi


# setmtmode(2)
# setmemorymax(640)

#ColorYUV(gain_y=1,cont_y=5,cont_u=3,cont_v=3,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)
McDegrainSharp(frames=2, bblur=0.6, csharp=0.6, bsrch=true)
# f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=72,cb=48,cr=48,grainY=0,grainC=0)
Gradfun2DBmod(thr=1.4,thrC=1.4,mode=2,str=0.3,strC=0.0,temp=50,adapt=64)

# ����������: ��� ��������� ������������ DVD � ����������� �� ��������
# ��� ���������������� ��������������: removegrain(mode = 17)
# ��� ��������� ��������������: �� ������ ���������� ������� ������ �������� �� �������������� MDegrain2
# ��� �������: LSFmod 
# ������� ������� DeBanding �� ���������: �����������
# �������� ���������: �������                     

