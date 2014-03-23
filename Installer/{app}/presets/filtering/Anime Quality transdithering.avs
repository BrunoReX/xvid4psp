#avstp.dll
#RgTools.dll
#EEDI2.dll
#mt_masktools-26.dll
#SangNom.dll
#nnedi3.dll
#TDeint.dll
#TMM.dll
#TIVTC.dll
#yadifmod.dll
#Warpsharp.dll
#Toon-v1.1.dll
#vmToon-v0.74.avs
#GradFun2DB.dll
#medianblur.dll
#awarpsharp2.dll
#dither.dll
#TTempSmooth.dll
#Dither.avsi
#DeHaloH.avs
#EdgeCleaner.avs
#aa.avs
#FastLineDarken 1.4x MT MOD.avsi


setmtmode(2)
setmemorymax(640)

#ColorYUV(levels="TV->PC") 
#ColorYUV(gain_y=0,cont_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) 

# ===== Варианты деинтерлейса =====

# 1-й вариант NTSC 29.97 fps
#tfm(order=1).tdecimate(hybrid=1) 

# 2-й вариант NTSC 29.97 fps
#AssumeTFF() # подберите поле: верхнее поле первым для DVD
#AssumeBFF() # подберите поле: нижнее поле первым для видеокамер
#edeintted = nnedi3(field=-2,qual=2)
#res = TDeint(edeint=edeintted,order=-1,mode=2,sharp=true,mtnmode=3,full=false,tryWeave=false,type=1,emask=TMM(mode=1))
#tfm(order=-1,clip2=res,pp=7,slow=2,mode=2,chroma=false,display=false).tdecimate(hybrid=1,mode=1,vfrDec=0) 

# 3-й вариант NTSC 29.97 fps
#interp = nnedi3(field=1,qual=2)
#deint = tdeint(mode=0,order=1,field=1,edeint=interp,slow=2,emask=TMM(mode=0,order=1,field=1))
#tfm(mode=3,order=1,clip2=deint,slow=2).tdecimate() # or tdecimate(hybrid=1)

# 4-й вариант PAL 25.00 fps
#edeintted = TDeint(edeint=TomsMoComp(-1,11,0),order=-1,mode=0,sharp=true,mtnmode=3,full=true,tryWeave=false,type=1,slow=2,emask=TMM(mode=0))
#Yadifmod(mode=0,edeint=edeintted)
 
# 5-й вариант PAL 25.00 fps
#AssumeTFF() # подберите поле: верхнее поле первым для DVD
#AssumeBFF() # подберите поле: нижнее поле первым для видеокамер
#edeintted = nnedi3(field=-2,qual=2)
#TDeint(edeint=edeintted,order=-1,mode=2,sharp=true,mtnmode=3,full=false,tryWeave=false,type=1,emask=TMM(mode=1))

# 6-й вариант PAL 25.00 fps
#interp = nnedi3(field=1,qual=2)
#tdeint(mode=0,order=1,field=1,edeint=interp,slow=2,emask=TMM(mode=0,order=1,field=1))

  
# ===== Шумоподавление =====
o = last
emask = o.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = emask.mt_expand()
aa_clp = o.maa()
Dither2Pre ("TTempSmooth(lthresh=16, cthresh=20, lmdiff=8, cmdiff=12, scthresh=48)", overlap=0, tvopt=true)
ref = last
mask = DitherPost (mode=-1).mt_edge (mode="min/max", thY1=0, thY2=255, thC1=0, thC2=255)
mask = mask.mt_binarize (1, u=3, v=3).mt_expand (u=3, v=3).mt_expand (u=3, v=3)
mask = mask.RemoveGrain(20).RemoveGrain(20)
Dither_bilateral16 (radius=16, thr=1.5, wmin=1, flat=0.75)
Dither_bilateral16 (radius=8, thr=2.5, wmin=1, flat=0.33, ref=ref)
Dither_limit_dif16 (ref, thr=0.3)
DitherPost ()
flat = mt_merge (last, o, mask, u=3, v=3)
mt_merge(flat, aa_clp, m_aa)

# ===== Варианты затемнения линий =====
ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200),last, "AverageLuma()",">","50")
# ConditionalFilter(last.toon(0.2),last, "AverageLuma()",">","50") 
# ConditionalFilter(last.vmToon(sharpen=true,thinning=24,strength=36,luma_cap=203,threshold=8),last, "AverageLuma()",">","50")  


# Назначение: Типовой пресет для обработки аниме  
# Подавление радужности изображения по умолчанию: отсутствует
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: пространственно-временной фильтр TTempSmooth
# Наличие фильтра DeBanding по умолчанию: включен Dither
# Скорость обработки: средняя