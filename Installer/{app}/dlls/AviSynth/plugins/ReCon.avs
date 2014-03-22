Function ReCon(clip c, float "str", float "strv", float "strh", float "rad", float "radh", float "radv", int "lmode", int "thresh")
{#Reconvolution - makes things sharp by mixing pixels together

	str = Default(str, 4)
		strv = Default(strv, str)
		strh = Default(strh, str)

	Rad = Default(Rad, 2)
		Radv = Default(Radv, Rad)
		Radh = Default(Radh, Rad)

	lmode = Default(lmode, 1)
	
	thresh = Default(thresh, 720)


	thrc = thresh
		thrcv = thrc
		thrcH = thrc				
			thr2gv = 1/sqrt(thrcv)
			thr2gh = 1/sqrt(thrch)
	str_ = thresh
		strv_ =str_
		strh_ = str_		
		
		thrm = thresh
					
	thrm_ = string(thrm)
	Max_V = Radv == 0.5 ? mt_luts( C, C, mode = "max", pixels = "0 1 0 -1", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : C
	Max_V = Radv == 1   ? mt_luts( C, C, mode = "max", pixels = "0 1 0 -1 0 2 0 -2", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_V
	Max_V = Radv == 1.5 ? mt_luts( C, C, mode = "max", pixels = "0 1 0 -1 0 2 0 -2 0 3 0 -3", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_V
	Max_V = Radv == 2   ? mt_luts( C, C, mode = "max", pixels = "0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_V
	Max_V = Radv == 2.5 ? mt_luts( C, C, mode = "max", pixels = "0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_V
	Max_V = Radv == 3   ? mt_luts( C, C, mode = "max", pixels = "0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_V
	Max_V = Radv == 4   ? mt_luts( C, C, mode = "max", pixels = "0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6 0 7 0 -7 0 8 0 -8", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_V
	
	Min_V = Radv == 0.5 ? mt_luts( C, C, mode = "min", pixels = "0 1 0 -1", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : C
	Min_V = Radv == 1   ? mt_luts( C, C, mode = "min", pixels = "0 1 0 -1 0 2 0 -2", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_V
	Min_V = Radv == 1.5 ? mt_luts( C, C, mode = "min", pixels = "0 1 0 -1 0 2 0 -2 0 3 0 -3", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_V
	Min_V = Radv == 2   ? mt_luts( C, C, mode = "min", pixels = "0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_V
	Min_V = Radv == 2.5 ? mt_luts( C, C, mode = "min", pixels = "0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_V
	Min_V = Radv == 3   ? mt_luts( C, C, mode = "min", pixels = "0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_V
	Min_V = Radv == 4   ? mt_luts( C, C, mode = "min", pixels = "0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6 0 7 0 -7 0 8 0 -8", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_V

	thrcv_ = string(thrcv)
	Med_V = Radv == 0.5 ? MT_Luts( C, C, mode = "med", pixels = "0 0 0 1 0 -1" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : C
	Med_V = Radv == 1   ? MT_Luts( C, C, mode = "med", pixels = "0 0 0 1 0 -1 0 2 0 -2" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_V
	Med_V = Radv == 1.5 ? MT_Luts( C, C, mode = "med", pixels = "0 0 0 1 0 -1 0 2 0 -2 0 3 0 -3" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_V
	Med_V = Radv == 2   ? MT_Luts( C, C, mode = "med", pixels = "0 0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_V
	Med_V = Radv == 2.5 ? MT_Luts( C, C, mode = "med", pixels = "0 0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_V
	Med_V = Radv == 3   ? MT_Luts( C, C, mode = "med", pixels = "0 0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_V
	Med_V = Radv == 4   ? MT_Luts( C, C, mode = "med", pixels = "0 0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6 0 7 0 -7 0 8 0 -8" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_V
	Med_V = Med_V.mt_Lut("X 128 - abs", u=1, v=1)
	
		MinMax_High_V = mt_lutXY( Max_V, Min_V, expr = "x 128 - abs y 128 - abs > x y ? 128 - abs", u=1, v=1)
		MinMax_Low_V = mt_lutXY( Max_V, Min_V, expr = "x 128 - abs y 128 - abs > y x ? 128 - abs", u=1, v=1)
			minmax_UL_V = mt_lutXY( MinMax_Low_V, MinMax_High_V, expr = "x y x - -", u=1, v=1)
				minmaxmed_v = Average(MinMax_High_V, 0.0625, MinMax_Low_V, 0.25, minmax_UL_V, 0.34375, Med_V, 0.34375)
	
	STRH_ = string(strh_)
	Max_H = Radh == 0.5 ? mt_luts( C, C, mode = "max", pixels = "1 0 -1 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : C
	Max_H = Radh == 1   ? mt_luts( C, C, mode = "max", pixels = "1 0 -1 0 2 0 -2 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_H
	Max_H = Radh == 1.5 ? mt_luts( C, C, mode = "max", pixels = "1 0 -1 0 2 0 -2 0 3 0 -3 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_H
	Max_H = Radh == 2   ? mt_luts( C, C, mode = "max", pixels = "1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_H
	Max_H = Radh == 2.5 ? mt_luts( C, C, mode = "max", pixels = "1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_H
	Max_H = Radh == 3   ? mt_luts( C, C, mode = "max", pixels = "1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_H
	Max_H = Radh == 4   ? mt_luts( C, C, mode = "max", pixels = "1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6 0 7 0 -7 0 8 0 -8 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Max_H
	
	Min_H = Radh == 0.5 ? mt_luts( C, C, mode = "min", pixels = "1 0 -1 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : C
	Min_H = Radh == 1   ? mt_luts( C, C, mode = "min", pixels = "1 0 -1 0 2 0 -2 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_H
	Min_H = Radh == 1.5 ? mt_luts( C, C, mode = "min", pixels = "1 0 -1 0 2 0 -2 0 3 0 -3 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_H
	Min_H = Radh == 2   ? mt_luts( C, C, mode = "min", pixels = "1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_H
	Min_H = Radh == 2.5 ? mt_luts( C, C, mode = "min", pixels = "1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_H
	Min_H = Radh == 3   ? mt_luts( C, C, mode = "min", pixels = "1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_H
	Min_H = Radh == 4   ? mt_luts( C, C, mode = "min", pixels = "1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6 0 7 0 -7 0 8 0 -8 0", expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1, v=1) : Min_H
		
	thrch_ = string(thrch)
	Med_H = Radh == 0.5 ? MT_Luts( C, C, mode = "med", pixels = "0 0 1 0 -1 0" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : C
	Med_H = Radh == 1   ? MT_Luts( C, C, mode = "med", pixels = "0 0 1 0 -1 0 2 0 -2 0" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_H
	Med_H = Radh == 1.5 ? MT_Luts( C, C, mode = "med", pixels = "0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_H
	Med_H = Radh == 2   ? MT_Luts( C, C, mode = "med", pixels = "0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_H
	Med_H = Radh == 2.5 ? MT_Luts( C, C, mode = "med", pixels = "0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_H
	Med_H = Radh == 3   ? MT_Luts( C, C, mode = "med", pixels = "0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6 0" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_H
	Med_H = Radh == 4   ? MT_Luts( C, C, mode = "med", pixels = "0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 6 0 -6 0 7 0 -7 0 8 0 -8 0" ,expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+thrm_+" 1 >= "+thrm_+" 0.5 ^ "+thrm_+" ? + / - 128 +", u=1,v=1) : Med_H
	Med_H = Med_H.mt_Lut("X 128 - abs", u=1, v=1)

		MinMax_High_H = mt_lutXY( Max_H, Min_H, expr = "x 128 - abs y 128 - abs > x y ? 128 - abs", u=1, v=1)
		MinMax_Low_H  = mt_lutXY( Max_H, Min_H, expr = "x 128 - abs y 128 - abs > y x ? 128 - abs", u=1, v=1)
			minmax_UL_H = mt_lutXY( MinMax_Low_H, MinMax_High_H, expr = "x y x - -" )
				minmaxmed_h = Average(MinMax_High_h, 0.0625, MinMax_Low_h, 0.25, minmax_UL_h, 0.34375, Med_h, 0.34375)
	
							
																			
	Blur_V = C.NLLV_variant4()
	Blur_V = Rad > 1 ? Blur_V.NLLV_variant4(2) : Blur_V
	Blur_V = Rad > 2 ? Blur_V.NLLV_variant4(3) : Blur_V
	Blur_V = Rad > 3 ? Blur_V.NLLV_variant4(4) : Blur_V
		Sharp_Diff_V = mt_Makediff(C, Blur_V)

		thr2gv_ = string(thr2gv)
		cstrv_ = string(strv)
		Sharp_V = lmode == 0 ? mt_lutXY(Sharp_Diff_V, minmaxmed_v, expr = " x 128 - y * "+thr2gv_+" * "+cstrv_+" * 128 + ", u=1, v=1) : C
		Sharp_V = lmode == 1 ? mt_lutXY(Sharp_Diff_V, minmaxmed_v, expr = " x 128 - abs y > x 128 - y * "+thr2gv_+" * "+cstrv_+" * 128 + X 128 - y 0.5 ^ * "+thr2gv_+" 0.5 ^ * "+cstrv_+" * 128 + ? ", u=1, v=1) : Sharp_V
		Sharp_V = lmode == 2 ? mt_lutXY(Sharp_Diff_V, minmaxmed_v, expr = " x 128 - abs y > x 128 - y * "+thr2gv_+" * "+cstrv_+" * 128 + Y 0 > X 128 - "+cstrv_+" * 128 + 128 ? ? ", u=1, v=1) : Sharp_V
		Sharp_V = lmode == 3 ? mt_lutXY(Sharp_Diff_V, minmaxmed_v, expr = " x 128 - abs y > x 128 - y * "+thr2gv_+" * "+cstrv_+" * 128 + X 128 - "+cstrv_+" * 128 + ? ", u=1, v=1) : Sharp_V
	
	Blur_H = C.NLLH_variant4()
	Blur_H = Rad > 1 ? Blur_H.NLLH_variant4(2) : Blur_H
	Blur_H = Rad > 2 ? Blur_H.NLLH_variant4(3) : Blur_H
	Blur_H = Rad > 3 ? Blur_H.NLLH_variant4(4) : Blur_H
		Sharp_Diff_H = mt_Makediff(C, Blur_H)

		thr2gh_ = string(thr2gh)
		cstrh_ = string(strh)
		Sharp_H = lmode == 0 ? mt_lutXY(Sharp_Diff_H, minmaxmed_h, expr = " x 128 - y * "+thr2gh_+" * "+cstrh_+" * 128 + ", u=1, v=1) : C
		Sharp_H = lmode == 1 ? mt_lutXY(Sharp_Diff_H, minmaxmed_h, expr = " x 128 - abs y > x 128 - y * "+thr2gh_+" * "+cstrh_+" * 128 + X 128 - y 0.5 ^ * "+thr2gh_+" 0.5 ^ * "+cstrh_+" * 128 + ? ", u=1, v=1) : Sharp_H
		Sharp_H = lmode == 2 ? mt_lutXY(Sharp_Diff_H, minmaxmed_h, expr = " x 128 - abs y > x 128 - y * "+thr2gh_+" * "+cstrh_+" * 128 + Y 0 > X 128 - "+cstrh_+" * 128 + 128 ? ? ", u=1, v=1) : Sharp_H	
		Sharp_H = lmode == 3 ? mt_lutXY(Sharp_Diff_H, minmaxmed_h, expr = " x 128 - abs y > x 128 - y * "+thr2gh_+" * "+cstrh_+" * 128 + X 128 - "+cstrh_+" * 128 + ? ", u=1, v=1) : Sharp_H
		Sharp_H = lmode == 4 ? mt_lutXY(Sharp_Diff_H, minmaxmed_h, expr = " x 128 - "+cstrh_+" * 128 + ", u=1, v=1) : Sharp_H
		
			Sharp_VH = mt_adddiff(Sharp_V, Sharp_H)
				sharpened = mt_adddiff(C, Sharp_VH)
sharpened.mergechroma(C, 1)

Return(last)
}

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

