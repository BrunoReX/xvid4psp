Function Median2(clip "input_1", clip "input_2", clip "input_3", clip "input_4", clip "input_5", string "chroma")
{# median of 5 clips from Helpers.avs by G-force

chroma = default(chroma,"process") #default is "process". Alternates: "copy first" or "copy second"

#MEDIAN(i1,i3,i5)
Interleave(input_1,input_3,input_5)
chroma == "process" ? Clense(reduceflicker=false) : Clense(reduceflicker=false,grey=true)
m1 = selectevery(3,1)

#MAX(MIN(i1,i3,i5),i2)
m2  = input_1.MT_Logic(input_3,"min",chroma=chroma).MT_Logic(input_5,"min",chroma=chroma).MT_Logic(input_2,"max",chroma=chroma)

#MIN(MAX(i1,i3,i5),i4)
m3  = input_1.MT_Logic(input_3,"max",chroma=chroma).MT_Logic(input_5,"max",chroma=chroma).MT_Logic(input_4,"min",chroma=chroma)

Interleave(m1,m2,m3)
chroma == "process" ? Clense(reduceflicker=false) : Clense(reduceflicker=false,grey=true)
selectevery(3,1)

chroma == "copy first" ? last.MergeChroma(input_1) : chroma == "copy second" ? last.MergeChroma(input_2) : last

Return(last)
}

# ========================================================================

function TMedian2(clip c) {
Median2( c.selectevery(1,-2), c.selectevery(1,-1), c, c.selectevery(1,1), c.selectevery(1,2) ) }