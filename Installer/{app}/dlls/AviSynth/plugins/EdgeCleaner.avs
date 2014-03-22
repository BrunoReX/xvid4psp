# EdgeCleaner() v1.04 (03/04/2012)
# - a simple edge cleaning and weak dehaloing function
#
# Description:
# Functions have been briefly tested to work with MT on mode 1 and 2 without any problems
#
# Requirements:
# aWarpSharp (SEt's updated version), mt_masktools, Repair (optional), RemoveGrain (optional) and Deen (optional) plugins required
# YV12 input required and mod16 or even mod32 input is preferred since aWarpSharp borks sometimes
#
# Parameters:
# strength (float)      - specifies edge denoising strength (10)
# rep (boolean)         - actives Repair for the aWarpSharped clip (true; requires Repair)
# rmode (integer)       - specifies the Repair mode; 1 is very mild and good for halos, 
#                         16 and 18 are good for edge structure preserval on strong settings but keep more halos and edge noise, 
#                         17 is similar to 16 but keeps much less haloing, other modes are not recommended (17; requires Repair)
# smode (integer)       - specifies what method will be used for finding small particles, ie stars; 0 is disabled, 
#                         1 uses RemoveGrain and 2 uses Deen (0; requires RemoveGrain/Repair/Deen)
# hot (boolean)         - specifies whether removal of hot pixels should take place (false)


function EdgeCleaner(clip c, int "strength", bool "rep", int "rmode", int "smode", bool "hot") {

    strength    = default(strength, 10)
    rep         = default(rep, true)
    rmode       = default(rmode, 17)
    smode       = default(smode, 0)
    hot         = default(hot, false)

    c           = (c.isYV12()) ? c : c.ConvertToYV12()
    strength    = (smode==0) ? strength : strength+4

    main	= c.aWarpSharp2(depth=Round(strength/2),blur=1) 
    main        = (rep) ? Repair(main,c,rmode) : main

    mask        = c.mt_edge("prewitt",4,32,4,32).mt_invert().mt_convolution()

    final       = (!hot) ? mt_merge(c,main,mask) : Repair(mt_merge(c,main,mask),c,2)
    final       = (smode != 0) ? mt_merge(final,c,c.StarMask(smode)) : final

    return final

}

function StarMask(clip c, int "mode") {

    mode        = default(mode, 1)

    clean       = (mode==1) ? c.RemoveGrain(17) : Repair(c.Deen("a3d",4,12,0),c,15).RemoveGrain(21)
    diff        = (mode==1) ? mt_makediff(c,clean) : NOP
    
    final       = (mode==1) ? diff.Greyscale().Levels(40,0.350,168,0,255).removegrain(7,-1).mt_edge("prewitt",4,16,4,16) : \
                  Subtract(mt_merge(clean,c,c.mt_edge("roberts",0,2,0,2).mt_expand(mode=mt_circle(1)).mt_invert()),c).mt_edge("roberts",0,0,0,0).mt_deflate()
    
    return final

}
