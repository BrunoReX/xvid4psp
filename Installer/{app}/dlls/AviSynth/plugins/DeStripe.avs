function DeStripe(Clip C, int "rad", int "offset", int "thr")
{

	rad = Default(rad, 2)
	offset = Default(offset, 0)
	thr_ = Default(thr, 256)


	Blurred = Rad == 1 ? C.Mt_Convolution(Horizontal=" 1 1 1 ", vertical = " 1 ", u=1, v=1) : C
	Blurred = Rad == 2 ? offset == 0 ? C.Mt_Convolution(Horizontal=" 1 1 1 1 1 ", vertical = " 1 ", u=1, v=1) : C.Mt_Convolution(Horizontal=" 1 0 1 0 1 ", vertical = " 1 ", u=1, v=1) : Blurred
	Blurred = Rad == 3 ? offset == 0 ?  C.Mt_Convolution(Horizontal=" 1 1 1 1 1 1 1 ", vertical = " 1 ", u=1, v=1) : offset == 1 ?  C.Mt_Convolution(Horizontal=" 1 1 0 1 0 1 1 ", vertical = " 1 ", u=1, v=1) : C.Mt_Convolution(Horizontal=" 1 0 0 1 0 0 1 ", vertical = " 1 ", u=1, v=1) : Blurred
	Blurred = Rad == 4 ? offset == 0 ?  C.Mt_Convolution(Horizontal=" 1 1 1 1 1 1 1 1 1 ", vertical = " 1 ", u=1, v=1) :  offset == 1 ? C.Mt_Convolution(Horizontal=" 1 1 1 0 1 0 1 1 1 ", vertical = " 1 ", u=1, v=1) :  offset == 2 ? C.Mt_Convolution(Horizontal=" 1 1 0 0 1 0 0 1 1 ", vertical = " 1 ", u=1, v=1) : C.Mt_Convolution(Horizontal=" 1 0 0 0 1 0 0 0 1 ", vertical = " 1 ", u=1, v=1) : Blurred
	Blurred = Rad == 5 ? offset == 0 ?  C.Mt_Convolution(Horizontal=" 1 1 1 1 1 1 1 1 1 1 1 ", vertical = " 1 ", u=1, v=1) :  offset == 1 ?  C.Mt_Convolution(Horizontal=" 1 1 1 1 0 1 0 1 1 1 1 ", vertical = " 1 ", u=1, v=1) :  offset == 2 ?  C.Mt_Convolution(Horizontal=" 1 1 1 0 0 1 0 0 1 1 1 ", vertical = " 1 ", u=1, v=1) :  offset == 3 ?  C.Mt_Convolution(Horizontal=" 1 1 0 0 0 1 0 0 0 1 1 ", vertical = " 1 ", u=1, v=1) : C.Mt_Convolution(Horizontal=" 1 0 0 0 0 1 0 0 0 0 1 ", vertical = " 1 ", u=1, v=1) : Blurred
		Diff = Mt_Makediff(C, Blurred)

	THR=string(thr_)
	MedianDiff =  Rad == 1 ? MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 1 0 -1 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : Diff
	MedianDiff =  Rad == 2 ? offset == 0 ?  MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 1 0 -1 0 2 0 -2 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 2 0 -2 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : MedianDiff
	MedianDiff =  Rad == 3 ? offset == 0 ?  MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : offset == 1 ? MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 2 0 -2 0 3 0 -3 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 3 0 -3 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : MedianDiff
	MedianDiff =  Rad == 4 ? offset == 0 ?  MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : offset == 1 ?  MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : offset == 2 ?  MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 3 0 -3 0 4 0 -4 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 4 0 -4 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : MedianDiff
	MedianDiff =  Rad == 5 ? offset == 0 ?  MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 1 0 -1 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : offset == 1 ?  MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 2 0 -2 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : offset == 2 ?  MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 3 0 -3 0 4 0 -4 0 5 0 -5 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : offset == 3 ?  MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 4 0 -4 0 5 0 -5 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : MT_Luts(Diff, Diff, mode="med", pixels = " 0 0 5 0 -5 0 " ,  expr = " X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1) : MedianDiff
		ReconstructedMedian = mt_makediff(Diff, MedianDiff)
			Mt_AddDiff(Blurred, ReconstructedMedian)

Return(Mergechroma(Last, C, 1))
}
