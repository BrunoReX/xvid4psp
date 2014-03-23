#avstp.dll
#RgTools.dll
#mvtools2.dll
#mt_masktools-26.dll
#WarpSharp.dll
#deen_1.0.dll
#Warpsharp.dll
#Deblock.dll
#AddGrainC.dll
#dctfilter.dll
#msharpen.dll
#aWarpSharp2.dll
#SangNom.dll
#EEDI2.dll
#nnedi3.dll
#yadifmod.dll
#Toon-v1.1.dll
#mipsmooth.dll
#gradfun2db.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#mt_xxpand_multi.avsi
#DeRainbow2.avs
#aa.avs
#ab16.avs
#Soothe.avs
#EdgeCleaner.avs
#Deblock_QED_MT2.avs
#LimitedSharpenFaster Mod.avs
#FastLineDarken 1.4x MT MOD.avsi


setmtmode(2)
# setmemorymax(768)

#ColorYUV(gain_y=15,cont_y=8,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255)

# ===== подавление радужных помех =====
  DeRainbow2() 

  clp = last
# calculate the appropriate borders so its width and height are mod 16, these will be removed later
  x_temp      = ab16(clp.width)
  x1          = round(x_temp / 2.0)
  x0          = int(x_temp - x1)
  y_temp      = ab16(clp.height)
  y1          = round(y_temp / 2.0)
  y0          = int(y_temp - y1)
  
# add blank borders (to improve frame edge processsing and make the clip mod 16), we will remove these at the end.  
# clp = clp.addborders(x0,y0,x1,y1)
clp.pointresize( clp.width()+x_temp, clp.height()+y_temp, -x0, -y0, clp.width()+x_temp+.001, clp.height()+y_temp+.001 )
  
source = last
m_edge = source.mt_edge("sobel",7,7,5,5).mt_inflate()
zero_l = 64       
m_luma = source.mt_lut("x "+String(zero_l)+" - Abs 255 * "+String(zero_l)+" 128 - Abs 128 + /")
m_aa   = m_edge.mt_expand()
 
# Deblock with Re-Sharp
dbl = source.Deblock_QED(uv=3)                                 # variant 1
# dbl = source.Deblock(30)                                     # variant 2
# dbl = source.deen("a2d",7,7,7,7,7,7/77.).gradfun2db(77/7/7.) # variant 3
dblD = mt_makediff(source,dbl,U=3,V=3)
shrpD = mt_makediff(dbl,dbl.removegrain(11),U=3,V=3)
DD = shrpD.repair(dblD,13)
d = dbl.mt_adddiff(DD,U=3,V=3) 
fin = Soothe(d,dbl) # успокоение, если не нужно, можно убрать
  
# ==== антиайлиазинг =====
# aa = source.ediaa()
# aa = source.daa()
aa_clp = source.maa() 

dbl_sup = dbl.MSuper(pel=2,sharp=2)
fin_sup = fin.MSuper(pel=2,sharp=2,levels=1)
bv2 = MAnalyse(dbl_sup, isb=true, delta=2, blksize=8, overlap=4, truemotion=true)
bv1 = MAnalyse(dbl_sup, isb=true, delta=1, blksize=8, overlap=4, truemotion=true)
fv1 = Manalyse(dbl_sup, isb=false,delta=1, blksize=8, overlap=4, truemotion=true)
fv2 = Manalyse(dbl_sup, isb=false,delta=2, blksize=8, overlap=4, truemotion=true)
den = fin.MDegrain2(fin_sup, fv1,bv1,fv2,bv2,thSAD=400)
mt_merge(den, aa_clp, m_aa)
EdgeCleaner(smode=1,strength=20)

ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200),last, "AverageLuma()",">","50")

sharp = last.LSFmod(defaults="fast", preblur="ON", strength=80)
db_clp = sharp.LumaDB(g1str=1.2,g2str=1.0,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false) # DeBanding 
mt_merge(db_clp, den, m_luma, luma=true)
crop(x0,y0,-x1,-y1)

# Назначение: качественный наиболее оптимальный пресет для аниме с устранением блочности изображения  
# Подавление радужности изображения по умолчанию: включено
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: на основе векторного анализа оценки движения и его функций MDegrain2 и MCompensate с конечным фильтром Clense
# Тип шарпера: LSFmod  
# Наличие фильтра DeBanding по умолчанию: LumaDB
# Скорость обработки: медленная