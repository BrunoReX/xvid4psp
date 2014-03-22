function ProcessLine(clip c, int "n")
{
n = default(n,0) 
cropl = c.Crop(0,n*2,36,2)
newcropl = ScriptClip(cropl, """
black = int(AverageLuma(Crop(0,0,6,2))) #get the average luma of the left pixels
white = int(AverageLuma(Crop(30,0,6,2))) #get the average luma of the right pixels
oldwhite = white
l = 30
gamma = 1.9 - (Float(oldwhite)/Float(255))
#WriteFile("c:\output.txt", "oldwhite")
#WriteFile("c:\output.txt", "Float(oldwhite)/Float(255)")
#WriteFile("c:\output.txt", "gamma")
white = white > l ? l : white
black = black > l ? l : black
margin = (white - black)/5
Levels(black + margin, gamma, white, 0, 255, coring=false) #adjust the level to make the left real black and right real white.
""")

cropr = c.Crop(684,n*2,36,2)
newcropr = ScriptClip(cropr, """
white = int(AverageLuma(Crop(0,0,6,2))) #get the average luma of the left pixels
black = int(AverageLuma(Crop(30,0,6,2))) #get the average luma of the right pixels
l = 40
oldwhite = white
gamma = 1.9 - (Float(oldwhite)/Float(255))
white = white > l ? l : white
black = black > l ? l : black
margin = (white - black)/5
Levels(black + margin, gamma, white, 0, 255, coring=false) #adjust the level to make the left real black and right real white.
""")

newcrop = StackHorizontal(newcropl, newcropr)

return (n < 239) ? StackVertical(newcrop, ProcessLine(c, n + 1)) : newcrop


}