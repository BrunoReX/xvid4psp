function SmartFFT(clip input, int "strength") {
strength = default(strength, 10) #processing strength, 0-255

# apply rainbow remover to the entire video
derainbow = input.FFT3DFilter(plane=3, bt=1, sigma=3, sigma2=3, sigma3=strength, sigma4=3, bw=32, bh=32,ow=16,oh=16)

# create an edge mask from the rainbow video
lutexpr = "x .2 ^ 110 *"
edgemask = input.mt_edge(thY1=1, thY2=255, mode="sobel").mt_inflate().mt_lut(yexpr=lutexpr).GreyScale()

# apply ssiq only to masked area, using "strength"
result = overlay(input, derainbow, mode="blend", mask=edgemask, opacity=strength/255.0).Limiter()

return result
}


