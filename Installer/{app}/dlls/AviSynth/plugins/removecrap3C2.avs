function removecrap3C2(clip c, int "rad", float "ss", int "hthr", int "hbias", int "agmrad", int "thresh"){
	
	Thresh = Default(Thresh, 8)
	ss = default(ss, 1.5)
	rad = default(rad, 7)
	hthr = default(hthr, 48)
	hbias = default(hbias, -48)
	agmrad = default(agmrad, 6)

	mask1 = halomask1(c, ss=ss, rad=rad)
	mask2 = halomask2(c, hthr=hthr, hbias=hbias, agmrad=agmrad)
	blurred = medianblur(c, 2)

	B1 = mt_merge(mt_lutxy(c, awarpsharp2(c, depth=12, cm=2, blur=4), "x y - 3 / x +", u=3, v=3),\
						awarpsharp2(mt_merge(mt_lutxy(blur(c, 0.25), blurred,  "x y - 2 / x +", u=3, v=3),\
						blurred, mask1.mt_convolution(horizontal=" -1 0 4 7 4 0 -1 ", vertical=" -1 0 4 7 4 0 -1 ", u=1, v=1)), depth=12, cm=2, blur=4), mask2.mt_convolution(horizontal=" -1 0 4 7 4 0 -1 ", vertical=" -1 0 4 7 4 0 -1 ", u=1, v=1))
							Mt_LutXY(C, b1, " X Y - abs X Y - abs * X Y -  * X Y - abs X Y - abs * "+string(thresh)+" + / 128 +", u=1, v=1)
	Mt_AddDiff(last, b1, u=1, v=1)
return(last)}

Function Twarp(Clip c, int "thresh")
{

	Thresh = Default(Thresh, 8)
		B1 = C.awarpsharp2(depth=3, blur=1, thresh=253)
			Mt_LutXY(C, b1, " X Y - abs X Y - abs * X Y -  * X Y - abs X Y - abs * "+string(thresh)+" + / 128 +", u=1, v=1)
	
Mt_AddDiff(last, b1, u=1, v=1)
}

Function TNLHH(Clip c, int "thresh")
{

	Thresh = Default(Thresh, 8)
		B1 = C.NLHH
			Mt_LutXY(C, b1, " X Y - abs X Y - abs * X Y -  * X Y - abs X Y - abs * "+string(thresh)+" + / 128 +", u=1, v=1)
	
Mt_AddDiff(last, b1, u=1, v=1)
Return(last)
}

Function TNLHV(Clip c, int "thresh")
{

	Thresh = Default(Thresh, 8)
		B1 = C.NLHV
			Mt_LutXY(C, b1, " X Y - abs X Y - abs * X Y -  * X Y - abs X Y - abs * "+string(thresh)+" + / 128 +", u=1, v=1)
	
Mt_AddDiff(last, b1, u=1, v=1)
Return(last)
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