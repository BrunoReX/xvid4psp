#RgTools.dll
#mvtools2.dll
#Warpsharp.dll
#mt_masktools-26.dll
#MSharpen.dll
#AddGrainC.dll
#GradFun2DB.dll
#hqdn3d.dll
#SangNom.dll
#Ylevels.avs
#maa.avs
#LEM.avs
#GradFun2DBmod.avs
#LimitedSharpenFaster Mod.avs


# setmtmode(2)
# setmemorymax(600)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0)
# maa()
LEM(ff="hqdn3d(2.0,1.5,3,2.25)",flem="LSFmod(strength=90,Smode=3,Smethod=3,ss_x=2.0,ss_y=2.0)",mode="LEM")
GradFun2DBmod(thr=1.2,thrC=1.6,str=0.3,strC=0.0,temp=50,adapt=64)
YlevelsS(0,1.0,255,0,255,false)


# Назначение: для качественной обработки DVD 
# Тип основного шумоподавителя: hqdn3d
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: бысрая




