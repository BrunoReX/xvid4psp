#TIVTC.dll
#mt_masktools-26.dll
#RgTools.dll
#flash3kyuu_deband.dll
#frfun7.dll
#sbr.avs
#vinverse.avs


# setmemorymax(640)

borders = bicubicresize(width()/2,height()/2).bicubicresize(width()+8,height())
stackhorizontal(borders.crop(0,0,4,0),last,borders.crop(width()+4,0,0,0))

o = last 
ox = o.width() 
oy = o.height()

drr     = o.separatefields().vinverse2().weave()
both    = stackhorizontal(drr,o)
IVTC    = both.tfm(pp=0,clip2=stackhorizontal(drr,drr)).tdecimate()
raw     = IVTC.crop(ox,0,ox,oy)
clean1  = IVTC.crop(0,0,ox,oy)

D1      = mt_makediff(raw,clean1)
D8      = D1.bicubicresize(ox/2-72,oy).blur(1,0).bicubicresize(ox,oy,1,0)
D9      = mt_lutxy(D1,D8,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?")
clean1a = clean1.mt_adddiff(D9,U=2,V=2)
clean1b = clean1a.frfun7(1.01,8,1)

allD    = mt_makediff(raw,clean1b).greyscale()
shrpD   = mt_makediff(clean1b,clean1b.removegrain(20))
DD      = shrpD.repair(allD,13,0).mt_lutxy(shrpD,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?")
clean1c = clean1b.mt_lutxy(clean1a,"x 3 + y < x 2 + x y < x 1 + x 3 - y > x 2 - x y > x 1 - x ? ? ? ?",U=2,V=2)
                \.mt_adddiff(DD.sbr(),U=2,V=2)

raw     = raw.crop(4,0,-4,0,true)
clean1c = clean1c.crop(4,0,-4,0,true)

# interleave(raw,clean1c)   # interleave "only-IVTC" with result of full filterchain, for frame comparison
clean1c                 # just result

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)