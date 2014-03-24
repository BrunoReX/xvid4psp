#mvtools2svp.dll
#RgTools.dll
#EEDI2.dll
#InterFrame.avsi

# setmtmode(2)
# setmemorymax(512)

Try { InterFrame() }
 Catch(FlowPath)
 {
 FlowPath = MidStr(FlowPath, FindStr(FlowPath, "(") + 1)
 FlowPath = MidStr(FlowPath, 1, FindStr(FlowPath, "\InterFrame"))
 }
 
InterFrame(Preset="Fast", GPU=false, NewNum=75, NewDen=1, FlowPath=FlowPath) 
# InterFrame(Preset="Fast", GPU=false, NewNum=75, NewDen=1, FlowPath=FlowPath) 
AssumeFPS(25.00)

# применяется для замедления видео в 3 раза

