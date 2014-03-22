function ftoon(clip orig, float "sstrength", "sdboost", int "srange", "warpdepth", "warplevel")
{
###### parameters ######
sstr	= string(default(sstrength, 180)/255.0)
srange 	= default(srange, 0)
sdboost = default(sdboost, 1.0)
_depth	= default(warpdepth, 5)
_level	= default(warplevel, 1)


###### filtering ######
sharp	= orig.Unsharpmask(300, 4, 0)

orig.mt_edge(thy1=3,thy2=255,mode="prewitt",Y=3,V=1,U=1).Tweak(bright=60+srange).Levels(60,sdboost,255,0,255).mt_inflate().mt_inflate().mt_inflate()
linemask = mt_lutxy(orig, last, yexpr="300 1 x 255 / - 255 y - * x 1.14 ^ + - "+sstr+" *", uexpr="x", vexpr="x")

mt_merge(orig, sharp, linemask, Y=3, U=2, V=2)

final	= _depth<=0 || _level<=0 ? last : _level==1 ? awarpsharp2(last,chroma=4,depth=_depth,blur=_level) :
	\	awarpsharp2(last,chroma=4,depth=_depth,blur=2).awarpsharp2(chroma=4,depth=_depth,blur=2-_level%2)

return 	final
}