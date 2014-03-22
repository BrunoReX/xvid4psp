#Average.dll
#Corrector.dll
#RemoveGrainSSE2.dll
#RepairSSE2.dll
#mt_masktools-26.dll
#TIVTC.dll
#TMM.dll
#fft3dfilter.dll
#TDeint.dll
#nnedi3.dll
#flash3kyuu_deband.dll
#daa3.avs
#FixBlendIVTC.avs
#VinverseD.avs
#VinverseDenoise.avs


setmtmode(2)
# setmemorymax(512)

o = last
edeintted = o.nnedi3(field=-2)
res = TDeint(edeint=edeintted,order=-1,mode=2,sharp=true,mtnmode=3,full=false,tryWeave=false,type=1,emask=TMM(mode=1))
a1 = o.tfm(order=-1,clip2=res,pp=7,slow=2,mode=2,chroma=false,display=false).greyscale()
# a1 = o.TFM(chroma=false).greyscale() # variant 2
a2 = a1.trim(1,0)

fixed = o.blur(0,1).FixBlendIVTC()

x0 = fixed.mt_lut("0")
x1 = mt_lutxy(a1,fixed,"x y - abs 2 *")
x2 = mt_lutxy(a2,fixed,"x y - abs 2 *")
x1 = mt_lutf(x1,x1,mode="average",expr="x")
x2 = mt_lutf(x2,x2,mode="average",expr="x")

fixed.greyscale()
corrector(x0,last,x1,x2,a1,a2,mode=1,th=255).mergechroma(fixed)
daa3().VinverseDenoise()
tdecimate(hybrid=1,mode=1,vfrDec=0)

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)

# для устанения блендов по цветности в  аниме