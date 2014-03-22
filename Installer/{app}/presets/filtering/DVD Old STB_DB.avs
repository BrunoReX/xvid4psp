#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mvtools2.dll
#mt_masktools-26.dll
#WarpSharp.dll
#VerticalCleaner.dll
#Gradfun2db.dll
#AddGrainC.dll
#flash3kyuu_deband.dll
#RemoveNonBobDiff.avs
#vinverse.avs
#Ylevels.avs
#srestore.avs
#GradFun2DBmod 1.5.avsi
 
 
setmtmode(2)
# setmemorymax(640)
 
# vinverse().srestore(omode=2, cache=9).tdecimate() #  устранение блендов

# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

source = last
w = source.Width()
h = source.Height() 
ts1 = source.temporalsoften(1,255,255,28,2)
ts2 = source.temporalsoften(2,255,255,28,2)
tempGauss = ts1.merge(ts2,0.357).merge(source,0.125)

repair0 = tempGauss.RemoveNonBobDiff( source, 4 )
epsilon = 0.0001 
spatialBlur = repair0.RemoveGrain(11).GaussResize( w,h, 0,0, w+epsilon,h+epsilon, p=2 ).Merge( repair0, 0.1 )
tweaked = mt_lutxy( repair0, source, "x 3 + y < x 3 + x 3 - y > x 3 - y ? ?", U=3,V=3 )
searchclip = spatialBlur.mt_lutxy( tweaked, "x 7 + y < x 2 + x 7 - y > x 2 - x 51 * y 49 * + 100 / ? ?", U=3,V=3 )

preNR_super = searchclip.MSuper(pel=2, sharp=2, rfilter=2)
dct = 0 # установить dct=5 при мерцании по яркости
vb2 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=2, blksize=16, overlap=8, dct=dct)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=1, blksize=16, overlap=8, dct=dct)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=1, blksize=16, overlap=8, dct=dct)
vf2 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=2, blksize=16, overlap=8, dct=dct)

source_super = source.MSuper(pel=2, sharp=2, levels=1)
tgmc = source.MDegrain1(source_super,vf1,vb1,thSAD=240)
repair1 = tgmc.RemoveNonBobDiff( source, 0 )
vresharp = Merge( repair1.mt_expand( mode="vertical", U=3,V=3 ), repair1.mt_inpand( mode="vertical", U=3,V=3 ) ) 
vresharp = vresharp.mt_lutxy( repair1, "x y < x 1 + x y > x 1 - x ? ?", U=3,V=3 ) 
#resharp = repair1.mt_lutxy( repair1.RemoveGrain(11), "x x y - "+ string(2) + " * +", U=3,V=3 ) 
resharp = repair1.mt_lutxy( vresharp.RemoveGrain(11), "x x y - "+ string(2) + " * +", U=3,V=3 )

SVThin = 1
SVThinSc = SVThin * 4.0 
vertMedD  = mt_lutxy( repair1, repair1.VerticalCleaner(mode=1), "y x - " + string(SVThinSc) + " * 128 +", U=1,V=1 ).Blur( 1,0 )
neighborD = mt_lutxy( vertMedD, vertMedD.RemoveGrain( 11,-1 ), "y 128 - abs x 128 - abs > y 128 ?" )
thin  = resharp.mt_adddiff( neighborD, U=2,V=2 )
backBlend1 = thin.mt_makediff( mt_makediff( thin, repair1, U=1,V=1 ).RemoveGrain( 11,-1 ).GaussResize( w,h, 0,0, w+epsilon,h+epsilon, p=5 ), U=2,V=2 )
sharpLimit1 =  backBlend1.Repair( backBlend1.Repair( source, 12 ), 1 ) 
backBlend2 = sharpLimit1.mt_makediff( mt_makediff( sharpLimit1, repair1, U=1,V=1 ).GaussResize( w,h, 0,0, w+epsilon,h+epsilon, p=5 ), U=2,V=2 )

stableSuper = backBlend2.MSuper( pel=2, sharp=2, levels=1 ) 
stable  = backBlend2.MDegrain2(stableSuper,vf1,vb1,vf2,vb2, thSAD=300)
repair2 = stable.RemoveNonBobDiff(source, 4)
processed = repair2.Repair( repair2.Repair(source, 12 ), 1)
processed 

# ENHANCING
# f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)
GradFun2DBmod(thr=1.4,thrC=1.6,mode=2,str=0.8,strC=0.0,temp=50,adapt=64)


# Назначение: для обработки старых проблемных DVD c флюктацией строк, а также музыкальных клипов или Cartoon с блендами
# Тип предварительного шумоподавителя: CamCD, DePulse
# Тип основного шумоподавителя: на основе векторного анализа оценки движения на MDegrain3+ MCompensate c RemoveDirtMC
# Тип шарпера: resharp
# наличие фильтра DeBanding: включен
# Скорость обработки: медленная  
