function HighPassSharp(clip c, float "r", bool "half", bool "soft") {
	# High Pass sharp by Andrew Revvo, 2011
	# Requires: mt_masktools2
	r = default(r, 0.3)
	half = default(half, false)
	soft = default(soft, false)
	blur = c.Blur(r)
	hpm = mt_average(c, blur.Invert()).Greyscale()
	mode = soft ? "softlight" : "hardlight"
	c.Overlay(hpm, mode=mode)
	half ? mt_average(c, last) : last
}

function HighPassSharp2(clip c, float "r1", float "r2", bool "half", bool "soft") {
	# High Pass sharp by Andrew Revvo, 2011
	# Requires: mt_masktools2
	r1 = default(r1, 0.2)
	r2 = default(r2, 0.1)
	half = default(half, false)
	soft = default(soft, false)
	blur = c.Blur(r1).Blur(r2)
	hpm = mt_average(c, blur.Invert()).Greyscale()
	mode = soft ? "softlight" : "hardlight"
	c.Overlay(hpm, mode=mode)
	half ? mt_average(c, last) : last
}

function HighPassSharp3(clip c, float "r1", float "r2", float "r3", bool "half", bool "soft") {
	# High Pass sharp by Andrew Revvo, 2011
	# Requires: mt_masktools2
	r1 = default(r1, 0.1)
	r2 = default(r2, 0.2)
	r3 = default(r3, 0.1)
	half = default(half, false)
	soft = default(soft, false)
	blur = c.Blur(r1).Blur(r2).Blur(r3)
	hpm = mt_average(c, blur.Invert()).Greyscale()
	mode = soft ? "softlight" : "hardlight"
	c.Overlay(hpm, mode=mode)
	half ? mt_average(c, last) : last
}

function Range8to16(clip c) {
	# Requires: mt_masktools2
	StackVertical(c, c.mt_lut(Y=0,U=0,V=0))
}