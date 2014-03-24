#avstp.dll
#RgTools.dll
#mvtools2.dll
#awarpsharp2.dll
#mt_masktools-26.dll
#nnedi3.dll
#medianblur.dll
#flash3kyuu_deband.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#mt_xxpand_multi.avsi
#sbr.avs
#minblur.avs


# setmtmode(2)
setmemorymax(640)

#ColorYUV(levels="TV->PC") 
#ColorYUV(gain_y=0,cont_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) 

o = last 
ox = o.width() 
oy = o.height()

o.nnedi3(field=-2,nsize=6,nns=2)

AA = merge(selecteven(),selectodd())
D1 = mt_makediff(o,AA)
D2 = mt_makediff(AA,AA.mt_edge("06 25 06 12 30 12 06 25 06 128",thy1=0,thy2=255,U=2,V=2).removegrain(4)).mt_lut("x 128 - 1.49 * x 128 - 2 ^ x 128 - 2 ^ 9 + / * 128 +")
AA.mt_adddiff(D2.repair(D1,13*1,-1).mt_lutxy(D2,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",Y=3),U=2,V=2)
spat = last

pre = AA.minblur(0).minblur(2)
sup1 = pre.MSuper()
sup2 = spat.MSuper(levels=1)

bv2=sup1.manalyse(isb=true, delta=2,truemotion=false,global=true,blksize=16,overlap=8,search=5,searchparam=6,dct=5)
bv1=sup1.manalyse(isb=true, delta=1,truemotion=false,global=true,blksize=16,overlap=8,search=5,searchparam=6,dct=5)
fv1=sup1.manalyse(isb=false,delta=1,truemotion=false,global=true,blksize=16,overlap=8,search=5,searchparam=6,dct=5)
fv2=sup1.manalyse(isb=false,delta=2,truemotion=false,global=true,blksize=16,overlap=8,search=5,searchparam=6,dct=5)

spat.MDegrain2(sup2,bv1,fv1,bv2,fv2,thSAD=400)

up2 = spline36resize(ox*2,oy*2)
wd = mt_makediff(up2,up2.awarpsharp2(depth=4,thresh=200,blur=2).awarpsharp2(depth=3,thresh=200,blur=2)).bicubicresize(ox,oy,-.4,.2)
last.mt_makediff(wd,U=2,V=2)
sbr().merge(last,0.51)
mt_lutxy(removegrain(4),"x x y - abs 1.49 / 1 1.25 / ^ x y - x y - abs 0.001 + / * +",U=2,V=2)

DB = f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)
# DB = LumaDB(g1str=1.0,g2str=0.8,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false)
mask = mt_edge("prewitt",17,17,17,17,u=3,v=3)
maskf = mt_logic(mask,mt_logic(mask.utoy(),mask.vtoy(),"or").spline64resize(width,height),"or").mt_expand().mt_expand()
mt_merge(last,DB,maskf.mt_invert(),luma=true)


# Назначение: для обработки старого аниме
# Тип антиайлизинга по умолчанию: внутренний
# Тип шумоподавителя: на основе векторного анализа оценки движения и его функций MDegrain2 
# Тип шарпера: aWarpSharp2  +  sbr 
# Наличие фильтра DeBanding по умолчанию: включен
# Скорость обработки: медленная
