function Killer(clip source, int temporal, int "blksize", int "overlap", int "sharp", int "thSAD", int "dct", bool "RefineMotion", bool"truemotion")
{ 
# Motion compensated denoiser for progressive source clip with prefiltering for strength and repair for de-artefacting
# Uses MVTools2, ReduceFlicker and RemoveGrain/Repair

blksize       = default(blksize,16)          # blksize value (4, 8 or 16)
overlap       = default(overlap,blksize/2)   # overlap value (0 to half blksize)
sharp         = default(sharp,2)             # 0=bilinear softest, 1=bicubic, 2=Wiener sharpest
thSAD         = default(thSAD,400)           # higher risks motion ghosting and swimming, lower risks blotchy denoising
dct           = default(dct,5)
RefineMotion  = default(RefineMotion,true)   # true means MRecalculate will be used to improve motion vectors

halfblksize   = blksize/2                    # MRecalculate works with half block size
halfoverlap   = overlap/2                    # Halve the overlap to suit the halved block size
halfthSAD     = thSAD/2                      # MRecalculate uses a more strict thSAD, which defaults to 150 (half of function's default of 300)
truemotion    = default(truemotion,false)


source        = source.assumeframebased()    # MSuper pel=2 is faster with this

# Prefilter the clip
calm          = source.reduceflicker(strength=3,aggressive=true)
calm          = calm.repair(source,mode=1)
calm          = calm.removegrain(mode = 17)
calm          = calm.removegrain(mode = 17)
calm          = calm.removegrain(mode = 17)

calm_super    = calm.MSuper(pel=2, hpad=blksize, vpad=blksize, sharp=sharp)
source_super  = source.MSuper(pel=2, hpad=blksize, vpad=blksize, sharp=sharp,levels=1)
recalculate   = calm.MSuper(pel=2, hpad=blksize, vpad=blksize, sharp=sharp,levels=1)

backward_vec3 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 3, overlap=overlap, truemotion=truemotion, dct=dct)
backward_vec3 = RefineMotion ? MRecalculate(recalculate, backward_vec3, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD) : backward_vec3
backward_vec2 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 2, overlap=overlap, truemotion=truemotion, dct=dct)
backward_vec2 = RefineMotion ? MRecalculate(recalculate, backward_vec2, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD) : backward_vec2
backward_vec1 = MAnalyse(calm_super, blksize=blksize, isb = true, delta = 1, overlap=overlap, truemotion=truemotion, dct=dct)
backward_vec1 = RefineMotion ? MRecalculate(recalculate, backward_vec1, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD) : backward_vec1

forward_vec1  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 1, overlap=overlap, truemotion=truemotion, dct=dct)
forward_vec1  = RefineMotion ? MRecalculate(recalculate, forward_vec1, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD) : forward_vec1
forward_vec2  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 2, overlap=overlap, truemotion=truemotion, dct=dct)
forward_vec2  = RefineMotion ? MRecalculate(recalculate, forward_vec2, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD) : forward_vec2
forward_vec3  = MAnalyse(calm_super, blksize=blksize, isb = false, delta = 3, overlap=overlap, truemotion=truemotion, dct=dct)
forward_vec3  = RefineMotion ? MRecalculate(recalculate, forward_vec3, blksize=halfblksize, overlap=halfoverlap, thSAD=halfthSAD) : forward_vec3

temporal == 3 ? MDegrain3(source, source_super, backward_vec1, forward_vec1, backward_vec2, forward_vec2, backward_vec3, forward_vec3, thSAD=thSAD) : \
temporal == 2 ? MDegrain2(source, source_super, backward_vec1, forward_vec1, backward_vec2, forward_vec2, thSAD=thSAD) : \
                MDegrain1(source, source_super, backward_vec1, forward_vec1, thSAD=thSAD)
repair(source,mode=17)
}


