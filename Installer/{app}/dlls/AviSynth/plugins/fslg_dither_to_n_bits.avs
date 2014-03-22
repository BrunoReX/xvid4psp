# other parameters: transmitted to DitherPost().
#
# Example:
#
# .avs:
# ...
# GradFun3(lsb=true) # Stack16 clip
# fslg_dither_to_n_bits (10, outn=true)
# Dither_convey_yuv4xxp16_on_yvxx ()
# 
# .bat:
# avs2yuv -raw script.avs -o - | x264-10bit --demuxer raw --input-depth 10 --input-res 1280x720 --fps 24000/1001 --output video.mkv -


Function fslg_dither_to_n_bits (clip o, int n, bool "outn", int "mode", int "ampo", int "ampn", bool "dyn")
{
	outn = Default (outn, false)

	o
	msb = Dither_get_msb ()
	lsb = Dither_get_lsb ()
	hr = 2

	m = String (Round (Pow (2, 16 - hr - n)) - 1)
	l = msb.mt_lut ("x     "+m+"   &u", y=3, u=3, v=3)
	h = msb.mt_lut ("x 255 "+m+" - &u", y=3, u=3, v=3)

	s1 = String (n - 8)
	ofs = String (Round (Pow (2, 7 - hr)))
	a = StackVertical (l, lsb)
	a = a.Dither_lut16 ("x "+s1+" <<u "+ofs+" 256 * +", y=3, u=3, v=3)

	b = a.DitherPost (mode=mode, ampo=ampo, ampn=ampn, dyn=dyn)

	(outn)
\	? fslg_dither_to_n_bits_out_n (b, h, n, hr, s1, ofs, m)
\	: fslg_dither_to_n_bits_out_16 (b, h, n, hr, s1, ofs)
}

Function fslg_dither_to_n_bits_out_16 (clip b, clip h, int n, int hr, string s1, string ofs)
{
	s2 = String (16 - n)
	ofs2 = String (Round (Pow (2, 15 - hr - n)))
	b_msb = b.mt_lut ("x "+s1+" >>u 255 &u "+ofs2+" - 128 +", y=3, u=3, v=3)
	b_lsb = b.mt_lut ("x "+ofs+" - "+s2+" <<u 255 &u", y=3, u=3, v=3)

	c = mt_adddiff (h, b_msb, y=3, u=3, v=3)

	StackVertical (c, b_lsb)
}

Function fslg_dither_to_n_bits_out_n (clip b, clip h, int n, int hr, string s1, string ofs, string m)
{
	ofs2 = String (Round (Pow (2, 7 - (n-8) - hr)))
	b2 = b.mt_lut ("x "+s1+" >>u "+ofs2+" - 128 + 255 "+m+" - &u", y=3, u=3, v=3)
	h2 = mt_adddiff (h, b2, y=3, u=3, v=3)
	msb = h2.mt_lut ("x "+String(16-n)+" >>u", y=3, u=3, v=3)

	m2 = String (Round (Pow (2, 8 - hr)) - 1)
	lsb = mt_lutxy (h2, b, "x "+s1+" <<u 255 "+m2+" - &u y "+ofs+" - "+m2+" &u +", y=3, u=3, v=3)

	StackVertical (msb, lsb)
} 