#avstp.dll
#RgTools.dll
#TDeInt.dll
#mvtools2mod.dll
#dfttestmod.dll
#TIVTC.dll
#blendbob.dll
#fft3dfilter.dll
#EEDI2.dll
#nnedi3.dll
#AddGrainC.dll
#dither.dll
#Deblock.dll
#aWarpSharp2.dll
#average.dll
#mt_masktools-26.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#NNEDI3AA.avs
#QTGMC-3.33d.avsi
#dither.avsi
#srestore.avs
#FastLineDarken 1.4x MT MOD.avsi


setmtmode(2)
# setmemorymax(768)

# SeparateFields().Deblock().Weave() # DeBlock

QTGMC(tr2=3,preset="very slow",Lossless=2,sourcematch=3,sharpness=0.3,MatchEnhance=0.0,MatchPreset="Slow", \
                         MatchPreset2="Slow",border=false,edithreads=0,thSAD1=400,lsb=true,lsbd=true)

blendbob().TDecimate(mode=1)
# selectevery(5,0,1,2,4) # подобрать номер кадра с блендом

# srestore(frate=23.976) # вариант 2


# ==== anti-aliasing ====
# EEDI2().Repair(last.NNEDI3(dh=true,field=1),9)
  NNEDI3AA()

# dark lines
ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200).aWarpSharp2(thresh=48, depth=4), last, "AverageLuma()",">","50")

# DeBanding 
DB = LumaDB(g1str=0.8,g2str=0.6,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false) 
mask = mt_edge("prewitt",17,17,17,17,u=3,v=3)
maskf = mt_logic(mask,mt_logic(mask.utoy(),mask.vtoy(),"or").spline64resize(width,height),"or").mt_expand().mt_expand()
mt_merge(last,DB,maskf.mt_invert(),luma=true)



# Для обработки интерлейсного аниме с попыткой устранения блендов




