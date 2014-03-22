#avstp.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#dfttestmod.dll
#EEDI2.dll
#mvtools2mod.dll
#awarpsharp2.dll
#mt_masktools-26.dll
#nnedi3.dll
#TDeint.dll
#TMM.dll
#TIVTC.dll
#SmoothAdjust-ICL-x86.dll
#yadifmod.dll
#SangNom.dll
#Warpsharp.dll
#GradFun2DB.dll
#Dither.dll
#aa.avs
#minblur.avs
#Dither.avsi
#EdgeCleaner.avs
#mt_xxpand_multi.avsi
#LumaMask.avsi
#SmDegrain.avsi
#ContraSharpening.avs
#LimitedSharpenFaster Mod.avs


setmtmode(2)
# setmemorymax(768)

a = last
W = width(a)
H = height(a)

m_edge = a.mt_edge("prewitt",0,255).mt_lut("x 4 - 4 *").mt_inflate()
m_aa   = m_edge.mt_expand()
aa_clp = a.maa()
dfttest(tbsize=1,sigma=10,lsb=true).ditherpost(mode=6)

Lbias = 60
Ebias = 5
msk = mt_logic(mt_binarize(Lbias,upper=true).mt_inpand.mt_inpand,\
             mt_edge("prewitt",thY1=Ebias,thY2=Ebias).mt_expand.mt_inpand,"min")

SMDegrain(tr=3,thSAD=400,cclip=a,refinemotion=true,chroma=false,contrasharp=150,hpad=0,vpad=0,plane=0,lsb_out=true)
dither_merge16_8(a.Dither_convert_8_to_16(),msk,luma=true)

Dither_resize16(W,H,kernel="spline36")
GradFun3(0.5,13,smode=1,lsb_in=true,mode=0,ampo=1.2)
mt_merge(last, aa_clp, m_aa)
aWarpSharp2(depth=3,type=1,blur=4,thresh=128,chroma=2)


# Назначение: для обработки аниме и Cartoon с повышением контрастности и насыщенности изображения   
# Подавление радужности изображения по умолчанию: отключено
# Тип затемнения линий по умолчанию: FastLineDarken
# Тип антиайлизинга по умолчанию: SangNom
# Тип шумоподавителя: на основе векторного анализа оценки движения и его функций MDegrain3 и предварительным dfttest
# Тип шарпера: Contrasharpening 
# Наличие фильтра DeBanding по умолчанию: gradfun3
# Скорость обработки: медленная
