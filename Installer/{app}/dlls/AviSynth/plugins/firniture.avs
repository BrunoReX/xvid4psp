# 5 new interpolation kernels (via DitherTools)
# example usage:  firniture(720, 400, kernel="binomial7", taps=7, gamma=true)
# http://forum.doom9.org/showthread.php?t=166080

function firniture(clip c, int width_, int height_, string "kernel", int "taps", bool "gamma")
{
	binomial5 = string("8 0 -589 0 11203 0 -93355 0 606836 1048576 606836 0 -93355 0 11203 0 -589 0 8")
	binomial7 = string("146 0 -20294 0 744006 0 -11528384 0 94148472 0 -487836876 0 2551884458 4294967296 2551884458 0 -487836876 0 94148472 0 -11528384 0 744006 0 -20294 0 146")

	maxflat5 = string("-259 1524 -487 -12192 17356 42672 -105427 -85344 559764 1048576 559764 -85344 -105427 42672 17356 -12192 -487 1524 -259")
	maxflat8 = string(" 2 -26  166 -573  912 412 1524 -589 -12192 17356 42672 -105427 -85344 606836 1048576 606836 -85344 -105427 42672 17356 -12192 -589 1524 412 912 -573 166 -26 2 ")

	noalias4 = string("-1 2 4 -6 -16 8 64 96 64 8 -16 -6 4 2 -1")
	noaliasnoring4 = string("-1 8  40  -114 -512 360  3520 5664 3520 360 -512 -114 40 8 -1")

	wall7 = string("8020 0 -108072 0 725221 0 -3242240 0 15136016 0 -32220202 0 127642340 207552512 127642340 0 -32220202 0 15136016 0 -3242240 0 725221 0 -108072 0 8020")

	kernel_ = Default(kernel, "binomial7")
	taps = Default(taps, 8)
	gamma = default(gamma, false) 

	in = c
	out = in.Dither_convert_8_to_16
	out = gamma ? out.Dither_y_gamma_to_linear : out
	out = out.Dither_resize16(width_, height_, 0, 0, 0, 0, kernel="impulse "+string(Eval(kernel_))+"", kovrspl=2, taps=taps)
	out = gamma ? out.Dither_y_linear_to_gamma : out
	out = out.DitherPost
	
return(out)
}