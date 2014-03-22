# AnimeIVTC() by thetoof
# v1.06.1 2008-10-10
# Read the documentation for all the required info to know how to use this function

function AnimeIVTC (clip i, int "mode", int "aa", int "precision", int "killcomb", bool "mt"\
		, int "decimate", float "cdeblendmthr", float "dupthr", float "mrestorebf", int "mrestoredup", int "mrestoremthr"\
		, string "iregion", string "oregion", string "postconv", string "wavaudio"\
		, bool "denoise", int "block", bool "showmetrics", float "hybriddup", float "vidthresh", int "pass" \
		, int "bob", string "edimode", int "degrain", int "omode", int "mix"\
		, int "istart1", int "iend1", int "istart2", int "iend2" \
		, int "estart1", int "eend1", int "estart2", int "eend2", int "estart3", int "eend3" \
		, int "pstart1", int "pend1", int "pstart2", int "pend2" \
		, int "overlap", int "pel", int "search", bool "nnedipel", string "denoiseri", string "denoiserp"\
		, int "check", bool "reduce", bool "horizontal" \
		, int "aastr", float "dark", int "thin", int "sharp", int "smooth", bool "stabilize", int "tradius", int "aapel", int "aaov", int "aablk", string "aatype"){

#General arguments
assert(defined(mode), "Specify a mode... please read the documentation. If you are not sure if you have pure interlaced, use any mode + check=1")
assert(mode == 1 || mode == 2 || mode == 3 || mode == 4 || mode == 5 || mode == 6 || mode == 7, "Please use mode = 1, 2, 3, 4, 5, 6 or 7")
precision 	= default ( precision, 		  3 ) 
aa 		= (mode==7 || defined(check)) ? 0 : default ( aa,	  5 )
killcomb	= default ( killcomb,		  1 )
mt		= default ( mt,		      false )

#aa=4
aastr	= default ( aastr,    255 ) # antialiasing strength
dark	= default ( dark,     0.2 ) # strokes darkening strength
thin	= default ( thin,      80 ) # Presharpening
sharp	= default ( sharp,    300 ) # Postsharpening
smooth	= default ( smooth,   100 ) # Postsmoothing
stabilize= default ( stabilize,    true ) # Use post stabilization with Motion Compensation
Tradius	= default ( Tradius,    2 ) # 2 = MVDegrain2 / 3 = MVDegrain3 /// 28 = MVDegrain28
aapel	= default ( aapel,      1 ) # accuracy of the motion estimation (Value can only be 1, 2 or 4. 1 means a precision to the pixel. 2 means a precision to half a pixel, 4 means a precision to quarter a pixel, produced by spatial interpolation (better but slower).)
aaov	= default ( aaov,       4 ) # block overlap value (horizontal). Must be even and less than block size. (Higher = more precise & slower)
aablk	= default ( aablk,      8 ) # Size of a block (horizontal). It's either 4, 8 or 16 ( default is 8 ). Larger blocks are less sensitive to noise, are faster, but also less accurate.
aatype	= default ( aatype, "Sangnom" ) # Use Sangnom() or EEDI2() for anti-aliasing

#VFR arguments
denoise		= default ( denoise,	       true )
block		= default ( block, 		 16 )
showmetrics	= default ( showmetrics,      false )
hybriddup	= default ( hybriddup, 		1.1 )
vidthresh	= default ( vidthresh, 		1.1 )
pass		= (mode==5 || mode==7) ? default ( pass, 1 ) : default ( pass, 0 )

#30i arguments
bob		= default ( bob,		  3 )
edimode		= default ( edimode, 	    "eedi2" )
degrain		= default ( degrain, 		  1 )
assert(mode==1 || mode==2 || mode==5 || mode==6 || mode==7 || defined(omode), "Please select an output framerate with omode = 1 or 2")
assert(mode==1 || mode==2 || mode==5 || mode==6 || mode==7 || defined(mix), "Please tell how to deal with the 30i sections with mix = 1 to 22")
omode= (defined(check) || mode==1 || mode==2) ? 3 : default(omode, 3)
mix=defined(check) ? 23 : default(mix, 23)
#If frame numbers are not entered... yay, that was fun to do
assert(mix != 1  || (defined(istart1) && defined(iend1) && 	defined(estart1) && defined(eend1)), 																"Please enter the frame # for istart1, iend1, estart1 and eend1")
assert(mix != 2  || (defined(istart1) && defined(iend1) && 	defined(estart1) && defined(eend1) && 	defined(istart2) && defined(iend2)), 											"Please enter the frame # for istart1, iend1, estart1, eend1, istart2 and iend2")
assert(mix != 3  || (defined(istart1) && defined(iend1) && 	defined(estart1) && defined(eend1) && 	defined(istart2) && defined(iend2) && 	defined(estart2) && defined(eend2)), 						"Please enter the frame # for istart1, iend1, estart1, eend1, istart2, iend2, estart2 and eend2")
assert(mix != 4  || (defined(estart1) && defined(eend1) && 	defined(istart1) && defined(iend1) && 	defined(estart2) && defined(eend2)), 											"Please enter the frame # for estart1, eend1, istart1, iend1, estart2 and eend2")
assert(mix != 5  || (defined(estart1) && defined(eend1) && 	defined(istart1) && defined(iend1)), 																"Please enter the frame # for estart1, eend1, istart1 and iend1")
assert(mix != 6  || (defined(estart1) && defined(eend1) && 	defined(istart1) && defined(iend1) && 	defined(estart2) && defined(eend2) && 	defined(istart2) && defined(iend2)), 						"Please enter the frame # for estart1, eend1, istart1, iend1, estart2, eend2, istart2 and iend2")
assert(mix != 7  || (defined(estart1) && defined(eend1) && 	defined(istart1) && defined(iend1) && 	defined(estart2) && defined(eend2) && 	defined(istart2) && defined(iend2) && 	defined(estart3) && defined(eend3)), 	"Please enter the frame # for estart1, eend1, istart1, iend1, estart2, eend2, istart2, iend2, estart3 and eend3")
assert(mix != 8  || (defined(pstart1) && defined(pend1) && 	defined(estart1) && defined(eend1)), 																"Please enter the frame # for pstart1, pend1, estart1 and eend1")
assert(mix != 9  || (defined(pstart1) && defined(pend1) && 	defined(estart1) && defined(eend1) && 	defined(pstart2) && defined(pend2)), 											"Please enter the frame # for pstart1, pend1, estart1, eend1, pstart2 and pend2")
assert(mix != 10 || (defined(pstart1) && defined(pend1) && 	defined(estart1) && defined(eend1) && 	defined(pstart2) && defined(pend2) && 	defined(estart2) && defined(eend2)), 						"Please enter the frame # for pstart1, pend1, estart1, eend1, pstart2, pend2, estart2 and eend2")
assert(mix != 11 || (defined(estart1) && defined(eend1) && 	defined(pstart1) && defined(pend1) && 	defined(estart2) && defined(eend2)), 											"Please enter the frame # for estart1, eend1, pstart2, pend2, estart2 and eend2")
assert(mix != 12 || (defined(estart1) && defined(eend1) && 	defined(pstart1) && defined(pend1)), 																"Please enter the frame # for estart1, eend1, pstart2 and pend2")
assert(mix != 13 || (defined(estart1) && defined(eend1) && 	defined(pstart1) && defined(pend1) && 	defined(estart2) && defined(eend2) && 	defined(pstart2) && defined(pend2)), 						"Please enter the frame # for estart1, eend1, pstart1, pend1, estart2, eend2, pstart2 and pend2")
assert(mix != 14 || (defined(estart1) && defined(eend1) && 	defined(pstart1) && defined(pend1) && 	defined(estart2) && defined(eend2) && 	defined(pstart2) && defined(pend2) && 	defined(estart3) && defined(eend3)), 	"Please enter the frame # for estart1, eend1, pstart1, pend1, estart2, eend2, pstart2, pend2, estart3 and eend3")
assert(mix != 15 || (defined(estart1) && defined(eend1) && 	defined(istart1) && defined(iend1) && 	defined(estart2) && defined(eend2) && 	defined(pstart1) && defined(pend1)), 						"Please enter the frame # for estart1, eend1, istart1, iend1, estart2, eend2, pstart1 and pend1")
assert(mix != 16 || (defined(istart1) && defined(iend1) && 	defined(estart1) && defined(eend1) && 	defined(pstart1) && defined(pend1) && 	defined(estart2) && defined(eend2)), 						"Please enter the frame # for istart1, iend1, estart1, eend1, pstart1, pend1, estart2 and eend2")
assert(mix != 17 || (defined(estart1) && defined(eend1) && 	defined(istart1) && defined(iend1) && 	defined(estart2) && defined(eend2) && 	defined(pstart1) && defined(pend1) && 	defined(estart3) && defined(eend3)), 	"Please enter the frame # for estart1, eend1, istart1, iend1, estart2, eend2, pstart1, pend1, estart3 and eend3")
assert(mix != 18 || (defined(istart1) && defined(iend1) && 	defined(estart1) && defined(eend1) && 	defined(pstart1) && defined(pend1)), 											"Please enter the frame # for istart1, iend1, estart1, eend1, pstart1 and pend1")
assert(mix != 19 || (defined(pstart1) && defined(pend1) && 	defined(estart1) && defined(eend1) && 	defined(istart1) && defined(iend1)), 											"Please enter the frame # for pstart1, pend1, estart1, eend1, istart1 and iend1")
assert(mix != 20 || (defined(estart1) && defined(eend1) && 	defined(pstart1) && defined(pend1) && 	defined(estart2) && defined(eend2) && 	defined(istart1) && defined(iend1)), 						"Please enter the frame # for estart1, eend1, pstart1, pend1, estart2, eend2, istart1 and iend1")
assert(mix != 21 || (defined(pstart1) && defined(pend1) && 	defined(estart1) && defined(eend1) && 	defined(istart1) && defined(iend1) && 	defined(estart2) && defined(eend2)), 						"Please enter the frame # for pstart1, pend1, estart1, eend1, istart1, iend1, estart2 and eend2")
assert(mix != 22 || (defined(estart1) && defined(eend1) && 	defined(pstart1) && defined(pend1) && 	defined(estart2) && defined(eend2) && 	defined(istart1) && defined(iend1) && 	defined(estart3) && defined(eend3)), 	"Please enter the frame # for estart1, eend1, pstart1, pend1, estart2, eend2, istart1, iend1, estart3 and eend3")


#Field blended/DHT
decimate	= default ( decimate, 		  4 )

#cdeblend
cdeblendmthr	= default ( cdeblendmthr,	0.3 )

#mrestore
mrestorebf	= default ( mrestorebf, 	0.6 )
mrestoredup	= default ( mrestoredup,	  0 )
mrestoremthr	= default ( mrestoremthr,	  0 )

#Norm conversion
iregion 	= default ( iregion,  	     "NTSC" )
oregion 	= default ( oregion,  	    iregion )
assert(iregion=="NTSC" || iregion=="PAL", "Invalid region, please use NTSC or PAL")
assert(oregion=="NTSC" || oregion=="PAL", "Invalid region, please use NTSC or PAL")
tnum 		= (oregion=="NTSC") ? 24000 : 25000
tden 		= (iregion=="NTSC") ? 1001 : 1000
regionconv 	= (iregion=="NTSC" && oregion=="NTSC") ? 1 : (iregion=="NTSC" && oregion=="PAL") ? 2 : (iregion=="PAL" && oregion=="PAL") ? 3 : (iregion=="PAL" && oregion=="NTSC") ? 4 : NOP()
postconv	= default ( postconv,	    "bleh" )
assert(postconv=="NTSC" || postconv=="PAL" || postconv=="bleh", "Invalid region, please use NTSC or PAL")
i = defined(wavaudio) ? audiodub(i,wavsource(wavaudio)) : i
omode = (regionconv==2 || regionconv==4) ? 1 : (mode==6) ? 2 : omode

#Framerate conversion arguments
bs		= (i.width>720) ? 16 : 8
overlap 	= default ( overlap,	       bs/2 )
pel       	= default ( pel, 		  2 )
search 		= default ( search, 		  2 )
assert(search == 2 || search == 3, "Using a lower search than 2 or 3 will most probably lead to weird artifacts")
nnedipel 	= default(nnedipel, false)


#Lil' helpers
check		= default ( check,		 11 )
reduce		= default ( reduce,	      false )
horizontal	= default ( horizontal,	      false )
errormsgs	= blankclip(pixel_type="YV12")

####################
#Field matching

#IVTC for mode 1 & 3, bob for mode 2 & 4, IVTC + stats.txt output for mode 5
ht = 	(precision==0) ? i.tfm(slow=2) : 
\	(precision==1) ? i.tfm(slow=2,clip2=i.tdeint(2)) : 
\	(precision==2) ? i.tfm(slow=2,clip2=i.tdeint(2,edeint=i.nnedi2(-2))) : 
\	(precision==3) ? i.tfm(slow=2,clip2=i.tdeint(2,edeint=i.nnedi2(-2),emask=i.tmm(1))) : 
\	errormsgs.subtitle("Please use precision = 0, 1, 2 or 3")

dhtbob = 	(precision==0) ? i.tdeint(1) : 
\		(precision==1) ? i.tdeint(1,edeint=i.nnedi2(-2)) : 
\		(precision==2) ? i.tdeint(1,edeint=i.nnedi2(-2),emask=i.tmm(1)) : 
\		(precision==3) ? i.tempgaussmc_beta1mod(mt=mt,edimode=edimode,tr2=degrain) : 
\		errormsgs.subtitle("Please use precision = 0, 1, 2 or 3")

hybridfm = 	(mode==5 && precision==0 && pass!=2) ? i.tfm(slow=2, output="tfm.txt") : 
\		(mode==5 && precision==1 && pass!=2) ? i.tfm(slow=2, output="tfm.txt",clip2=i.tdeint(2)) : 
\		(mode==5 && precision==2 && pass!=2) ? i.tfm(slow=2, output="tfm.txt",clip2=i.tdeint(2,edeint=i.nnedi2(-2))) : 
\		(mode==5 && precision==3 && pass!=2) ? i.tfm(slow=2, output="tfm.txt",clip2=i.tdeint(2,edeint=i.nnedi2(-2),emask=i.tmm(1))) : 
\		errormsgs.subtitle("Please use precision = 0, 1, 2 or 3")

matched = (mode == 1 || mode == 3 || mode == 5 || mode == 6) ? ht : (mode == 2 || mode == 4) ? dhtbob : i

####################
#CFR decimation
####################

####################
#HT decimation
htdecim = matched.tdecimate()

####################
#Decimate bobbed stream based on user settings
derrmsg = errormsgs.subtitle("Decimate=1, 2 or 3 are meant for NTSC to NTSC only")
d1 = (regionconv==1) ? matched.selectevery(5,0,2) : derrmsg
d2 = (regionconv==1) ? matched.selectevery(5,1,3) : derrmsg
d3 = (regionconv==1) ? matched.selectevery(5,2,4) : derrmsg
d4prep = defined(dupthr) ? 	matched.cdeblend(mthresh=cdeblendmthr,omode=1).dup(dupthr).requestlinear(clim=30) : 
\				matched.cdeblend(mthresh=cdeblendmthr,omode=1).requestlinear(clim=30)

d4 = 	(regionconv==1) ? d4prep.tdecimate(1,3,5) : 
\	(regionconv==2) ? d4prep.tdecimate(1,7,12) : 
\	(regionconv==3) ? d4prep.tdecimate(1,3,6) : 
\	(regionconv==4) ? d4prep.tdecimate(1,13,25) : NOP()

d5 = matched.mrestore(tnum,tden,0,mrestorebf,true,mrestoredup,mthr=mrestoremthr,dclip=i.bob().reduceflicker(strength=1),cache=20)

dhtdecim = 	(decimate==1) ? d1 : 
\		(decimate==2) ? d2 : 
\		(decimate==3) ? d3 : 
\		(decimate==4) ? d4 : 
\		(decimate==5) ? d5 : errormsgs.subtitle("Please use decimate = 0 to 5")

#Prepare clip for blind decimation comparison
compdecim = interleave(	d1.subtitle("decimate=1",align=9),
\			d2.subtitle("decimate=2",align=9),
\			d3.subtitle("decimate=3",align=9))

w = (horizontal) ? i.width*2 : i.width
h = (horizontal) ? i.height : i.height*2

#Prepare clip for smart decimation comparison
compdecim2 = (horizontal) ? 	stackhorizontal(	d4.subtitle("decimate=4",align=9),
\							d5.subtitle("decimate=5",align=9)) : 
\				stackvertical  (	d4.subtitle("decimate=4",align=9),
\							d5.subtitle("decimate=5",align=9))

#IVTCed clip
ivtced = 	(mode == 1 || mode == 3) ? 	htdecim : 
\		(mode == 2 || mode == 4) ? 	dhtdecim : 
\		(mode==6) ? 			matched : nop() #Will be done later via VFR decimation

####################
#Credits
####################

####################
#Interlaced
#Smart-bobbing
b0 = i.tdeint(1)
b1 = i.tdeint(1,edeint=i.nnedi2(-2))
b2 = i.tdeint(1,edeint=i.nnedi2(-2),emask=i.tmm(1))
b3 = i.tempgaussmc_beta1mod(mt=mt,edimode=edimode,tr2=degrain)
b4 = i.mcbobmod()
bobbed = (bob==0) ? b0 : (bob==1) ? b1 : (bob==2) ? b2 : (bob==3) ? b3 : (bob==4) ? b4 : errormsgs.subtitle("Please use bob = 0 to 4")
compbob = interleave(	b0.subtitle("bob=0",align=9),
\			b1.subtitle("bob=1",align=9),
\			b2.subtitle("bob=2",align=9),
\			b3.subtitle("bob=3",align=9),
\			b4.subtitle("bob=4",align=9))

####################
#Progressive
#Blend deinterlace the 24t background while doing minimal damage on the 30p credits
blendbg=i.daa()

####################
#Framerate conversion
#Clean detection clip for MVAnalyse, if requested
bobbed
mvdeni = defined(denoiseri) ? eval(denoiseri) : last

blendbg
mvdenp = defined(denoiserp) ? eval(denoiserp) : last

#External pelclip on source with nnedi, if requested
upsi = 	(nnedipel && pel==2) ? bobbed.nnedi2x() : 
\	(nnedipel && pel==4) ? bobbed.nnedi2x().nnedi2x() : nop()

upsp = 	(nnedipel && pel==2) ? blendbg.nnedi2x() : 
\	(nnedipel && pel==4) ? blendbg.nnedi2x().nnedi2x() : nop()

#External pelclip on prefiltered with nnedi, if requested
upprefi = 	(nnedipel && pel==2) ? mvdeni.nnedi2x() : 
\		(nnedipel && pel==4) ? mvdeni.nnedi2x().nnedi2x() : nop()

upprefp = 	(nnedipel && pel==2) ? mvdenp.nnedi2x() : 
\		(nnedipel && pel==4) ? mvdenp.nnedi2x().nnedi2x() : nop()

#Prepare idx values in case prefiltered clip is used
idxmvi=defined(denoiseri) ? 32 : 31
idxmvp=defined(denoiseri) ? 34 : 33
idxconvi=31
idxconvp=33

#Convert the framerate of the interlaced credits
mvti = (nnedipel && mt) ? 	mvdeni.MVAnalyseMulti(refframes=1, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvi, pelclip=defined(denoiseri) ? upprefi : upsi) : 
\		mt ?	mvdeni.MVAnalyseMulti(refframes=1, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvi) : nop()

bvi = (mt) ? mvti.mvmultiextract(0) : (nnedipel) ? 	mvdeni.MVAnalyse(isb = true, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvi, pelclip=defined(denoiseri) ? upprefi : upsi) : 
\							mvdeni.MVAnalyse(isb = true, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvi)

fvi = (mt) ? mvti.mvmultiextract(1) : (nnedipel) ? 	mvdeni.MVAnalyse(isb = false, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvi, pelclip=defined(denoiseri) ? upprefi : upsi) : 
\							mvdeni.MVAnalyse(isb = false, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvi)

fpsconvi = (nnedipel) ? 	bobbed.MVFlowFps(bvi, fvi, tnum, tden, idx=idxconvi, pelclip=upsi) : 
\				bobbed.MVFlowFps(bvi, fvi, tnum, tden, idx=idxconvi)

#Convert the framerate of the progressive credits
mvtp = (nnedipel && mt) ? 	mvdenp.MVAnalyseMulti(refframes=1, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvp, pelclip=defined(denoiserp) ? upprefp : upsp) : 
\		mt ?	mvdenp.MVAnalyseMulti(refframes=1, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvp) : nop()

bvp = (mt) ? mvtp.mvmultiextract(0) : (nnedipel) ? 	mvdenp.MVAnalyse(isb = true, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvp, pelclip=defined(denoiserp) ? upprefp : upsp) : 
\							mvdenp.MVAnalyse(isb = true, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvp)

fvp = (mt) ? mvtp.mvmultiextract(1) : (nnedipel) ? 	mvdenp.MVAnalyse(isb = false, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvp, pelclip=defined(denoiserp) ? upprefp : upsp) : 
\							mvdenp.MVAnalyse(isb = false, pel=pel,search=search, blksize=bs, overlap=overlap, idx=idxmvp)

fpsconvp = (nnedipel) ? 	blendbg.MVFlowFps(bvp, fvp, tnum, tden, idx=idxconvp, pelclip=upsp) : 
\				blendbg.MVFlowFps(bvp, fvp, tnum, tden, idx=idxconvp)

####################
#Splicing restored sections

#Choose how to deal with the pure interlaced sections based on the desired output framerate
credi = (omode==1) ? fpsconvi : (omode==2) ? bobbed : 	errormsgs.subtitle("Please use omode = 1 or 2")
credp = (omode==1) ? fpsconvp : (omode==2) ? blendbg : 	errormsgs.subtitle("Please use omode = 1 or 2")

#Prepare 30i sections for splicing
usec1 = (mix==1 || mix==2 || mix==3 || mix==4 || mix==5 || mix==6 || mix==7 || mix==15 || mix==16 || mix==17 || mix==18 || mix==19 || mix==20 || mix==21 || mix==22) ? true : false
usec2 = (mix==2 || mix==3 || mix==6 || mix==7) ? true : false
c1 = 	(usec1 && omode==2 && isodd(istart1)) ? 	credi.trim(istart1,iend1).selectodd() : 
\	(usec1 && omode==2 && iseven(istart1)) ? 	credi.trim(istart1,iend1).selecteven() : 
\	(usec1 && omode==1 && usec1) ? 			credi.trim(istart1,iend1) : 			nop()

c2 = 	(usec2 && omode==2 && isodd(istart2)) ? 	credi.trim(istart2,iend2).selectodd() : 
\	(usec2 && omode==2 && iseven(istart2)) ? 	credi.trim(istart2,iend2).selecteven() : 
\	(usec2 && omode==1 && usec2) ? 			credi.trim(istart2,iend2) : 		nop()

#Prepare 30p sections for splicing
usep1 = (mix==8 || mix==9 || mix==10 || mix==11 || mix==12 || mix==13 || mix==14 || mix==15 || mix==16 || mix==17 || mix==18 || mix==19 || mix==20 || mix==21 || mix==22) ? true : false
usep2 = (mix==9 || mix==10 || mix==13 || mix==14) ? true : false
p1 = (usep1) ? credp.trim(pstart1,pend1) : nop()
p2 = (usep2) ? credp.trim(pstart2,pend2) : nop()

maxfps = (usec1) ? c1.framerate : (usep1) ? p1.framerate : nop()

#Prepare the IVTCed clip for splicing with the deinterlaced 30i
usee1 = (mix != 23) ? true : false
usee2 = (mix==3 || mix==4 || mix==6 || mix==7 || mix==10 || mix==11 || mix==13 || mix==14 || mix==15 || mix==16 || mix==17 || mix==20 || mix==21 || mix==22) ? true : false
usee3 = (mix==7 || mix==14 || mix==17 || mix==22) ? true : false
e1 = 	(usee1 && omode==2) ? ivtced.trim(estart1,eend1).changefps(maxfps) : 
\	(usee1 && omode==1) ? ivtced.trim(estart1,eend1) : 			nop()

e2 = 	(usee2 && omode==2) ? ivtced.trim(estart2,eend2).changefps(maxfps) : 
\	(usee2 && omode==1) ? ivtced.trim(estart2,eend2) : 			nop()

e3 =	(usee3 && omode==2) ? ivtced.trim(estart3,eend3).changefps(maxfps) : 
\	(usee3 && omode==1) ? ivtced.trim(estart3,eend3) : 			nop()

#Splice
spliced=(mix==1) ? 	c1 + 	e1 : \
	(mix==2) ? 	c1 + 	e1 + 	c2 : \
	(mix==3) ? 	c1 + 	e1 + 	c2 + 	e2 : \ 
	(mix==4) ? 	e1 + 	c1 + 	e2 : \
	(mix==5) ? 	e1 + 	c1 : \ 
	(mix==6) ? 	e1 + 	c1 + 	e2 + 	c2 : \
	(mix==7) ? 	e1 + 	c1 + 	e2 + 	c2 + 	e3 : \
	(mix==8) ? 	p1 + 	e1 : \
	(mix==9) ? 	p1 + 	e1 + 	p2 : \
	(mix==10) ? 	p1 + 	e1 + 	p2 + 	e2 : \ 
	(mix==11) ? 	e1 + 	p1 + 	e2 : \
	(mix==12) ? 	e1 + 	p1 : \ 
	(mix==13) ? 	e1 + 	p1 + 	e2 + 	p2 : \
	(mix==14) ? 	e1 + 	p1 + 	e2 + 	p2 + 	e3 : \
	(mix==15) ? 	e1 + 	c1 + 	e2 + 	p1 : \
	(mix==16) ? 	c1 + 	e1 + 	p1 + 	e2 : \
	(mix==17) ?	e1 + 	c1 + 	e2 + 	p1 +	e3 : \
	(mix==18) ? 	c1 + 	e1 + 	p1 : \
	(mix==19) ? 	p1 + 	e1 + 	c1 : \ 
	(mix==20) ? 	e1 + 	p1 + 	e2 + 	c1 : \
	(mix==21) ? 	p1 + 	e1 + 	c1 + 	e2 : \
	(mix==22) ? 	e1 + 	p1 + 	e2 + 	c1 +	e3 : \
	NOP()

####################
#Final clip at the desired CFR with framerate post-conversion, if requested

restored = (mode==1 || mode==2) ? ivtced : (omode==1) ? spliced : errormsgs.subtitle("You need a CFR clip to do a region conversion")
ajustfps = 	(regionconv==2) ? restored.changefps(25) : 
\		(regionconv==4) ? restored.changefps(24000,1001) : restored
converted = 	(postconv=="NTSC") ? restored.assumefps(24000,1001,true) : 
\		(postconv=="PAL") ?  restored.assumefps(25	  ,true) : NOP()
finalcfr = (postconv=="bleh") ? ajustfps : converted

####################
#Kill combing
toprocess = (mode==1 || mode==2 || omode==1) ? finalcfr : (mode==5) ? matched : (omode==2) ? spliced : i
dec0=(check!=11 && check!=5) ? errormsgs : toprocess
dec1=(check!=11 && check!=5) ? errormsgs : toprocess.vinverse()
dec2=(check!=11 && check!=5) ? errormsgs : toprocess.vinverseD()
dec = 	(killcomb==0) ? dec0 : 
\	(killcomb==1) ? dec1 : 
\	(killcomb==2) ? dec2 : 
\	errormsgs.subtitle("Please use killcomb = 0, 1 or 2")

#Prepare clip for killcomb comparison
compdec = interleave(	dec0.subtitle("killcomb=0",align=9),
\			dec1.subtitle("killcomb=1",align=9),
\			dec2.subtitle("killcomb=2",align=9))

####################
#Anti-aliasing

aa0=dec
aa1=dec.ediaa()
aa2=dec.daa()
aa3=dec.maa()
aa4=dec.sharpaamcmod(aastr=aastr, ds=dark, shpre=thin, shpost=sharp, smpost=smooth, tradius=tradius, mt=mt, MC=stabilize, pel=aapel, ov=aaov, blk=aablk, aatype=aatype)

#Prepare clip for aa comparison
compaa = interleave(	aa0.subtitle("aa=0",align=9),
\			aa1.subtitle("aa=1",align=9),
\			aa2.subtitle("aa=2",align=9),
\			aa3.subtitle("aa=3",align=9),
\			aa4.subtitle("aa=4\n"+"\n"+"Tweak aastr, dark, thin, sharp and smooth for better results.\n"+"Other more advanced options are also available.",lsp=1,align=9))

#Apply the desired aa method or output aa comparison
aaed = (aa==0) ? aa0 : (aa==1) ? aa1 : (aa==2) ? aa2 : (aa==3) ? aa3 : (aa==4) ? aa4 : compaa.subtitle("You are now comparing the anti-aliasing modes. \n"+"Please choose the one that looks better with your source.",lsp=1)

####################
#Final clip with VFR decimation

hybrid = 	(mode == 5 && pass == 1) ? hybridfm.TDecimate(4, output="stats.txt",denoise=denoise, blockx=block, blocky=block,display=showmetrics) : 
\		(mode == 5 && pass == 2) ? aaed.TDecimate(5,hybrid=2,dupThresh=hybriddup,vidThresh=vidthresh, blockx=block, blocky=block,tfmin="tfm.txt",input="stats.txt",mkvout="timecodes.txt",batch=true) : nop()
tovfr = (mode==7) ? i : aaed
others= ((mode==7 || omode==2) && pass==1) ? tovfr.TDecimate(4, output="stats.txt",denoise=true, blockx=block, blocky=block,display=showmetrics) : 
\	((mode==7 || omode==2) && pass==2) ? tovfr.TDecimate(5,hybrid=2,dupThresh=hybriddup,vidThresh=vidthresh,vidDetect=1, blockx=block, blocky=block,input="stats.txt",mkvout="timecodes.txt") : nop()

output = (mode==1 || mode==2 || omode==1) ? aaed : (mode==5) ? hybrid : (mode==7 || omode==2) ? others : nop()

#Useful tools for checking various things
chkint = i.nnedi2(-2).subtitle("The framerate has changed to 59.94. \n"+"If you are checking for pure interlaced sections, have fun! :p\n"+"If you are using omode=2, take the frame # where the section(s) with \n"+"pure intelaced material start and end from this clip. \n"+"If you are using omode=1, note the time and use it to find the correct frame # with check=3.",lsp=1)
chkp = 	blendbg.subtitle("Here you can get the frame # where the progressive credits sections start and end for omode=2. \n"+"For omode=1, use check=10",lsp=1)
chkep = 	( mode == 3 || mode == 4 || mode == 6) ? 		ivtced.		subtitle("The framerate has changed to 23.976. \n"+"Note the frame # where the section(s) that are not truly interlaced start and end.",lsp=1) : errormsgs.subtitle("Check=2 is meant for mode = 3, 4 or 6")
chkbob = 	( mode == 2 || mode == 4) ? 		compbob.	subtitle("You are now comparing the bobbed clips without any additionnal post-processing") : errormsgs.subtitle("This is meant to compare the different bobbing methods with mode=2 or 4")
chkconvi = 	((mode == 3 || mode == 4)) ? 		fpsconvi.	subtitle("The framerate has changed to 23.976. \n"+"Yeah, this is slow as hell... \n"+"Try getting the time with check=1 or 2 \n"+"and then come back to check=3 to find the exact frame #.",lsp=1) : errormsgs.subtitle("Using check=3 with anything else than mode=3 or 4 and omode=1 makes no sense")
chkconvp = 	((mode == 3 || mode == 4)) ? 		fpsconvp.	subtitle("The framerate has changed to 23.976. \n"+"Yeah, this is slow as hell... \n"+"Try getting the time with check=0 \n"+"and then come back to check=10 to find the exact frame #.",lsp=1) : errormsgs.subtitle("Using check=10 with anything else than mode=3 or 4 and omode=1 makes no sense")
chkdecim = 	( mode == 2 || mode == 4) ? 		compdecim.	subtitle("You are now comparing the blind decimation methods. \n"+"If there are blends, don't use it!\n"+"Hint: check various high motion scenes (movement on every frame) throughout the clip",lsp=1) : errormsgs.subtitle("Check=6 is meant for mode = 2 or 4")
chkdecim2 = 	( mode == 2 || mode == 4 && reduce) ? 	compdecim2.subtitle("You are now comparing decimate=4 and 5. \n"+"There shouldn't be any blends, but check out for jerks (possible with 5)\n"+"Hint: check various high motion scenes throughout the clip",lsp=1).spline36resize(w/2,h/2) : (mode == 2 || mode == 4) ? compdecim2.subtitle("You are now comparing decimate=4 and 5. \n"+"There shouldn't be any blends, but check out for jerks (possible with 5)\n"+"Hint: check various high motion scenes throughout the clip",lsp=1) : errormsgs.subtitle("Check=7 meant for mode = 2 or 4")
chkdclipi = 	( mode == 3 || mode == 4 || mode == 6) ? 		mvdeni.		subtitle("Here you can see the effets of your denoiser \n"+"on the clip on which the motion vectors will be calculated for 30i sections",lsp=1) : errormsgs.subtitle("Check=8 is only intended for mode=3 or 4 with omode=1")
chkdclipp = 	( mode == 3 || mode == 4 || mode == 6) ? 		mvdenp.		subtitle("Here you can see the effets of your denoiser \n"+"on the clip on which the motion vectors will be calculated for 30p sections",lsp=1) : errormsgs.subtitle("Check=9 is only intended for mode=3 or 4 with omode=1")
chkcomb = compdec.subtitle("You are now comparing the 3 killcomb modes")

return (aa==5) ? aaed : (check==0) ? chkp : (check==1) ? chkint : (check==2) ? chkep : (check==3) ? chkconvi : (check==4) ? chkbob : (check==5) ? chkcomb : (check==6) ? chkdecim : (check==7) ? chkdecim2 : (check==8) ? chkdclipi : (check==9) ? chkdclipp : (check==10) ? chkconvp : (mode!=1 && mode!=2 && mode!=5 && mode!=7 && omode!=1 && pass==0) ? aaed : output
}

function iseven(n) {return isint(n/2)}

function isodd(n) {return isint(n/2) ? false : true}

function nnedi2x(clip a) {return a.nnedi2(1,true).turnright().nnedi2(1,true).turnleft()}

#Suggested by Mystery Keeper in "Denoise of tv-anime" thread
function ediaa(clip a) {return a.EEDI2(field=1).TurnRight().EEDI2(field=1).TurnLeft().spline36resize(a.width,a.height,-0.5,-0.5,2*a.width+.001,2*a.height+.001)}

#Anti-aliasing with contra-sharpening by Didée, modded by Terranigma for nnedi and by thetoof for merge
function daa(clip c) {
dbl   = merge(c.nnedi2(1),c.nnedi2(0))
dblD = mt_makediff(c,dbl,U=3,V=3)
shrpD = mt_makediff(dbl,dbl.removegrain(11),U=3,V=3)
DD = shrpD.repair(dblD,13)
return dbl.mt_adddiff(DD,U=3,V=3) }

#Anti-aliasing with edge masking by martino, mask using "sobel" taken from Kintaro's useless filterscripts and modded by thetoof for spline36
function maa(clip input, int "mask") {
mask = input.mt_edge("sobel",7,7,5,5).mt_inflate()
aa_clip=input.spline36Resize(width(input)*2,height(input)*2).TurnLeft().SangNom().TurnRight().SangNom().spline36Resize(width(input),height(input)).MergeChroma(input) 
return mt_merge(input,aa_clip,mask) }

#Developped in the "fine anime antialiasing thread"
function SharpAAMCmod(clip orig, int "aastr", float "ds", int "ShPre", int "ShPost", int "SmPost", bool "MC", bool "MT", int "tradius", int "pel", int "ov", int "blk", string "aatype")
{
aastr	= default ( aastr,  255 ) # antialiasing strength
ds	= default ( ds,     0.2 ) # strokes darkening strength
ShPre	= default ( ShPre,   80 ) # Presharpening
ShPost	= default ( ShPost, 300 ) # Postsharpening
SmPost	= default ( SmPost, 100 ) # Postsmoothing
MC	= default ( MC,    true ) # Use post stabilization with Motion Compensation
MT	= default ( MT,    true ) # Use josey_wells' branch of MVTools
Tradius	= default ( Tradius,  2 ) # 2 = MVDegrain2 / 3 = MVDegrain3 /// 28 = MVDegrain 28
assert(mt || tradius<4, "You must use MT=true with josey_wells' branch of MVTools to use a higher tradius than 3")
pel	= default ( pel,      1 ) # accuracy of the motion estimation (Value can only be 1, 2 or 4. 1 means a precision to the pixel. 2 means a precision to half a pixel, 4 means a precision to quarter a pixel, produced by spatial interpolation (better but slower).)
ov	= default ( ov,       4 ) # block overlap value (horizontal). Must be even and less than block size. (Higher = more precise & slower)
blk	= default ( blk,      8 ) # Size of a block (horizontal). It's either 4, 8 or 16 ( default is 8 ). Larger blocks are less sensitive to noise, are faster, but also less accurate.
aatype	= default ( aatype,   "Sangnom" ) # Use Sangnom() or EEDI2() for anti-aliasing

w=width(orig)
h=height(orig)
m=logic( orig.DEdgeMask(0,255,0,255,"5 10 5 0 0 0 -5 -10 -5", divisor=4,Y=3,U=3,V=3)
 \       ,orig.DEdgeMask(0,255,0,255,"5 0 -5 10 0 -10 5 0 -5", divisor=4,Y=3,U=3,V=3)
 \       ,"max").greyscale().levels(0,0.8,128,0,255,false)
preaa=(ShPre==0 && ds==0) ? orig : (ShPre==0) ? orig.Toon(ds) : (ds==0) ? orig.Warpsharp(depth=ShPre) : orig.Toon(ds).Warpsharp(depth=ShPre)
aa= (aatype=="Sangnom") ? preaa.spline36resize(w*2,h*2).TurnLeft().SangNom(aa=aastr).TurnRight().SangNom(aa=aastr).spline36resize(w,h) : (aatype=="EEDI2") ? preaa.ediaa() : blankclip(pixel_type="YV12").subtitle("Please use Sangnom or EEDI2 for aatype")
postsh=(ShPost==0 && SmPost==0) ? aa : aa.LimitedSharpenFaster(edgemode=1,strength=ShPost,overshoot=1,soft=SmPost)
merged=mt_merge(orig,postsh,m,Y=3,U=3,V=3)

sD=mt_makediff(orig,merged)

fv3 = orig.MVAnalyse(isb=false,delta=3,pel=pel,overlap=ov,blksize=blk,idx=21)
fv2 = orig.MVAnalyse(isb=false,delta=2,pel=pel,overlap=ov,blksize=blk,idx=21)
fv1 = orig.MVAnalyse(isb=false,delta=1,pel=pel,overlap=ov,blksize=blk,idx=21)
bv1 = orig.MVAnalyse(isb=true, delta=1,pel=pel,overlap=ov,blksize=blk,idx=21)
bv2 = orig.MVAnalyse(isb=true, delta=2,pel=pel,overlap=ov,blksize=blk,idx=21)
bv3 = orig.MVAnalyse(isb=true, delta=3,pel=pel,overlap=ov,blksize=blk,idx=21)
allv = mt ? orig.MVAnalyseMulti(refframes=tradius,pel=pel,overlap=ov,blksize=blk,idx=21) : nop()
fiz = (tradius==1) ? sD.MVDegrain1(bv1,fv1,idx=22) : (tradius==2) ? sD.MVDegrain2(bv1,fv1,bv2,fv2,idx=22) : (tradius==3) ? sD.MVDegrain3(bv1,fv1,bv2,fv2,bv3,fv3,idx=22) : blankclip(pixel_type="yv12").subtitle("You must use MT=true with josey_wells' branch of MVTools to use a higher tradius than 3")
sDD = (MT) ? sD.MVDegrainMulti(allv,idx=22) : fiz

reduc = 0.4
sDD = mt_lutxy(sD,sDD,"x 128 - abs y 128 - abs < x y ?").mergeluma(sDD,1.0-reduc)

return MC ? orig.mt_makediff(sDD,U=2,V=2) : merged
}