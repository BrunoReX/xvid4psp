function unsharpen(clip c,float variance,float k)
{
blr=gaussianblur(c,vary=variance,varc=2,Y=3,U=2,V=2,border=1)
return yv12lutxy(blr,c,"y x - "+string(k)+" * y +",y=3,u=2,v=2)
}