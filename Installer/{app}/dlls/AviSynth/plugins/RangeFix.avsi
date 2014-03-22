###################################################
###                                             ###
###               RangeFix.avsi                 ###
###                                             ###
###     By 06_taro ( astrataro@gmail.com )      ###
###                                             ###
###           v1.1 - 05 April 2011              ###
###                                             ###
###################################################
###
###
### Automatically fix pc range based on Histogram.
###
### Fix only pc range frames, with no touch on correct tv range frames.
###
### I created this function in order to save time when dealing with "hybrid" pc/tv range clips.
###
### I didn't add parameters to customize your own settings for Levels function so it only works with "standard" wrong pc range frames, because in other weird cases it is certainly not recommended to use an auto-detect function.
### 
### +-------------+
### |  CHANGELOG  |
### +-------------+
###
### v1.1 - 05 April 2011:
###      - Use ColorYUY2 instead of internal filter Levels
###
### v1.0 - 05 April 2011:
###      - First script
###
### +----------------+
### |  REQUIREMENTS  |
### +----------------+
###
### ColorYUY2_for_25.dll (2003.09.06)
###
### +-------+
### | USAGE |
### +-------+
###
### Import("RangeFix.avsi")
### RangeFix()
###
### +---------+
### | EXAMPLE |
### +---------+
###
### AviSource(xxx.avi)                                   # load a correct video
### Trim(0,100).ColorYUY2(levels="TV->PC")+Trim(100,200) # create a wrong video
### RangeFix()                                           # fix wrong pc range frames and keep correct tv range frames
###

function RangeFix(clip input){
return ScriptClip(input, """LumaDifference( histoCheck(standard=false), histoCheck(standard=true) ) < 2 ? last : ColorYUY2(levels="PC->TV")""")
}

function histoCheck(clip input, bool "standard"){

w = width(input)
h = height(input)
fn = frameratenumerator(input)
fd = frameratedenominator(input)
fc = framecount(input)

Default(standard, false)

test = input.Histogram(mode="classic")
tests = StackHorizontal(test.Crop(w, 0, 16, 0), test.Crop(w+236, 0, 20, 0))

stand = BlankClip(length=fc, width=w, height=h, pixel_type="YV12", fps=fn, fps_denominator=fd, color=$000000).Histogram(mode="classic")
stands = StackHorizontal(stand.Crop(w, 0, 16, 0), stand.Crop(w+236, 0, 20, 0))

histo = ( standard == false ) ? tests : stands

return histo
}
