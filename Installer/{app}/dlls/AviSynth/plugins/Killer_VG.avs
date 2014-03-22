function Killer(clip source, int temporal, clip "ref", int "calm", int "blksize", int "overlap", int "sharp", int "thSAD"\ 
                , bool "oversharp", clip "sharpclip", bool "RefineMotion", int "limit", int "search", int "dct", bool "dark"\ 
                , int "pel", int "flux", bool "gamma", bool "Full") 
{ # Motion compensated denoiser for progressive source clip with prefiltering for strength and repair for de-artefacting 
  # Uses MVTools2, ReduceFlicker and RemoveGrain/Repair 

blksize       = default(blksize,16)          # blksize value (4, 8 or 16) 
overlap       = default(overlap,blksize/2)   # overlap value (0 to half blksize) 
sharp         = default(sharp,2)             # 0=bilinear softest, 1=bicubic, 2=Wiener sharpest 
thSAD         = default(thSAD,300)           # higher risks motion ghosting and swimming, lower risks blotchy denoising 
RefineMotion  = default(RefineMotion,true)   # true means MRecalculate will be used to improve motion vectors 
limit         = default(limit, 255)          # Limits maximum change of a pixel. Default means no limit 
ref           = default(ref, source)         # Reference (calmed) clip 
presharpclip  = source.KillerSharp()         # Pre sharp if need 
sharpclip     = default(sharpclip, presharpclip)   # sharp clip 
calm          = default(calm, 1)             # use calm() for predenoising as default 
dct           = default(dct, 5)              # SATD instead of SAD for brightness 
search        = default(search, 5)           # Search Uneven multi hexagons (UMH), searchparam parameter determines the range. (like the x264).     
oversharp     = default(oversharp, true)     # Pre sharp the clip 
dark          = default(dark, false)         # mode for dark movies 
pel           = default(pel, 2)              # Value can only be 1, 2 or 4. 1 means a precision to the pixel. 2 means a precision to half a pixel, 4 means a precision to quarter a pixel 
flux          = default(flux,  5)            # default calm mode for flux for killer 
gamma         = default(gamma, false)        # mode for dark movies 
Full          = default(Full, false)         # full strength, false for repair at end 
halfblksize   = blksize/2                    # MRecalculate works with half block size 
halfoverlap   = overlap/2                    # Halve the overlap to suit the halved block size 
halfthSAD     = thSAD/2                      # MRecalculate uses a more strict thSAD, which defaults to 150 (half of function's default of 300) 
#Also, the default values thSCD1=400, thSCD2=130 often do not reckognize some scenechanges,  
#especially in dimmed/dark scenery. lowering to sth like 350,90 is more safe in reckognizing scenechanges ...  
#however, the more you lower these values, the more there is danger that the detection  
#erroneously triggers during bright/complex scenery with lots of motion. 
thSCD1        = (dark==true) ? 350 : 400 
thSCD2        = (dark==true) ? 90  : 130 

pel           = (temporal>3) ? 1 : pel 
source        = source.assumeframebased()    # MSuper pel=2 is faster with this 

# Prefilter the clip 
calm=(calm==1) ? ref.KillerCalm(flux=flux, gamma=gamma): ref 
# Presharp the clip 
sharp0 = (oversharp==true) ? sharpclip : source 

calm_super    = calm.MSuper(pel=pel, hpad=blksize, vpad=blksize, sharp=sharp) 
source_super  = sharp0.MSuper(pel=pel, hpad=blksize, vpad=blksize, sharp=sharp,levels=1) 
recalculate   = calm.MSuper(pel=pel, hpad=blksize, vpad=blksize, sharp=sharp,levels=1) 

bv9 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 9, overlap=overlap, dct=dct, search=search) 
bv9 = RefineMotion ? MRecalculate(recalculate, bv9, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : bv9 
bv8 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 8, overlap=overlap, dct=dct, search=search) 
bv8 = RefineMotion ? MRecalculate(recalculate, bv8, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : bv8 
bv7 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 7, overlap=overlap, dct=dct, search=search) 
bv7 = RefineMotion ? MRecalculate(recalculate, bv7, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : bv7 
bv6 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 6, overlap=overlap, dct=dct, search=search) 
bv6 = RefineMotion ? MRecalculate(recalculate, bv6, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : bv6 
bv5 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 5, overlap=overlap, dct=dct, search=search) 
bv5 = RefineMotion ? MRecalculate(recalculate, bv5, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : bv5 
bv4 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 4, overlap=overlap, dct=dct, search=search) 
bv4 = RefineMotion ? MRecalculate(recalculate, bv4, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : bv4 
bv3 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 3, overlap=overlap, dct=dct, search=search) 
bv3 = RefineMotion ? MRecalculate(recalculate, bv3, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : bv3 
bv2 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 2, overlap=overlap, dct=dct, search=search) 
bv2 = RefineMotion ? MRecalculate(recalculate, bv2, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : bv2 
bv1 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 1, overlap=overlap, dct=dct, search=search) 
bv1 = RefineMotion ? MRecalculate(recalculate, bv1, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : bv1 

fv1  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 1, overlap=overlap, dct=dct, search=search) 
fv1  = RefineMotion ? MRecalculate(recalculate, fv1, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : fv1 
fv2  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 2, overlap=overlap, dct=dct, search=search) 
fv2  = RefineMotion ? MRecalculate(recalculate, fv2, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : fv2 
fv3  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 3, overlap=overlap, dct=dct, search=search) 
fv3  = RefineMotion ? MRecalculate(recalculate, fv3, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : fv3 
fv4  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 4, overlap=overlap, dct=dct, search=search) 
fv4  = RefineMotion ? MRecalculate(recalculate, fv4, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : fv4 
fv5  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 5, overlap=overlap, dct=dct, search=search) 
fv5  = RefineMotion ? MRecalculate(recalculate, fv5, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : fv5 
fv6  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 6, overlap=overlap, dct=dct, search=search) 
fv6  = RefineMotion ? MRecalculate(recalculate, fv6, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : fv6 
fv7  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 7, overlap=overlap, dct=dct, search=search) 
fv7  = RefineMotion ? MRecalculate(recalculate, fv7, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : fv7 
fv8  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 8, overlap=overlap, dct=dct, search=search) 
fv8  = RefineMotion ? MRecalculate(recalculate, fv8, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : fv8 
fv9  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 9, overlap=overlap, dct=dct, search=search) 
fv9  = RefineMotion ? MRecalculate(recalculate, fv9, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD, search=search) : fv9 

temporal == 9 ? Eval(""" 
        dg123 = source.MDegrain3(source_super, bv1,fv1,bv2,fv2,bv3,fv3, thSAD=thSAD+thSAD/10, limit=limit, thSCD1=thSCD1, thSCD2=thSCD2)  
        dg456 = source.MDegrain3(source_super, bv4,fv4,bv5,fv5,bv6,fv6, thSAD=thSAD, limit=limit, thSCD1=thSCD1, thSCD2=thSCD2) 
        dg789 = source.MDegrain3(source_super, bv7,fv7,bv8,fv8,bv9,fv9, thSAD=thSAD-thSAD/10, limit=limit, thSCD1=thSCD1, thSCD2=thSCD2) 
# 
#        Average( dg123, 1./3., dg456, 1./3., dg789, 1./3.) 
#OR 
#        merge(dg456,dg789).merge(dg123,0.3334) 
#OR 
         Mt_lutxyz(dg123, dg456, dg789,"x 3 / y 3 / + z 3 / +") 
# 
        """) :\ 
temporal == 5 ? Eval(""" 
        mdg3 = source.MDegrain3(source_super,bv1,fv1,bv2,fv2,bv3,fv3,thSAD=thSAD, limit=limit, thSCD1=thSCD1, thSCD2=thSCD2) 
        mdg3.MDegrain2(source_super,bv4,fv4,bv5,fv5,thSAD=thSAD, limit=limit, thSCD1=thSCD1, thSCD2=thSCD2) 
         \           .Merge(mdg3, 0.455) # correct weightings (hopefully)   
        """) :\ 
temporal == 3 ? MDegrain3(source, source_super, bv1, fv1, bv2, fv2, bv3, fv3, thSAD=thSAD, limit=limit, thSCD1=thSCD1, thSCD2=thSCD2) :\ 
temporal == 2 ? MDegrain2(source, source_super, bv1, fv1, bv2, fv2, thSAD=thSAD, limit=limit, thSCD1=thSCD1, thSCD2=thSCD2)  :\ 
                MDegrain1(source, source_super, bv1, fv1, thSAD=thSAD, limit=limit, thSCD1=thSCD1, thSCD2=thSCD2) 

Full == false ? repair(sharp0,mode=17) : last 
} 

function KillerCalm (clip ref, int "flux", bool "gamma") 
{ 
flux          = default(flux,  7)             # calm mode 
gamma         = default(gamma, false)         # mode for dark movies 
calm          = (flux >= 0) ? ref.FluxSmoothT(temporal_threshold=flux) : ref.reduceflicker(strength=3,aggressive=true) 
calm          = calm.repair(ref,mode=1) 
calm          = (gamma == true) ? calm.levels(0, 2, 255, 0, 255, coring = false) : calm 
calm          = calm.removegrain(mode = 17) 
calm          = calm.removegrain(mode = 17) 
calm          = calm.removegrain(mode = 17) 
return calm 
} 

function KillerSharp (clip ref) 
{ 
 return ref.Seesaw(nrlimit=0, nrlimit2=0, sstr=2.0, sootheT=0, sootheS=0, Slimit=50, Sdamplo=29, Spower=1, SdampHi=35).mergechroma(ref) 
 #return ref.Seesaw(nrlimit=0, nrlimit2=99, bias=49, sstr=1.24, Spower=3, Szp=12, Sdamplo=4, SdampHi=19, Slimit=99,  sootheT=0, sootheS=0) 
}  