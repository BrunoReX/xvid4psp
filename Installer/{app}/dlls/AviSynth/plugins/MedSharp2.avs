Function MedSharp2(Clip C, int "thresh", int "rad", int "mode", bool "lp", bool "hp", bool "nr", float "str", int "kernel")
{

	_Thr = Default(thresh, 256)
	_Rad = Default(rad, 1)
	Mode = Default(mode, 1)
	str = Default(str, 1)
		THR  = string(_Thr)
		RAD  = string(_Rad)
		RAD2  = string(_Rad)

	lp = Default(lp, false)
	hp = Default(hp, false)
	nr = Default(nr, false)
	kernel = Default(kernel, 2)


	inputclipproperties = c
	blank = BlankClip(length=inputclipproperties.framecount, width=inputclipproperties.width, height=inputclipproperties.height, pixel_type="rgb32", fps=inputclipproperties.framerate, fps_denominator=1, audio_rate=inputclipproperties.Audiorate, stereo=true, sixteen_bit=true, color=$828282).converttoyv12()


	Lowpass1 =  C.NLLV(rad=1).NLLH(rad=1) 
		Lowpass_Return = lp == true ? _Rad >= 2 ? Lowpass1 : C : C 

	Lowpass_NR_1 = Lowpass_Return.TMed2(rad=_Rad, thresh=_Thr, Kernel=1)
	Lowpass_NR_2 = Lowpass_Return.TMed2(rad=_Rad, thresh=_Thr/4, Kernel=2)

	Diff1 = MT_Luts(C, Lowpass_NR_1, mode="med", pixels = "0 "+RAD+" "+RAD+" 0 -"+RAD+" 0 0 -"+RAD+" 0 0" ,\
	 expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1)
	Diff2 = MT_Luts(C, Lowpass_NR_2, mode="med", pixels = "-"+RAD2+" -"+RAD2+"-"+RAD2+" "+RAD2+" "+RAD2+" -"+RAD2+" "+RAD2+" "+RAD2+" 0 "+RAD+" "+RAD+" 0 -"+RAD+" 0 0 -"+RAD ,\
	 expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 2 * 1 >= "+THR+" 2 * 0.5 ^ "+THR+" 2 * ? + / - 128 +", u=1,v=1)
		
	mask1 = Mt_Lut(Diff1, " X 128 - 255 * ", u=1, v=1)#.NLLV().NLLH()
	#mask2 = Mt_Lut(Diff2, " X 128 - 255 * ", u=1, v=1)#.NLLV().NLLH()
		
	s1 = mt_merge(Diff2, blank, mask1).mt_Lut("X 128 - "+string(str)+" 2 / * 128 +")
		s1b = s1.NLLV().NLLH()
			s1s = mt_makediff(s1, s1b)
	s2 = Diff1.mt_Lut("X 128 - "+string(str)+" * 128 +")
		s2b = s1.NLLV().NLLH()
			s2s = mt_makediff(s2, s2b)
		

	out = MT_adddiff(C, s1s, u=2, v=2)
	out = MT_adddiff(out, s2s, u=2, v=2)
	out

Return(Last)
}

# Y'et A'nother H'alo R'educing script
function YAHR(clip clp)
{
b1    = clp.minblur(2).removegrain(11,-1)
b1D   = mt_makediff(clp,b1)
w1    = clp.aWarpSharp2(depth=32,blur=2,thresh=128,chroma=3)
w1b1  = w1.minblur(2,1).removegrain(11,-1)
w1b1D = mt_makediff(w1,w1b1)
DD    = b1D.repair(w1b1D,13) 
DD2   = mt_makediff(b1D,DD)
clp.mt_makediff(DD2,U=2,V=2)
}

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

Function Tblur4(Clip c, int "thresh")
{

	Thresh = Default(Thresh, 8)
		B1 = C.yahr
			Mt_LutXY(C, b1, " X Y - abs X Y - abs * X Y -  * X Y - abs X Y - abs * "+string(thresh)+" + / 128 +", u=1, v=1)
	
Mt_AddDiff(last, b1, u=1, v=1)

Return(last)
}

Function NLLV(Clip C, int "rad")
{


	Rad = Default(Rad, 1)

	B1 = C.BlurV(1*rad, 0.439)
	B2 = C.BlurV(3*rad, 0.833)
	B3 = C.BlurV(5*rad, 0.934)
	B4= C.BlurV(7*rad, 0.983)

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

Function NLLH(Clip C, int "rad")
{


	Rad = Default(Rad, 1)

	B1 = C.BlurH(1*rad, 0.439)
	B2 = C.BlurH(3*rad, 0.833)
	B3 = C.BlurH(5*rad, 0.934)
	B4= C.BlurH(7*rad, 0.983)

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

function Halomask1(clip c, int "Rad", float "SS")
{
	
	SS = default(ss, 1.5)
	Rad = default(rad, 7)
	owidth = c.width
	oheight = c.height
	
	
	ssample = spline36resize(c, round((c.width*SS)/4)*4, round((c.height*SS)/4)*4)
	
	mask1 = mt_lutxy(ssample, Xsharpen(ssample, 127, 255), "x y - abs 1 - 63 *", u=1, v=1)
		mask2 = (rad >= 1) ? mask1.mt_expand(u=1, v=1) : mask1
		mask2 = (rad >= 2) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 3) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 4) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 5) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 6) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 7) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 8) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 9) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 10) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 11) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 12) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 13) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 14) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 15) ? mask2.mt_expand(u=1, v=1) : mask2
		mask2 = (rad >= 16) ? mask2.mt_expand(u=1, v=1) : mask2
			mask3 = mt_lutXY(mask1, mask2, "y x - 63 - 1.5 *", u=1, v=1).spline36resize(owidth, oheight)
	
return(mask3)
}



Function NLHH(Clip C)
{


	B1 = Average(C.BlurH(1, 0.833), 0.5, C.BlurH(2, 0.833), 0.5)
	B2 = C.BlurH(3, 0.750)
	B3 = C.BlurH(5, 0.944)
	B4= C.BlurH(7, 0.981)

		B1_D = Mt_Makediff(c, b1, u=1, v=1)
		B2_D = Mt_MakeDiff(b2, c, u=1, v=1)
		B3_D = Mt_MakeDiff(c, b3, u=1, v=1)
		B4_D = Mt_MakeDiff(b4, c, u=1, v=1)

			B2_DT = Mt_LutXY(B1_D, B2_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 0.75 * X 128 - abs - 0 > Y 128 - abs 0.75 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B3_DT = Mt_LutXY(B2_DT, B3_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 2.25 * X 128 - abs - 0 > Y 128 - abs 2.25 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B4_DT = Mt_LutXY(B3_DT, B4_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 6.75 * X 128 - abs - 0 > Y 128 - abs 6.75 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)

	Mt_AddDiff(B4_DT, C)

Return(last)
}

Function NLHV(Clip C)
{


	B1 = Average(C.BlurV(1, 0.833), 0.5, C.BlurV(2, 0.833), 0.5)
	B2 = C.BlurV(3, 0.750)
	B3 = C.BlurV(5, 0.944)
	B4= C.BlurV(7, 0.981)

		B1_D = Mt_Makediff(c, b1, u=1, v=1)
		B2_D = Mt_MakeDiff(b2, c, u=1, v=1)
		B3_D = Mt_MakeDiff(c, b3, u=1, v=1)
		B4_D = Mt_MakeDiff(b4, c, u=1, v=1)

			B2_DT = Mt_LutXY(B1_D, B2_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 0.75 * X 128 - abs - 0 > Y 128 - abs 0.75 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B3_DT = Mt_LutXY(B2_DT, B3_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 2.25 * X 128 - abs - 0 > Y 128 - abs 2.25 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B4_DT = Mt_LutXY(B3_DT, B4_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 6.75 * X 128 - abs - 0 > Y 128 - abs 6.75 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)

	Mt_AddDiff(B4_DT, C)

Return(last)
}

Function TblurNL(Clip c, float "thresh", float "thresh2", float "thresh3", int "rad")
{


	Rad = Default(Rad, 1)

		B1 = C.NLLH(1*Rad)
		B2 = B1.NLLV(1*Rad)
		B3 = B2.NLLH(2*Rad)
		B4 = B3.NLLV(2*Rad)
		B5 = B4.NLLH(3*Rad)
		B6 = B5.NLLV(3*Rad)
	
	
	
	Thresh = Default(Thresh, 8)
	Thresh2 = Default(Thresh2, Thresh/4)
	Thresh3 = Default(Thresh3, Thresh/9)

	Thresh1 = Thresh
	Thresh2 = Thresh
	
	Thresh3 = Thresh2
	Thresh4 = Thresh2

	Thresh5 = Thresh3
	Thresh6 = Thresh3


	Mt_LutXY(b5, b6, " X Y - abs 1 + X Y - abs 1 + * X Y -  * X Y - abs 1 + X Y - abs 1 + * "+string(thresh6)+" + / 128 +", u=1, v=1)
	Mt_AddDiff(last, b6, u=1, v=1)
		b5 = last
		
	Mt_LutXY(b4, b5, " X Y - abs 1 + X Y - abs 1 + * X Y -  * X Y - abs 1 + X Y - abs 1 + * "+string(thresh5)+" + / 128 +", u=1, v=1)
	Mt_AddDiff(last, b5, u=1, v=12)
		b4 = last
		
	Mt_LutXY(b3, b4, " X Y - abs 1 + X Y - abs 1 + * X Y -  * X Y - abs 1 + X Y - abs 1 + * "+string(thresh4)+" + / 128 +", u=1, v=1)
	Mt_AddDiff(last, b4, u=1, v=1)
		b3 = last


	Mt_LutXY(b2, b3, " X Y - abs 1 + X Y - abs 1 + * X Y -  * X Y - abs 1 + X Y - abs 1 + * "+string(thresh3)+" + / 128 +", u=1, v=1)
	Mt_AddDiff(last, b3, u=1, v=1)
		b2 = last

	Mt_LutXY(b1, b2, " X Y - abs 1 + X Y - abs 1 + * X Y -  * X Y - abs 1 + X Y - abs 1 + * "+string(thresh2)+" + / 128 +", u=1, v=1)
	Mt_AddDiff(last, b2, u=1, v=1)
		b1 = last

	Mt_LutXY(C, b1, " X Y - abs 1 + X Y - abs 1 + * X Y -  * X Y - abs 1 + X Y - abs 1 + * "+string(thresh1)+" + / 128 +", u=1, v=1)
Mt_AddDiff(last, b1, u=1, v=1)

Return(Last)
}

Function TMed2(Clip C, int "thresh", int "rad", int "mode", int "kernel")
{

	_Thr = Default(thresh, 256)
	_Rad = Default(rad, 1)
	Mode = Default(mode, 1)
		THR  = string(_Thr)
		RAD  = string(_Rad)
		RAD2  = string(_Rad)
		kernel = Default(kernel, 1)

	Diff = Mode==0 ? MT_Luts(C, C, mode="med", pixels = "0 "+RAD+" "+RAD+" 0 -"+RAD+" 0 0 -"+RAD ,\
	expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1)\
	 : MT_Luts(C, C, mode="med", pixels = "0 "+RAD+" "+RAD+" 0 -"+RAD+" 0 0 -"+RAD+" 0 0" ,\
	 expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1)
        Diff = Kernel > 1 ? MT_Luts(C, C, mode="med", pixels = "-"+RAD2+" -"+RAD2+"-"+RAD2+" "+RAD2+" "+RAD2+" -"+RAD2+" "+RAD2+" "+RAD2+" 0 "+RAD+" "+RAD+" 0 -"+RAD+" 0 0 -"+RAD ,\
          expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : Diff 

	 
	 
	 	MT_Makediff(C, Diff, u=2, v=2)

Return(Last)
}

