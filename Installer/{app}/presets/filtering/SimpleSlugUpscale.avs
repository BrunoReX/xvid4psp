#mt_maskTools-25.dll
#mvtools2.dll
#NNEDI2.dll
#NNEDI3.dll
#fft3dfilter.dll
#RgTools.dll
#AutoYUY2.dll
#ColorMatrix.dll
#AddGrainC.dll
#QTGMC.avs
#TempGaussMC_beta2.avs
#SimpleSlugUpscale.avs


setmtmode(2)
# setmemorymax(768)

#				name		dimensions				PAR	interlaced?
#
#				deint		same as input				same	no
#				square		square pixel equivalent of input	1:1	no
#				480sq		640x480					1:1	no
#				360sq		640x360					1:1	no
#				DVfullpNTSC	720x480					10:11	no
#				DVfulliNTSC	720x480					10:11	bottom field first
#				DVfullpPAL	720x576					12:11	no
#				DVfulliPAL	720x576					12:11	bottom field first
#				DVwidepNTSC	720x480					40:33	no
#				DVwideiNTSC	720x480					40:33	bottom field first
#				DVwidepPAL	720x576					16:11	no
#				DVwideiPAL	720x576					16:11	bottom field first
#				720p		1280x720				1:1	no
#				1080pana	1440x1080				4:3	no
#				1080iana	1440x1080				4:3	top field first
#				1080psq		1920x1080				1:1	no
#				1080isq		1920x1080				1:1	top field first

#ConvertToYV12(interlaced=true)

# SimpleSlugUpscale(size="DVfullpPAL")
# SimpleSlugUpscale(size="DVfullpPALbox")
# SimpleSlugUpscale(size="DVfulliPAL",interlaced="tff") 
# SimpleSlugUpscale(size="DVfulliPALbox",interlaced="tff")
# SimpleSlugUpscale(size="DVwidepPAL")
# SimpleSlugUpscale(size="DVwidepPALbox")
# SimpleSlugUpscale(size="DVwideiPAL",interlaced="tff")  
# SimpleSlugUpscale(size="DVwideiPALbox",interlaced="tff")
  SimpleSlugUpscale(prog=true,widein=true, drate=true,qual="super",resize="Spline36Resize",size="720p")
# SimpleSlugUpscale(prog=true,widein=true,size="1080psqboxbg")
# SimpleSlugUpscale(drate=true,widein=true,qual="balance",resize="Spline36Resize",size="1080iana")
# SimpleSlugUpscale(prog=true,widein=true, drate=true,qual="super",resize="Spline36Resize",size="1080pana")
# SimpleSlugUpscale(prog=true,widein=false,drate=true,qual="super",resize="Spline36Resize",size="1080pana")
# SimpleSlugUpscale(prog=true,widein=true, drate=true,qual="super",resize="Spline36Resize",size="1080psqboxbg")
# SimpleSlugUpscale(prog=true,widein=false,drate=true,qual="super",resize="Spline36Resize",size="1080psqboxbg")
# SimpleSlugUpscale(drate=true,widein=true,qual="super",resize="Spline36Resize",size="1080isqboxbg")

# AutoYUY2() # закрыть строку в случае прогрессивного выхода
# ColorMatrix(mode="Rec.601->Rec.709",interlaced=true) # закрыть строку в случае прогрессивного выхода



# Для вставки кадров DV формата в HDV или AVCHD видео с высоким разрешением
# Установить тип исходного видео как прогрессивное
# Предупреждение: деинтерлейс в программе XviD 4PSP 5.0 НЕ ПОДКЛЮЧАТЬ!!!! Следует также отключить AutotoYV12 и ресайз, помимо указанного в пресете
# Пресет предназначен для формирования скрипта в XviD 4PSP 5.0 и передачи его в Rhozet Carbon Coder или ССE SP2 в случае интерлейсного выхода
