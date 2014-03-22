### Original by 06_taro: http://pastebin.com/L1SAjpYZ
### Script by ssnake & 06_taro
### Tested by 454790560
###
### This script is used in such cases:
### OP/NCOP (and of course EDs) are interlaced/cross-upconved in background, need pp,
### while credits (subtitles) need other pp method, or are progressive.
###
### It requires two clips ("input"/"nc") with same time-line, resolution, and other properties.
### You may use "OP" and "NCOP" for this two clips (in order).
### And a clip of "pp" should be given, which is filtered nc clip.
###
### If destripe moves the clip, say, by 0.5 pixel, move it back (in "pp"),
### or shift diff clip to adjust to pped clip using "diffpp" parameter.
###
### Sometimes pp may changed pixels of edges, resulting in artifacts after mt_adddiff.
### In that case, use "repair" ( indicates "mode" of repair, 0 to disable, 2 by default) to remove them.
###
### e.g. 
### OP   = AviSource("OP.avi")
### NCOP = AviSource("NCOP.avi")
### pp   = NCOP.Destripe(360, 4, 3, 3).evenly720(3, 30).Spline64Resize(NCOP.width, NCOP.height)
### NCPP(OP, NCOP, pp, "vinverse.Spline36Resize(1920, 1080, 0, -0.5)", 2)
###
 
function NCPP(clip input, clip nc, clip "pp", string "diffpp", int "repair")
{
  repair = default(repair, 2)

  ### get clean credit
  diff           = mt_makediff(input, nc, u=3, v=3)              ### "x y - 128"
  diff_Overflow  = mt_lutxy(input, nc, "x y - 127 -", u=3, v=3)  ### "x y - 128 + 255 -"
  diff_Underflow = mt_lutxy(input, nc, "y x - 128 -", u=3, v=3)  ### "0 x y - 128 + -"

  ### process diff
  diff           = Defined(diffpp) ? eval("diff."+diffpp)           : diff
  diff_Overflow  = Defined(diffpp) ? eval("diff_Overflow."+diffpp)  : diff_Overflow
  diff_Underflow = Defined(diffpp) ? eval("diff_Underflow."+diffpp) : diff_Underflow

  ### process interlaced/cross-upconved background
  pped = Defined(pp) ? pp : input
 
  ### add back credit
  adb = pped.mt_adddiff(diff, u=3, v=3).mt_lutxyz(diff_Overflow, diff_Underflow, "x y + z -", u=3, v=3)

  rep = ( repair!=0 ) ? adb.Repair(input, repair) : adb

  return rep
}
