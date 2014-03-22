FUNCTION ab16(float x)
 {
 #y = float( ( round(x / 16.0) - (x / 16.0) ) * 16.0 ) # number of lines to add / remove to make mod 16
 y = frac (x / 16.0) * 16.0 # number of lines to add / remove to make mod 16
 z = ( y < 0 ) ? 16.0 - abs(Y) : y # we only want to add borders so adjust up if negative
 z = ( z == 0 ) ? 16.0 : z # we always want to add a border to help properly process our borders
RETURN int(z)
 }