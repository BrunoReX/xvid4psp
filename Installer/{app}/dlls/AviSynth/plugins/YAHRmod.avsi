# Y'et A'nother H'alo R'educing script by Didée
# http://forum.doom9.org/showthread.php?p=1205653#post1205653
#
function YAHR(clip clp){
  b1    = clp.MinBlur(2, 1).RemoveGrain(11, -1)
  b1D   = mt_makediff(clp, b1)
  w1    = clp.aWarpSharp2(depth=32, blur=2, thresh=128)
  w1b1  = w1.MinBlur(2, 1).RemoveGrain(11, -1)
  w1b1D = mt_makediff(w1, w1b1)
  DD    = b1D.repair(w1b1D, 13, -1) 
  DD2   = mt_makediff(b1D, DD)
  clp.mt_makediff(DD2, U=2, V=2)
}
