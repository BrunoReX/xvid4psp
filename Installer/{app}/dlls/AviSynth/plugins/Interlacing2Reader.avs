#####################################
## Interlacing2Reader by MOmonster ##
#####################################

## Interlacing2Reader is a small helper function for interlacing detection.
## It can detect interlacing, fieldshifting, fieldorder and blending.
##
## Use import("Interlacing2Reader.avs") in your script and load the necessary filters to be able using this function
##
## required filters:
##		- TIVTC or Decomb


## parameter description:
##	start,end
##		Just the starting end ending frame for the detection. It´s good to use the detection on scenes with more motion.
##												[int  ->0,400]
##	frames
##		Set how many frames of the working range should be processed. If you want to process all frames of the given
##		range, set frames smaller zero							[int  ->-1]
##	mthresh
##		The motionthreshold gives the motionlimit for the detection. If the LumaDifference is lower than mthresh
##		the detection is not save enough and won´t be used.				[1.5...10.0  ->3.0]
##	TIVTC
##		It´s a boolean to decide if TIVTC or Decomb is used for the interlacing detection. TIVTC runs faster on my pc
##		and the results are not so different. Use Decomb if the function runs with TIVTC not stable enough on your system.
##												[bool  ->true]
##	inf,file,fontsize
##		With inf you can choose the way you want to read the informations:
##		- inf=1: information will be subtitled on the source				[ ->1]
##		- inf=2: the calculations will be written in the given file
##		- inf=0: information won´t be outputed, but you can read them 
##			 from the global values (for external programs, fastest)
##		With file you can set the logfile for output inf=2				["..." ->"C:\interlacing.log"]
##		The fontsize is used for the subtitle output inf=1				[6...48 ->16]


function Interlacing2Reader(clip clp, int "start", "end", "frames", float "mthresh", bool "TIVTC", int "inf", string "file", int "FontSize")
{
###### parameter preparation ######
begin   = isint(start) ? (start<0 ? 0 : start>framecount(clp)-3 ? framecount(clp)-3 : start) : 0
output  = default(file,"C:\interlacing.log")
global inf	= default(inf, 1)
inf		= default(inf, 1)
global TIVTC	= default(TIVTC,true)

global stop	= isint(end) ? (end<framecount(clp) ? (end>start+1 ? end : start+2) : framecount(clp)-1) : 400<framecount(clp) ? 400 : 0
global mt	= default(mthresh, 3.0)
global FontSize	= default(FontSize, 16) 

frames	= isint(frames) ? (frames<stop-begin ? frames : -1) : -1
global frate	= framerate(clp) / ((round((stop-begin)/frames * pow(10,4-int(log(abs((stop-begin-1)/frames))/2.3))) * 30 + 1) / 30.0 / pow(10,4-int(log(abs((stop-begin-1)/frames))/2.3)))

###### source preparation ######
clp	= clp.AssumeTFF()
global source	= clp.trim(begin,stop)
global cltff	= source.bob()

###### VAR.. ######
global tffcount		= 0
global bffcount		= 0
global interlaced	= 0
global progressive	= 0
global fieldshifted	= 0
global fluid_i		= 0
global countblend	= 0
global isblend		= 0

###### evaluation function ######
function sub_out()
{
usedfr		= interlaced+progressive+fieldshifted
detect		= progressive>0.95*usedfr ? 0 : interlaced<0.05*usedfr && fieldshifted>0.3*usedfr ? (round(framerate(source)*100)==2997 ? 1 : 2) :
		\ interlaced>0.4*usedfr && isblend<0.1*countblend && fluid_i>0.7*interlaced ? 3 :
		\ interlaced<0.3*usedfr && interlaced>0.1*usedfr && isblend>0.25*countblend && fieldshifted>0.2*usedfr ? 4 :
		\ interlaced>0.4*usedfr && isblend>0.2*countblend &&  fluid_i<0.5*interlaced ? 5 :
		\ fieldshifted>0.88*usedfr && interlaced<0.05*usedfr ? 6 : -1

sol_s	= detect==0 ? "progressive -> all is fine :-)" : detect==1 ? "telecining -> tfm + tdecimate or decomb" :
	\ detect==2 ? "some strange fieldshifting ???" : detect==3 ? "fine interlacing -> tdeint, leakkernel, bob..." :
	\ detect==4 ? "maybe DEFT-conversion -> unDEFT..." : detect==5 ? "blend-norm-conversion -> Mrestore, restore24..." :
	\ detect==6 ? "nice fieldshifted source  -> tfm, telecide..." : "I´m just a stupid function! Ask some people for help! (Sorry :-))"

inf<1 ? source :
\ source.Subtitle("progressive|fieldshifted|interlaced: "+string(progressive)+"|"+string(fieldshifted)+"|"+string(interlaced)+" (fluid: "+string(fluid_i)+")",size=FontSize )
	\ .Subtitle("tff|bff: "+string(tffcount)+"|"+string(bffcount)+"    blended: "+string(isblend)+"/"+string(countblend),size=FontSize,y=FontSize )
	\ .Subtitle("result:  "+sol_s,size=FontSize,y=FontSize*3 )

return last
}

###### Conditional Function Chain, evaluated from bottom to top (!) ######
inf<2 ? scriptclip(source, "sub_out()") :
	\ WriteFile(source, output, """ "interlaced:" """, "interlaced", """ " (fluid:" """ , "fluid_i",
	\ """ "),  progressive:" """, "progressive", """ ",  fieldshifted:" """, "fieldshifted", """ ",  BFF:" """,
	\ "bffcount", """ ",  TFF:" """, "tffcount", """ ", blended:" """, "isblend", """ "/" """, "countblend", append=false,flush=false)

FrameEvaluate(last, "
	tffp	= LumaDifference(cltff.selecteven(), cltff.selectodd())  
	tffc	= LumaDifference(cltff.selectodd(), cltff.selecteven().trim(1,0))
	bffp	= tffp
	bffc	= LumaDifference(cltff.selecteven(), cltff.selectodd().trim(1,0))

	count	= TIVTC==false ? 0 : tffp>mt || tffc>mt || bffp>mt || bffc>mt ? (source.IsCombedTIVTC(MI=72)==false ? 0 :
		\ tffc<bffc ? (source.doubleweave().selectodd().IsCombedTIVTC(MI=72)==false ? 1 : 2) :
		\ source.assumebff().doubleweave().selectodd().IsCombedTIVTC(MI=72)==false ? 1 : 3) : -1

	count	= TIVTC==true ? count : tffp>mt || tffc>mt || bffp>mt || bffc>mt ? (source.IsCombed(threshold=18)==false ? 0 :
		\ tffc<bffc ? (source.doubleweave().selectodd().IsCombed(threshold=18)==false ? 1 : 2) :
		\ source.assumebff().doubleweave().selectodd().IsCombed(threshold=18)==false ? 1 : 3) : -1

	global tffcount		= count<0 || (tffc+tffp)*1.25>bffc+bffp ? tffcount : tffcount+1
	global bffcount		= count<0 || (bffc+bffp)*1.25>tffc+tffp ? bffcount : bffcount+1
	global interlaced	= count<2 ? interlaced : interlaced+1
	global progressive	= count==0 ? progressive+1 : progressive
	global fieldshifted	= count==1 ? fieldshifted+1 : fieldshifted
	global fluid_i		= count==2 && tffc<1.3*tffp && tffc*1.3>tffp || count==3 && bffc<1.3*bffp && bffc*1.3>bffp ? fluid_i+1 : fluid_i
	global countblend	= count==2 && tffc>mt && tffp>mt || count==3 && bffc>mt && bffp>mt ? countblend+1 : countblend
	global isblend		= count==2 && tffc>mt && tffp>mt ? ((tffp+tffc)/YDifferenceToNext(cltff.selecteven()) < 1.2 ? isblend+1 : isblend) :
				\ count==3 && bffc>mt && bffp>mt ? ((bffp+bffc)/YDifferenceToNext(cltff.selectodd()) < 1.22 ? isblend+1 : isblend) : isblend
		")

frames<0 ? last : last.changefps(frate,linear=false)

return last
}