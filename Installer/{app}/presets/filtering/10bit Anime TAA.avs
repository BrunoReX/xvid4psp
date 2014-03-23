#avstp.dll
#EEDI2.dll
#EEDI3.dll
#nnedi3.dll
#mt_masktools-26.dll
#SangNom.dll
#tcanny.dll
#MSharpen.dll
#awarpsharp2.dll
#RgTools.dll
#warpsharp.dll
#variableblur.dll
#SmoothAdjust.dll
#dfttestmod.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#Soothe.avs
#EdgeCleaner.avs
#LimitedSharpenFaster mod.avs
#TAA.avsi
#Down10.avs

setmtmode(2)
setmemorymax(1536)

W = width(last)
H = height(last)

emask = mt_edge("sobel", 7, 7, 5, 5).mt_inflate()
zero_l = 64   
m_luma = mt_lut("x "+String(zero_l)+" - Abs 255 * "+String(zero_l)+" 128 - Abs 128 + /")

# Denoice
dfttest (sigma=2.0, tbsize=3, lsb=true, threads=1) # last is now 16 bits
s16 = last

# DeBanding, AA & Sharpening
DitherPost (mode=-1)                               # 16 ->  8 bits
smE = last.EdgeCleaner(smode=1, 20)   
db_clp = smE.LumaDB(g1str=1.2,g2str=1.0,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false) # DeBanding                           
deband = mt_merge(db_clp, smE, m_luma, luma=true)
taa(aatype=1, preaa=1, postaa=false, mtype=1, sharp=75, src=deband, mclip=emask)  #  8 ->  8
# taa(aatype=1, preaa=1, postaa=true, mtype=5, sharp=75, src=deband, mclip=emask)

Dither_convert_8_to_16 ()                          #  8 -> 16
s16.Dither_limit_dif16 (last, thr=0.5, elast=2.0)

# ==== ресайз 16-битного видео ====
Dither_Resize16(W, H) 

OUTPUT_BIT_DEPTH = 10 # изменить 10 на 8 при отладке или установить 16 без обрезания верхних битов скриптом

(OUTPUT_BIT_DEPTH == 16) ? Eval("""
Dither_convey_yuv4xxp16_on_yvxx()          #16-бит
""") : (OUTPUT_BIT_DEPTH == 10) ? Eval("""
Down10(10, stack=false, dither=-2)         #10-бит
""") : Down10(8)                           #8-бит


# Для качественного антиайлиазинга аниме c качественным дебандингом с конвертацией 8 битного исходника в 16 бит
#
###### ПРЕДУПРЕЖДЕНИЕ ######
# Установить в Глобальных настройках: Сначала кроп\ресайз потом фильтрация
# Выбрать в настройках кодека AVC profile: High 10 Profile
