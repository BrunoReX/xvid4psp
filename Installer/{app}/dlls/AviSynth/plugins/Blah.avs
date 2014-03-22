Function blah(Clip c, Int "str", int "strv", int "strh", float "de", float "dev", float "deh", float "re", float "rev", float "reh", float "cstr", float "cstrv", float "cstrh")
{# A sharpening function, Version 0.0

	str = Default(Str, 4)
		strv = Default(strv, str)
		strh = Default(strh, str)
	de = Default(de, 0.2)
		dev = Default(dev, de)
		deh = Default(deh, de)
	re = Default(re, de/2)
		rev = Default(rev, re)
		reh = Default(reh, re)
	cstr = Default(cstr, 0.5)
	cstrv = Default(cstrv, cstr)
	cstrh = Default(cstrh, cstr)

	de = 20/de
		dev = 20/dev
		deh = 20/deh
	re = 20/re
		rev = 20/rev
		reh = 20/reh

	thrc = 72
		thrcv = thrc
		thrcH = thrc				
			thr2gv = 1/sqrt(thrcv)
			thr2gh = 1/sqrt(thrch)
	
	
	lp_V = C.NLLV_Variant4()
		Diff_V = mt_makediff(C, lp_V)

	lp_H = lp_V.NLLH_Variant4()
		Diff_H = mt_makediff(lp_V, lp_H)
			dev_ = string(rev)
			deh_ = string(reh)
			DeEmphasis = lp_H.yahr.yahr.Mt_Convolution(Horizontal=" 1 6 15 "+deh_+" 15 6 1 ", vertical =" 1 6 15 "+dev_+" 15 6 1 ", u=1, v=1)

	STRV_ = string(strv)
	Max_V = mt_luts( C, C, mode = "max", pixels = " 1 0 -1 0 ", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+STRV_+" 1 >= "+STRV_+" 0.5 ^ "+STRV_+" ? + / - 128 +", u=1, v=1)
	Min_V = mt_luts( C, C, mode = "min", pixels = " 1 0 -1 0 ", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+STRV_+" 1 >= "+STRV_+" 0.5 ^ "+STRV_+" ? + / - 128 +", u=1, v=1)
		MinMax_High_V = mt_lutXY( Max_V, Min_V, expr = "x 128 - abs y 128 - abs > x y ? 128 - abs", u=1, v=1)
		MinMax_Low_V = mt_lutXY( Max_V, Min_V, expr = "x 128 - abs y 128 - abs > y x ? 128 - abs", u=1, v=1)
			minmax_UL_V = mt_lutXY( MinMax_Low_V, MinMax_High_V, expr = "x y x - -", u=1, v=1)
				minmax_G_V = Average(MinMax_High_V, 0.1, MinMax_Low_V, 0.35, minmax_UL_V, 0.275, minmax_UL_V, 0.275)
	STRH_ = string(strh)
	Max_H = mt_luts( C, C, mode = "max", pixels = " 0 1 0 -1 ", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+STRH_+" 1 >= "+STRH_+" 0.5 ^ "+STRH_+" ? + / - 128 +", u=1, v=1)
	Min_H = mt_luts( C, C, mode = "min", pixels = " 0 1 0 -1 ", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+STRH_+" 1 >= "+STRH_+" 0.5 ^ "+STRH_+" ? + / - 128 +", u=1, v=1)
		MinMax_High_H = mt_lutXY( Max_H, Min_H, expr = "x 128 - abs y 128 - abs > x y ? 128 - abs", u=1, v=1)
		MinMax_Low_H = mt_lutXY( Max_H, Min_H, expr = "x 128 - abs y 128 - abs > y x ? 128 - abs", u=1, v=1)
			minmax_UL_H = mt_lutXY( MinMax_Low_H, MinMax_High_H, expr = "x y x - -" )
				minmax_G_H = Average(MinMax_High_H, 0.1, MinMax_Low_H, 0.35, minmax_UL_H, 0.275, minmax_UL_H, 0.275)


	Diff_V = mt_lutXY( Diff_V, minmax_G_V, expr = " x 128 - y 1 > y 1 ? * y x 128 - abs - 1 > y x 128 - abs - 1 ? / 128 +  ", u=1, v=1)
	Diff_H = mt_lutXY( Diff_H, minmax_G_H, expr = " x 128 - y 1 > y 1 ? * y x 128 - abs - 1 > y x 128 - abs - 1 ? / 128 +  ", u=1, v=1)
		Diff_HV = mt_adddiff(Diff_H, Diff_V)
			HPSharp = mt_adddiff(DeEmphasis, Diff_HV)
				rev_ = string(rev)
				reh_ = string(reh)
				ReEmphasis = HPSharp.Mt_Convolution(Horizontal=" 1 6 15 -"+reh_+" 15 6 1 ", vertical =" 1 6 15 -"+rev_+" 15 6 1 ", u=1, v=1)

	thrcv_ = string(thrcv)
		V = MT_Luts(ReEmphasis, ReEmphasis, mode="med", pixels = " 0 0 0 1 0 -1 0 2 0 -2 " ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrcv_+" 1 >= "+thrcv_+" 0.5 ^ "+thrcv_+" ? + / - 128 +", u=1,v=1).mt_Lut("X 128 - abs", u=1, v=1)
	thrch_ = string(thrch)
		H = MT_Luts(ReEmphasis, ReEmphasis, mode="med", pixels = " 0 0 1 0 -1 0 2 0 -2 0 " ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrch_+" 1 >= "+thrch_+" 0.5 ^ "+thrch_+" ? + / - 128 +", u=1,v=1).mt_Lut("X 128 - abs", u=1, v=1)


	Gauss_V = mt_Makediff(ReEmphasis, ReEmphasis.Mt_Convolution(Horizontal=" 1 ", vertical =" 1 6 15 20 15 6 1 ", u=1, v=1))
		thr2gv_ = string(thr2gv)
		cstrv_ = string(cstrv)
		Gauss_V = mt_lutXY( Gauss_V, V, expr = " x 128 - y * "+thr2gv_+" * "+cstrv_+" * 128 + ", u=1, v=1)
	Gauss_H = mt_Makediff(ReEmphasis, ReEmphasis.Mt_Convolution(Horizontal=" 1 6 15 20 15 6 1 ", vertical =" 1 ", u=1, v=1))
		thr2gh_ = string(thr2gh)
		cstrh_ = string(cstrh)
		Gauss_H = mt_lutXY(Gauss_H, H, expr = " x 128 - y * "+thr2gh_+" * "+cstrh_+" * 128 + ", u=1, v=1)
			Gauss_VH = mt_adddiff(Gauss_V, Gauss_H)
				contrast = mt_adddiff(ReEmphasis, Gauss_VH)
				
Return(mergechroma(contrast, C, 1))
}

# ===========================================================================
# Required Functions:
 
Function blurH(clip c, int "rad", Float "CW")
{
	
	Rad = Default(rad, 1)
	CW = Default(CW, 0.5)
	
	Center = C
	Left = C.PointResize(C.width, C.height, -rad, 0, C.width, C.height)
	Right = C.PointResize(C.width, C.height, rad, 0, C.width, C.height)
	
	Average(Center, CW/2, Left, (1-CW)/2, Right, (1-CW)/2, Center, CW/2)
	
Return(last)
}

Function BlurV(clip c, int "rad", Float "CW")
{
	
	Rad = Default(rad, 1)
	CW = Default(CW, 0.5)
	
	Center = C
	Down = C.PointResize(C.width, C.height, 0, -rad, C.width, C.height)
	Up = C.PointResize(C.width, C.height, 0, rad, C.width, C.height)
	
	Average(Center, CW/2, Down, (1-CW)/2, Up, (1-CW)/2, Center, CW/2)
	
Return(last)
}

Function NLLH_Variant4(Clip C, int "rad")
{


	Rad = Default(Rad, 1)

	B1 = C.BlurH(1*rad, 0.439)
	B2 = C.BlurH(2*rad, 0.833)
	B3 = C.BlurH(3*rad, 0.934)
	B4= C.BlurH(4*rad, 0.983)

		B1_D = Mt_Makediff(B1, C, u=1, v=1)
		B2_D = Mt_MakeDiff(C, B2, u=1, v=1)
		B3_D = Mt_MakeDiff(B3, C, u=1, v=1)
		B4_D = Mt_MakeDiff(C, B4, u=1, v=1)

			B2_DT = Mt_LutXY(B1_D, B2_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 1.915 * X 128 - abs - 0 > \
			Y 128 - abs 1.915 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B3_DT = Mt_LutXY(B2_DT, B3_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 2.025 * X 128 - abs - 0 > \
			Y 128 - abs 2.025 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B4_DT = Mt_LutXY(B3_DT, B4_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 2.077 * X 128 - abs - 0 > \
			Y 128 - abs 2.077 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
	Mt_AddDiff(B4_DT, C)
	
	

Return(last)
}

Function NLLV_Variant4(Clip C, int "rad")
{


	Rad = Default(Rad, 1)

	B1 = C.BlurV(1*rad, 0.439)
	B2 = C.BlurV(2*rad, 0.833)
	B3 = C.BlurV(3*rad, 0.934)
	B4= C.BlurV(4*rad, 0.983)

		B1_D = Mt_Makediff(B1, C, u=1, v=1)
		B2_D = Mt_MakeDiff(C, B2, u=1, v=1)
		B3_D = Mt_MakeDiff(B3, C, u=1, v=1)
		B4_D = Mt_MakeDiff(C, B4, u=1, v=1)

			B2_DT = Mt_LutXY(B1_D, B2_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 1.915 * X 128 - abs - 0 > \
			Y 128 - abs 1.915 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B3_DT = Mt_LutXY(B2_DT, B3_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 2.025 * X 128 - abs - 0 > \
			Y 128 - abs 2.025 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B4_DT = Mt_LutXY(B3_DT, B4_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 2.077 * X 128 - abs - 0 > \
			Y 128 - abs 2.077 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
	Mt_AddDiff(B4_DT, C)
	
	

Return(last)
}



# Y'et A'nother H'alo R'educing script

function YAHR(clip clp)
{
b1    = clp.minblur(2).removegrain(11,-1)
b1D   = mt_makediff(clp,b1)
w1    = clp.aWarpSharp(depth=32,blurlevel=2,thresh=0.5)
w1b1  = w1.minblur(2,1).removegrain(11,-1)
w1b1D = mt_makediff(w1,w1b1)
DD    = b1D.repair(w1b1D,13) 
DD2   = mt_makediff(b1D,DD)
clp.mt_makediff(DD2,U=2,V=2)
}

 function MinBlur(clip clp, int r, int "uv")
 {
 uv   = default(uv,3)
 uv2  = (uv==2) ? 1 : uv
 rg4  = (uv==3) ? 4 : -1
 rg11 = (uv==3) ? 11 : -1
 rg20 = (uv==3) ? 20 : -1
 medf = (uv==3) ? 1 : -200
 
 RG11D = (r==1) ? mt_makediff(clp,clp.removegrain(11,rg11),U=uv2,V=uv2)
  \    : (r==2) ? mt_makediff(clp,clp.removegrain(11,rg11).removegrain(20,rg20),U=uv2,V=uv2)
  \    :          mt_makediff(clp,clp.removegrain(11,rg11).removegrain(20,rg20).removegrain(20,rg20),U=uv2,V=uv2)
 RG4D  = (r==1) ? mt_makediff(clp,clp.removegrain(4,rg4),U=uv2,V=uv2)
  \    : (r==2) ? mt_makediff(clp,clp.medianblur(2,2*medf,2*medf),U=uv2,V=uv2)
  \    :          mt_makediff(clp,clp.medianblur(3,3*medf,3*medf),U=uv2,V=uv2)
 DD    = mt_lutxy(RG11D,RG4D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",U=uv2,V=uv2)
 clp.mt_makediff(DD,U=uv,V=uv)
 return(last)
}

