function ss_resize(clip c, int "width", int "height", int "sampler", int "ltaps" ) {
sampler = default( sampler, 4 )
ltaps = default( ltaps, 10 )
return( c.lanczosresize(width*sampler,height*sampler,taps=ltaps).lanczosresize(width,height,taps=ltaps) )
}
