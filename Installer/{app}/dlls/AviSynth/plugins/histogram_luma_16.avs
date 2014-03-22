Function histogram_luma_16 (clip src, int "amp", bool "tv_range")
{
	amp      = Default (amp,        16)
	tv_range = Default (tv_range, true)

	mi = (tv_range ?  16 * 256 :     0)
	ma = (tv_range ? 235 * 256 : 65535)
	rpa = (ma + 1 - mi) / amp - 1
	mis = String (mi)
	rpas = String (rpa)
	amps = String (amp)
	e = rpas+" x "+mis+" - "+rpas+" 2 * % "+rpas+" - abs - "+amps+" * "+mis+" +"

	src
	Dither_lut16 (e, u=1, v=1)
	DitherPost (mode=6, u=-128, v=-128)
}