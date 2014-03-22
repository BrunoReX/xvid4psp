function SmartSSIQ(clip input, int "strength")
{
strength = default(strength, 1) #processing strength, 0-255

# apply rainbow remover to the entire video
derainbow = input.SSIQ(11, 300, false)

# create an edge mask from the rainbow video
lutexpr = "x .2 ^ 110 *"
# uncomment to use masktools 1
edgemask = input.edgemask(thY1=1, thY2=255, type="sobel").inflate().yv12lut(yexpr=lutexpr).GreyScale()
#edgemask = input.mt_edge(thY1=1, thY2=255, mode="sobel").mt_inflate().mt_lut(yexpr=lutexpr).GreyScale()

# apply ssiq only to masked area, using "strength"
result = overlay(input, derainbow, mode="blend", mask=edgemask, opacity=strength/255.0).Limiter()

return result
}


