#avstp.dll
#RgTools.dll
#dfttestmod.dll
#EEDI2.dll
#mvtools2mod.dll
#awarpsharp2.dll
#mt_masktools-26.dll
#nnedi3.dll
#TDeint.dll
#TMM.dll
#TIVTC.dll
#SmoothAdjust.dll
#yadifmod.dll
#SangNom.dll
#Warpsharp.dll
#dither.dll
#AddGrainC.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#GrainFactory3mod_v1.2.avsi
#LumaDB_v0.7.avsi
#FastLineDarken 1.4x MT MOD.avsi
#minblur.avs
#Dither.avsi
#EdgeCleaner.avs
#vmToon-v0.74.avs
#mt_xxpand_multi.avsi
#LumaMask.avsi
#SmDegrain.avsi
#ContraSharpening.avs
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


source = last
w = width (source)
h = height(source) 
m_edge = source.mt_edge("sobel",7,7,5,5).mt_inflate()
zero_l = 64       
m_luma = source.mt_lut("x "+String(zero_l)+" - Abs 255 * "+String(zero_l)+" 128 - Abs 128 + /")
m_aa   = m_edge.mt_expand()
aa_clip=source.spline36Resize(w*2,h*2).TurnLeft().SangNom().TurnRight().SangNom().spline36Resize(w,h).MergeChroma(source) 

a = last
dfttest(tbsize=1,sigma=16,lsb=true).ditherpost(mode=6)
lumamask(a,last,45,55,brightfilt=false) # tweak these 2 values for lineart on darks

SMDegrain(tr=3,thSAD=400,cclip=a,refinemotion=true,chroma=true,contrasharp=true,hpad=0,vpad=0,plane=4,lsb=false)
EdgeCleaner(smode=1,strength=24)
output = mt_merge(last,aa_clip,m_aa)

dark = ConditionalFilter(output.vmToon(sharpen=true,thinning=24,strength=36,luma_cap=203,threshold=8),output, "AverageLuma()",">","50")

# DeBanding 
db_clp = dark.LumaDB(g1str=1.2,g2str=1.0,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false) 
mt_merge(db_clp, output, m_luma, luma=true)


# Назначение: для обработки аниме и Cartoon с повышенным уровнем шума  
# Подавление радужности изображения по умолчанию: нет
# Тип затемнения линий по умолчанию: FastLineDarken
# Тип антиайлизинга по умолчанию: SangNom
# Тип шумоподавителя: на основе векторного анализа оценки движения и его функций SMDegrain и предварительным dfttest
# Тип шарпера: Contrasharpening 
# Наличие фильтра DeBanding по умолчанию: LumaDB
# Скорость обработки: медленная
