Function Median1(clip input_1, clip input_2, clip input_3, string "chroma") {
# median of 3 clips from Helpers.avs by G-force
chroma = default(chroma,"process") #default is "process". Alternates: "copy first" or "copy second"
Interleave(input_1,input_2,input_3)
chroma == "process" ? Clense(reduceflicker=false) : Clense(reduceflicker=false,grey=true)
SelectEvery(3,1)
chroma == "copy first" ? last.MergeChroma(input_1) : chroma == "copy second" ? last.MergeChroma(input_2) : last
Return(last)
}

# ========================================================================

function TMedian1(clip c) {
Median1(c.selectevery(1,-1), c, c.selectevery(1,1)) }