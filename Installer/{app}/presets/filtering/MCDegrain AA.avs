#avstp.dll
#RemovegrainSSE2.dll
#RepairSSE2.dll
#AddGrainC.dll
#EEDI2.dll
#mt_masktools-26.dll
#mvtools2mod.dll
#Gradfun2db.dll
#MCDegrainmod.avs
#Gradfun2DBMod 1.5.avsi

# crop(960,464,-0,-256)  # need only this section for the given sample. 

setmtmode(2)
# setmemorymax(768)

o = last 
ox = o.width 
oy = o.height

# round/soften hard corner pixels
o.pointresize(ox*3,oy*3).removegrain(4)
mt_lutxy(last,last.removegrain(11,-1),"x x y - 2.51 * +",U=2,V=2).bilinearresize(ox,oy)
o3 = last

# spatial AA (two chained instances, one instance is less effective)
bubb0 = o3.eedi2(maxd=8).bicubicresize(ox,oy,0,0,0,0.5).turnleft().eedi2(maxd=8).turnright().bicubicresize(ox,oy,0,0,-0.5,0)
bubb1 = bubb0.turnleft().eedi2(maxd=8).turnright().bicubicresize(ox,oy,0,0,-0.5,0).eedi2(maxd=8).bicubicresize(ox,oy,0,0,0,0.5)

# masking: AA is most important where pixels meet black background
ee = o.mt_lut("255 x 16 - 8 * -").mt_expand().mt_inflate().mt_inflate()

# mix AA in via 'ee' mask
bubb2 = o.mt_merge(bubb1,ee,U=2,V=2)

# temporal stabilization
bubb3 = bubb2.MCDegrain(2,bubb1,bs=8,thsad=960,rg1=0,rg2=20)

# again, mix via 'ee' mask
bubb4 = o.mt_merge(bubb3, ee, U=2, V=2)

# show
# stackvertical( bubb0.subtitle("antialiasing (simple)").crop(0,0,0,-8).addborders(0,0,0,8,color=$004000),
#  \             o.subtitle("source").crop(0,0,0,-8).addborders(0,0,0,8,color=$004000),
#  \             bubb4.subtitle("antialiasing (very very slow)"))

bubb4.Gradfun2DBmod(thr=1.4,thrC=1.4,mode=2,str=0.3,strC=0.0,temp=50,adapt=64)



