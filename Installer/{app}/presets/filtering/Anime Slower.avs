#avstp.dll
#RgTools.dll
#dfttest.dll
#deen.dll
#deen_1.0.dll
#EEDI2.dll
#mvtools2.dll
#awarpsharp2.dll
#mt_masktools-25.dll
#MT.dll
#nnedi3.dll
#TDeint.dll
#TMM.dll
#TIVTC.dll
#yadifmod.dll
#Toon-v1.1.dll
#SangNom.dll
#Warpsharp.dll
#medianblur.dll
#splineresize.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#aa.avs
#vmToon-v0.74.avs
#minblur.avs
#EdgeCleaner.avs
#DeHaloH.avs
#Soothe.avs
#YAHR.avs
#EdgeCleaner.avs
#DeHalo_Alpha.avs
#Gradfun2dbmod.avs
#LimitedSharpenFaster Mod.avs


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


MergeChroma(aWarpSharp2(chroma=4))

source = last
m_edge = source.mt_edge("sobel", 7, 20).mt_inflate()
m_aa   = m_edge.mt_expand()
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")

# aa_clp = ediaa()
# aa_clp = daa()
  aa_clp = maa()
  
# ==== варианты DeHalo ==== 
  dh_clp = aa_clp.YAHR().DeHalo_alpha(rx=0.5,ry=0.5,ss=2)
# dh_clp = aa_clp.DeHaloH(2, 10, Maska=false)
# dh_clp = aa_clp.DeHalo_Alpha(rx=2.4,ry=2.4,darkstr=0.5,brightstr=1.0,ss=1.5) 
  
# ===== Denoiced =====
sharp = source.LSFmod(edgemode=0,strength=35,overshoot=2).aWarpSharp2(chroma=2, depth=2, blur=1, thresh=252)
source_super = source.MSuper(pel=2, sharp=2, rfilter=2)
sharp_super = sharp.MSuper(pel=2, sharp=2, levels=1)
vf2 = source_super.MAnalyse(isb=false, blksize=8, overlap=4, delta=2, search=5, dct=5)
vf1 = source_super.MAnalyse(isb=false, blksize=8, overlap=4, delta=1, search=5, dct=5)
vb1 = source_super.MAnalyse(isb= true, blksize=8, overlap=4, delta=1, search=5, dct=5)
vb2 = source_super.MAnalyse(isb= true, blksize=8, overlap=4, delta=2, search=5, dct=5)

mask1 = source.mmask(vb2, ml=100, kind = 1, Ysc = 255, gamma=0.999)
mask2 = source.mmask(vb1, ml=100, kind = 1, Ysc = 255, gamma=0.999)
mask3 = source.mmask(vf1, ml=100, kind = 1, Ysc = 255, gamma=0.999)
mask4 = source.mmask(vf2, ml=100, kind = 1, Ysc = 255, gamma=0.999)
maskb = mt_lutxy(mask1,mask2,"x 255 < y 255 < x y + 2 / x ? y ?")
maskf = mt_lutxy(mask3,mask4,"x 255 < y 255 < x y + 2 / x ? y ?")
tmask = mt_lutxy(maskb,maskf,"x 255 < y 255 < x y + 2 / x ? y ? 32 - 255 * 223 /")# комбинированная маска оценки движения SAD

den = source.MDegrain2(sharp_super,vb1,vf1,vb2,vf2,thSAD=400,thSCD1=450,thSCD2=125)

mrg = mt_merge(source, den, tmask, chroma="process")
mrg_super = mrg.Msuper(pel=2,levels=1,chroma=true)
cf2 = MCompensate(mrg, mrg_super, vf2, thSCD1=400)
cf1 = MCompensate(mrg, mrg_super, vf1, thSCD1=400)
cb1 = MCompensate(mrg, mrg_super, vb1, thSCD1=400)
cb2 = MCompensate(mrg, mrg_super, vb2, thSCD1=400)

inter = interleave(cf2, cf1, mrg, cb1, cb2)
mvden1 = inter.dfttest(sstring = "0.0:5.8 0.64:4.4 0.82:4.0 1.0:3.0", tbsize=5, threads=1)
NR1 = mvden1.selectevery(5,2)
mvden2 = inter.dfttest(sstring = "0.0:1.5 0.64:1.2 0.82:1.5 1.0:1.0", tbsize=5, threads=1)
NR2 = mvden2.selectevery(5,2)

rem = mrg.removegrain(2)
maski = rem.mt_inpand().mt_inpand().mt_inpand()
maske = rem.mt_expand().mt_expand().mt_expand()
maskc = mt_lutxy(maski,maske,"255 y x - "+string(8)+" - "+string(16)+" / 255 * -").Blur(1.5).Blur(1.5)
merg = mt_merge(source, NR1, maskc, chroma="process")
mt_merge(merg, NR2, tmask, chroma="process")
EdgeCleaner(smode=1, 20)
non_hl = mt_merge(last, aa_clp, m_aa)
mt_merge(non_hl, dh_clp, m_halo)

# ===== Варианты затемнения линий =====
ConditionalFilter(last.vmToon(sharpen=true,thinning=24,strength=36,luma_cap=203,threshold=8).aWarpSharp2(thresh=48, depth=4), last, "AverageLuma()",">","50")

# DeBanding 
DB = LumaDB(g1str=1.0,g2str=0.8,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false) 
mask = mt_edge("prewitt",17,17,17,17,u=3,v=3)
maskf = mt_logic(mask,mt_logic(mask.utoy(),mask.vtoy(),"or").spline144resize(width,height),"or").mt_expand().mt_expand()
mt_merge(last,DB,maskf.mt_invert(),luma=true)

# POST-SHARPENING
LSFmod(defaults="fast",strength=60)


# Назначение: для обработки аниме с высоким уровнем шумов и устранением ореолов и звона на контурах изображения  
# Подавление радужности изображения по умолчанию: отключено
# Тип затемнения линий по умолчанию: vmtoon
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: на основе векторного анализа оценки движения и его функций MDegrain2 и MCompensate с конечным фильтром dfttest
# Тип шарпера: aWarpSharp2  +  LSFmod  
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная
