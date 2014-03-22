#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#fft3dgpu.dll
#dfttest.dll
#Checkmate.dll
#mvtools2.dll
#degrainmedian.dll
#mt_masktools-26.dll
#nnedi3.dll
#EEDI2.dll
#Toon-v1.1.dll
#awarpsharp2.dll
#Warpsharp.dll
#medianblur.dll
#SangNom.dll
#deen.dll
#deen_1.0.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#splineresize.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#aa.avs
#YAHR.avs
#minblur.avs
#DeHaloH.avs
#Dehalo_alpha.avs
#FastLineDarken 1.4x MT MOD.avsi
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(768)

#ColorYUV(gain_y=0,cont_y=0,gain_v=0,gain_u=-0,off_u=-0,off_v=-0).levels(0,1.0,255,0,255) 

# ==== набор масок ====
source = last
m_edge = source.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
m_halo = m_aa.mt_expand().mt_lutxy(m_edge, "x y -")

# ==== варианты антиайлиазинга ==== 
aa_clp = source.maa() 
# aa_clp = source.ediaa()
# aa_clp = source.daa()

# ==== варианты DeHalo ==== 
  dh_clp = aa_clp.YAHR().DeHalo_alpha(darkstr=1.0,brightstr=1.4,rx=2.4,ry=2.4,highsens=100,lowsens=30)
# dh_clp = aa_clp.DeHaloH(2, 10, Maska=false)
# dh_clp = aa_clp.DeHalo_Alpha(rx=2.4,ry=2.4,darkstr=0.5,brightstr=1.0,ss=1.5) 

pre = source.degrainmedian(limitY=2,limitUV=3,mode=1)
psuper = pre.MSuper(pel=2, sharp=2, rfilter=2)
ssuper = source.MSuper(pel=2, sharp=2, levels=1)
vb1 = MAnalyse(psuper,isb=true, delta=1, blksize=8, overlap=4, truemotion=true, search=5)
vf1 = MAnalyse(psuper,isb=false,delta=1, blksize=8, overlap=4, truemotion=true, search=5)

maskb = source.mmask(vb1, ml=150, kind = 1, Ysc = 255, gamma=0.999)
maskf = source.mmask(vf1, ml=150, kind = 1, Ysc = 255, gamma=0.999)
tmask = mt_lutxy(maskb,maskf,"x 255 < y 255 < x y + 2 / x ? y ? 32 - 255 * 223 /")# комбинированная маска оценки движения SAD
maskstatic  = mt_invert(tmask)

cf1 = MCompensate(source, ssuper, vf1, thSCD1=300)
cb1 = MCompensate(source, ssuper, vb1, thSCD1=300)
interleave(cf1, source, cb1)
# checkmate(100)
# dfttest(sigma=8,tbsize=3,dither=1)
setmtmode(5)
fft3dgpu(bw=16,bh=16,ow=8,oh=8,bt=3,sigma=3.0,sigma2=2.0,sigma3=2.5,sigma4=1.0,plane=4,mode=1,precision=2)
setmtmode(2)
Selectevery(3,1)

non_hl = mt_merge(last, aa_clp, m_aa)
mt_merge(non_hl, dh_clp, m_halo)

# ===== Варианты затемнения линий =====
ConditionalFilter(last.FastLineDarkenMod(strength=19,threshold=1, thinning=9,luma_cap=200).aWarpSharp2(thresh=48, depth=4), last, "AverageLuma()",">","50")

  DB = last.f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)
# DB = last.LumaDB(g1str=1.0,g2str=0.8,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false)

mask = mt_edge("prewitt",17,17,17,17,u=3,v=3)
maskf = mt_logic(mask,mt_logic(mask.utoy(),mask.vtoy(),"or").spline144resize(width,height),"or").mt_expand().mt_expand()
flat = mt_merge(last,DB,maskf.mt_invert(),luma=true)

# don't sharpen motion, dark area or starfield areas
maskstatic = mt_lutxy(flat,maskstatic,"x 32 < 0 y ?")

# Sharpening
Sclp = flat.LSFmod(defaults="fast",Smode=3,Smethod=3,Lmode=1,strength=85,preblur="ON",secure=true,edgemode=0,soft=0,soothe=true,ss_x=1.5,ss_y=1.5,source=source)
Tmax = source.mt_logic(cf1,"max",U=1,V=1).mt_logic(cb1,"max",U=1,V=1)
Tmin = source.mt_logic(cf1,"min",U=1,V=1).mt_logic(cb1,"min",U=1,V=1)
shrp = Sclp.mt_clamp(Tmax, Tmin, 2, 2, U=1, V=1)
mt_merge(flat, shrp, maskstatic)


# Назначение: для обработки аниме с низким уровнем шумов и наличием ореолов
# Тип затемнения линий по умолчанию: FastLineDarkenMOD
# Тип антиайлизинга по умолчанию: maa
# Тип шумоподавителя: на основе векторного анализа оценки движения и его функции MCompensate с конечным фильтром dfttest или fft3dgpu
# Тип шарпера: LSFmod
# Наличие фильтра DeBanding по умолчанию: LumaDB
# Скорость обработки: медленная                 


