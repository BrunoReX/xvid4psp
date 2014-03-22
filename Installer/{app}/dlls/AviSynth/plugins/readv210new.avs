#v210 Reader Ver 0.5 by jmac698
#Read v210 Quicktime files with Sashimi, by jmac698
#Ver 0.5 - reads grey image in a new way with sashimi 0.85
#Requirements - only Sashimi 0.85
#fn="D:\project001a\deepcolor\v210 samples\v210.mov"
#readv210new(fn, 48, 1920, 1080)

function readv210new(string fn, int file_head, int frame_width, int frame_height) {#greyscale v210 file
    line_size = (frame_width * 16 / 6 + 127) / 128 * 128 # all lines are padded to 128 bytes boundary
    LeftWords = RawReader(fn, "RGB", line_size/4, frame_height, filehead=file_head, packing="8:0:8; 6:0:6; 18:0:2")#3 bitfields in 32bits
    RightWords = RawReader(fn, "RGB", line_size/4, frame_height, filehead=file_head, packing="20:16:4; 4:0:4; 8:2:6")
    p2 = LeftWords.every(2,1)
    p3 = RightWords.every(2,1)
    p0 = LeftWords.every(2,0)
    p1 = RightWords.every(2,0)
    Cb0_7_0=p0.showred
    Y0_5_0=p0.showgreen
    Cb0_9_8=p0.showblue 
    Cr0_3_0=p1.ShowRed
    Y0_9_6=p1.ShowGreen
    Cr0_9_4=p1.showblue 
    Y1_7_0=p2.showred 
    Cb1_5_0=p2.showgreen 
    Y1_9_8=p2.showblue 
    Y2_3_0=p3.showred 
    Cb1_9_6=p3.showgreen 
    Y2_9_4=p3.showblue 
    
    Y0_9_2=CombineBits(Y0_9_6,Y0_5_0,4)
    Y1_9_2=CombineBits(Y1_9_8,Y1_7_0,2)
    Y2_9_2=CombineBits(Y2_9_4,Y2_3_0,6)
    Weave3h(Y0_9_2,Y1_9_2,Y2_9_2)
}

function weave3h(clip a, clip b, clip c) {#horizontally weave 3 clips
    a=a.turnright
    b=b.turnright
    c=c.turnright
    interleave(a,b,a,c)#0 1 2 3->01 23->0213->213 or abc
    assumefieldbased
    assumetff
    weave
    assumefieldbased
    assumetff
    weave
    pointresize(width,height*3/4)#deletes every 4th line offset 0
    turnleft
}

function every(clip v, int n, int offset) {#select every n bytes horizontally with offset, works on yv12 only
    v
    w=width
    h=height
    pointresize(v,w*2,h)
    crop(offset*2,0,0,0).addborders(0,0,offset*2,0)#shift left offset pixels
    pointresize(w/n,h)
}

function CombineBits(clip left, clip right, int bits) {
    #Combine first bitsl of left with first bitsr of right
    #e.g. 9876xxxx and 5432xxxx with bitsl=4, bitsr=4 gives 98765432
    bitsright=8-bits
    pwr=pow(2,bitsright)
    Overlay(left, right.Levels(0,1,256, 0,int(pwr), false), mode="Add")
}