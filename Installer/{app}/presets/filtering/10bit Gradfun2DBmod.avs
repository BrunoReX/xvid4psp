#avstp.dll
#RgTools.dll
#Dither.dll
#flash3kyuu_deband.dll
#SmoothAdjust.dll
#O16mod.avsi
#mt_masktools-26.dll
#dfttestmod.dll
#AddGrainC.dll
#Gradfun2DB.dll
#Dither.avsi
#Gradfun2DBmod.avs
#mt_xxpand_multi.avsi
 

SetMTMode(2)
# setmemorymax(512)

W = width(last)
H = height(last)

U16 () # конвертируем из 8 в 16 бит
s16 = last
DitherPost (mode=-1) #  конвертируем назад в 8 бит для применения 8-битного фильтра
gradfun2dbMod(thr=1.4,thrC=1.4,mode=2,str=0.3,strC=0.0,temp=50,adapt=64)    # добавляем 8 битный дебандер для Film
# gradfun2dbMod(thr=1.4,thrC=1.4,mode=2,str=0.3,strC=0.0,temp=100,adapt=64) # добавляем 8 битный дебандер для Anime
Dither_convert_8_to_16 ()                         # конвертируем опять в 16 бит
s16.Dither_limit_dif16 (last, thr=0.5, elast=2.0) # 16 битное s16 c помощью функции Dither_limit_dif16 смешиваем с 16-битным уже с дебандером

# ==== ресайз 16-битного видео ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10                        # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-бит
""") : Down10(8)                           #8-бит 


# Для конвертации 8 битного исходника в 16 бит c дебандингом Gradfun2dDBMod
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile
