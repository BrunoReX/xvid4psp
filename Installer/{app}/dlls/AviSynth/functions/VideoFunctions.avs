Function AutoYV12(clip Video) {
 Video = (isYV12(Video)==false) ? ConvertToYV12(Video) : Video
 return(Video)
}

Function AutoYUY2(clip Video) {
 Video = (isYUY2(Video)==false) ? ConvertToYUY2(Video) : Video
 return(Video)
}

function RemoveDirt(clip input, bool "_grey", int "repmode")  
{ 
    _grey=default(_grey, false) 
    repmode=default(repmode, 16) 
    clmode=17 
    clensed=Clense(input, grey=_grey, cache=4) 
    sbegin = ForwardClense(input, grey=_grey, cache=-1) 
    send = BackwardClense(input, grey=_grey, cache=-1) 
    alt=Repair(SCSelect(input, sbegin, send, clensed, debug=true), input, mode=repmode, modeU = _grey ? -1 : repmode )  
    restore=Repair(clensed, input, mode=repmode, modeU = _grey ? -1 : repmode) 
    corrected=RestoreMotionBlocks(clensed, restore, neighbour=input, alternative=alt, gmthreshold=70, dist=1, dmode=2, debug=false, noise=10, noisy=12, grey=_grey) 
    return RemoveGrain(corrected, mode=clmode, modeU = _grey ? -1 : clmode ) 
}

function DirectShowSource2(string source, float "fps", int "cache", int "seekthr", int "preroll", int "subsm", string "lavs", string "lavd", bool "flipv", bool "fliph", string "pixel_type", int "timeout")
{ 
    cache=default(cache, 10)            #backward cache size (in frames)
    seekthr=default(seekthr, 100)       #forward seeking threshold (in frames)
    preroll=default(preroll, 0)         #"underseek" for more precise seeking (in frames)
    subsm=default(subsm, 0)             #0 = no subs, 1 = try to render, 2 = force loading DirectVobSub and try to render
    lavs=default(lavs, "")              #use LAV Splitter and pass some settings to it
    lavd=default(lavd, "")              #use LAV Video Decoder and pass some settings to it
    lavf_path="..\..\LAVFilters"        #relative or absolute path to LAVFilters folder
    dvs_path=""                         #relative or absolute path to VSFilter.dll    
    flipv=default(flipv, false)         #flip vertical
    fliph=default(fliph, false)         #flip horizontal
    pixel_type=default(pixel_type, "")  #allowed colorspace (YV12, YUY2, RGB24, RGB32 or RGB - only one of them; or "" for all)
    timeout=default(timeout, 30)        #timeout for waiting for decoded frame (in seconds, 0 = INFINITE)

    return DSS2(source, fps, cache, seekthr, preroll, subsm, lavs, lavd, lavf_path, dvs_path, flipv, fliph, pixel_type, timeout)
}

function ConvertMFlowFPS(clip input, int "numerator", int "denominator")
{ 
     last = input
     fps_super=MSuper(pel=2, hpad=16, vpad=8)
     fps_backward_vec1=MAnalyse(fps_super, isb=true, blksize=32, blksizev=16, overlap=8, overlapv=4, searchparam=1, plevel=2)
     fps_forward_vec1=MAnalyse(fps_super, isb=false, blksize=32, blksizev=16, overlap=8, overlapv=4, searchparam=1, plevel=2)
     fps_forward_vec=MRecalculate(fps_super, fps_forward_vec1, blksize=16, blksizev=8, overlap=4, overlapv=2, thSAD=100, searchparam=1)
     fps_backward_vec=MRecalculate(fps_super, fps_backward_vec1, blksize=16, blksizev=8, overlap=4, overlapv=2, thSAD=100, searchparam=1)
     return MFlowFps(fps_super, fps_backward_vec, fps_forward_vec, num=numerator, den=denominator, mask=2, ml=5000)
}