#avstp.dll
#RgTools.dll
#EEDI2.dll
#mt_masktools-26.dll
#SangNom.dll
#mvtools2mod.dll
#nnedi3.dll
#TDeint.dll
#fft3dgpu.dll
#TMM.dll
#TIVTC.dll
#yadifmod.dll
#Warpsharp.dll
#Toon-v1.1.dll
#vmToon-v0.74.avs
#medianblur.dll
#GradFun2DB.dll
#medianblur.dll
#awarpsharp2.dll
#dither.dll
#Dither.avsi
#DeHaloH.avs
#EdgeCleaner.avs
#minblur.avs
#aa.avs
#mt_xxpand_multi.avsi
#FastLineDarken 1.4x MT MOD.avsi
#Contrasharpening.avs


# setmtmode(2)
# setmemorymax(768)

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
source = last.assumeframebased()   
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()

aa_clp = source.maa()

tr = 3   # Temporal radius
super = source.MSuper (pel=2,sharp=2)
multi_vec = MAnalyse (super, multi=true, delta=tr, blksize=8, overlap=4, truemotion=true, search=5)
den = source.MDegrainN (super, multi_vec, tr, thSAD=400, thSAD2=150, lsb=true)

flat = den.DitherPost(mode=-1)
mt_merge(flat,aa_clp,m_aa)
EdgeCleaner(smode=1,strength=20)

lvl_overshoot = 3.5
lvl_details = 2

o = last
w = Width ()
h = Height ()

edges   = mt_edge (mode="prewitt", thY1=0, thY2=255)
details = mt_edge (mode="min/max", thY1=0, thY2=255)

mask_lines     = edges.mt_lut ("x 6 - 50 *")
mask_lines     = mask_lines.mt_expand ().mt_expand ().mt_expand ().mt_expand ()
mask_overshoot = edges.mt_lut ("x "+String(lvl_overshoot)+" - 2 ^ 40 *")
mask_overshoot = mask_overshoot.mt_inpand ().RemoveGrain (12, -1)
mask_overshoot = mt_logic (mask_overshoot, mask_lines, mode="max")
mask_details   = details.mt_binarize (lvl_details)
mask_details   = mask_details.RemoveGrain (21 ,-1).mt_expand ()
mask_final     = mt_logic (mask_overshoot, mask_details, mode="min")
mask_final     = mask_final.RemoveGrain (20, -1).RemoveGrain (20, -1)

o
BicubicResize (w/16 * 4, h/16 * 4, 1, 0).BicubicResize (w, h, 1, 0)
GradFun3 (radius=4, thr=0.6, mask=0, mode=6)  # Huge blur
mt_merge (last, o, mask_overshoot, luma=true) # W/o overshoot
GradFun3 (thr=0.6, mask=0)                    # W/o banding
mt_merge (last, o, mask_final, luma=true)     # Details protected

# ===== Варианты затемнения линий =====
output = last.ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200),last, "AverageLuma()",">","50")
# output = last.ConditionalFilter(last.vmToon(sharpen=true,thinning=24,strength=36,luma_cap=203,threshold=8),last, "AverageLuma()",">","50")

# Contrasharp 
sharp8 = Contrasharpening(output, source) 
lsbctr = Dither_merge16_8 (den, sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
# lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=1) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0)   # for x264 encode 
lsb_out


# Назначение: пресет для обработки аниме, когда клип содержит выбросы, цветовые полосы, которые могут оказаться нечувствительными к GradFun3
# Подавление радужности изображения по умолчанию: отключено
# Тип затемнения линий по умолчанию: FastLineDarkenMOD2
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: MDegrainN
# Наличие фильтра DeBanding по умолчанию: включен многоступенчатый GradFun3
# Скорость обработки: средняя