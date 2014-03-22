####
#### BitDepth
####
#### function by cretindesalpes
#### wrapped by Dogway 30-08-2011
####
####
#### Changes/reduces bitdepth of your clip. I don't see a real use of this, but it's funny nonetheless.
####
#### You will need the Dither package and Masktools2
####
#### Masktools2: http://forum.doom9.org/showthread.php?t=98985
#### Dither:     http://forum.doom9.org/showthread.php?p=1386559#post1386559
####
######################################## 

function BitDepth (clip c, int "bits", int "mode"){

bits = default(bits, 2)    # Valid range: 0 - 8
mode = default(mode, 0)    # Valid modes: 0 - 8. Read Dither documentation for details
mul = String (Pow (2, 8 - bits))
c
Dither_convert_8_to_16()
Dither_lut16 (expr="x "+mul+" /")
DitherPost (mode=mode)
mt_lut ("x "+mul+" *", y=3, u=2, v=2)}