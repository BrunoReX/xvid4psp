#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mvtools2mod.dll
#Warpsharp.dll
#mt_masktools-26.dll
#hqdn3d.dll
#AddGrainC.dll
#GradFun2DB.dll
#Gradfun2DBMod 1.5.avsi
#SeeSaw.avs
#Ylevels.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
  
blksize = 16 
overlap = blksize/2
hpad = blksize
vpad = blksize
chroma = true
planes = chroma?4:0
chr31 = chroma?3:1
search = 5

source = last
preNR = source.hqdn3d(0.9,1.1,1.3,1.5)
preNR_super = preNR.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2, chroma=chroma)
vb2 = MAnalyse(preNR_super, isb=true, delta=2, blksize=16, overlap=8, truemotion=false, chroma=chroma, search=search)
vb1 = MAnalyse(preNR_super, isb=true, delta=1, blksize=16, overlap=8, truemotion=false, chroma=chroma, search=search)
vf1 = MAnalyse(preNR_super, isb=false,delta=1, blksize=16, overlap=8, truemotion=false, chroma=chroma, search=search)
vf2 = MAnalyse(preNR_super, isb=false,delta=2, blksize=16, overlap=8, truemotion=false, chroma=chroma, search=search)
mask1 = source.mmask(vb1, ml = 130, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 300) # маска1 SAD назад
mask2 = source.mmask(vb2, ml = 130, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 300) # маска2 SAD назад
mask3 = source.mmask(vf1, ml = 130, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 300) # маска1 SAD вперед
mask4 = source.mmask(vf2, ml = 130, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 300) # маска2 SAD вперед
tsadb = mt_lutxy(mask1,mask2,"x 255 < y 255 < x y + 2 / x ? y ?")
tsadf = mt_lutxy(mask3,mask4,"x 255 < y 255 < x y + 2 / x ? y ?")
tmask = mt_lutxy(tsadb,tsadf,"x 255 < y 255 < x y + 2 / x ? y ? 32 - 255 * 223 /")
smooth = preNR.GradFun2DB(1.01)
source2 = mt_merge(source,smooth,tmask,Y=3,U=chr31,V=chr31)
sharp = source2.LSFmod(defaults="slow", strength=100)
# sharp = source2.Seesaw(nrlimit=0, nrlimit2=99, bias=49, sstr=1.18, Spower=3, Szp=12, Sdamplo=4, SdampHi=19, Slimit=99,  sootheT=0, sootheS=0)
sharp_super = sharp.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, chroma=chroma, levels=1)
den = source2.MDegrain2(sharp_super,vb1,vf1,vb2,vf2,thSAD=160,thSCD1=240,thSCD2=96,plane=planes).Temporalsoften(2,1,1,6,2)
Diff = mt_makediff(source,den,U=chr31,V=chr31)
source.mt_makediff(Diff,U=chr31,V=chr31)
GradFun2DBmod(thr=1.4,thrC=1.4,mode=2,str=0.5,strC=0.0,temp=50,adapt=64)
YlevelsS(0,1.0,255,0,255,false)



# Назначение: для обработки качественных мягких исходников DVB типа телеканалов НТВ, Россия1 и ОРТ на основе метода повышения резкости "careful" 
# Тип предварительного шумоподавителя: NLMeansCL или fft3dgpu
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain2
# Тип шарпера:  включен
# Наличие фильтра DeBanding по умолчанию: вкл
# Скорость обработки: средняя         
# ПРЕДУПРЕЖДЕНИЕ!!! Применяя NLMeansCL, данный фильтр предназначен для видеокарт NVIDIA 8600 и выше с последними драйверами
