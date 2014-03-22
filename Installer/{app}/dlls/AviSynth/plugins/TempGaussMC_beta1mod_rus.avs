#            ===============
#              TempGaussMC 
#            ===============
#  (version: something point something, beta-1)
#
#   Bob-деинтерлейс на основе компенсации движения, базируется на временнОм гауссовском блюре
#
#   
#   разработчик данного скрипта и его возможностей: Didйe
#   модификация для MVTools 1.9.7.7 и 2.x by thetoof
#   исправление сдвига Croma(Сигнала цветности) stage2 было заблокировано с MVTools2, так как это было исправлено в MVTools 1.10.2.1
#
#   ОГОВОРКИ:
#   - Этот bobber НЕ оставляет оригинальные поля неизменными!
#   - Кроме того он обладает возможностями шумоподавления \ добавления резкости исходника
#
#   В плане изменений, данный скрипт богат на детали, и вероятно самый спокойный/устойчивый, если Вы когда-либо добирались до bob-деинтерлейса. 
#
#   НЕОБХОДИМЫЕ БИБЛИОТЕКИ: 
#   - MVTools v.1.9.7.7 и MVTools2
#   - RemoveGrain + Repair
#   - MaskTools v2
#   - NNEDI / EEDI2 / Yadif , depending on which EdiMode you want to use
#
#     VariableBlur(Переменный блюр): Не применяется более, из-за серьёзной утечки памяти в BinomialBlur (). (Заменен другими фильтрами, дающими тот же самый результат).

function TempGaussMC_beta1mod(clip clp, int "tr0", int "tr1", int "tr2", int "rep0", int "rep1", int "rep2", string "EdiMode", int "EEDI2maxd",
 \                          float "sharpness", int "Smode", int "SLmode", int "SLrad", float "Sbb", float "SVthin", int "Sovs", 
 \                          int "blocksize", int "overlap", bool "truemotion", bool "globalmtn",
 \                          int "search", int "searchparam", int "pelsearch", int "sharp", int "lambda", int "DCT", int "pnew", int "plevel", int "lsad",
 \                          int "SCth1", int "SCth2", int "thSAD1", int "thSAD2",
 \                          float "pel2hr", bool "border", int "draft",
 \			    bool "MT")
{
clp

# Установки по умолчанию для временнОго гаусс фильтрования
tr0       = default( tr0,       2 )    #  временнОй радиус для временнОго Gauss перед компенсацией движения (1 или 2)
tr1       = default( tr1,       2 )    #  временнОй радиус для временнОго Gauss с компенсацией движения (1 или 2)
tr2       = default( tr2,       1 )    #  временнОй радиус для финального шумоподавления функцией MVDegrain (1, 2 или 3)

# Установки по умолчанию для EDI интерполяции
EdiMode   = default( EdiMode,"EEDI2")  #  интерполяция применяется: "NNEDI", "EEDI2" "Yadif". Любая другая строка: применяется планарный bicubic bob (быстро!)
EEDI2maxd = default( EEDI2maxd, 8 )    #  только для интерполяции EEDI2: пространственное значение величины поиска

# Установки по умолчанию для temp-gauss исправления(ремонта)
rep0      = default( rep0,      4 )    #  ремонт temporalsoften-деффектов для поискового клипа
rep1      = default( rep1,      0 )    #  ремонт MVDegrain-деффектов для выхода (stage1)
rep2      = default( rep2,      4 )    #  ремонт MVDegrain-деффектов для выхода (stage2)

# Установки по умолчанию для умеренной резкости (contra-sharpening) временнОго гауссовского клипа
sharp0    = default( sharpness, 0.25+(tr1+tr2)/6.) # уровень резкости, 0.0 до 1.0, или более, если вам нравится
Smode     = default( Smode,     2 )    #  Какой метод применить для ре-шарпинга MC'ого временнОго gauss:
                                       #    0 = никакой
                                       #    1 = 3x3 kernel
                                       #    2 = вертикальный min/max  плюс  3x3 kernel
SLmode    = default( SLmode,    2 )    #  Как ограничить увеличение резкости: 
                                       #    0 = никак
                                       #    1 = пространственный, перед 2-й стадией MV(векторного анализа)     (быстро)
                                       #    2 = MC-временОй, перед 2-й стадией MV  (медленно)
                                       #    3 = пространственный, после 2-й стадии MV       (быстро)
                                       #    4 =  MC-временОй, после 2-й стадии MV  (медленно)
SLrad     = default( SLrad,     1 )    #  Сколько предудущих + последующих временных соседних блоков рассматривается для ограничения резкости (SLmode = 2|4),
                                       #  см. пространственный радиус для пространственного ограничивающего режима резкости (SLmode = 1|3)
Sbb       = default( Sbb,       1 )    #  Back-blending(Обратно-плавное сопряжение) гаусс-размытия шарпной разности(немного увеличивает визуальную точность)
                                       #    0 = нет back-blending
                                       #    1 = перед шарп-ограничением (sharp-limiting)
                                       #    2 = после шарп-ограничения (sharp-limiting)
                                       #    3 = перед и после шарп-ограничения (sharp-limiting)
SVthin    = default( SVthin,  1.0 )    #  Вертикальное утончение расширенных горизонтальных краев. 0.0=отключено 0.5=слабое 3.0=сильное
Sovs      = default( Sovs,      0 )    #  Позволенное "overshoot"(перерегулирование) для ограничения резкости (небольшой обман, который имеется)

# Установки по умолчанию для импорта параметров векторноно анализа оценки движения MV
_bs       = default( blocksize,16 )    #  Размер блока для поиска движения
_ovlp     = default( overlap,_bs/2)    #  Величина перекрытия блоком
_tm       = default( truemotion,false) #  использовать ли по умолчанию "truemotion" в MVAnalyse
_global   = default( globalmtn, true)  #  "global" параметр для MVAnalyse

# Установки по умолчанию для "less important" MV-параметров
_search   = default( search,    2 )    #  метод поиска
_ME       = default( searchparam,2)    #  глубина поиска
_pelsrch  = default( pelsearch, 2 )    #  точность pel(пиксельного) уровня поиска: 1 = быстро, 2 = точно
_shrp     = default( sharp,     2 )    #  резкость субпиксельной интерполяции
_DCT      = default( DCT,       0 )    #  DCT режим. Разные режимы могут помочь или могут навредить ... по умолчанию  0 = отключено
_lambda   = default( lambda, _tm ? 1000* _bs*_bs /64 : 0 )   # вектор когеренции
_pnew     = default( pnew,   _tm ? 50 : 0 )                  # штраф для новых векторов по предсказанным векторам
_plevel   = default( plevel, _tm ?  1 : 0 )                  # режим масштабирования уровня lamda
_lsad     = default( lsad,   _tm ? 1200*_bs*_bs/64 : 400*_bs*_bs/64 ) # локальный lambda сброшенный порог

# Пороги смены сцен и MVDegrain thSAD величина. 
# ***** К ОБЪЕКТАМ КАТАЛОГА НЕ КАСАйтесь БЕЗ ВЕСКОЙ ПРИЧИНЫ *****
_SCth1    = default( SCth1,     180 )  #  SAD порог для "плохих блоков" 
_SCth2    = default( SCth2,      98 )  #  процент плохих блоков, чтобы запустить изменение сцен
_thSAD1   = default( thSAD1, 5* 128 )  #  SAD порог для  1-й стадии MVDegrain (гауссовская стадия)  
_thSAD2   = default( thSAD2, 2* 128 )  #  SAD порог для  2-й стадии MVDegrain (линейная стадия)

# Другие stuff границы padd внутренне, чтобы захватить "половину сканирований строк" в вершине + основание (материал радиопередачи)
border    = default( border,   true )  #  true = padd границы внутренние, чтобы захватить "half scanlines" вверх + вниз (материал к дальнейшей передачи данных)
draft     = default( draft,       0 )  #  '1' выводы быстрыго проекта, и '2' четен больше draft'ier
pel2hr    = default( pel2hr,    0.0 )  #  0.0 = отключен.  0.1 ~ 0.3 может быть полезным, чтобы провести усиление ореола pel=2 подвыборки 
MT	  = default( MT,      false )  #  true = применяется мультиверсия MVtools
ST	  = mt ? false : true 		# одноядерный вариант


# корректировки параметров внутреннего применения
sharpness = default(sharpness, (SLmode==1||SLmode==3) ? sharp0 : 2*sharp0 ) # временнОе ограничение может позволить себе больше, чем пространственное ограничение
ed0       = rep0<10 ? rep0 : rep0/10
od0       = rep0<10 ?    0 : rep0-ed0*10
ed1       = rep1<10 ? rep1 : rep1/10
od1       = rep1<10 ?    0 : rep1-ed1*10
ed2       = rep2<10 ? rep2 : rep2/10
od2       = rep2<10 ?    0 : rep2-ed2*10
trmax     = (tr1 > tr2) ? tr1 : tr2
use1      = (trmax > 0) ? true : false
use2      = (trmax > 1) ? true : false
use3      = (trmax > 2 || SLrad>1) ? true : false
thinn     = SVthin * 6.0


#---------------------------------------------------------------------------------------------------
# Давайте начнём делать кое-что

nullclip  = blankclip(clp,width=16,height=16) 

# если "border"необходим, добавьте по 4 пикселя вверх и вниз
clp = (border) ? clp.pointresize(clp.width(),clp.height()+8, 0,-4,-0,clp.height()+8.001 )
 \             : clp
ox = clp.width()
oy = clp.height()

# Создайте пространственно интерполированный bob-clips
dbob = clp.bob(0,0.5)
edi  = (EdiMode=="NNEDI") ? clp.nnedi(field=-2)
 \   : (EdiMode=="EEDI2") ? clp.SeparateFields().EEDI2(field=-2, maxd=EEDI2maxd) 
 \   : (EdiMode=="Yadif") ? clp.Yadif(mode=1)
 \                        : dbob

# создайте линейное взвешенное временное усреднение
t1 = dbob.temporalsoften(1,255,255,28,2)
t2 = dbob.temporalsoften(2,255,255,28,2)

# создайте временное Гауссовское среднее число из линейных средних чисел
t  = (tr0==0) ? dbob
 \ : (tr0==1) ? t1.merge(dbob,0.25)
 \            : t1.merge(t2,0.357).merge(dbob,0.125)

# Если rep0=true: Позволяются только типичные для Боба вертикальные разности
t1 = t.VCRep(dbob,ed=ed0,od=od0)
t2 = (rep0!=0) ? t1 : t

# Создайте клип для поиска движения 
# Уловка: вес - в Гауссовом блюре, чтобы привести локальный контраст клипа поиска. (Должен был позже сделать работу MVDegrain как ожидается..., "SAD понятие" не соответствует
#                                                                              фактам - так, давайте приспосабливать факты, чтобы соответствовать проклятому понятию...)
t3=mt_lutxy(t2,dbob,"x 3 + y < x 3 + x 3 - y > x 3 - y ? ?",U=3,V=3) # маленький обман для лучшего поиска движения
searchclip = t2.removegrain(11).gaussresize(ox,oy,0,0,ox+.0001,oy+.0001,p=2)
 \             .merge(t2,0.1).mt_lutxy(t3,"x 7 + y < x 2 + x 7 - y > x 2 - x 51 * y 49 * + 100 / ? ?",U=3,V=3)


# Получение векторов движения
_pel  = 2

searchclipsuper = st ? searchclip.msuper(pel=_pel,sharp=_shrp, levels=0) : nullclip

allv = 						      MT ?	searchclip.MVAnalyseMulti(refframes=3, truemotion=_tm,pel=_pel,sharp=_shrp,blksize=_bs,overlap=_ovlp,lambda=_lambda,pnew=_pnew,
 \                               				global=_global,search=_search,searchparam=_ME,pelsearch=_pelsrch,DCT=_DCT,plevel=_plevel,lsad=_lsad,idx=6) : nullclip

bvec3   = (use3 && MT) ? allv.MVMultiExtract(0) : (use3) ? 	searchclipsuper.MAnalyse(isb=true, delta=3,truemotion=_tm,blksize=_bs,overlap=_ovlp,lambda=_lambda,pnew=_pnew,
 \                                     		   		global=_global,search=_search,searchparam=_ME,pelsearch=_pelsrch,DCT=_DCT,plevel=_plevel,lsad=_lsad) : nullclip  # ,sadx264=3

bvec2   = (use2 && MT) ? allv.MVMultiExtract(1) : (use2) ? 	searchclipsuper.MAnalyse(isb=true, delta=2,truemotion=_tm,blksize=_bs,overlap=_ovlp,lambda=_lambda,pnew=_pnew,
 \                                     				global=_global,search=_search,searchparam=_ME,pelsearch=_pelsrch,DCT=_DCT,plevel=_plevel,lsad=_lsad) : nullclip  # ,sadx264=3

bvec1   = (use1 && MT) ? allv.MVMultiExtract(2) : (use1) ?	searchclipsuper.MAnalyse(isb=true, delta=1,truemotion=_tm,blksize=_bs,overlap=_ovlp,lambda=_lambda,pnew=_pnew,
 \                                    				global=_global,search=_search,searchparam=_ME,pelsearch=_pelsrch,DCT=_DCT,plevel=_plevel,lsad=_lsad) : nullclip  # ,sadx264=3

fvec1   = (use1 && MT) ? allv.MVMultiExtract(3) : (use1) ? 	searchclipsuper.MAnalyse(isb=false,delta=1,truemotion=_tm,blksize=_bs,overlap=_ovlp,lambda=_lambda,pnew=_pnew,
 \                                      			global=_global,search=_search,searchparam=_ME,pelsearch=_pelsrch,DCT=_DCT,plevel=_plevel,lsad=_lsad) : nullclip  # ,sadx264=3

fvec2   = (use2 && MT) ? allv.MVMultiExtract(4) : (use2) ? 	searchclipsuper.MAnalyse(isb=false,delta=2,truemotion=_tm,blksize=_bs,overlap=_ovlp,lambda=_lambda,pnew=_pnew,
 \                                      			global=_global,search=_search,searchparam=_ME,pelsearch=_pelsrch,DCT=_DCT,plevel=_plevel,lsad=_lsad) : nullclip  # ,sadx264=3

fvec3   = (use3 && MT) ? allv.MVMultiExtract(5) : (use3) ? 	searchclipsuper.MAnalyse(isb=false,delta=3,truemotion=_tm,blksize=_bs,overlap=_ovlp,lambda=_lambda,pnew=_pnew,
 \                                      			global=_global,search=_search,searchparam=_ME,pelsearch=_pelsrch,DCT=_DCT,plevel=_plevel,lsad=_lsad) : nullclip  # ,sadx264=3

vec1	= MT ? allv.MVMultiExtract(2,3) : nullclip
vec2	= MT ? allv.MVMultiExtract(1,4) : nullclip
deg2	= MT ? allv.MVMultiExtract(1,2,3,4) : nullclip


# создайте временное усреднение движения, компенсированное с линейным взвешиванием
edisuper= st ? edi.msuper(pel=_pel,sharp=_shrp, levels=1) : nullclip
mvdg1   =            MT ? edi.MVDegrainMulti(vec1,     thSAD=_thSAD1,thSCD1=_SCth1,thSCD2=_SCth2,idx=7) : 	    edi.MDegrain1(edisuper,bvec1,fvec1,            thSAD=_thSAD1,thSCD1=_SCth1,thSCD2=_SCth2)
mvdg2   = (tr1>1 && MT) ? edi.MVDegrainMulti(     vec2,thSAD=_thSAD1,thSCD1=_SCth1,thSCD2=_SCth2,idx=7) : (tr1>1) ? edi.MDegrain1(edisuper,            bvec2,fvec2,thSAD=_thSAD1,thSCD1=_SCth1,thSCD2=_SCth2) : nullclip

# создайте явные компенсации движения (необходимо для SLmode = 2|4)
comp_fw1 = (SLmode==2 || SLmode==4)         ?  st ? edi.MCompensate(edisuper,fvec1,thSCD1=_SCth1,thSCD2=_SCth2) : edi.MVCompensate(fvec1,thSCD1=_SCth1,thSCD2=_SCth2,idx=7) : nullclip
comp_bw1 = (SLmode==2 || SLmode==4)         ?  st ? edi.MCompensate(edisuper,bvec1,thSCD1=_SCth1,thSCD2=_SCth2) : edi.MVCompensate(bvec1,thSCD1=_SCth1,thSCD2=_SCth2,idx=7) : nullclip
comp_fw3 = (SLmode==2 || SLmode==4)&& use3  ?  st ? edi.MCompensate(edisuper,fvec3,thSCD1=_SCth1,thSCD2=_SCth2) : edi.MVCompensate(fvec3,thSCD1=_SCth1,thSCD2=_SCth2,idx=7) : nullclip
comp_bw3 = (SLmode==2 || SLmode==4)&& use3  ?  st ? edi.MCompensate(edisuper,bvec3,thSCD1=_SCth1,thSCD2=_SCth2) : edi.MVCompensate(bvec3,thSCD1=_SCth1,thSCD2=_SCth2,idx=7) : nullclip
    
# дешёвое приведение ореола для резких режимов элемента растра (для Lmode=2|4)
cx1=comp_fw1.width()
cx3=comp_fw3.width()
cy1=comp_fw1.height()
cy3=comp_fw3.width()
comp_fw1 = (pel2hr==0.0) ?  comp_fw1 :  comp_fw1.mergeluma(comp_fw1.removegrain(11,-1).gaussresize(cx1,cy1,0,0,cx1+.0001,cy1+.0001,p=5),pel2hr)
comp_fw3 = (pel2hr==0.0) ?  comp_fw3 :  comp_fw3.mergeluma(comp_fw3.removegrain(11,-1).gaussresize(cx3,cy3,0,0,cx3+.0001,cy3+.0001,p=5),pel2hr)
comp_bw1 = (pel2hr==0.0) ?  comp_bw1 :  comp_bw1.mergeluma(comp_bw1.removegrain(11,-1).gaussresize(cx1,cy1,0,0,cx1+.0001,cy1+.0001,p=5),pel2hr)
comp_bw3 = (pel2hr==0.0) ?  comp_bw3 :  comp_bw3.mergeluma(comp_bw3.removegrain(11,-1).gaussresize(cx3,cy3,0,0,cx3+.0001,cy3+.0001,p=5),pel2hr)
     
# изобразите локальный минимум и максимум по данному временному окну  (для Lmode=2|4)
pmax = (SLrad>0) ? edi .mt_logic(comp_fw1,"max",U=3,V=3).mt_logic(comp_bw1,"max",U=3,V=3) : edi
pmax = (SLrad>1) ? pmax.mt_logic(comp_fw3,"max",U=3,V=3).mt_logic(comp_bw3,"max",U=3,V=3) : pmax
pmin = (SLrad>0) ? edi .mt_logic(comp_fw1,"min",U=3,V=3).mt_logic(comp_bw1,"min",U=3,V=3) : edi
pmin = (SLrad>1) ? pmin.mt_logic(comp_fw3,"min",U=3,V=3).mt_logic(comp_bw3,"min",U=3,V=3) : pmin

# создайте компенсированное на движение временнОе Гауссово размытие
stage1  = (tr1==0) ? edi
 \      : (tr1==1) ? mvdg1.merge(edi,0.25)
 \                 : mvdg1.merge(mvdg2,0.2).merge(edi,0.0625)

# Если rep1=true: Позвольте только bob-typical вертикальные разности
stage1 = (rep1!=0) ? stage1.VCRep(edi,ed=ed1,od=od1) : stage1


# вычислите вертикальный медиан (для того, чтобы утончиться), и вертикальное минимальное\максимальное\среднее число (для того, чтобы повысить резкость)
vmedD   = mt_luts(stage1,stage1,mode="median",pixels="0 -1 0 0 0 1",yexpr="128 x y - "+string(thinn)+" * -",U=1,V=1).blur(1,0)
vmedDD  = mt_lutxy(vmedD,vmedD.removegrain(11,-1),"y 128 - abs x 128 - abs > y 128 ?")
st1mmavg =  mt_average( stage1.mt_expand(mode="vertical",U=3,V=3),stage1.mt_inpand(mode="vertical",U=3,V=3),U=3,V=3 )
 \         .mt_lutxy(stage1,"x y < x 1 + x y > x 1 - x ? ?",U=3,V=3)

# ре-шарпен временнОго гауссовского размытия 
stage1a = (Smode==0) ? stage1
 \      : (Smode==1) ? stage1.mt_lutxy(stage1.removegrain(11),"x x y - "+string(sharpness)+" * +",U=3,V=3)
 \                   : stage1.mt_lutxy(st1mmavg.removegrain(11),"x x y - "+string(sharpness)+" * +",U=3,V=3)

# примените вертикальное утончение?
stage1a = (SVthin==0.0) ? stage1a : stage1a.mt_adddiff(vmedDD,U=2,V=2)

# примените 1-ю стадию повышения резкости back-blending?
stage1a = ((Sbb==1 || Sbb==3) && Smode!=0 && sharpness!=0.0) 
 \       ? stage1a.mt_makediff(mt_makediff(stage1a,stage1,U=1,V=1).removegrain(11,-1).gaussresize(ox,oy,0,0,ox+.0001,oy+.0001,p=5),U=2,V=2) 
 \       : stage1a

# примените ограничение увеличения резкости? (SLmode 1|2)
stage1b = (sharpness==0.0) ? stage1 
 \                         : (SLmode==1) ? ( (SLrad<2) ? stage1a.repair(edi,1) : stage1a.repair(stage1a.repair(edi,12),1) )
 \                         : (SLmode==2) ? stage1a.mt_clamp(pmax,pmin,Sovs,Sovs,U=3,V=3)
 \                                       : stage1a

# примените 2-ю стадию повышения резкости back-blending?
stage1b = ((Sbb==2 || Sbb==3) && Smode!=0 && sharpness!=0.0) 
 \       ? stage1b.mt_makediff(mt_makediff(stage1b,stage1,U=1,V=1).gaussresize(ox,oy,0,0,ox+.0001,oy+.0001,p=5),U=2,V=2) 
 \       : stage1b
    
# финальный временнОй фильтр для стабилизации, движение-компенсировано
stage1bsuper= st ? stage1b.msuper(pel=_pel,sharp=_shrp, levels=1) : nullclip
stage2  = (tr2==0) ? stage1b
 \      : (tr2==1 && MT) ? stage1b.MVDegrainMulti(vec1,thSAD=_thSAD2,thSCD1=_SCth1,thSCD2=_SCth2,idx=8) : (tr2==1) ? stage1b.MDegrain1(stage1bsuper,bvec1,fvec1,                        thSAD=_thSAD2,thSCD1=_SCth1,thSCD2=_SCth2)
 \      : (tr2==2 && MT) ? stage1b.MVDegrainMulti(deg2,thSAD=_thSAD2,thSCD1=_SCth1,thSCD2=_SCth2,idx=8) : (tr2==2) ? stage1b.MDegrain2(stage1bsuper,bvec1,fvec1,bvec2,fvec2,            thSAD=_thSAD2,thSCD1=_SCth1,thSCD2=_SCth2)
 \                 : MT  ? stage1b.MVDegrainMulti(allv,thSAD=_thSAD2,thSCD1=_SCth1,thSCD2=_SCth2,idx=8) : 	     stage1b.MDegrain3(stage1bsuper,bvec1,fvec1,bvec2,fvec2,bvec3,fvec3,thSAD=_thSAD2,thSCD1=_SCth1,thSCD2=_SCth2)

# Если rep2=true: Позвольте только bob-typical вертикальные разности
stage2  = (rep2!=0) ? stage2.VCRep(edi,ed=ed2,od=od2) : stage2

## MVDegrain вызывает сдвиг сигнала цветности (да, это делается, с pel>1 !) Мы компенсируем, сдвигая сигнал цветности к планарному EDI с помощью маленькой метки
##   [ 1+(x-1)/(1+(x/5)^4) ] on 128-centered diff-clip (x-y) ==>  [ x y - abs 2 < y x x y - abs 1 - 1 x y - abs 5 / 4 ^ + / 1 + x y - x y - abs 0.0001 + / * + ? ]
#mod : disabled with MVTools2 since it has been corrected in MVTools 1.10.2.1
stage2 = mt ? stage2.mt_lutxy(edi,"x y - abs 2 < y x x y - abs 1 - 1 x y - abs 5 / 4 ^ + / 1 + x y - x y - abs 0.0001 + / * - ?",Y=2,U=3,V=3) : stage2
 
# примените ограничение резкости (SLmode 3|4), или имейте "проект", требуемый?
stage3  = (draft==2)   ?  t  .subtitle("Draft 2")
 \      : (draft==1)   ?  t1 .subtitle("Draft 1")
 \      : (SLmode==3)  ?  ( (SLrad<2) ? stage2.repair(edi,1) : stage2.repair(stage2.repair(edi,12),1) )
 \      : (SLmode==4)  ?  stage2.mt_clamp(pmax,pmin,Sovs,Sovs,U=3,V=3)
 \                     :  stage2

# Если "border" был активен, сделайте crop снова
(border) ? stage3.crop(0,4,-0,-4)
 \       : stage3

 
return( last )
}

#===================================================================================================

# вспомагательная функция: сравните два клипа, и позвольте только разности для bob-typical
function VCRep(clip clp, clip ref, int "ed", int "od")
{
ed = default(ed,1)  #  e'rosion d'istance: 1 = minimum, 5 = maximum
od = default(od,0)  #  o'ver-d'ilation of the eroded difference: 0=no, 1=somewhat, 2=somewhat more, 3=one full pixel

tD_2   = mt_makediff(ref,clp,U=3,V=3) 

tD1_2  = (ed>=3)        ? tD_2 .mt_inpand(mode="vertical",U=3,V=3) :   tD_2
tD1_2  =                  tD1_2.mt_inpand(mode="vertical",U=3,V=3) 
tD1_2  = (ed!=0&&ed!=3) ? tD1_2.mt_deflate(U=3,V=3)                :   tD1_2
tD1_2  = (ed==2||ed==5) ? tD1_2.removegrain(4)                     :   tD1_2
tD1_2  =                  tD1_2.mt_expand(mode="vertical",U=3,V=3)
tD1_2  = (ed>=2) ?        tD1_2.mt_expand(mode="vertical",U=3,V=3) :   tD1_2
tD1_2  = (ed>=5) ?        tD1_2.mt_expand(mode="vertical",U=3,V=3) :   tD1_2
tD1_2  = (od==0) ?        tD1_2 
 \     : (od==1) ?        tD1_2.mt_inflate(U=3,V=3) 
 \     : (od==2) ?        tD1_2.mt_inflate(U=3,V=3).mt_inflate(U=3,V=3)
 \               :        tD1_2.mt_expand(U=3,V=3)

tD2_2  = (ed>=3)        ? tD_2 .mt_expand(mode="vertical",U=3,V=3) :   tD_2
tD2_2  =                  tD2_2.mt_expand(mode="vertical",U=3,V=3) 
tD2_2  = (ed!=0&&ed!=3) ? tD2_2.mt_inflate(U=3,V=3)                :   tD2_2
tD2_2  = (ed==2||ed==5) ? tD2_2.removegrain(4)                     :   tD2_2
tD2_2  =                  tD2_2.mt_inpand(mode="vertical",U=3,V=3)
tD2_2  = (ed>=2) ?        tD2_2.mt_inpand(mode="vertical",U=3,V=3) :   tD2_2
tD2_2  = (ed>=5) ?        tD2_2.mt_inpand(mode="vertical",U=3,V=3) :   tD2_2
tD2_2  = (od==0) ?        tD2_2 
 \     : (od==1) ?        tD2_2.mt_deflate(U=3,V=3) 
 \     : (od==2) ?        tD2_2.mt_deflate(U=3,V=3).mt_deflate(U=3,V=3)
 \               :        tD2_2.mt_inpand(U=3,V=3)

tDD_2  = tD_2.mt_lutxy(tD1_2,"x 129 < x y 128 < 128 y ? ?",U=3,V=3).mt_lutxy(tD2_2,"x 127 > x y 128 > 128 y ? ?",U=3,V=3)
clp.mt_adddiff(tDD_2,U=3,V=3)
}

