# File: Combi_DeInterMotion.avs
 # автор скрипта Tim68
 #
 # Needed plugins and libruaries:
 # nnedi3.dll
 # mvtools2.dll
 #===========================================================================================================================
 # Режимы: деинтерлейс, деинтерлейс с удвоением частоты кадров или ресайз в 2 раза по вертикали с сохранением чересстрочности.
 # Достраивает поля, соответствующие по фазе оригинальным полям.
 # сохраняется информация из всех фаз движения источника, оригинальное разрешение.
 # Эффект "Фильма"(имитация времени открытия затвора камеры) - небольшой "Motion Blur".
 # Присутствует некий эффект фильтрации шумов, возростает сжатие.
 # Не зависит от частоты кадров исходного материала.
#======================================================================================================================
 function Combi_DeInterMotion(clip clp, int "mode", int "search", int "blksize")
 {
 last = clp
# Рarameters
H = Height()
W = width()
Fden = FramerateDenominator()

# Default variables
mode = default(mode, 0) #mode=0(deinterlace), 1(double fps), 2(double height).
 search = default(search, 4) #the type of search:
 #3 - Exhaustive search. Slow.The best results for SAD.
 #4 - Hexagon search (similar to x264);
 #5 - Uneven Multi Hexagon (UMH) search (similar to x264).
 blksize = default(blksize, (W > 720) ? 32 : (W > 320) ? 16 : 8) # 32, 16 or 8
# Variables
blksizeV = blksize/2
 overlap = blksize/2
 overlapV = blksizeV/2
 Fnum=(mode < 1)?(FramerateNumerator()):(mode < 2)?(2*FramerateNumerator()):(FramerateNumerator())
nnedi3(field=-2)
 BlackmanResize(W,2*H,taps=4).AssumeTFF() #stretch up to 2*H, top field first
TF_TF = SelectEven().SeparateFields().selectEven()
 BF_TF = SelectEven().SeparateFields().selectOdd()
 TF_BF = SelectOdd().SeparateFields().selectEven()
 BF_BF = SelectOdd().SeparateFields().selectOdd()
# Create new bottom fields
super1 = MSuper(BF_BF.blur(1),pel=2,rfilter=4)
 rec_super1 = MSuper(BF_BF.blur(1),pel=2,rfilter=4,levels=1)
 b_vec11 = MAnalyse(super1,isb=true, blksize=blksize,blksizeV=blksizeV,search=search,overlap=overlap,overlapV=overlapV,dct=0)
 f_vec11 = MAnalyse(super1,isb=false,blksize=blksize,blksizeV=blksizeV,search=search,overlap=overlap,overlapV=overlapV,dct=0)
 b_vec12 = MRecalculate(rec_super1,b_vec11, blksize=blksize/2,blksizeV=blksizeV/2,search=search,overlap=overlap/2,overlapV=overlapV/2,dct=0)
 f_vec12 = MRecalculate(rec_super1,f_vec11,blksize=blksize/2,blksizeV=blksizeV/2,search=search,overlap=overlap/2,overlapV=overlapV/2,dct=0)
 MFlowInter(BF_BF,MSuper(BF_BF,pel=2,rfilter=4),b_vec12,f_vec12,blend=true,time=50,ml=70,thSCD1=200)
 BF = Trim(BF_TF,0,-1)++DeleteFrame(FrameCount()) #ending new bottom fields
# Create new top fields
super2 = MSuper(TF_TF.blur(1),pel=2,rfilter=4)
 rec_super2 = MSuper(TF_TF.blur(1),pel=2,rfilter=4,levels=1)
 b_vec21 = MAnalyse(super2,isb=true, blksize=blksize,blksizeV=blksizeV,search=search,overlap=overlap,overlapV=overlapV,dct=0)
 f_vec21 = MAnalyse(super2,isb=false,blksize=blksize,blksizeV=blksizeV,search=search,overlap=overlap,overlapV=overlapV,dct=0)
 b_vec22 = MRecalculate(rec_super2,b_vec21, blksize=blksize/2,blksizeV=blksizeV/2,search=search,overlap=overlap/2,overlapV=overlapV/2,dct=0)
 f_vec22 = MRecalculate(rec_super2,f_vec21,blksize=blksize/2,blksizeV=blksizeV/2,search=search,overlap=overlap/2,overlapV=overlapV/2,dct=0)
 TF = MFlowInter(TF_TF,MSuper(TF_TF,pel=2,rfilter=4),b_vec22,f_vec22,blend=false,time=50,ml=70,thSCD1=200) #ending new top fields
Fr0=Interleave(TF_TF,BF).Weave()
 Fr1=Interleave(TF,BF_BF).Weave()
preresult = (mode < 1) ? Fr1 : (mode < 2) ? (Interleave(Fr0,Fr1)) : (Interleave(TF_TF,BF_BF).Weave())
 result = (mode < 2) ? (spline36resize(preresult,W,H)) : preresult
 AssumeFPS(result,Fnum,Fden)
return (last)
 }