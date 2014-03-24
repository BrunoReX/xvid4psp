#svpflow2.dll
#svpflow1.dll
#AvsFilterNet.dll
#InterFrame2.avsi
#flash3kyuu_deband.dll


# setmtmode(2)
# setmemorymax(600) 
InterFrame (GPU=false, Preset="Medium", Tuning ="Film", OverrideAlgo=23, InputType="2D", Cores=4)
# InterFrame (GPU=false, Preset="Medium", Tuning ="Film", NewNum=48000, NewDen=1001, OverrideAlgo=23, InputType="2D", Cores=4)

f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=true,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)
# применяется для удвоения частоты кадров
