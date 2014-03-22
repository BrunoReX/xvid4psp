#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#AvsFilterNet.dll
#fft3dgpu.dll
#AddGrainC.dll
#mt_masktools-26.dll
#GradFun2DB.dll
#mvtools2mod.dll
#Dither.dll
#flash3kyuu_deband.dll
#Dither.avsi
#mt_xxpand_multi.avsi
#SeeSaw.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(640)

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)
  
blksize = 8 
overlap = blksize/2
hpad = blksize
vpad = blksize
chroma = true
planes = chroma?4:0
chr31 = chroma?3:1
search = 5

source = last
setmtmode(5)
preNR = source.NLMeansCL(A=4, S=2, B=1, aa=1.0, h=1.0, plane=planes) # for NVIDIA
# preNR = source.fft3dgpu(bw=16,bh=16,ow=8,oh=8,bt=1,sigma=2.0,sigma2=1.3,sigma3=1.5,sigma4=0.5,plane=planes,mode=1,precision=2) # for VC ATI
setmtmode(2)

preNR_super = preNR.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2, chroma=chroma)
vb2 = MAnalyse(preNR_super, isb=true, delta=2, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, search=search)
vb1 = MAnalyse(preNR_super, isb=true, delta=1, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, search=search)
vf1 = MAnalyse(preNR_super, isb=false,delta=1, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, search=search)
vf2 = MAnalyse(preNR_super, isb=false,delta=2, blksize=blksize, overlap=overlap, truemotion=false, chroma=chroma, search=search)
mask1 = source.mmask(vb1, ml = 130, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 300) # маска1 SAD назад
mask2 = source.mmask(vb2, ml = 130, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 300) # маска2 SAD назад
mask3 = source.mmask(vf1, ml = 130, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 300) # маска1 SAD вперед
mask4 = source.mmask(vf2, ml = 130, kind = 1, Ysc = 255, gamma = 0.999, thSCD1 = 300) # маска2 SAD вперед
tsadb = mt_lutxy(mask1,mask2,"x 255 < y 255 < x y + 2 / x ? y ?")
tsadf = mt_lutxy(mask3,mask4,"x 255 < y 255 < x y + 2 / x ? y ?")
tmask = mt_lutxy(tsadb,tsadf,"x 255 < y 255 < x y + 2 / x ? y ? 32 - 255 * 223 /")
smooth = preNR.GradFun2DB(1.01)
source2 = mt_merge(source,smooth,tmask,Y=3,U=chr31,V=chr31)
sharp = source2.LSFmod(defaults="old", strength=100)
# sharp = source2.Seesaw(nrlimit=0, nrlimit2=99, bias=49, sstr=1.18, Spower=3, Szp=12, Sdamplo=4, SdampHi=19, Slimit=99,  sootheT=0, sootheS=0)
sharp_super = sharp.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, chroma=chroma, levels=1)
source2.MDegrain2(sharp_super,vb1,vf1,vb2,vf2,thSAD=150,thSCD1=160,thSCD2=96,limit=102,plane=planes,lsb=true)

# ==== DEBANDING ====
f3kdb(16, 56, 36, 36, 0, 0, input_mode=1, output_mode=1)#.Dither_limit_dif16(last, thr=0.25, Y=3, U=3, V=3)
# GradFun3 (thr=1.4*0.3, smode=0, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.07, uvar=0, soft=2)

den = DB.DitherPost(mode=6,ampo=1,ampn=1).Temporalsoften(2,1,1,6,2)
Diff = mt_makediff(source,den,U=chr31,V=chr31)
source.mt_makediff(Diff,U=chr31,V=chr31)


# Назначение: для обработки качественных мягких исходников DVB типа телеканалов НТВ, Россия1 и ОРТ на основе метода повышения резкости "careful" 
# Тип предварительного шумоподавителя: NLMeansCL или fft3dgpu
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на шумоподавителе MDegrain2
# Тип шарпера:  включен
# Наличие фильтра DeBanding по умолчанию: вкл
# Скорость обработки: средняя         
# ПРЕДУПРЕЖДЕНИЕ!!! Применяя NLMeansCL, данный фильтр предназначен для видеокарт NVIDIA 8600 и выше с последними драйверами
