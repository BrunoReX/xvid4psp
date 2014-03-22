function rainbow_smooth(clip orig, int "mode", "wdepth", float "ss")
{
### parameters ###
mode	= default(mode, 1)		#[1...6]
wdepth	= default(wdepth, 28)		#[10...68]
ss	= default(ss, 1.0)*0.25		#[0.5...3.0]

### process ###
orig.bicubicresize(int(width(orig)*ss)*4,int(height(orig)*ss)*4)
SmoothUV(mode,field=false)
mode>3 ? awarpsharp2(last,blur=3,type=0,depth=wdepth,chroma=4) :
\	awarpsharp2(depth=wdepth,chroma=4,blur=mode)

return orig.mergechroma(last.bicubicresize(width(orig),height(orig)))
}