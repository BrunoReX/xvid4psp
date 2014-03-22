#Suggested by Mystery Keeper, modded by thetoof for nnedi & spline64
function nnediaa(clip a) {return a.nnedi2(1,true).turnright().nnedi2(1,true).turnleft().spline36resize(a.width,a.height)}