#RgTools.dll
#fft3dfilter.dll
#mvtools2.dll
#mvtoolsMT.dll
#WarpSharp.dll
#SangNom.dll
#mt_masktools-26.dll
#MaskTools.dll
#EEDI2.dll
#nnedi2.dll
#nnedi3.dll
#Toon-v1.1.dll
#UnFilter.dll
#awarpsharp2.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#aa.avs
#Gradfun2dbmod.avs
#LSharpAAF.avs
#FastLineDarkenMod.avs
#LimitedSharpenFaster.avs


setmtmode(2)
# setmemorymax(768)

#ColorYUV(levels="TV->PC") 
#ColorYUV(gain_y=0,cont_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) 

MergeChroma(aWarpSharp2(chroma=4))

# ===== Denoiced =====
# StrDrk = default(StrDrk,38) #FastLineDarkenMOD
# ShPre = default(ShPre,18) #Presharpening
# ShPost = default(ShPost,300) #Postsharpening
# SmPost = default(SmPost,100) #Postsmoothing
# stabilize= default(stabilize,false ) # Use post stabilization with Motion Compensation
# tradius	= default(tradius,2) # 2 = MDegrain2 / 3 = MDegrain3 
# MT=default(MT,false) # Use josey_wells' branch of MVTools
# aapel	= default(aapel,1) # accuracy of the motion estimation
# \ (Value can only be 1, 2 or 4. 1 means a precision to the pixel. 2 means a precision to half a pixel, 4 means a precision to quarter a pixel, produced by spatial interpolation (better but slower).)
# aaov	= default ( aaov,(a.width>1100) ? 8 : 4 ) # block overlap value (horizontal). Must be even and less than block size. (Higher = more precise & slower)
# aablk	= default ( aablk,(a.width>1100) ? 16 : 8 ) # Size of a block (horizontal). It's either 4, 8 or 16 ( default is 8 ). Larger blocks are less sensitive to noise, are faster, but also less accurate.
# aatype = default(aatype,"EEDI2") # Use EEDI2() or Sangnom() or maa() or daa() or ediaa() or aaa() or saa() or splinaa() or supaa() or naa() or shaarp() or aaf() or nnedi() or nnedi2() or nnedi3() or antialiasing() for anti-aliasing.

LSharpAAF(StrDrk=48, ShPre=18, ShPost=300, SmPost=100, tradius=2, aapel=2, aaov=4, aablk=8, aatype="maa")

# DeBanding 
DB = LumaDB(g1str=1.2,g2str=1.0,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false) 
mask = mt_edge("prewitt",17,17,17,17,u=3,v=3)
maskf = mt_logic(mask,mt_logic(mask.utoy(),mask.vtoy(),"or").spline64resize(width,height),"or").mt_expand().mt_expand()
mt_merge(last,DB,maskf.mt_invert(),luma=true)


# Назначение: для "мягкого" анимэ с повышением резкости движущихся объектов на основе скрипта SharpAAMCmod
# Подавление радужности изображения по умолчанию: отключено
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: на базе SangNom или EEDI2
# Тип шумоподавителя: на основе векторного анализа оценки движения  
# Тип шарпера: на основе скрипта SharpAAMCmod
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная