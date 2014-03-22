#function S4Mod(clip c, float "strength", int "hthr", int "hbias")
{
hthr     = default(hthr, 256)
hbias    = default(hbias, -128)
strength = default(strength, 9.0)

w = c.width()
h = c.height()

s = c.spline36resize(w*2,h*2)

Mblur = s.removegrain(4 ,-1)
Gblur = s.removegrain(19,-1)
Hmask = mt_lutxy(Mblur, Gblur, "y x - abs "+string(hthr)+" * "+string(hbias)+" +", U=1, V=1)

MT_merge(mt_lutxy(s, Gblur, yexpr="x x y - "+string(strength)+    " * +",U=1,V=1), s, Hmask, U=1,V=1)

spline36resize(w,h).mergechroma(c)

return(last)
}


function S5Mod(clip c, float "strength", int "hthr", int "hbias")
{
hthr     = default(hthr, 256)
hbias    = default(hbias, -128)
strength = default(strength, 9.0)

Mblur = c.removegrain(4 ,-1)
Gblur = c.removegrain(19,-1)
Hmask = mt_lutxy(Mblur, Gblur, "y x - abs "+string(hthr)+" * "+string(hbias)+" +", U=1, V=1)

MT_merge(mt_lutxy(c, Gblur, yexpr="x x y - "+string(strength)+    " * +",U=1,V=1), c, Hmask, U=1,V=1)

mergechroma(c)
return(last)
}


function SSSharpFaster(clip c, float "strength", int "hthr", int "hbias")
{
hthr     = default(hthr, 256)
hbias    = default(hbias, -128)
strength = default(strength, 6.0)

w = c.width()
h = c.height()

s = c.spline36resize(w*2,h*2)
a = s.awarpsharp(cm=0, depth=3, blurlevel=1, thresh=0.99)
#a = s.awarpsharp2(chroma=2, depth=2, blur=1, thresh=250)


Mblur = s.removegrain(4 ,-1)
Gblur = s.removegrain(19,-1)
Hmask = mt_lutxy(Mblur, Gblur, "y x - abs "+string(hthr)+" * "+string(hbias)+" +", U=1, V=1)

MT_merge(mt_lutxy(s, Gblur, yexpr="x x y - "+string(strength)+    " * +",U=1,V=1),
  \      mt_lutxy(s,     a, yexpr="x y x - "+string(strength/3.0)+" * +",U=1,V=1), 
  \      Hmask,
  \      U=1,V=1)

spline36resize(w,h).mergechroma(c)

return(last)
}

