#RgTools.dll
#mvtools2.dll
#degrainmedian.dll
#WarpSharp.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#LimitedSharpenFaster Mod.avs


# setmtmode(2)
# setmemorymax(640)
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

blksize = 8
overlap = blksize/2
hpad = blksize
vpad = blksize
lambda = 512
search = 5

source = last
preNR = source.degrainmedian(limitY=4,limitUV=5,mode=2)
preNR_super = preNR.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2)
source_super = source.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, levels=1)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=true, delta=1, blksize=blksize, overlap=overlap, search=search, lambda=lambda)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=true, delta=1, blksize=blksize, overlap=overlap, search=search, lambda=lambda)

# Use the vectors to create motion and static masks, we use these for prefilter and sharpening masks
maskstar = source.mt_binarize(upper=false)
maskmotion1 = source.mmask(kind=0, vb1, gamma=1, ml=130)
maskmotion1 = mt_adddiff(maskmotion1, mt_makediff(maskmotion1,source))
maskmotion2 = source.mt_motion(thy1=5,thy2=10,thc1=5,thc2=10,u=3,v=3).mt_lut(expr="x 255 == x 156 - 0 ?")
maskmotion  =  mt_lutxy(maskmotion1,maskmotion2,expr="x 0 == 0 x y < y x ? ?") 
maskstatic  = mt_invert(maskmotion)
  
NR = source.MDegrain1(source_super,vb1,vf1,thSAD=150,thSCD1=300,thSCD2=96,limit=102,plane=4)
den = mt_merge(NR,source,maskstar)

# PROTECTING
threshold = 16
cutoff = 64
maxdiff = 4
rg17 = den.removegrain(17,-1)
iOB  = source.mt_lut("x "+string(cutoff)+" >= x 0 ?",U=1,V=1)
mB   = mt_makediff(iOB,rg17,U=1,V=1).mt_binarize(128+threshold,upper=false,U=1,V=1).removegrain(5,-1)
lB   = mt_lutxy(den,source,"x y - abs "+string(maxdiff)+" <= x x y - 0 < y "+string(maxdiff)+" - x ? ?",U=1,V=1)
smB  = mt_merge(den,lB,mB,U=2,V=2)

# EDGECLEANING
mP = mt_edge(smB,"prewitt",0,255,0,0,V=1,U=1)
mS = mP.mt_expand(mode=mt_square(radius=2),U=1,V=1).mt_inflate(U=1,V=1)
mD = mt_lutxy(mS,mP.mt_inflate(U=1,V=1),"x y - "+string(32)+" <= 0 x y - ?",U=1,V=1).mt_inflate(U=1,V=1).removegrain(20,-1)
smE = mt_merge(smB,Eval("smB." + "Removegrain(2,0)"),mD,luma=true,U=3,V=3)

# don't sharpen motion, dark area or starfield areas
maskstatic = mt_lutxy(smE,maskstatic,"x 32 < 0 y ?")
  
# SHARPENING
b1c = source.MCompensate(source_super,vb1)
f1c = source.MCompensate(source_super,vf1)
Sclp = smE.LSFmod(defaults="fast", preblur="ON", strength=90)
Tmax = source.mt_logic(f1c,"max",U=1,V=1).mt_logic(b1c,"max",U=1,V=1)
Tmin = source.mt_logic(f1c,"min",U=1,V=1).mt_logic(b1c,"min",U=1,V=1)
shrp = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)
mt_merge(smE, shrp, maskstatic)

# DEBANDING
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=52,cb=40,cr=40,grainY=0,grainC=0)


# Назначение: Качественный, наиболее основной пресет для обработки DVD 
# Тип предварительного шумоподавителя: blur
# Тип основного шумоподавителя: на основе векторного анализа оценки движения c масками движения и конечным шумоподавителем MDegrain1
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: f3kdb включен
# Скорость обработки: медленная
