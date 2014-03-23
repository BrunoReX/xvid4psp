#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#Bifrost.dll
#mvtools2mod.dll
#WarpSharp.dll
#degrainmedian.dll
#SmoothAdjust.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#SmoothContrast.avsi
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(640)
# ColorYUV(gain_y=0,cont_y=0,cont_u=0,cont_v=0,gain_v=0,gain_u=-0,off_y=0,off_u=-0,off_v=-0)

# удаление радужности и цветового шума
  ConvertToRGB32().CamCD(2,1).ConvertToYV12()
# Bifrost(interlaced=false)

blksize = 16
overlap = blksize/2
hpad = blksize
vpad = blksize
lambda = 512
search = 5
chroma = false
planes = chroma?4:0 

source = last
preNR = source.degrainmedian(limitY=4,limitUV=5,mode=2)
preNR_super = preNR.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, rfilter=2, chroma=chroma )
source_super = source.MSuper(hpad=hpad, vpad=vpad, pel=2, sharp=2, levels=1, chroma=chroma )
vb1 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, lambda=lambda, chroma=chroma )
vf1 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=1, blksize=blksize, overlap=overlap, search=search, lambda=lambda, chroma=chroma )

# Use the vectors to create motion and static masks, we use these for prefilter and sharpening masks
maskstar = source.mt_binarize(upper=false)
maskmotion1 = source.mmask(kind=0, vb1, gamma=1, ml=130)
maskmotion1 = mt_adddiff(maskmotion1, mt_makediff(maskmotion1,source))
maskmotion2 = source.mt_motion(thy1=5,thy2=10,thc1=5,thc2=10,u=3,v=3).mt_lut(expr="x 255 == x 156 - 0 ?")
maskmotion  =  mt_lutxy(maskmotion1,maskmotion2,expr="x 0 == 0 x y < y x ? ?") 
maskstatic  = mt_invert(maskmotion)
  
NR = source.MDegrain1(source_super,vb1,vf1,thSAD=160,thSCD1=160,thSCD2=90,limit=102,plane=planes).Temporalsoften(2,2,2,6,2)
den = mt_merge(NR,source,maskstar)

# EDGECLEANING
mP = mt_edge(den,"prewitt",0,255,0,0,V=1,U=1)
mS = mP.mt_expand(mode=mt_square(radius=2),U=1,V=1).mt_inflate(U=1,V=1)
mD = mt_lutxy(mS,mP.mt_inflate(U=1,V=1),"x y - "+string(32)+" <= 0 x y - ?",U=1,V=1).mt_inflate(U=1,V=1).removegrain(20,-1)
smE = mt_merge(den,Eval("den." + "Removegrain(2,0)"),mD,luma=true,U=3,V=3)

# don't sharpen motion, dark area or starfield areas
maskstatic = mt_lutxy(smE,maskstatic,"x 32 < 0 y ?")
  
# SHARPENING
b1c = source.MCompensate(source_super,vb1)
f1c = source.MCompensate(source_super,vf1)
Sclp = smE.LSFmod(defaults="fast", preblur="ON", strength=80)
Tmax = source.mt_logic(f1c,"max",U=1,V=1).mt_logic(b1c,"max",U=1,V=1)
Tmin = source.mt_logic(f1c,"min",U=1,V=1).mt_logic(b1c,"min",U=1,V=1)
shrp = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)
mt_merge(smE, shrp, maskstatic)

# LEVELS
# SmoothContrast(contrast=0.02) 
# SmoothCurve(Ycurve="0-0;16-0;235-255;255-255", Ucurve="0-0;16-0;240-255;255-255", Vcurve="0-0;16-0;240-255;255-255", interp=0) 
  SmoothLevels(gamma=1.0, useopt=0) # 0 = automatic choice; 1 = use C code; 2 = use SSE2 code; 3 = use AVX2 code

# DEBANDING
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)


# Назначение: Качественный, наиболее основной пресет для обработки DVB 
# Тип предварительного шумоподавителя для векторного анализа: blur
# Тип основного шумоподавителя: на основе векторного анализа оценки движения c масками движения и конечным шумоподавителем MDegrain2 
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: f3kdb включен
# Скорость обработки: медленная
