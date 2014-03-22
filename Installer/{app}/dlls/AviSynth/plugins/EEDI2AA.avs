function EEDI2AA(clip c) 
{
c.SeparateFields()
dbl   = EEDI2(field=-2,maxd=4)
dbl   = Merge(dbl.SelectEven,dbl.SelectOdd,0.5)
dblD  = mt_MakeDiff(c,dbl,U=3,V=3)
shrpD = mt_MakeDiff(dbl,dbl.RemoveGrain(11),U=3,V=3)
DD    = shrpD.Repair(dblD,13)

dbl.mt_AddDiff(DD,U=3,V=3)
}