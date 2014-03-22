function Scripted_MVDegrain5(clip clp, bool "truemotion", int "pel", int "blksize", int "overlap", int "sharp", int "thSAD", int "idx")
{

tm    = default( truemotion, true )
pel   = default( pel,           2 )
bs    = default( blksize,       8 )
ovlp  = default( overlap,       0 )
shrp  = default( sharp,         1 )
thSAD = default( thSAD,       400 )
idx   = default( idx,          11 )

bvec5 = clp.MVAnalyse(isb=true, delta=5,truemotion=tm,pel=pel,sharp=shrp,blksize=bs,overlap=ovlp,idx=idx)
bvec4 = clp.MVAnalyse(isb=true, delta=4,truemotion=tm,pel=pel,sharp=shrp,blksize=bs,overlap=ovlp,idx=idx)
bvec3 = clp.MVAnalyse(isb=true, delta=3,truemotion=tm,pel=pel,sharp=shrp,blksize=bs,overlap=ovlp,idx=idx)
bvec2 = clp.MVAnalyse(isb=true, delta=2,truemotion=tm,pel=pel,sharp=shrp,blksize=bs,overlap=ovlp,idx=idx)
bvec1 = clp.MVAnalyse(isb=true, delta=1,truemotion=tm,pel=pel,sharp=shrp,blksize=bs,overlap=ovlp,idx=idx)
fvec1 = clp.MVAnalyse(isb=false,delta=1,truemotion=tm,pel=pel,sharp=shrp,blksize=bs,overlap=ovlp,idx=idx)
fvec2 = clp.MVAnalyse(isb=false,delta=2,truemotion=tm,pel=pel,sharp=shrp,blksize=bs,overlap=ovlp,idx=idx)
fvec3 = clp.MVAnalyse(isb=false,delta=3,truemotion=tm,pel=pel,sharp=shrp,blksize=bs,overlap=ovlp,idx=idx)
fvec4 = clp.MVAnalyse(isb=false,delta=4,truemotion=tm,pel=pel,sharp=shrp,blksize=bs,overlap=ovlp,idx=idx)
fvec5 = clp.MVAnalyse(isb=false,delta=5,truemotion=tm,pel=pel,sharp=shrp,blksize=bs,overlap=ovlp,idx=idx)

mvdg3 = clp.MVDegrain3(bvec1,fvec1,bvec2,fvec2,bvec3,fvec3,thSAD=thSAD,idx=idx)
mvdg5 = mvdg3.MVDegrain2(bvec4,fvec4,bvec5,fvec5,thSAD=thSAD,idx=idx) 
 \           .Merge(mvdg3, 0.436) # correct weightings (hopefully)

return( mvdg5 )
}