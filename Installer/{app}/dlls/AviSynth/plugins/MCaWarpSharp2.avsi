###
###  
###  MCaWarpSharp2()
###                 :fix halo, chroma bleeding & blurry edges (SHARPENER)
###  
###  (28-03-2011)
### 
### By z. ndmn.(zee944) with Didée guidance.
### Optimized by Dogway
### http://forum.doom9.org/showthread.php?t=159248
### 
### aWarpSharp-ener to define (sharpen) blurry edges, or remove ringing.
###
### dependencies: MVTools2, masktools, aWarpSharp[20090619]
### 
### 
### supsamp [default: 4]
### -------------------
### Interpolation strength. Recommended 4 for
### encoding, 2 for testing. 1 disables it [1...4]
###
###
### post [default: 4]
### -------------------
### Post processing of the sharpened areas for better blending/integration [1...4]
### 1 = no post
### 2 = a little blurring on the sharp new edges...
### 3 = ...or sharpening everywhere else to make the image consistent.
### 4 = or a mix of both
###
###
### Usage:
### 
###      MCaWarpSharp2(4,4)
### 
### 
########################################################################


Function MCaWarpSharp2(clip source, int "supsamp",int "post"){

supsamp = default(supsamp, 4)	# supsamp=2 recommended for testing, supsamp=4 for encoding.
post    = default(post, 4)      # mix the warpsharped edges with original footage thru blur and sharpen post processing
source

# if no supersampling (supsamp=1) -> (thresh=255,blur=3,type=1,depth=8,chroma=4)
# if 4x supersampling (supsamp=4) -> (thresh=192,blur=36,type=1,depth=96,chroma=4)
sourceSup=last.Lanczos4Resize(width*supsamp,height*supsamp)
WarpedEdges=sourceSup.aWarpSharp2(
\ thresh=int(255*pow(supsamp,-0.207)),
\ blur=3*int(pow(supsamp,1.7925)),
\ type=1,depth=8*int(pow(supsamp,1.7925)),chroma=4)

# Getting back to the original shapes with motion compensation to have good and undeformed edges, although still cartoonish look
Interleave(sourceSup,WarpedEdges)

blurredclip=GaussResize(width*2,height*2,p=32*pow(supsamp,-2)).GaussResize(width,height,p=32*pow(supsamp,-2))

super=MSuper(blurredclip, levels=1)
super2=MSuper(last, levels=1)
forward_vectors = MAnalyse(super, blksize=4, levels=1, search=3, searchparam=5, isb=true)
MFlow(super2,forward_vectors)

SelectEvery(2,0)
Lanczos4Resize(width/supsamp,height/supsamp)

# Replacing 'bad' edges with 'good' edges on the original image
edgemask=source.mt_edge("min/max",U=-128,V=-128).blur(1.0)

Assert  ((post >= 1 && post <= 4 )  ? true : false, chr(10) + "'post' have not a correct value! [1,2,3,4]" + chr(10))
post =   (post==1) ? mt_merge(source,last,edgemask,luma=true)
    \  : (post==2) ? mt_merge(last,last.Blur(0.5),edgemask,luma=true)
    \  : (post==3) ? mt_merge(last.LSFmod(defaults="slow",strength=20,edgemode=0,soothe=true,ss_x=1.0,ss_y=1.0),last,edgemask,luma=true)
    \  : (post==4) ? mt_merge(last.LSFmod(defaults="slow",strength=20,edgemode=0,soothe=true,ss_x=1.0,ss_y=1.0),last.Blur(0.5),edgemask,luma=true)
    \  :  blankclip(source, width=width, height=120).SubTitle("post = " + string(post),text_color=$FFFFFF,font="COURIER NEW",size=12,x=320,y=90)

Return post}