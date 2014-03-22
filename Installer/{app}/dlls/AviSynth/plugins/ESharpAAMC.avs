function ESharpAAMC(clip orig, float "ds", int "ShPre", int "ShPost", int "SmPost")
{
ds=default(ds,0.2) #strokes darkening strength
ShPre=default(ShPre,80) #Presharpening
ShPost=default(ShPost,300) #Postsharpening
SmPost=default(SmPost,100) #Postsmoothing

a=orig.assumetff()
w=width(a)
h=height(a)
m=logic( a.DEdgeMask(0,255,0,255,"5 10 5 0 0 0 -5 -10 -5", divisor=4,Y=3,U=3,V=3)
 \       ,a.DEdgeMask(0,255,0,255,"5 0 -5 10 0 -10 5 0 -5", divisor=4,Y=3,U=3,V=3)
 \       ,"max").greyscale.levels(0,0.8,128,0,255,false)
b=a.Toon(ds).Warpsharp(depth=ShPre)
b=b.TurnLeft().EEDI2().TurnRight().EEDI2().spline64resize(w,h,0.5,-0.5,2*w+.001,2*h+.001)
b=b.LimitedSharpenFaster(edgemode=1,strength=ShPost,overshoot=1,soft=SmPost)


mt_merge(a,b,m,Y=3,U=3,V=3)
sD=mt_makediff(a,last)
fv2 = a.MVAnalyse(isb=false,delta=2,idx=13)
fv1 = a.MVAnalyse(isb=false,delta=1,idx=13)
bv1 = a.MVAnalyse(isb=true, delta=1,idx=13)
bv2 = a.MVAnalyse(isb=true, delta=2,idx=13)

sDD = sD.MVDegrain2(bv1,fv1,bv2,fv2,idx=14)

reduc = 0.4
sDD = mt_lutxy(sD,sDD,"x 128 - abs y 128 - abs < x y ?").mergeluma(sDD,1.0-reduc)

a.mt_makediff(sDD,U=2,V=2)

return last
}

