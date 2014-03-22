######
## LimitEdge Smooth Degrain lite v0.71
## LSD for short
## Original idea came from HQdering and how it used an edgemask to limit the smoothing, 
## I was looking through Tritical's filters and I saw Tcanny and I knew it would have some practical usage, and so I created this.
## Its a multilayered edgemask limited Degrainer/Smoother/Denoiser, that helps to improve compression without damaging details
## Its extremely accurate because of the limiting and how sensitive it is, it is even chroma sensitive so it will not oversmooth lightly shaded areas that lack hard edges
## Its a canny edge detection so anything that messes with edges or lines or even noise (I said it was sensitive) should probably be done after using this filter
## It is very specific in the way it works, it creates a multilevel mask that uses chroma as a meter of how much to smooth, higher chroma means less smoothing
##  LSDlite is a moderately stronger version of LSDverylite or LSDvlite for short, LSDvlite will basically cause absolutely zero damage to your source
##  LSDlite might cause extremely minor blurring of some soft details but at a relatively nice increase in compression and at zero speed cost
##  
## Requirements (all of which will be provided at a this link here http://www.mediafire.com/?ue0l85quzolhgqb )
## RemoveGrain.dll 
## tcanny.dll
## LSFmod.v1.9.avsi
## Tbilateral.dll       
## Daa3.avsi
## masktools
## 
## Usage Notes
## the filter itself really has no hard "parameters" because one of the things I kept from the conversion from HQdering is that the script has no set method of smoothing
## I have found that Tbilateral fits extremely well into what I wanted this to do, and I have configured it to work well with this filter, 
## lite and vlite are just different tbilateral settings with the same internals, currently I do not know how to store presets or else I would have them all as 1 filter
## The only thing this shares in common with HQdering is the input system and the maskmerging
## You can actually use any filter you want (within reason, also if you tell a filter to give you a mask as the output as far as I know it will not work) 
## If you desire to change what smoother is used then just put Smoother="filtername" and then fill in the parameters
##  with params="what ever they should be"  
## only issue is if there are quotes already in there then you need to use Chr(34) like this params=Chr(34)+"w2d"+Chr(34)+", 2, 15, 15, 20"
## 
## Credits
## Thank you Torque,Telepathic,Light,Sashamaru,Evil,Wes and Ondeed
## Thank you Tritical for making such awesome filters that made this possible such as Tbilateral and Tcanny
## Thank you Mf for making the filter HQdering
## Thank you Didée for fixing the filter that Mf made so it works in yv12 and for making limitedsharpenfaster and Daa
## Thank you LaTo for making LSFmod
## Thank you Terranigma and thetoof for Daa3
## Thank you Kassandro for making removegrain
## Thank you Jesus for coming back on Sunday and then watering my lawn
##
####

function LSDlite(clip input, string "smoother", string "params") {

  smoother = Default(smoother, "tbilateral")	# filter that smooths
#params   = default defined below	# filter parameters - use Chr(34) for quotes

defaultnull = Default(params, "")
defaulttbilateral = Default(params, "diameterL=3,DiameterC=3,sDevL=0.9,sDevC=0.9,iDevL=5,iDevC=5,csL=1,csC=1,d2=true,chroma=true,gui=false,KernI=4,KernS=3,resType=2")

params = (smoother=="tbilateral") ? defaulttbilateral : defaultnull

try {
smoothedwparams = Eval(smoother + "(input, " + params + ")")
}
catch(err_msg) {
smoothedwoparams = Eval(smoother + "(input)")
}

smoothed = (params=="") ? smoothedwoparams : smoothedwparams

input.tcanny(sigma=1.5,mode=1,t_l=1.5).blur(1).tcanny(sigma=1,mode=1,t_l=2.5)
normalmask = last

normalmask.lsfmod(defaults="slow",edgemode=0).tcanny(sigma=1.5,mode=0)Levels(0, 3.3, 90, 0, 255).blur(0.5)
amplifiedmask = last

normalmask.tcanny(sigma=0.3,mode=1,t_l=1,plane=3).Levels(0, 3.3, 90, 0, 255).removegrain(2).Levels(0, 3.3, 255, 0, 255).daa3
thickmask = last

Overlay(amplifiedmask.Invert(), thickmask, mode="multiply").greyscale


ringingmask = last

mt_merge(input, smoothed, ringingmask)

}