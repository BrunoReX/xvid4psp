function ReplaceFramesMC(clip Source, int N, int X)
{
    # N is number of the 1st frame in Source that needs replacing. 
    # X is total number of frames to replace
    #e.g. RX(101, 5) would replace 101,102,103,104,105 , by using 100 and 106 as reference points for mflowfps interpolation
 
    start=Source.trim(N-1,-1) #one good frame before, used for interpolation reference point
    end=Source.trim(N+X,-1) #one good frame after, used for interpolation reference point
 
    start+end
    AssumeFPS(1) #temporarily FPS=1 to use mflowfps
  
    super = MSuper()
    backward_vec = MAnalyse(super, isb = true)
    forward_vec = MAnalyse(super, isb = false)
    MFlowFps(super, backward_vec, forward_vec, blend=false, num=X+1, den=1) #num=X+1
    AssumeFPS(FrameRate(Source)) #return back to normal source framerate for joining
    Trim(1, framecount-1) #trim ends, leaving replacement frames
  
    Source.trim(0,-N) ++ last ++ Source.trim(N+X+1,0)
}