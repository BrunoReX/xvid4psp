#	--SimpleSlugUpscale v1.12--
#
#		For AviSynth 2.5.x (Tested in standard 2.5.6, 2.5.7, and 2.5.8, along with SEt's build of 2.5.8 MT)
#
#		Scales a clip from one size to another, cropping as necessary or padding by automatic letter, pillar,
#		or window boxing, all while accounting for pixel and display aspect ratios. Presets cover common frame
#		sizes, but custom values are also allowed for almost everything.		
#
#		If you're impressed with the quality of the output, you have Didée and -Vit- of the Doom9 forums to thank
#		for creating TempGaussMC and QTGMC, respectively, along with the authors of the plugins upon which those two
#		were built.
#
#		Unfortunately, although this script was designed to make SD<->HD conversions somewhat less intimidating
#		with regard to deinterlacing, cropping, and scaling, it does not currently address the subjects of
#		framerate or colorspace conversion; between my lack of knowledge in those areas and the sheer variety
#		of possible input/output combinations, I don't feel comfortable trying to deal with them here. I recommend
#		you research the material yourself and apply whatever conversions suit your needs.
#
#		Questions and comments welcome, either by email at robert.martens@gmail.com or on Twitter @ItEndsWithTens
#
#
#	--Requirements--
#
#		Progressive input:
#
#			None
#
#		Interlaced input:
#		
#			QTGMC (by default; other deinterlacers are also supported)
#				All presets
#					MaskTools v2
#					MVTools 2
#					RemoveGrain & Repair 1.0 prerelease
#					VerticalCleaner
#				Slower through Super Fast
#					NNEDI3
#				Ultra Fast
#					TDeint
#					Yadif
#				Very Slow and Placebo
#					FFT3DFilter + FFTW3
#				Placebo
#					AddGrainC
#
#		You can hunt all of these down yourself, or just grab them from http://www.gyroshot.com/simpleslug.htm
#		For installation help, see page 2 of my upscaling tutorial: http://www.gyroshot.com/upscale2.htm
#
#
#	--Basic Use--
#
#		This script has a variety of more complex features, but you only need to do three things to get started:
#
#		1.)	If your input is progressive, set prog=true.
#
#		2.)	If your input is widescreen DV (NTSC or PAL), or 1440x1080 HD with a DAR of 16:9 (this includes the
#			HDV2 and HDCAM formats), set widein=true.
#
#		3.)	Choose a name from this list of output presets, and assign it to 'size':
#
#				name		dimensions				PAR	interlaced?
#
#				deint		same as input				same	no
#				square		square pixel equivalent of input	1:1	no
#				480sq		640x480					1:1	no
#				360sq		640x360					1:1	no
#				DVfullpNTSC	720x480					10:11	no
#				DVfulliNTSC	720x480					10:11	bottom field first
#				DVfullpPAL	720x576					12:11	no
#				DVfulliPAL	720x576					12:11	bottom field first
#				DVwidepNTSC	720x480					40:33	no
#				DVwideiNTSC	720x480					40:33	bottom field first
#				DVwidepPAL	720x576					16:11	no
#				DVwideiPAL	720x576					16:11	bottom field first
#				720p		1280x720				1:1	no
#				1080pana	1440x1080				4:3	no
#				1080iana	1440x1080				4:3	top field first
#				1080psq		1920x1080				1:1	no
#				1080isq		1920x1080				1:1	top field first
#
#			Adding "box" to any of those names will trigger auto letter/pillarboxing, while "window" will
#			use windowboxing. The box will be a solid color unless you instead use "bg" in the name, which
#			will use a blurry version of the input clip instead.
#
#		To demonstrate, assuming you have progressive, anamorphic input, and you want square pixel 1080p output
#		that's padded with a Gaussian blurred copy of the input, your call to SimpleSlug would look like this:
#
#			SimpleSlugUpscale(prog=true,widein=true,size="1080psqbg")
#
#		That should be enough to get you going, but I encourage you to take some time to read the Advanced Use
#		section. You might find something useful.
#
#
#	--Advanced Use--
#
#		Now that you're familiar with the basics, we can get into a full description of the script's parameters:
#
#	prog		bool, default false
#
#		Lets you process progressive footage, bypassing the deinterlacing procedure.
#
#	widein		bool, default false
#
#		Allows anamorphic widescreen input; only covers DV NTSC wide (40:33 PAR), DV PAL wide (16:11 PAR), and
#		anamorphic 1080 HD (4:3 PAR). For other anamorphic input, leave this set to false and specify either a
#		custom pixel aspect with PARin, or a custom display aspect with DARin.
#
#	PARin		float
#
#		Overrides preset pixel aspect ratio setting (DARin overrides the input display aspect). Enter the value as
#		either a float or a rational (e.g. 1.333333 or 4.0/3.0). Has priority over DARin if both are defined.
#
#	drate		bool, default false
#
#		For progressive output from interlaced input, this gives 60p for NTSC, 50p for PAL. No effect on interlaced
#		output, or when same-rate deinterlacers are used in 'qual'. Mutually exclusive with 'shtrhack'.
#
#	shtrhack	val, true, false or "QTGMCdefault", default false
#
#		Simulates the effect of "blend" deinterlacing. Using that technique, the contents of two fields are blended
#		together to form a new output frame. By doing this, the motion blur of the footage is altered in a way that
#		some people find desirable. An NTSC clip, for example, shot at 60 fields per second with a 1/60th shutter,
#		turns into a 30 frame per second clip with what appears to be a 1/30th shutter.
#
#		The alternative to this blending is to merely select every other frame of the bobbed video, and that's what
#		I do when 'shtrhack' is set to false. When it's true, I merge each pair of frames together, starting with 0
#		and 1. When using "QTGMCdefault", I employ the motion blur features added to QTGMC in version 3.05, but only
#		at their default settings. If you need greater control over those options, use a custom 'qual' string to
#		dictate your desires. Full details of said options are available in the	QTGMC documentation.
#
#		'shtrhack' has no effect on interlaced output, or if 'prog' is true; although it's conceivable that some
#		would want to use QTGMC's motion blur capabilities for such cases, it's decidedly advanced functionality to
#		include in a script like mine, aimed at simplifying the use of these tools. Should you nonetheless feel the
#		need to	pursue that line of action, just set prog=false and use a custom 'qual' string, as detailed below.
#
#	hshift, vshift	int, default 0
#
#		With some combinations of output settings, input video will be cropped as necessary to fit the shape of the
#		output frame. These two parameters let you reframe your video, if for example a subject's head has been cut
#		off by the default position of the crop area.
#
#		Please note that these act as offsets for said crop area, and are relative to 0. Use negative numbers to
#		shift the video down and to the right, positive numbers to bring it up and left. The values are clamped to
#		the maximum for a given clip, so beyond a certain point larger numbers won't shift the video any further.
#
#		hshift will be left alone for RGB clips, made mod 2 for YUY2, and mod 4 for YV12, while vshift will be left
#		alone for RGB and YUY2, but made mod 2 for YV12.
#
#	boxcolor	int, default color_black
#
#		Determines color of letter/pillar/windowbox bars. See your AviSynth plugins directory for colors_rgb.avsi,
#		which lists a series of global variables that correspond to commonly used colors. If you want a color not
#		defined there, see the "Colors" section of the AviSynth documentation for more info on defining RGB values.
#
#	boxbgblur	float, 1.0 through 100.0, default 1.0
#
#		For "bg" size options, sets blur for background video. Blur is achieved by GaussResize, this value sets 'p',
#		so lower numbers blur more.
#
#	qual		string, choose from QTGMC presets, default left up to QTGMC ("Slower" as of this writing)
#
#		Sets quality of deinterlacing. Any deinterlacer will work, but presets use QTGMC. "Draft" is the default
#		for downconversions where both output dimensions are at most half their corresponding input, or for 1080
#		deinterlacing. Other downscales use "Super Fast", and all other deinterlacing uses the QTGMC default, which
#		is "Slower". Presets from older versions of SimpleSlug ("dumbbob", "low", "balance") are still present, for
#		backward compatibility.
#
#		You can also enter a custom string here to run any deinterlacer you like with whatever arguments you see
#		fit. The string must be the call to the deinterlacer function, so if, for example, you wanted to use
#		LeakKernelBob, you would type qual="LeakKernelBob(order=1)". If you have a need to, you can also string
#		multiple filters together here. qual="TempGaussMC_alpha3().Invert()", for example. How useful that will prove
#		to most people, I'm not sure, but the option is there. The full gamut of possibilities is too great to cover
#		here, but if you want custom settings you know what you're doing. Don't forget to surround your qual string
#		with triple quotes if the string itself contains quotes!
#
#		One final note, please keep in mind that the script looks for parentheses to check for custom deinterlacers;
#		if you're in the habit of calling functions without using them ("Bob" instead of "Bob()"), you'll need to
#		change that here. I'm sorry, but it was the most reliable way I could come up with of providing this feature.
#
#	resize		string, default "BlackmanResize" for upscaling in AviSynth 2.5.8, "Lanczos4Resize" for upscaling in
#			earlier versions, "BilinearResize" for downscaling
#
#		Allows for change of scaling technique; argument must be the name of the resizer. See the AviSynth manual for
#		all possible values (Core filters->Geometric deformation filters->BilinearResize / etcetera). If you define
#		a custom 'resizev', 'resize' will only affect horizontal resizing.
#
#	ep0, ep1	string
#
#		These let you specify extra parameters for the resizer; b and c for Bicubic, taps for Blackman and Lanczos,
#		and p for Gauss. You must type the entire assignment, mind you: ep0="b=0.0",ep1="c=1.0"
#
#	size		string, default "720p"
#
#		Determines output size. Anything above 720p is really pushing it with DV source, I don't recommend larger
#		frames unless you're desperate. The method used to parse this variable provides some flexibility in how you
#		type the string, but I recommend choosing from the names I use in the table shown in step 3 of the Basic Use
#		section above. Please also note the following with regard to the various box options:
#
#			"window" will override boxwidth, boxheight, and boxvideoDAR; this setting provides an easy way to
#			keep your input video at its original size, padding as necessary to produce the output dimensions. If
#			you instead want custom dimensions for the box, you'll need to use "box".
#
#			"box" is for letter or pillarboxing by default, but by defining one or more custom options (boxwidth,
#			boxheight, boxvideoDAR) you can achieve a windowbox effect.
#
#			"bg", when used on its own, will behave the same way "box" does, but instead of a solid color
#			background it will use a blurred, cropped copy of the center. If you've defined a custom background
#			clip with 'bgclip', that will be used instead, minus the blur. "bg" can also be added to "window".
#
#	outwidth, outheight	float
#
#		If you desire a custom output frame size, use these parameters to set it. Odd values can be used only with
#		RGB video (and even then, odd heights can only be used with progressive RGB). Output dimensions in all cases,
#		preset or custom, will be rounded to the closest multiple of the appropriate 'mod' parameter. If you have RGB
#		video, and you want one or both of the dimensions to be odd, you'll need to set 'modw' and/or 'modh' to 1.0.
#
#	PARout		float
#
#		Sets pixel aspect for output. Uses the same presets as PARin, so if you want a custom output PAR, use this
#		to define it. Has priority over DARout if both are defined.
#
#	modw		float, default 1.0 for "deint", "square" and "window" sizes with RGB input, 4.0 for those sizes
#			with YUV input, 8.0 otherwise
#
#	modh		float, default 1.0 for "deint", "square" and "window" sizes with RGB input and progressive output,
#			2.0 for RGB input with interlaced output or for YUV input, 8.0 otherwise
#
#		Allow for easier codec-friendly output sizing. All output dimensions respect this, so frame size and box
#		edges all land on multiples of modw and modh. The resulting aspect ratios will therefore be slightly
#		different than what you ask for, but your video will be cropped based on the actual aspect ratio (after modw
#		and modh are applied), not the one requested, so there shouldn't be any unnecessary distortion. Of course,
#		you can change these values as you see fit, so if you know what you're doing go right ahead.
#
#	DARout		float, default same as input unless custom outwidth and outheight are both requested
#
#		If you want a custom output display aspect, define it here. For example, if you want output that's 640 pixels
#		wide, and has a display aspect of 2.35, but you don't know the vertical dimension, use DARout=2.35 along with
#		outwidth=640 to have SimpleSlug calculate an appropriate height.
#
#	boxvideoDAR	float, default same as input DAR
#
#		Only for "box" and "bg" sizes, this lets you set the display aspect of the video frame as distinct from the
#		display aspect of the overall frame.
#
#	boxshifth, boxshiftv	int, default 0
#
#		In addition to shifting the crop area with hshift and vshift, you can slide your video frame around in
#		relation to the output frame. The box can be shifted completely offscreen, if so desired. Cumulative with
#		'boxpos'.
#
#	boxwidth, boxheight	float
#
#		These define explicit dimensions for the video in the various box modes.
#
#	boxpos		string, "left", "top", "right", "bottom", or a combination of those
#
#		Easy way to stick center video at one edge or corner of the frame without having to calculate the boxshift
#		values yourself. Cumulative with said shifts.
#
#	boxmode		string, "overlay" or "layer"
#
#		Boxes are achieved by default with Stack filters; StackVertical for letterboxing, StackHorizontal for
#		pillarboxing, and one nested inside the other for windowboxing. You can, however, use the Overlay or Layer
#		filters provided with AviSynth to achieve this effect. Both force a colorspace conversion, which is why I
#		don't use either one by default, but they offer a variety of blend modes that you may find useful.
#
#	boxargs		string
#
#		If you do choose to use Overlay or Layer, this is how you pass custom arguments into the filters. Only type
#		what goes between the parentheses, e.g.: SimpleSlugUpscale(boxmode="overlay",boxargs=""" mode="add" """)
#		See the AviSynth documentation for a full list of modes and other arguments supported by Overlay/Layer.
#
#	bgclip		clip
#
#		If you want to use another clip as your background, set it with this. Station ID-style graphics, or just
#		another video, do whatever you like! But be careful: it's your responsibility to make sure this clip is the
#		same as your center clip with regard to colorspace, duration and framerate. If they don't match, you'll get
#		either an outright error or, perhaps worse, unexpected results. Whatever you do, there is no blur applied to
#		custom bgclips, as if you ask for a custom background you probably want to see it clearly.
#
#	bgargs		string, default "prog=true,outwidth=outwidth,outheight=outheight,PARout=PARout,modw=modw,modh=modh"
#
#		The background, like the center clip, is now (as of v1.00) generated by calling SimpleSlugUpscale from within
#		SimpleSlugBox. If you've defined a custom bgclip, and have specific requirements about things like its pixel
#		aspect ratio, set them here. I'd recommend sticking with square pixel, progressive clips for your bgclip, and
#		simply ignoring this parameter, but I can imagine scenarios where this feature might be useful, so I included
#		it.
#
#		Use with extreme caution, and take care to read the QTGMC documentation on "Multiple QTGMC Calls", under the
#		"External Linkage" section; if you use QTGMC in bgargs and as the deinterlacer for your main clip, you'll run
#		into global variable conflicts, which you'll need to sort out yourself.
#
#	resizev		string
#
#		Redesigning part of SimpleSlug as I did for v1.00, any necessary vertical resizing now occurs distinct from
#		the horizontal. If you want to use a different resizer for this step, you can. If you leave this out, the
#		same resizer is used for both scales.
#
#	ep2, ep3	string
#
#		Extra parameters for resizev, if you want them.
#
#	interlaced	string, "tff" or "bff"
#
#		Set top or bottom field first for interlaced output, assuming the interlacing you want isn't handled by the
#		preset sizes. DV is bottom field first, DVDs are usually top field first, so "DVfulliNTSC", for example, is
#		no good for DVD output. Using interlaced="tff" would give you the proper field order. This parameter will
#		override the 'size' preset, mind you, so if you've chosen one that's progressive, but used "tff" or "bff"
#		here, you'll get interlaced output.
#
#	globalDAR	bool, default false
#
#		Enables a pair of global integer variables containing the numerator and denominator of the output's display
#		aspect ratio. Be careful! Global variables can cause no end of problems that are difficult to trace, so
#		please be sure you review your script, making sure this option won't unintentionally override globals that
#		you, or any of the other plugins and scripts you're using, have defined elsewhere.
#
#	globalDARnum, globalDARden	string, default "megui_darx" and "megui_dary"
#
#		If you want to use globalDAR, but need to avoid conflicts with other global variables in your script, use
#		these two to define your own names. The defaults can be detected by MeGUI, which should make anamorphic
#		encoding a little easier. The values assigned to these are integers, so if you want to subsequently do any
#		kind of work with them, you may need to convert them to floats first.
#
#	DARin		float
#
#		Forces SimpleSlug to treat input video as having the specified display aspect ratio. If you need to override
#		the PAR/DAR preset system, but you don't know the input pixel aspect ratio, use this instead.
#
#
#	--Changes--
#
#	1.12 - December 26th, 2011
#
#		-Used AudioDub to restore missing audio on output from 'box' modes
#		-Corrected edithreads try...catch block; now checks actual MT threads, not mode number
#
#	1.11 - March 5th, 2011
#
#		-Replaced MotionBlur with ShutterBlur, as per QTGMC 3.20
#		-Fixed inefficiency with 'bobbed' assignment, revealed by QTGMC 3.20's global variable system
#		-Collapsed try...catch block onto one line, wasn't really worth spreading out
#
#	1.10 - February 17th, 2011
#
#		-Cleaned up some grammar, typos, and outdated info in documentation
#		-Removed redundant check from shtrclp variable assignment
#		-Added globalDAR, globalDARnum, globalDARden
#		-Added DARin
#		-Tweaked shtrhack to allow basic use of new QTGMC motion blur system
#		-Fixed unbelievably stupid, roundabout method of negating cropleft/croptop for hshift/vshift
#		-Reinstated order-of-operations parentheses throughout script
#		-Switched to OOP notation when possible, easier to read
#		-Added more white space to especially dense portions of script
#		-Reworded Assert for drate/shtrhack combo
#		-Added LCase() conversions for strings queried with FindStr(), which is apparently case sensitive
#		-Changed lowest quality for deintcall to use QTGMC Draft preset instead of Bob (allows for motion blur)
#		-Added try...catch block to limit spawning of NNEDI3 threads in QTGMC deinterlacing
#
#	1.02 - November 15th, 2010
#
#		-Corrected oversight with bwrequest/bhrequest in box function (thanks to Nico Feragnoli for the note)
#		-Updated PAL DV pixel aspect ratios (found these in henryho_hk's resizing script, realized they work better)
#		-Changed 0s in PARout and DARout checks to 0.0, for consistency's sake
#		-Clarified grammar of step 3 in Basic Use
#		-Improved interlacing check for shtrclp
#
#	1.01 - November 5th, 2010
#
#		-Added 'interlaced' parameter, allows for choice of field order
#
#	1.00 - November 5th, 2010
#
#		-Switched to QTGMC as default deinterlacer, kept old presets for backward compatibility
#		-Added horizontal resizing before deinterlace for downscales from interlaced source material
#		-Added windowbox modes
#		-Added boxwidth and boxheight parameters to allow custom window dimensions
#		-Removed Asserts for hshift, vshift, boxshifth and boxshiftv
#		-Changed box script to emulate ability of Layer/Overlay to shift window out of frame
#		-Added boxmode parameter to allow use of Layer and Overlay for box sizes, to make use of blend modes
#		-Added boxargs parameter to let user specify blend modes, levels, and other such options for said filters
#		-Added bgclip parameter to allow separate clip to be loaded as background
#		-Added boxpos parameter to provide preset positions for box
#		-Added resizev parameter to specify separate resizer for vertical resize
#		-Added ep2 and 3 to pass extra parameters to resizev
#		-Relaxed default mod values to 8.0, except in box modes
#		-Simplified box function, now generates center and bg by calling SimpleSlugUpscale
#		-Rearranged bobbed/shtrclp business to fix a problem with drate that was introduced with new box function
#		-Removed several unnecessary steps in crop value generation
#		-Added bgargs parameter to pass custom SSU arguments for generation of background
#		-Added framerate check to shtrclp processing, detects same-rate deinterlacers if used
#		-Made Basic Use section of docs simpler in an attempt to scare off fewer people
#		-Commented portions of script to try and explain my line of thinking
#
#	0.9 - 0.1 - See http://www.gyroshot.com/simpleslug.htm

function SimpleSlugUpscale(	clip orig, bool "prog", bool "widein", float "PARin", bool "drate", val "shtrhack",
\				int "hshift", int "vshift", int "boxcolor", float "boxbgblur", string "qual",
\				string "resize", string "ep0", string "ep1", string "size", float "outwidth",
\				float "outheight", float "PARout", float "modw", float "modh", float "DARout",
\				float "boxvideoDAR", float "boxshifth", float "boxshiftv", float "boxwidth",
\				float "boxheight", string "boxpos", string "boxmode", string "boxargs", clip "bgclip",
\				string "bgargs", string "resizev", string "ep2", string "ep3", string "interlaced",
\				bool "globalDAR", string "globalDARnum", string "globalDARden", float "DARin") {

	# This may be a bit paranoid on my part, but since I'm doing most of my work in SimpleSlugUpscale with floating
	# point numbers, I thought it'd be best to generate float versions of the values I need, in this case the width and
	# height of the input. Mixing data types is not strictly forbidden by AviSynth, but I'm only a hobbyist after all,
	# and I'd rather not get into that habit.

	inwidthf =	orig.Width().Float()
	inheightf =	orig.Height().Float()

	prog =		Default(prog,		false)
	widein =	Default(widein,		false)
	drate =		Default(drate,		false)
	shtrhack =	Default(shtrhack,	false)
	hshift =	Default(hshift,		0)
	vshift =	Default(vshift,		0)
	size =		Default(size,		Defined(outwidth) || Defined(outheight) || Defined(DARout) ? "" :
\						"720p").LCase()
	interlaced =	Default(interlaced,	FindStr(size,"1080i") > 0 ? "tff" :
\						LeftStr(size,2)=="dv" && MidStr(size,7,1)=="i" ? "bff" : "")

	Assert(	(shtrhack.IsBool() && (shtrhack == true || shtrhack == false)) ||
\		(shtrhack.IsString() && shtrhack == "QTGMCdefault"),
\			"""SimpleSlugUpscale: shtrhack must be true, false, or "QTGMCdefault"!""")

	shtrhackset =	(shtrhack.IsBool() && shtrhack == true) ||
\			(shtrhack.IsString() && shtrhack == "QTGMCdefault") ? true : false

	Assert( !(drate == true && shtrhackset == true),
\			"SimpleSlugUpscale: No reason to use drate and shtrhack together! Please check your arguments.")

	modw =		Default(modw,	size == "deint" || size == "square" || FindStr(size,"window") > 0 ?
\						orig.IsRGB() ? 1.0 :
\						orig.IsYUY2() ? 2.0 :
\						4.0 :
\					8.0).Float()

	modh =		Default(modh,	size == "deint" || size == "square" || FindStr(size,"window") > 0 ?
\						orig.IsRGB() &&	!(interlaced == "tff" || interlaced == "bff") ?
\							1.0 :
\						2.0 :
\					8.0).Float()

	PARin =		Default(PARin,	Defined(DARin) ?
\						(inheightf / inwidthf) * DARin :
\					widein == true ?
\						inheightf == 576.0 ?
\							16.0/11.0 :
\						inheightf == 480.0 ?
\							40.0/33.0 :
\						4.0/3.0 :
\					inheightf == 576.0 && (inwidthf == 720.0 || inwidthf == 704.0) ?
\						12.0/11.0 :
\					inheightf == 480.0 && (inwidthf == 720.0 || inwidthf == 704.0) ?
\						10.0/11.0 :
\					1.0).Float()

	# This next section, with several redefinitions of outwidth and height, I found necessary in order to allow automatic
	# calculation of one value based on the other. The definition of outheight occurs below the one for outwidth, so if
	# I were to simply check Defined(outwidth) ? it would always be true, since by the time AviSynth reached the height
	# logic, outwidth would have been given a value whether or not the user entered one. Instead, I have each value fall
	# back to 0.0 if none of the other conditions are met, which lets the next set of procedures figure out on what to
	# base the value they're creating. Users can thereby enter both values, one, the other, or none, and get appropriate
	# results for each case.

	outwidth =	Default(outwidth,	size == "deint" ?
\							inwidthf :
\						size == "square" ?
\							inwidthf * PARin :
\						(FindStr(size,"480") > 0 || FindStr(size,"360") > 0) ?
\							640.0 :
\						FindStr(size,"720") > 0 ?
\							1280.0 :
\						FindStr(size,"1080") > 0 ?
\							FindStr(size,"ana") > 0 ?
\								1440.0 :
\							1920.0 :
\						FindStr(size,"dv") > 0 ?
\							720.0:
\						0.0).Float()

	outheight =	Default(outheight,	size == "deint" || size == "square" ?
\							inheightf :
\						FindStr(size,"480sq") > 0 ?
\							480.0 :
\						FindStr(size,"360sq") > 0 ?
\							360.0 :
\						FindStr(size,"dv") > 0 ?
\							FindStr(size,"pal") > 0 ?
\								576.0 :
\							480.0 :
\						FindStr(size,"720") > 0 ?
\							720.0 :
\						FindStr(size,"1080") > 0 ?
\							1080.0 :
\						0.0).Float()

	PARout =	Default(PARout,		size == "deint" ?
\							PARin :
\						LeftStr(size,6) == "dvwide" ?
\							FindStr(size,"pal") > 0 ?
\								16.0/11.0 :
\							40.0/33.0 :

\						LeftStr(size,6) == "dvfull" ?
\							FindStr(size,"pal") > 0 ?
\								12.0/11.0 :
\							10.0/11.0 :
\						FindStr(size,"ana") > 0 ?
\							4.0/3.0 : 
\						Defined(DARout) && outwidth > 0.0 && outheight > 0.0 ?
\							DARout / (outwidth / outheight) :
\						1.0).Float()

	DARin =		Default(DARin,		(inwidthf * PARin) / inheightf).Float()
	DARout =	Default(DARout,		outwidth > 0.0 && outheight > 0.0 ?
\							(outwidth * PARout) / outheight :
\						DARin).Float()

	####

	genow =		outwidth == 0.0 ? true : false
	genoh =		outheight == 0.0 ? true : false

	outwidth =	genow == true ?
\				genoh == true ?
\					(inheightf * DARout) / PARout :
\				(outheight * DARout) / PARout :				
\			outwidth

	outheight =	genoh == true ?
\				genow == true ?
\					inheightf :
\				(outwidth * PARout) / DARout :				
\			outheight

	outwidth =	outwidth > modw ?	Round(outwidth / modw) * modw : modw
	outheight =	outheight > modh ?	Round(outheight / modh) * modh : modh

	actualDARout =	(outwidth * PARout) / outheight

	####

	globalDAR =	Default(globalDAR,	false)
	globalDARnum =	Default(globalDARnum,	"megui_darx")
	globalDARden =	Default(globalDARden,	"megui_dary")

	# Back during the preparation for SimpleSlugUpscale version 0.9, I'd planned to offer a diagnostic mode of sorts,
	# which would display the aspect ratio onscreen in X:Y notation. As such, I wrote a series of small, recursive helper
	# functions to turn a decimal aspect ratio into a pair of integers. Only after working through the problem did I find
	# this next trick somewhere on the Doom9 boards.
	#
	# FrameRateNumerator/Denominator accomplish what I was after (Euclid's algorithm, I believe it's called), but since
	# they operate only on a clip's framerate, I need to assign that first. The clip 'orig' already exists, so I avoid
	# any overhead of creating a BlankClip(), and since the only part of the procedure that actually gets used is the
	# number returned by the two FrameRateXxx functions, 'orig' isn't actually affected.
	#
	# I decided against the diagnostic mode back in 0.9, but as of 1.10 you can turn on globalDAR and query these
	# variables to get the info it would have provided.

	globalDAR == true ? Eval("global " + globalDARnum + " = orig.AssumeFPS(actualDARout).FrameRateNumerator()") : NOP()
	globalDAR == true ? Eval("global " + globalDARden + " = orig.AssumeFPS(actualDARout).FrameRateDenominator()") : NOP()

	####

	fromheight =	actualDARout < DARin ? true : false

	cropwidth =	fromheight ? (inheightf * actualDARout) / PARin : inwidthf
	cropheight =	fromheight ? inheightf : (inwidthf * PARin) / actualDARout

	cropleft =	(inwidthf - cropwidth) / 2.0
	croptop =	(inheightf - cropheight) / 2.0

	hshift =	FindStr(size,"box") > 0 || FindStr(size,"bg") > 0 || FindStr(size,"window") > 0 ?
\				hshift :
\			Abs(hshift) > cropleft ?
\				hshift < 0 ?
\					-cropleft :
\				cropleft :
\			hshift

	vshift =	FindStr(size,"box") > 0 || FindStr(size,"bg") > 0 || FindStr(size,"window") > 0 ?
\				vshift :
\			Abs(vshift) > croptop ?
\				vshift < 0 ?
\					-croptop :
\				croptop :
\			vshift

	cropleft =	cropleft + hshift
	croptop =	croptop + vshift

	# As per the AviSynth documentation, there are certain restrictions when it comes to cropping different colorspaces.
	# For width, RGB has none, but YUY2 width must be mod 2 and YV12 width must be mod 4. For height, there are no
	# restrictions for RGB or YUY2, but YV12 must be mod 2. The numbers are different for interlaced footage, but since
	# the clips are always progressive by the time they get to the crop in my script, I don't need to worry about that.
	# Strictly speaking, since SimpleSlugDeint uses the resizers' expanded syntax to do its work, I could allow subpixel
	# values here, but in the interest of not interpolating chroma unnecessarily, I just do this.

	cropleft =	orig.IsRGB() ?
\				Round(cropleft) :
\			orig.IsYUY2() ?
\				Round(cropleft / 2.0) * 2 :
\			Round(cropleft / 4.0) * 4

	croptop =	orig.IsRGB() || orig.IsYUY2() ?
\				Round(croptop) :
\			Round(croptop / 2.0) * 2

	cropwidth =	orig.IsRGB() ?
\				Round(cropwidth) :
\			orig.IsYUY2() ?
\				Round(cropwidth / 2.0) * 2 :
\			Round(cropwidth / 4.0) * 4

	cropheight =	orig.IsRGB() || orig.IsYUY2() ?
\				Round(cropheight) :
\			Round(cropheight / 2.0) * 2

	####

	resize =	Default(resize,	outheight <= inheightf ? "BilinearResize" :
\					VersionNumber() >= 2.58 ? "BlackmanResize" : "Lanczos4Resize")

	bobbed =	FindStr(size,"box") > 0 || FindStr(size,"bg") > 0 || FindStr(size,"window") > 0 ?
\				NOP() :
\			SimpleSlugDeint(orig,prog,qual,cropleft,croptop,cropwidth,cropheight,resize,outwidth,
\					outheight,ep0,ep1,shtrhack,drate,interlaced)

	scaled =	FindStr(size,"box") > 0 || FindStr(size,"bg") > 0 || FindStr(size,"window") > 0 ?
\				SimpleSlugBox(	orig,prog,widein,PARin,drate,shtrhack,hshift,vshift,boxcolor,boxbgblur,qual,
\						resize,ep0,ep1,size,outwidth,outheight,PARout,modw,modh,boxvideoDAR,
\						boxshifth,boxshiftv,boxwidth,boxheight,boxpos,boxmode,boxargs,bgclip,bgargs,
\						resizev,ep2,ep3,interlaced,DARin
\				) :
\			Eval(	"bobbed." + (Defined(resizev) ? resizev : resize) +
\				"(bobbed.Width(),Round(outheight),src_left=0,src_top=croptop,src_width=bobbed.Width(),src_height=cropheight" +
\				(Defined(ep2) ? "," + ep2 : Defined(resizev) ? "" : Defined(ep0) ? "," + ep0 : "") +
\				(Defined(ep3) ? "," + ep3 + ")" : Defined(resizev) ? ")" : Defined(ep1) ? "," + ep1 + ")" : ")")
\			)

	shtrclp =	prog == true ||
\			drate == true ||
\			interlaced == "tff" ||
\			interlaced == "bff" ||
\			scaled.FrameRate() == orig.FrameRate() ?
\				scaled :
\			drate == false && shtrhack.IsBool() && shtrhack == true ?
\				Merge(scaled.SelectEven(),scaled.SelectOdd()) :
\			scaled.SelectEven()

	interlaced == "tff" ?
\		shtrclp.AssumeTFF().SeparateFields().SelectEvery(4,0,3).Weave() :
\	interlaced == "bff" ?
\		shtrclp.AssumeBFF().SeparateFields().SelectEvery(4,0,3).Weave() :
\	shtrclp

}

function SimpleSlugDeint(	clip orig, bool "prog", string "qual", int "cropleft", int "croptop", int "cropwidth",
\				int "cropheight", string "resize", float "outwidth", float "outheight", string "ep0",
\				string "ep1", val "shtrhack", bool "drate", string "interlaced") {

	inwidthf =	orig.Width().Float()
	inheightf =	orig.Height().Float()

	shutterblur =	shtrhack.IsString() && shtrhack == "QTGMCdefault" && interlaced != "tff" && interlaced != "bff" ? 1 : 0
	fpsdivisor =	shtrhack.IsString() && shtrhack == "QTGMCdefault" && interlaced != "tff" && interlaced != "bff" ? 2 : 1

	# Since my intent from the start was to use this script with a multithreaded version of AviSynth, this try...catch
	# block attempts to limit the number of threads NNEDI3 will use, by way of QTGMC's 'EdiThreads' parameter. You'll
	# likely still need to fiddle with SetMemoryMax(), but I've found this to be a sizeable step toward stability. This
	# could turn out to be a misguided effort on my part, but I think it's worth a shot, and I can always remove it if
	# there are any complications.
	#
	# I first try to ascertain the number of threads being used, by calling GetMTmode(true). Omitting 'true' would
	# retrieve the current MT mode. If you're trying to use more than one thread, I set QTGMC's thread count to 1, so as
	# not to overwhelm the system. If you're only using 1 thread, however, I set it to 0 to let QTGMC decide how many
	# threads it will use. If the attempt to call GetMTmode fails completely, then we're not running in an MT release of
	# Avisynth, and I once again leave the thread count up to QTGMC.
	#
	# In the interest of keeping my own parameter count to a minimum (I'm already up to 39), I haven't added 'edithreads'
	# to SimpleSlug's interface; if you want to customize the number of EdiThreads you use in QTGMC, you'll need to use
	# 'qual' to do it: SimpleSlugUpscale(qual="QTGMC(EdiThreads=2)")

	try { edithreads = GetMTmode(true) > 1 ? 1 : 0 } catch(err_msg) { edithreads = 0 }

	deintcall =	!(Defined(qual)) ?
\				orig.Height() >= 1080 || (inwidthf / outwidth >= 2.0 && inheightf / outheight >= 2.0) ?
\					"""QTGMC(Preset="Draft",ShutterBlur=shutterblur,FPSDivisor=fpsdivisor,EdiThreads=edithreads)""" :
\
\				cropwidth == orig.Width() || cropheight == orig.Height() ?
\					"QTGMC(ShutterBlur=shutterblur,FPSDivisor=fpsdivisor,EdiThreads=edithreads)" :
\
\				inheightf / outheight >= 1.5 ?
\					inheightf / outheight >= 2.0 ?
\						"""QTGMC(Preset="Draft",ShutterBlur=shutterblur,FPSDivisor=fpsdivisor,EdiThreads=edithreads)""" :
\					"""QTGMC(Preset="Super Fast",ShutterBlur=shutterblur,FPSDivisor=fpsdivisor,EdiThreads=edithreads)""" :
\
\				"QTGMC(ShutterBlur=shutterblur,FPSDivisor=fpsdivisor,EdiThreads=edithreads)" :
\
\			qual=="dumbbob" ?
\				"Bob()" :
\
\			qual=="low" ?
\				"""TempGaussMC_beta2(1,1,0,0,0,0,"bob",sharpness=0.0,Sbb=0,SVthin=0.0)""" :
\
\			qual=="balance" ?
\				"""TempGaussMC_beta2(1,1,3,0,0,0,"nnedi2")""" :
\
\			FindStr(qual,"(") == 0 && FindStr(qual,")") == 0 ?
\				"""QTGMC(Preset=qual,ShutterBlur=shutterblur,FPSDivisor=fpsdivisor,EdiThreads=edithreads)""" :
\
\			qual

	prescale =	outwidth < inwidthf ? true : false

	resize =	resize +
\			"(Round(outwidth),orig.Height(),src_left=cropleft,src_top=0,src_width=cropwidth,src_height=orig.Height()" +
\			(Defined(ep0) ? "," + ep0 : "") + (Defined(ep1) ? "," + ep1 + ")" : ")")

	Eval(	"orig" +
\		(prescale == true ? "." + resize : "" ) +
\		(prog == false ? "." + deintcall : "" ) +
\		(prescale == true ? "" : "." + resize)
\	)

}

function SimpleSlugBox(	clip orig, bool "prog", bool "widein", float "PARin", bool "drate", val "shtrhack", int "hshift",
\			int "vshift", int "boxcolor", float "boxbgblur", string "qual", string "resize", string "ep0",
\			string "ep1", string "size", float "outwidth", float "outheight", float "PARout", float "modw",
\			float "modh", float "boxvideoDAR", float "boxshifth", float "boxshiftv", float "boxwidth",
\			float "boxheight", string "boxpos", string "boxmode", string "boxargs",	clip "bgclip",
\			string "bgargs", string "resizev", string "ep2", string "ep3", string "interlaced", float "DARin") {

	inwidthf =	orig.Width().Float()
	inheightf =	orig.Height().Float()

	boxcolor =	Default(boxcolor,	color_black)
	boxbgblur =	Default(boxbgblur,	1.0).Float()
	boxpos =	Default(boxpos,		"center").LCase()
	boxmode =	Default(boxmode,	"stack").LCase()

	DARin =		(inwidthf * PARin) / inheightf
	DARout =	(outwidth * PARout) / outheight

	boxvideoDAR =	Default(boxvideoDAR,	DARin).Float()
	boxwidth =	Default(boxwidth,	0.0).Float()
	boxheight =	Default(boxheight,	0.0).Float()

	# The way I'd initially planned this next bit to function didn't quite work out, and I've resigned myself to using
	# this approach. "window" in your size preset will override everything, so if you want custom dimensions for the box,
	# you'll need to use "box" instead. I'll revisit this in the future, but for now this is the least troublesome.

	bwrequest =	FindStr(size,"window") > 0 ?
\				(inwidthf * PARin) / PARout :
\
\			boxwidth == 0.0 ?
\				((boxheight > 0.0 ? boxheight : outheight) * boxvideoDAR) / PARout < outwidth ?
\					((boxheight > 0.0 ? boxheight : outheight) * boxvideoDAR) / PARout :
\				outwidth :
\
\			boxwidth

	bhrequest =	FindStr(size,"window") > 0 ?
\				inheightf :
\
\			boxheight == 0.0 ?
\				(boxwidth > 0.0 ? boxwidth * PARout : outwidth * PARout) / boxvideoDAR < outheight ?
\					(boxwidth > 0.0 ? boxwidth * PARout : outwidth * PARout) / boxvideoDAR :
\				outheight :
\
\			boxheight


	# These two variable reassignments are the only reason I pass 'interlaced' into SimpleSlugBox; the actual generation
	# of interlaced output happens back in the main function, after everything else is finished, so as you see I don't
	# pass interlaced into SSU when creating 'center' below, instead letting it default to false.

	drate =		drate == true || interlaced == "tff" || interlaced == "bff" ? true : false
	shtrhack =	interlaced == "tff" || interlaced == "bff" ? false : shtrhack

	center =	SimpleSlugUpscale(	orig,prog=prog,widein=widein,PARin=PARin,drate=drate,shtrhack=shtrhack,
\						hshift=hshift,vshift=vshift,qual=qual,resize=resize,ep0=ep0,ep1=ep1,
\						DARout=boxvideoDAR,outwidth=bwrequest,outheight=bhrequest,PARout=PARout,
\						modw=modw,modh=modh,resizev=resizev,ep2=ep2,ep3=ep3,DARin=DARin)

	outwidth =	outwidth.Round()
	outheight =	outheight.Round()

	bgargs =	Default(bgargs, "prog=true,outwidth=outwidth,outheight=outheight,PARout=PARout,modw=modw,modh=modh")

	bg =		FindStr(size,"bg") == 0 ?
\				BlankClip(center,width=outwidth,height=outheight,color=boxcolor) :
\
\			Defined(bgclip) ?
\				Eval("bgclip.SimpleSlugUpscale(" + bgargs + ")") :
\
\			center.SimpleSlugUpscale(	prog=true,outwidth=center.Width()/4,resize="GaussResize",
\							ep0="p="+String(boxbgblur),PARin=PARout,PARout=PARout,DARout=DARout,
\							modw=modw,modh=modh).BicubicResize(outwidth,outheight,1.0,0.0)

	####

	# This is only to ensure that the borders in the image respect your chosen mod values. If they don't, a quick Crop
	# takes care of that, and should only remove a small portion of your image, if any at all. Visible borders in the
	# video have the potential to create noise on lower bitrate encodes, so if you really need to target anemic bitrates
	# I'd recommend setting modw and modh to 16.

	boxlr =		(outwidth - center.Width()) / 2.0
	boxtb =		(outheight - center.Height()) / 2.0
	boxlr =		Ceil(boxlr / modw) * modw
	boxtb =		Ceil(boxtb / modh) * modh

	bwfinal =	Round(outwidth - (boxlr * 2.0))
	bhfinal =	Round(outheight - (boxtb * 2.0))

	modcropl =	Round((center.Width() - bwfinal) / 2.0)
	modcropt =	Round((center.Height() - bhfinal) / 2.0)
	modcropl =	Floor(modcropl / modw) * Int(modw)
	modcropt =	Floor(modcropt / modh) * Int(modh)

	center =	modcropl >= center.Width() || modcropt >= center.Height() ?
\				center :
\			center.Crop(modcropl,modcropt,bwfinal,bhfinal)

	####

	boxshifth =	Default(boxshifth, 0.0).Float()
	boxshiftv =	Default(boxshiftv, 0.0).Float()
	boxshifth =	Round(boxshifth / modw) * modw
	boxshiftv =	Round(boxshiftv / modh) * modh

	boxshifth =	FindStr(boxpos,"left") > 0 ?	boxshifth - boxlr :
\			FindStr(boxpos,"right") > 0 ?	boxshifth + boxlr : boxshifth

	boxshiftv =	FindStr(boxpos,"top") > 0 ?	boxshiftv - boxtb :
\			FindStr(boxpos,"bottom") > 0 ?	boxshiftv + boxtb : boxshiftv

	left =		Round(boxlr + boxshifth)
	top =		Round(boxtb + boxshiftv)
	right =		Round(boxlr - boxshifth)
	bottom =	Round(boxtb - boxshiftv)

	####

	# This crop handles chopping off any parts of the center that overhang the output frame boundaries. I tried several
	# times to somehow combine this with the modcrop operation above, but gave myself a headache in the process.

	ctrcropl =	left < 0 ? left.Abs() : 0
	ctrcropt =	top < 0 ? top.Abs(): 0
	ctrcropr =	right < 0 ? right.Abs() : 0
	ctrcropb =	bottom < 0 ? bottom.Abs() : 0

	center =	ctrcropl >= center.Width() || ctrcropt >= center.Height() || ctrcropr >= center.Width() || ctrcropb >= center.Height() ?
\				center :
\			center.Crop(ctrcropl,ctrcropt,-ctrcropr,-ctrcropb)

	####

	left =		left > 0 ? left : 0
	top =		top > 0 ? top : 0
	right =		right > 0 ? right : 0
	bottom =	bottom > 0 ? bottom : 0

	# The Layer() filter in AviSynth demands YUY2 or RGB32 input, so I take care of that below. Since the conditions here
	# convert YUV->YUV and RGB->RGB, I don't need to worry about the 'matrix' parameter, and by the time we get this far
	# in the script, center and bg are both guaranteed to be progressive (unless you've set prog=true with interlaced
	# source material, but if you're doing that I assume you have a good reason). Consequently, there's only one way to
	# do this conversion, and I'm not nervous about handling the situation programmatically. ConvertBackToYUY2() doesn't
	# come into play, either, since if the original video is YUY2 it'll pass through both the pre- and post-Layer
	# conversion filters untouched.

	layerout =	center.IsYV12() ? "YV12" : center.IsYUY2() ? "YUY2" :
\			center.IsRGB24() ? "RGB24" : "RGB32"

	center =	boxmode == "layer" ?
\				center.IsRGB() ? center.ConvertToRGB32() : center.ConvertToYUY2() :
\			center

	# This next variable is only necessary for the Layer() filter, since it doesn't seem to handle this internally. The
	# default value is 257, which is fine for RGB data, but Layer also accepts YUY2 input; using 257 on YUY2 produces
	# artifacts, at least on my system, in the form of intermittent white specks in certain parts of the image. Setting
	# the default to 256 for YUY2 takes care of this. If a user enters their own level, however (by passing an
	# appropriate string through the "boxargs" parameter), the logic that pieces together the final call to Layer will
	# override "layerlevel" with whatever they've entered.

	layerlevel =	center.IsYUY2() ? 256 : 257

	bg =		boxmode == "layer" ?
\				bg.IsRGB() ? bg.ConvertToRGB32() : bg.ConvertToYUY2() :
\			bg

	####

	# Finally, I put all the pieces together. As you can see, the syntax of implementing Overlay and Layer is
	# dramatically simpler than what I've done further below them, but both force a colorspace conversion that may be
	# undesirable, so the fallback is a set of Stack filters. Conditional statements embedded inside the Stacks allow for
	# the possibility of only stacking two clips instead of all three, saving this section of the script from becoming
	# even more ridiculous. The entry condition for the StackVertical/Horizontal nest ensures that I won't end up calling
	# it with only one clip going into either Stack; those filters throw an exception unless fed two or more clips, so
	# the final two options account for dedicated pillar or letterboxing, respectively.

	video =	left <= 0 && right <= 0 && top <= 0 && bottom <= 0 ?
\			center :
\
\		left >= outwidth || right >= outwidth || top >= outheight || bottom >= outheight ?
\			bg :
\
\		boxmode == "overlay" ?
\			Eval("Overlay(bg,center,x=left,y=top" + (Defined(boxargs) ? "," + boxargs + ")" : ")")) :
\
\		boxmode == "layer" ?
\			Eval(	"Layer(bg,center,x=left,y=top" +
\				(Defined(boxargs) && FindStr(boxargs.LCase(),"level") > 0 ? "" : ",level=layerlevel") +
\				(Defined(boxargs) ? "," + boxargs + ")" : ")") +
\				".ConvertTo" + layerout + "()") :
\
\		(left > 0 || right > 0) && (top > 0 || bottom > 0) ?
\			Eval(	"StackVertical(" +	(top <= 0 ? "" : "bg.Crop(0,0,outwidth,top),") +
\							"""Eval("StackHorizontal(" +	(left <= 0 ? "" : "bg.Crop(0,top,left,center.Height()),") +
\											"center" +
\											(right <= 0 ? "" : ",bg.Crop(outwidth-right,top,right,center.Height())") + ")"
\							)""" +
\							(bottom <= 0 ? "" : ",bg.Crop(0,outheight-bottom,outwidth,bottom)") + ")"
\			) :
\
\		center.Height() == outheight ?
\			Eval("StackHorizontal(" +	(left <= 0 ? "" : "bg.Crop(0,top,left,outheight),") +
\							"center" +
\							(right <= 0 ? "" : ",bg.Crop(outwidth-right,0,right,outheight)") + ")"
\			) :
\
\		Eval("StackVertical(" + (top <= 0 ? "" : "bg.Crop(0,0,outwidth,top),") +
\					"center" +
\					(bottom <= 0 ? "" : ",bg.Crop(0,outheight-bottom,outwidth,bottom)") + ")"
\		)

	# I just added this in quickly for version 1.12, since it was pointed out to me (thanks Chymerix!) that in each of
	# the situations seen above--whether using a nested set of Stack filters, or Overlay/Layer--the audio for the result
	# is taken from the first clip passed as an argument. Since I pass 'bg' as the first argument in each case, the final
	# output has no audio. Dubbing the original soundtrack from the center clip should take care of this.

	return AudioDub(video, center)

}