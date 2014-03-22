function gsharp(clip c, float "str") {
str = default(str, 1.51)
mt_lutxy(c,c.removegrain(11),"x x y - abs 1 1.6 / ^ "+string(str)+" * x y - x y - abs 0.001 + / * +",U=3,V=3) }

function gnoise(clip c, int str, float ss) {
grr=blankclip(c,width=round((c.width*ss)/4.)*4,height=round((c.height*ss)/4.)*4).mt_lut("x",Y=-128).addgrainc(str,0)
c.mt_adddiff(grr.bicubicresize(c.width,c.height,-.2,.6),U=2,V=2)  }