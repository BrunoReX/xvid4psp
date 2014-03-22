Function repair_ff(clip "tff", clip "bff", float "mthresh", float "thresh", bool "booldup", bool "booltff", bool "halfrate", bool "sd") 
{
###### PARAMETERS ######
global tff = tff
global bff = bff

global booltff 	= default(booltff, true)
global mmotion 	= default(mthresh, 0.3)
global squared	= default(sd, false)
global proc	= default(thresh, 0.12) + 1.0
global booldup	= default(booldup, false)

hmode = default(halfrate, false)
rate  = framerate(tff)

###### lut strings ######
global ystring = "x y - 2 ^"
global ustring = "x"
global vstring = "x"

###### VAR.. ######
global tffdiffc = 1.0
global tffdiffn = 1.0
global bffdiffc = 1.0
global bffdiffn = 1.0
global vdup	= 0

###### Conditional Function Chain, evaluated from bottom to top (!) ######
g99=scriptclip(tff, "	booltff==true ? (vdup==2 ? tff.trim(1,0) : tff) : (vdup==2 ? bff.trim(1,0) : bff)")

g2=FrameEvaluate(g99, "	booltff = fi_diff<fr_diff*proc || fi_diff<mmotion || current_frame%2==1 || vdup==1 ? booltff : (booltff==true ? false : true)
			vdup = fi_diff>fr_diff*proc && fi_diff>mmotion && current_frame%2==1 && vdup!=2 ? 1 : 
				\	(vdup==1 || (booldup==true && fi_diff>fr_diff*proc && fi_diff>mmotion && current_frame%2==0) ? 2 : 0)")

g1=FrameEvaluate(g2, "	fi_diff = squared==false ? ( booltff==true ? YDifferenceToNEXT(tff.duplicateframe(0)) : YDifferenceToNext(bff.duplicateframe(0)) ) :
				\	( booltff==true ? AverageLuma(mt_lutxy(tff.duplicateframe(0), tff, yexpr=ystring, uexpr=ustring, vexpr=vstring)) :
				\	AverageLuma(mt_lutxy(bff.duplicateframe(0), bff, yexpr=ystring, uexpr=ustring, vexpr=vstring)) )
			fr_diff = squared==false ? ( booltff==true ? LumaDifference(tff.duplicateframe(0),tff.trim(1,0)) : LumaDifference(bff.duplicateframe(0),bff.trim(1,0)) ) :
				\	( booltff==true ? AverageLuma(mt_lutxy(tff.duplicateframe(0), tff.trim(1,0), yexpr=ystring, uexpr=ustring, vexpr=vstring)) :
				\	AverageLuma(mt_lutxy(bff.duplicateframe(0), bff.trim(1,0), yexpr=ystring, uexpr=ustring, vexpr=vstring)) ) ")

recl = hmode==true ? g1.changefps(rate*0.5) : g1.changefps(rate*2).changefps(rate,linear=true)
return(recl.addborders(8,0,0,0).crop(8,0,-0,-0))			
}