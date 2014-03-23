Function EDImod(clip input)
{# function by g-force v.1.00
#connects more lines than NNEDI2, without the blur bubbles and loss of detail of EEDI2

nn=input.NNEDI2(dh=true,field=1)
ee=input.EEDI2()

Interleave(ee,ee.RemoveGrain(12,-1),ee.RemoveGrain(4,-1))
Clense(input, grey=true)
SelectEvery(3,1)

MT_MakeDiff(last,last.RemoveGrain(12,-1))
last.Repair(MT_MakeDiff(nn,ee),-1).MT_LUTxy(last,"x 128 - abs y 128 - abs < x y ?")

ee.MT_AddDiff(last,chroma="copy first")

last.Repair(nn,9)

Return(last)
}
