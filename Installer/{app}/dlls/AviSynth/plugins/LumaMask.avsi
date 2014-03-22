##############################################################
###                                                          #
### LumaMask() (10-09-2011)                                  #
###                                                          #
##############################################################
###
### Function by Didée, adapted by Dogway:
### http://forum.doom9.org/showpost.php?p=761786&postcount=3
### http://forum.doom9.org/showthread.php?t=158954
### 
### 
### Mixes 2 versions of the source by a mask defined by luminosity (Luma Plane)
###
###
### input [default: last]
### -------------------
### Your 1st clip version
###
###
### filtered [default: filtered]
### -------------------
### Your 2nd clip version. Mandatory parameter
###
###
### black [default: 24]
### -------------------
### Limit for 100% black in your mask. [0...255]
###
###
### White [default: 48]
### -------------------
### Limit for 100% white in your mask. [0...255]
###
###
### brightfilt [default: true]
### -------------------
### Whether you want your filtered clip to be passed through the white or black part of the mask
###
###
### show [default: false]
### -------------------
### Shows the mask
###
###_______________________
###                       |
### Example:              |
###  raw=last             |
###  dfttest()            |
###  LumaMask(raw)        |
###_______________________|
###  
###   This will pass the dfttest'ed version of the clip only in the brightest part of the image,
###   starting where luma pixel value is 24 bright and smoothed up to 100% bypass where 48 bright.
###   Useful to protect dark/bright areas from certain filters.
###
###
###   FEEL FREE TO REMOVE THIS USELESS HELP  :P
##############################################################


function LumaMask(clip filtered, clip raw, int "black", int "white", bool "brightfilt", bool "show"){

LO         = string(default(black, 24))
HI         = string(default(white, 48))
brightfilt = default(brightfilt,true)
show       = default(show, false)


code     = "x "+LO+" < 255 x "+HI+" > 0 255 x "+LO+" - 255 "+HI+" "+LO+" - / * - ? ?"

darkmask = !show               ? raw.mt_lut(code,U=-128,V=-128) : nop

mrg      = !show ? (brightfilt ? mt_merge(filtered, raw, darkmask, luma=true, U=3,V=3)
 \                             : mt_merge(raw, filtered, darkmask, luma=true, U=3,V=3)) : nop

show  ? ( brightfilt ? raw.mt_lut("x "+LO+" < 0 x "+HI+" > 255 0 x "+LO+" - 255 "+LO+" "+HI+" - / * - ? ?",U=-128,V=-128) : raw.mt_lut(code,U=-128,V=-128)) : mrg}