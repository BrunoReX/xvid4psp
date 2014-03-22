#RemovegrainSSE2.dll
#mvtools2SVP.dll
#mvtools2.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#EEDI2.dll
#InterFrame.avsi
#DoubleFPS.avsi


  setmtmode(2)
# setmemorymax(768)

Try { InterFrame() }
 Catch(FlowPath)
 {
 FlowPath = MidStr(FlowPath, FindStr(FlowPath, "(") + 1)
 FlowPath = MidStr(FlowPath, 1, FindStr(FlowPath, "\InterFrame"))
 }
 
 
# InterFrame(Preset="Ultra Fast", GPU=true, FlowPath=FlowPath)
# InterFrame(Preset="Very Fast", GPU=true, FlowPath=FlowPath)
# InterFrame(Preset="Fast", GPU=false, FlowPath=FlowPath)
  InterFrame(Preset="Medium", GPU=false, FlowPath=FlowPath)
# InterFrame(Preset="Placebo", GPU=false, FlowPath=FlowPath)
# InterFrame(Preset="Fast", GPU=false,NewNum=48000, NewDen=1001, FlowPath=FlowPath) # for NTSC-film
# InterFrame(Preset="Fast", GPU=false,NewNum=48000, NewDen=1001, FlowPath=FlowPath) # for NTSC-film

# DoubleFPS( mode=2, mopro=false, bias=128, show=false) # второй вариант

f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)

# применяется для удвоения частоты кадров
