function HighPassSharpen(clip c, int mode, float radius, string "method")
{
	v1 = c.binomialblur(radius,radius)
	v2 = v1.invert()
	v3 = (method=="overlay") ? overlay(c,v2,opacity=0.5)
	 \ : (method=="merge")   ? merge(c,v2)
	 \                       : c.subtitle("unknown method")
	v3 = v3.greyscale()
	v4 = overlay(c,v3,mode="hardlight")

	v5 = (mode==0) ? v3 : v4
	return v5
}

function Range8to16(clip c) {
	# Requires: mt_masktools2
	StackVertical(c, c.mt_lut(Y=0,U=0,V=0))
}