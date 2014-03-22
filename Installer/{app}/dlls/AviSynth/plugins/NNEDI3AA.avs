function NNEDI3AA(clip o) {
o.NNEDI3(field=-2, qual=2)
dbl   = Merge(SelectEven(),SelectOdd())
dblD  = mt_MakeDiff(o,dbl,U=3,V=3)
shrpD = mt_MakeDiff(dbl,dbl.RemoveGrain(20),U=3,V=3)
DD    = shrpD.Repair(dblD,13)
dbl.mt_AddDiff(DD,U=3,V=3)    }

