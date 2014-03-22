function EEDI2(clip c) 
{
c.AssumeTFF().SeparateFields()
dbl   = mt_Average( SelectEven().EEDI2(field=1,maxd=4),
 \                  SelectOdd() .EEDI2(field=0,maxd=4), U=3,V=3 )
dblD  = mt_MakeDiff(c,dbl,U=3,V=3)
shrpD = mt_MakeDiff(dbl,dbl.RemoveGrain(11),U=3,V=3)
DD    = shrpD.Repair(dblD,13)

dbl.mt_AddDiff(DD,U=3,V=3)
}