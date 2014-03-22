FUNCTION Focus(clip input, int clp_width, int clp_height)
{
  # May help some edge blurred sources by defining the edges
  ssx = 3.5
  ssy = 3.5
  
  # Supersize the clip ensuring its mod16
  xx_ss2 = int(clp_width * ssx / 16 + 0.5) * 16 
  yy_ss2 = int(clp_height * ssy / 16 + 0.5) * 16 
  input  = input.spline36Resize(xx_ss2,yy_ss2)
  
  # apply our transfors to the edges (blur, warpsharp (only for luma), and xsharpen)
  input = input.minblur(2)
  input = input.awarpsharp2(depth=24, thresh=1, blur=2, chroma=2, type=1)
  input = input.xsharpen(255,255)
  
  # return the clip in its original size, this will just have enhanced edges
  RETURN input.BicubicResize(clp_width,clp_height).RemoveGrain(mode=1)
}