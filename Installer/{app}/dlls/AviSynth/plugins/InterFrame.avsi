#------------------------------------------------------------------------------#
#                                                                              #
#                          InterFrame 1.14 by SubJunk                          #
#                                                                              #
#     A frame interpolation script that primarily uses MVTools2 for making     #
#        accurate estimations about the content of non-existent frames         #
#      Its main use is to give videos higher framerates like newer TVs do      #
#------------------------------------------------------------------------------#


# For instructions and further information see the included InterFrame.html
# For news go to spirton.com


function InterFrame(clip Input, string "Preset", string "Tuning", int "NewNum", int "NewDen", string "FlowPath", bool "GPU", string "InputType", int "OverrideAlgo", int "OverrideSadML") {
	# Defaults
	Preset        = default(Preset       , "Medium"   )
	NewNum        = default(NewNum       , 0          )
	NewDen        = default(NewDen       , 0          )
	Tuning        = default(Tuning       , "Film"     )
	FlowPath      = default(FlowPath     , "Undefined")
	GPU           = default(GPU          , false      )
	InputType     = default(InputType    , "2D"       )
	OverrideAlgo  = default(OverrideAlgo , 0          )
	OverrideSadML = default(OverrideSadML, 0          )

	# Validate inputs
	Assert(Preset == "Placebo" || Preset == "Medium" || Preset == "Fast" || Preset == "Faster" || Preset == "Very Fast" || Preset == "Super Fast" || Preset == "Ultra Fast", "'"+Preset+"' is not a valid preset. Please check the documentation for a list of the valid presets.")
	Assert(Tuning == "Film" || Tuning == "Smooth" || Tuning == "Animation" || Tuning == "Weak", "'"+Tuning+"' is not a valid tuning. Please check the documentation for a list of the valid tunings.")
	Assert(InputType == "2D" || InputType == "SBS" || InputType == "OU" || InputType == "HSBS" || InputType == "HOU", "'"+InputType+"' is not a valid InputType. Please check the documentation for a list of the valid InputTypes.")
	Assert(FlowPath != "Undefined", "You must specify FlowPath. Please check the documentation for details.")

	# Get either 1 or 2 clips depending on InputType
	InputType == "SBS" ? Eval("""
		FirstEye  = InterFrameProcess(Input.crop(0            , 0, -Input.Width/2, 0), Preset=Preset, Tuning=Tuning, NewNum=NewNum, NewDen=NewDen, FlowPath=FlowPath, GPU=GPU, InputType=InputType, OverrideAlgo=OverrideAlgo, OverrideSadML=OverrideSadML)
		SecondEye = InterFrameProcess(Input.crop(Input.Width/2, 0, 0             , 0), Preset=Preset, Tuning=Tuning, NewNum=NewNum, NewDen=NewDen, FlowPath=FlowPath, GPU=GPU, InputType=InputType, OverrideAlgo=OverrideAlgo, OverrideSadML=OverrideSadML)
		StackHorizontal(FirstEye, SecondEye)
	""") : InputType == "OU" ? Eval("""
		FirstEye  = InterFrameProcess(Input.crop(0, 0             , 0, -Input.Height/2), Preset=Preset, Tuning=Tuning, NewNum=NewNum, NewDen=NewDen, FlowPath=FlowPath, GPU=GPU, InputType=InputType, OverrideAlgo=OverrideAlgo, OverrideSadML=OverrideSadML)
		SecondEye = InterFrameProcess(Input.crop(0, Input.Height/2, 0, 0              ), Preset=Preset, Tuning=Tuning, NewNum=NewNum, NewDen=NewDen, FlowPath=FlowPath, GPU=GPU, InputType=InputType, OverrideAlgo=OverrideAlgo, OverrideSadML=OverrideSadML)
		StackVertical(FirstEye, SecondEye)
	""") : InputType == "HSBS" ? Eval("""
		FirstEye  = InterFrameProcess(Input.crop(0            , 0, -Input.Width/2, 0).Spline36Resize(Input.Width, Input.Height), Preset=Preset, Tuning=Tuning, NewNum=NewNum, NewDen=NewDen, FlowPath=FlowPath, GPU=GPU, InputType=InputType, OverrideAlgo=OverrideAlgo, OverrideSadML=OverrideSadML)
		SecondEye = InterFrameProcess(Input.crop(Input.Width/2, 0, 0             , 0).Spline36Resize(Input.Width, Input.Height), Preset=Preset, Tuning=Tuning, NewNum=NewNum, NewDen=NewDen, FlowPath=FlowPath, GPU=GPU, InputType=InputType, OverrideAlgo=OverrideAlgo, OverrideSadML=OverrideSadML)
		StackHorizontal(FirstEye.Spline36Resize(Input.Width/2, Input.Height), SecondEye.Spline36Resize(Input.Width/2, Input.Height))
	""") : InputType == "HOU" ? Eval("""
		FirstEye  = InterFrameProcess(Input.crop(0, 0             , 0, -Input.Height/2).Spline36Resize(Input.Width, Input.Height), Preset=Preset, Tuning=Tuning, NewNum=NewNum, NewDen=NewDen, FlowPath=FlowPath, GPU=GPU, InputType=InputType, OverrideAlgo=OverrideAlgo, OverrideSadML=OverrideSadML)
		SecondEye = InterFrameProcess(Input.crop(0, Input.Height/2, 0, 0              ).Spline36Resize(Input.Width, Input.Height), Preset=Preset, Tuning=Tuning, NewNum=NewNum, NewDen=NewDen, FlowPath=FlowPath, GPU=GPU, InputType=InputType, OverrideAlgo=OverrideAlgo, OverrideSadML=OverrideSadML)
		StackVertical(FirstEye.Spline36Resize(Input.Width, Input.Height/2), SecondEye.Spline36Resize(Input.Width, Input.Height/2))
	""") : Eval("""
		InterFrameProcess(Input, Preset=Preset, Tuning=Tuning, NewNum=NewNum, NewDen=NewDen, FlowPath=FlowPath, GPU=GPU, InputType=InputType, OverrideAlgo=OverrideAlgo, OverrideSadML=OverrideSadML)
	""")
}

function InterFrameProcess(clip Input, string "Preset", string "Tuning", int "NewNum", int "NewDen", string "FlowPath", bool "GPU", string "InputType", int "OverrideAlgo", int "OverrideSadML") {
	# Create processed clip for slower presets
	Preset == "Placebo" || Preset == "Medium" || Preset == "Fast" || Preset == "Faster" ? Eval("""
		ProcessedSource = Input.RemoveGrain(mode=17)
	""") : Eval("""
		# Don't want ProcessedSource
	""")

	# Set variables controlled by Tuning
	BlockSize = (Tuning == "Film" || Tuning == "Animation") ? 16 : \
	            (Tuning == "Weak")                          ? 32 : 16
	Overlap1  = (Tuning == "Animation")                     ? 0  : 4
	Overlap2  = (Tuning == "Animation")                     ? 0  : 2

	# Set Algo
	OverrideAlgo != 0 ? Eval("""
		Algo = OverrideAlgo
	""") : Eval("""
		Algo = (Tuning == "Smooth" || Tuning == "Animation") ? 23 : 13
	""")

	# Set SadML
	OverrideSadML != 0 ? Eval("""
		SadML = OverrideSadML
	""") : Eval("""
		SadML = (Tuning == "Smooth" || Tuning == "Animation") ? 150 : 0
	""")

	# Create super clip/s
	SuperRegular = MSuper(Input, hpad=BlockSize, vpad=BlockSize, rfilter=4)

	Preset == "Placebo" ? Eval("""
		CustomLuma   = EEDI2(Input, field=1).Spline36Resize(2*width(Input), 2*height(Input), src_left=0.25             )
		CustomChroma = EEDI2(Input, field=1).Spline36Resize(2*width(Input), 2*height(Input), src_left=0.5 , src_top=0.5)

		CustomPelClip = MergeChroma(CustomLuma, CustomChroma, 1)

		Super = MSuper(ProcessedSource, hpad=BlockSize, vpad=BlockSize, rfilter=4, pelclip=CustomPelClip)
	""") : Preset == "Medium" ? Eval("""
		Super = MSuper(ProcessedSource, hpad=BlockSize, vpad=BlockSize, rfilter=4)
	""") : Eval("""
		Super = MSuper(Input, hpad=BlockSize, vpad=BlockSize, rfilter=4)
	""")

	# Make interpolation vector clip
	Preset == "Ultra Fast" ? Eval("""
		backward = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=true , lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, chroma=false)
		forward  = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=false, lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, chroma=false)
	""") : Preset == "Super Fast" ? Eval("""
		backward = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=true , lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, overlap=Overlap1)
		forward  = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=false, lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, overlap=Overlap1)
	""") : Preset == "Very Fast" ? Eval("""
		backward = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=true , lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, overlap=Overlap1)
		forward  = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=false, lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, overlap=Overlap1)
		backward = MRecalculate(Super, backward, blksize=8, overlap=Overlap2)
		forward  = MRecalculate(Super, forward,  blksize=8, overlap=Overlap2)
	""") : Preset == "Faster" ? Eval("""
		backward = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=true , lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, overlap=Overlap1, search=3, pelsearch=3)
		forward  = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=false, lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, overlap=Overlap1, search=3, pelsearch=3)
		backward = MRecalculate(Super, backward, blksize=8, overlap=Overlap2, search=3)
		forward  = MRecalculate(Super, forward,  blksize=8, overlap=Overlap2, search=3)
	""") : Preset == "Fast" ? Eval("""
		backward = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=true , lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, overlap=Overlap1, search=3, pelsearch=3)
		forward  = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=false, lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, overlap=Overlap1, search=3, pelsearch=3)
		backward = MRecalculate(Super, backward, blksize=8, overlap=Overlap2, search=3)
		forward  = MRecalculate(Super, forward,  blksize=8, overlap=Overlap2, search=3)
	""") : Eval("""
		backward = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=true , lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, overlap=Overlap1, search=3, pelsearch=3, dct=5)
		forward  = MAnalyse(Super, blksize=BlockSize, plevel=0, isb=false, lambda=1000 * BlockSize * Blocksize / 128, lsad=1600, overlap=Overlap1, search=3, pelsearch=3, dct=5)
		backward = MRecalculate(Super, backward, blksize=8, overlap=Overlap2, search=3, dct=5)
		forward  = MRecalculate(Super, forward,  blksize=8, overlap=Overlap2, search=3, dct=5)
	""")

	# Determine new framerate
	NewNum != 0 ? Eval("""
		# Use user values
	""") : Input.Framerate == 25 ? Eval("""
		NewNum = 50
		NewDen = 1
	""") : Input.Framerate == 30 ? Eval("""
		NewNum = 60
		NewDen = 1
	""") : Eval("""
		NewNum = 60000
		NewDen = 1001
	""")

	# See whether to use GPU-acceleration or not
	svp_flow_lib = GPU == true ? FlowPath+"libflowgpu.dll" : FlowPath+"libflowsse.dll"
	Finest = GPU == true ? SuperRegular : MFinest(Input, SuperRegular)

	# Put it together
	MSmoothFps(Input, SuperRegular, backward, forward, finest=Finest, num=NewNum, den=NewDen, algo=Algo, ml=0, sadml=SadML, sadgamma=2, block=false, blend=true)
}
