#mvtools2.dll
#mt_masktools-26.dll
#RgTools.dll
#medianBlur.dll
#flash3kyuu_deband.dll
#FSx.avs
#sbr.avs
#minblur.avs


setmtmode(2)
# setmemorymax(1024)

pel1 = 1   # you can use pel=2, 
pel2 = 1   # but with pel=1 the script is already slow & memory-hungry enough ...

changefps(last,last,true)

o  = last  
ox = o.width()  
oy = o.height()

pre01  = o.sbr()
pre02  = pre01.medianblur(2,0,0)
pre03  = o.mt_makediff(mt_makediff(pre01,pre01.removegrain(4,-1)),U=2,V=2).sbr()

msk    = mt_lutxy(o.utoy(),o.vtoy(),"x 128 - 0 1 - * 128 + y + 2 / 148 - 16 *").greyscale()
brite  = pre02. levels(80,1.0,160,0,255,false).greyscale()
brite  = brite.bicubicresize(ox/2,oy/2)
brite2 = brite.repair(brite.repair(brite.mt_inpand().mt_inpand().mt_inpand().mt_inpand().mt_expand().mt_expand().mt_expand().mt_expand(),1,0),12,0)
bmask  = mt_lutxy(brite2.mt_inpand(),msk.mt_expand(),"x y -").mt_expand().removegrain(20).greyscale()
 \      .bicubicresize(ox,oy,1,0)

sss1   = mt_lutxy(pre02,o,"x x y - abs 1 1.22 / ^ 0.51 * x y - x y - abs 0.001 + / * -",U=2,V=2)
sss2   = sss1.temporalsoften(2,12,12,20,2).merge(pre02,0.14)
sss3   = sss1.mt_merge(sss2,bmask,luma=true,U=3,V=3)

sup0   = sss3.msuper(pel=pel1)
sup1   = o.msuper(pel=pel1,levels=1)
bv02   = sup0.manalyse(isb=true, delta=2, blksize=16, overlap=8 , search=5)#,searchparam=8,DCT=5)
bv01   = sup0.manalyse(isb=true, delta=1, blksize=16, overlap=8 , search=5)#,searchparam=8,DCT=5)
fv01   = sup0.manalyse(isb=false,delta=1, blksize=16, overlap=8 , search=5)#,searchparam=8,DCT=5)
fv02   = sup0.manalyse(isb=false,delta=2, blksize=16, overlap=8 , search=5)#,searchparam=8,DCT=5)

mdg1   = o.mdegrain2(sup1,bv01,fv01,bv02,fv02,thSAD=400) 
mdg1a  = mdg1.mt_makediff(mt_makediff(mdg1,o).bicubicresize(ox/4,oy/4).bicubicresize(ox,oy,1,0),U=2,V=2)
mdg1aD = mt_makediff(o,mdg1)
pre02oD= mt_makediff(o,pre02)
xDD    = pre02oD.repair(mdg1aD,12)
spat2  = o.mt_makediff(xDD,U=2,V=2).minblur(0,2)
spat2  = mt_lutxy(spat2,o,"x 1 + y < x 2 + x 1 - y > x 2 - y ? ?",U=2,V=2)
spat2  = o.mt_merge(spat2,bmask,luma=true,U=3,V=3)

sup10  = mdg1.msuper(pel=pel2)
sup11  = spat2.FSx(mode=-1,sstr=2.0,cstr=-2.0,xstr=0.0).msuper(pel=pel2,sharp=1,levels=1)
bv4    = sup0.manalyse(isb=true, delta=4, blksize=16, overlap=8 , search=4, searchparam=1, DCT=5)
# bv3  = sup0.manalyse(isb=true, delta=3, blksize=16, overlap=8 , search=5, searchparam=8, DCT=5)
bv2    = sup0.manalyse(isb=true, delta=2, blksize=16, overlap=8 , search=5, searchparam=8, DCT=5)
bv1    = sup0.manalyse(isb=true, delta=1, blksize=16, overlap=8 , search=5, searchparam=8, DCT=5)
fv1    = sup0.manalyse(isb=false,delta=1, blksize=16, overlap=8 , search=5, searchparam=8, DCT=5)
fv2    = sup0.manalyse(isb=false,delta=2, blksize=16, overlap=8 , search=5, searchparam=8, DCT=5)
# fv3  = sup0.manalyse(isb=false,delta=3, blksize=16, overlap=8 , search=5, searchparam=8, DCT=5)
fv4    = sup0.manalyse(isb=false,delta=4, blksize=16, overlap=8 , search=4, searchparam=1, DCT=5)
spat2.removegrain(11,0).mdegrain3(sup11,bv1,fv1,bv2,fv2,bv4,fv4,thSAD=800)
mdg23  = last

mt_makediff(mt_makediff(last,spat2).bicubicresize(ox/4,oy/4).bicubicresize(ox,oy,1,0),U=2,V=2)
mt_lutxy(o,"x 4 + y < x 3 + x 4 - y > x 3 - x 0.49 * y 0.51 * + ? ?",U=3,V=3)
last.mt_merge(mdg23,bmask,luma=true,U=3,V=3)
mt_lutxy(sbr(),"x 4 + y < x 3 + x 4 - y > x 3 - x 0.51 * y 0.49 * + ? ?",U=2,V=2)

# ==== DeBanding ====
f3kdb(sample_mode=2,dynamic_grain=false,keep_tv_range=false,dither_algo=3,y=52,cb=36,cr=36,grainY=0,grainC=0)


# Для обработки BD с высоким уровнем яркостного шума
# перед строкой загрузки видео вписуйте в скрипт setmtmode(3,3) и рекомендуемое ограничение потребления памяти при threads=4 
