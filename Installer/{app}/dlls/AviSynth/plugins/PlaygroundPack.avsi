###                                                  #
###                                                  #
### Image Manipulation Playground Pack               #
###             By Dogway  (10-09-2011)              #
###                                                  #
###                                                  #
######################################################
####
#### BitDepth
####
#### function by cretindesalpes (http://forum.doom9.org/showthread.php?p=1516096#post1516096)
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


####
#### Scanlines
####
#### function by Didée  (http://forum.doom9.org/showthread.php?p=1432971#post1432971)
#### wrapped by Dogway 10-09-2011
####
####
#### Adds scanlines to your source in yuv space (tv range).
####
#### You will need the Dither package and Masktools2
####
#### Masktools2: http://forum.doom9.org/showthread.php?t=98985
#### Dither:     http://forum.doom9.org/showthread.php?p=1386559#post1386559
####
######################################## 

function Scanlines(clip c, int "Str", int "Rate", int "mode"){

strength = default(str, 100) # Strength of the scanline 0 - 255
scanrate = default(rate, 2)  # Define here every how many pixels you want a scanline
mode     = default(mode, 0)  # Valid modes: 0 - 8. Read Dither documentation for details

c
mt_lutxy(mt_lutspa(relative=false,expr="y "+string(scanrate)+" % 0.01 < "+string(strength)+" 235 ?"),"x 16 - y 16 - * 219 / 16 +",U=2,V=2)

Dither_convert_8_to_16()
Dither_merge16_8(c.Dither_convert_8_to_16(),c.greyscale)
ditherpost(mode=mode)}