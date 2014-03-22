Function TblurNL(Clip c, int "thresh", float "thresh2", float "thresh3", int "rad")
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

			B2_DT = Mt_LutXY(B1_D, B2_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 1.915 * X 128 - abs - 0 > Y 128 - abs 1.915 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B3_DT = Mt_LutXY(B2_DT, B3_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 2.025 * X 128 - abs - 0 > Y 128 - abs 2.025 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B4_DT = Mt_LutXY(B3_DT, B4_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 2.077 * X 128 - abs - 0 > Y 128 - abs 2.077 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)

	Mt_AddDiff(B4_DT, C)

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

			B2_DT = Mt_LutXY(B1_D, B2_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 1.915 * X 128 - abs - 0 > Y 128 - abs 1.915 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B3_DT = Mt_LutXY(B2_DT, B3_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 2.025 * X 128 - abs - 0 > Y 128 - abs 2.025 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)
			B4_DT = Mt_LutXY(B3_DT, B4_D, " X 128 - Y 128 - X 128 - abs Y 128 - abs * 1 + * X 128 - abs Y 128 - abs * Y 128 - abs 2.077 * X 128 - abs - 0 > Y 128 - abs 2.077 * X 128 - abs - 0 ?  X 128 - abs 0 > X 128 - abs -1 X 128 - abs 0 > X 128 - 1 ? / ^ 1 ? / 1 * + 1 + / +  128 + ", u=1, v=1)

	Mt_AddDiff(B4_DT, C)

Return(last)
}

Function BlurH(clip c, int "rad", Float "CW")
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
