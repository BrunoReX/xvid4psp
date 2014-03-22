###################################################
###                                             ###
###         Scene change detect script          ###
###                                             ###
###       by 06_taro - astrataro@gmail.com      ###
###                                             ###
###            v0.3 - 12 February 2012          ###
###                                             ###
###################################################
###
### SCDetect - Detect scene change and output scene change frames to a file.
###
### FFTypeList - Output frame type list to a new file.
###              The list has exactly the same format as x264's qpfile, except for no qp value is given.
###
### +-----------+
### | CHANGELOG |
### +-----------+
###
### v0.3 - 12 February 2012:
###      - Add means difference calculation, more accurate on flicking.
###
### v0.2 - 28 December 2011:
###      - Crop before calculate whether the scene change mask is a scene change frame or not,
###        and replace LumaDifference(BlankClip) with YPlaneMax, might be faster.
###      - Tweak parameters of thSCD1 and thSCD2 back to MVTools2's default. The parameters in v0.1 is too weak to detect non-grain clips.
###      - Add FFTypeList to output frame types of source clip. Can be used only with FFVideoSource or FFmpegSource2.
###
### v0.1 - 28 December 2011:
###      - First release.
###
### +----------------+
### |  REQUIREMENTS  |
### +----------------+
###
### SCDetect:
### YV12 input
### -> RemoveGrain
### -> MVTools2
###
### FFTypeList:
### FFVideoSource or FFmpegSource2 as source filter
###
### +-------+
### | USAGE |
### +-------+
###
### SCDetect(scFile, thSCD1, thSCD2, mDiff, pel, search, searchparam, info)
### ----------------------
###
###   scFile [string, Default="scFile.log"]
###   -- The log file of scene change frames, do not output log file when scFile is set to "nul"
###
###   thSCD1 [int, Default=360]
###   -- Threshold which decides whether a block has changed between the previous frame and the current one.
###   -- Raising it will lower the number of blocks detected as changed. It may be useful for noisy or flickered video.
###   -- Read MVTools2 documents for more details.
###
###   thSCD2 [int(0-255), Default=120]
###   -- Threshold which sets how many blocks have to change for the frame to be considered as a scene change.
###   -- 0 meaning 0 %, 255 meaning 100 %.
###
###   mDiff [float, Default=2.5]
###   -- Means difference threshold.
###
###   pel [int(1,2,4), Default=1]
###   -- It is the accuracy of the motion estimation. Value can only be 1, 2 or 4.
###   -- 1 means a precision to the pixel.
###   -- 2 means a precision to half a pixel.
###   -- 4 means a precision to quarter a pixel.
###   -- Larger value is more accurate but slower, and not always better due to big level scale step.
###
###   search [int(0-7), Default=4]
###   searchparam [int, Default=2]
###   -- Search decides the type of search at every level, and searchparam is an additional parameter (step, radius) for this search:
###   -- search = 0 : 'OneTimeSearch'.
###                   searchparam is the step between each vectors tried ( if searchparam is superior to 1, step will be progressively refined ).
###   -- search = 1 : 'NStepSearch'.
###                   N is set by searchparam. It's the most well known of the MV search algorithm.
###   -- search = 2 : Logarithmic search, also named Diamond Search.
###                   searchparam is the initial step search, there again, it is refined progressively. 
###   -- search = 3 : Exhaustive search.
###                   searchparam is the radius (square side is 2*radius+1). It is slow, but it gives the best results, SAD-wise.
###   -- search = 4 : Hexagon search.
###                   searchparam is the range. (similar to x264).
###   -- search = 5 : Uneven Multi Hexagon (UMH) search.
###                   searchparam is the range. (similar to x264).
###   -- search = 6 : pure Horizontal exhaustive search.
###                   searchparam is the radius (width is 2*radius+1). 
###   -- search = 7 : pure Vertical exhaustive search.
###                   searchparam is the radius (height is 2*radius+1). 
###
###   preblur [bool, Default=true]
###   -- Blurring before scene change detection on the clip to avoid affected by grain or not.
###
###   info [bool, Default=false]
###   -- Overlay the result of scene change detection on the clip or not.
###
###
###
### FFTypeList(tlFile, full)
### ----------------------
###
###   tlFile [string, Default="FFTypeList.log"]
###   -- The log file of frame type list.
###
###   full [bool, Default=false]
###   -- Generates list of only I frames or all frames.
###

Function SCDetect(clip c, string "scFile", int "thSCD1", int "thSCD2", float "mDiff", int "pel", int "search", int "searchparam", bool "preblur", bool "info"){

  scFile  = Default(scFile, "scFile.log")
  thSCD1  = Default(thSCD1,          360)
  thSCD2  = Default(thSCD2,          120)
  mDiff   = Default(mDiff,           2.5)
  pel     = Default(pel,               1)
  search  = Default(search,            4)
  searchparam = Default(searchparam,   2)
  preblur = Default(preblur,        true)
  info    = Default(info,          false)

  last    = preblur ? c.RemoveGrain(20, 0) : c

  Assert( IsYV12 , "SCDetect needs YV12 input!" )

  super   = MSuper(pel=pel, chroma=false)
  vector  = super.MAnalyse(pelsearch=pel, search=search, searchparam=searchparam, chroma=false)
  global scMask = MSCDetection(vector, thSCD1=thSCD1, thSCD2=thSCD2).Crop(0,0,16,16)

  global SC_mD  = mDiff
  global mean   = Histogram(mode="Color").Crop(width+64, 64, 128, 128)

  SCTrue  = c.Subtitle("Scene change: true" )
  SCFalse = c.Subtitle("Scene change: false")

  info ? ConditionalFilter( last, SCTrue, SCFalse, "boolSC", "==", "true" )
  \    : nop
  FrameEvaluate( """global boolSC =
  \           (
  \             ( scMask.YPlaneMax == 255 ) &&
  \             (
  \               (mean.YDifferenceFromPrevious > SC_mD*3) ||
  \               (
  \                 (mean.YDifferenceFromPrevious > SC_mD) &&
  \                 (mean.YDifferenceFromPrevious > (mean.YDifferenceToNext+mean.loop(0, 0, -1).YDifferenceToNext+mean.loop(0, 0, 1).YDifferenceToNext)/1.2)
  \               )
  \             )  
  \           )""" )

  ( scFile != "nul" ) ? WriteFileStart( scFile, """ "# Scene change frame list" """ ).WriteFileIf( scFile, "boolSC==true", "current_frame" ) : nop

  return last
}

Function FFTypeList(clip c, string "tlFile", bool "full"){

  tlFile = Default(tlFile, "FFTypeList.log")
  full   = Default(full,              false)
  last   = c

  full ? WriteFileIf(tlFile, "true", "current_frame", "chr(32)+chr(FFPICT_TYPE)", append=false)
  \    : WriteFileIf(tlFile, """ chr(FFPICT_TYPE)=="I" """, "current_frame", "chr(32)+chr(FFPICT_TYPE)", append=false)
}
