#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RgTools.dll
#ColorMatrix.dll
#TDeInt.dll
#mvtools2.dll
#dfttest.dll
#TIVTC.dll
#fft3dfilter.dll
#EEDI2.dll
#EEDI3.dll
#nnedi.dll
#nnedi2.dll
#nnedi3.dll
#Cnr2.dll
#AddGrainC.dll
#Depan.dll
#SSE2Tools.dll
#DepanEstimate.dll
#mt_masktools-26.dll
#srestore.avs
#QTGMC.avs


   ColorMatrix(interlaced=true, clamp=0, threads=0)
   ConvertToYV12(interlaced=true)
   setmtmode(2)
#  setmemorymax(768)

#  W = 720 # 1440 or 1920
#  H = 576 # 480 or 1080
#  Cnr2("oxx",8,16,191,100,255,32,255,false) # убрать цветовой шум камкодеров

#  ConvertToRGB32(interlaced=true)
#  CamCD(9,1)    # убрать цветовой шум камкодеров, при включении в составе QTGMC можно установить для увеличения скорости ChromaMotion=false
#  converttoyv12(interlaced=true)

# Установите режим шумоподавления TR2 = 1 для чистого исходника и TR2 = 2 или TR2 = 3 для зашумленного исходника, по умолчанию согласно пресета

# ====  Sharpness ====
# QTGMC( Preset="Fast", SourceMatch=1, Sharpness=0.4, Edithreads=1, TR2=1 )               # Базовый режим, быстрый
# QTGMC( Preset="Slow", SourceMatch=1, Lossless=2, Sharpness=0.4, Edithreads=1, TR2=2)    # Хорошее качество, эффективный, с остатками гребёнки
# QTGMC( Preset="Slow", SourceMatch=2, Sharpness=0.4, Edithreads=1, TR2=2 )               # Хорошее качество, медленный, нет гребёнки
# QTGMC( Preset="Slower", SourceMatch=3, Lossless=2, Sharpness=0.4, Edithreads=1, TR2=2 ) # Отличное качество, очень медленный, с незначительными остатками гребёнки

# ==== Basic ====
# QTGMC( Preset="Slow", Edithreads=1, SourceMatch=1 )                # Включён базовый source-match. Результат несколько ближе к источнику.
# QTGMC( Preset="Slow", Edithreads=1, SourceMatch=1, Sharpness=0.4 ) # базовый source-match, но шарпером (от 0.2). Будьте осторожны с шарпером, не уходите далеко от дефолтного порога 
# QTGMC( Preset="Slow", Edithreads=1, SourceMatch=1, Lossless=2 )    # базовый source-match с "фальшивым" lossless. Эффективная установка по качеству, может привести к незначительной гребёнке

# QTGMC( Preset="Medium", Edithreads=1, SourceMatch=2, TR2=2 )       # Очищенный от шумов source-match, ближе к исходнику, но без гребёнки, медленный. Увеличение TR2 уменьшает шум
# QTGMC( Preset="Slower", Edithreads=1, SourceMatch=3 )              # Двойная очистка source-match, выше качество чем режим 2, но опять ещё более медленный
# QTGMC( Preset="Slower", Edithreads=1, SourceMatch=3, Lossless=2 )  # Двойная очистка source-match с фальшивым lossless. Почти прекрасный способ обработки с незначительными артефактами
# QTGMC( Preset="Slower", Edithreads=1, SourceMatch=3, Lossless=1 )  # Двойная очистка source-match с фальшивым lossless. Точная детализация, но вероятность появления остатков гребёнки и мерцания 

# QTGMC( Preset="Slow", SourceMatch=3, Lossless=2, Edithreads=1, MatchEnhance=0.75 ) # Дальнейшее увеличение детализации, небольшая очистка шума, немного более резкий, может быть больше шумов
# QTGMC( Preset="Slow", SourceMatch=3, Lossless=2, Edithreads=1, MatchEnhance=0.75, NoiseProcess=1, NoiseRestore=0.7, Sigma=1.5 ) # Как и выше, шумоподавление немного, чтобы помочь очистить клип
  
# QTGMC( Preset="Slower", MatchPreset="Very Fast", Edithreads=1, SourceMatch=1 ) # Быстрый базовый source-match пресет (в три 3 раза быстрее чем дефолтный пресет)
# QTGMC( Preset="Slower", MatchPreset="Faster", Edithreads=1, MatchPreset2="Ultra Fast", SourceMatch=3 ) # Быстрый с очисткой source-match пресет, также хорош(в три 3 раза быстрее чем дефолтный пресет)
# QTGMC( Preset="Slower", MatchPreset="Slow", Edithreads=1, MatchPreset2="Slow", SourceMatch=3 ) # Или используйте медленный source-match пресеты(обычно не нужно)

# ==== Noise Bypass / Denoising ====
# Автоматические установки
# QTGMC( Preset="Slower", EZDenoise=2.5, Edithreads=1, NoisePreset="Slow"   ) # Автоматическое шумоподавление, величина задаёт уровень шумоподавления, пресет оптимален по качество/скорости
# QTGMC( Preset="Slower", EZKeepGrain=1.0, Edithreads=1, NoisePreset="Faster" ) # Автоматическое сохранение зерна - сохраняет все исходное зерно

# Шумоподавление
# QTGMC( Preset="Slower", NoiseProcess=1, NoiseRestore=0.0, Edithreads=1, Sigma=4.0 ) # Полностью шумоподавитель, сила шумоподавления зависит от установки Sigma
# QTGMC( Preset="Slower", NoiseProcess=1, NoiseRestore=0.0, Denoiser="dfttest", DenoiseMC=true, NoiseTR=2, Edithreads=1, Sigma=4.0 ) # Более "аккуратный" шумоподавитель (очень медленный)

# Возврат Шума / Зерна
# QTGMC( Preset="Slower", NoiseProcess=1, NoiseRestore=1.0, Edithreads=1, Sigma=2.0 ) # Сохраняют *весь* шум / прекрасную детализация, для менее шумного исходника
# QTGMC( Preset="Slower", NoiseProcess=1, GrainRestore=1.0, Edithreads=1, Sigma=2.0 ) # Подобен вышеупомянутому, но только сохраняют "более устойчивые" шумовые элементы (зависит от TR2), 
 
# Повышенная детализация  / Зерно
# QTGMC( Preset="Slower", NoiseProcess=2, GrainRestore=0.5, NoiseRestore=0.1, Edithreads=1, Sigma=2.5 ) # Использует более сильный режим 2, сохраняет шум и увеличивает резкость немного 

  QTGMC( Preset="Slower", NoiseProcess=2, GrainRestore=0.4, NoiseRestore=0.2, Edithreads=1, Sigma=1.8, \
           NoiseDeint="Generate", StabilizeNoise=true )  # Как выше, но с лучшим качеством, более устойчивой детализацией и зерном

# Преобразование частоты в случае необходимости

# SelectEven() # преобразование к частоте исходника
# SRestore(frate=25.000)
# SRestore(frate=23.976)

# ===== ЧАСТИЧНАЯ СТАБИЛИЗАЦИЯ ИЗОБРАЖЕНИЯ =====
# source1=last
# stab_reference= source1.crop(40,40,-40,-40).tweak(cont=1.07).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
# mdata = DePanEstimate(stab_reference,trust=1.0,dxmax=20,dymax=20)
# stab1 = DePanStabilize(source1,data=mdata,cutoff=0.5,dxmax=20,dymax=20,method=1,mirror=15)
# stab = stab1.crop(20,20,-20,-20)
# stab.levels(0,1.0,255,0,255).tweak(sat=1.1)#.spline36resize(W, H)

# ChangeFPS(50.000)      #  for PAL, открыть при использовании скрипта с удвоением частоты
# ChangeFPS(60000,1001)  #  for NTSC открыть при использовании скрипта с удвоением частоты


# Назначение: Для качественного деинтерлейса материалов DV, HDV или AVCHD с возможностью применения частичной стабилизации изображения
# Выставить тип исходного видео, как прогрессивное
# Предупреждение: деинтерлейс, колориметрию и ресайз(в случает применения STABILIZING) , выставляемые XviD 4XvidPSP 5.0 убрать!!!



