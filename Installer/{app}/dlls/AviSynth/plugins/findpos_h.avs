function findpos_h(clip m, int "searchwidth", int "x1", int "x2"){
    #Searches m from left to right in the range x1 to x1+searchwidth-1 and right to left in the range width-1-x2 to x2-searchwidth-1
    #for the first luma=255 pixel, then colors the output line with the offset from x
    #for example m is 0 0 255 255 255 0 0 0, width=8, x1=0, x2=0, searchwidth=4 becomes 4 4 2 3 3 4 4 4, then 2 2 2 2 3 3 3 3 
    #Can only search for 255 pixels (as the luma output is only 8 bit)
    #c and m should have the same clip properties (same size)
    #searchwidth should be <=width/2
    searchwidth=default(searchwidth,32)
    x1=default(x1,0)
    x2=default(x2,0)
    rampexpr="x "+string(m.width/2)+" < x "+string(m.width-1)+" x - ?"#x w/2 < x w-1 x - ?
    ramp=mt_lutspa(m, mode="absolute",expr=rampexpr)
    notfound=searchwidth#Value to return if no mask on this line, should be >=searchwidth or you'll find the wrong minimum later
    maskmarker=255#The luma value in the mask which indicates a detected pixel
    #(if m=maskmarker return ramp else notfound), 255 means x>=255, x<searchwidth or notfound
    mt_lutxy(m,ramp,yexpr="x "+string(maskmarker)+" = y "+string(notfound)+" ?")
    #now make solid lines based on min luma found in each line
    l=crop(0,0,-width/2,0)
    r=crop(width/2,0,0,0)
    l=l.minmax(0,0)
    r=r.minmax(0,0)
    StackHorizontal(l,r)
}

function alignbyluma(clip src, clip shift, int "mode"){
    #Shift/scale each line of clip src by the x offset defined by the luma of shift
    #for example if shift were all luma=8, the entire src clip would move 8 pixels to the (dir)
    #This works on a pixel basis, so solid horizontal lines in shift can shift src by variable amounts per line
    #It uses a simple replacement strategy, where each pixel in shift is tested and replaced by the same pixel in a shifted copy
    #Currently handles only 0-15 shifts
    #Magnify everything to get full color resolution
    mode=default(mode, 2)
    shiftuv=shift
    shift=shift.pointresize(shift.width*2,shift.height*2)
    shift=ytouv(shiftuv,shiftuv,shift)
    src=src.pointresize(src.width*2,src.height*2)#We double here to preserve chroma rez
    GScript("
        for (y=0, src.height/2-1, 1) {
            l=int(getpixel(shift,0,y).YPlaneMin)
            r=int(getpixel(shift,shift.width/2-2,y).YPlaneMin)
            getline(src, y*2)
            align(l*2, r*2, 12, 4)
            out=y==0?last:stackvertical(out,last)
        }#for y
    ")#GScript
    out
    converttoyuy2
    bilinearresize(src.width/2,src.height/2)
}

function align(clip v, int xl, int xr, int lb, int rb, int "mode") {
    v#shift an image, x>0 shifts left, xl is amount to shift left, xr is amount to shift right
    #mode 0 is shift left only, 1 shift right, 2 scale to shift left and right
    mode=default(mode, 2)
    offx=mode==0?xl:-xr
    mode<2?pointresize(last.width, last.height, offx, 0, last.width, last.height):crop(xl,0,-xr,0).addborders(lb, 0, rb, 0).Spline36Resize(last.width,last.height)
}

function getpixel(clip v, int x, int y) {
    #get color of a single pixel and return as a fat 2x2 yv12 pixel
    v
    #pointresize(last.width*2,last.height*2)
    crop(x>0?x*2:0,y>0?y*2:0,-(last.width-x*2-2),-(last.height-y*2-2))
}

function getline(clip v, int y) {
    v#return a line of height 2 from y to y+1
    crop(0,y,0,-(last.height-y-2))
}

function findthresh(clip v){
    #Find a resonable starting point for thresh by searching border
    current_frame=0
    v.converttoyv12
    crop(0,16,-last.width+2,-16)
    AverageLuma
}

