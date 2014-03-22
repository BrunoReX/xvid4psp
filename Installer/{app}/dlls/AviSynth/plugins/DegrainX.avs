function DegrainX (clip o, int "sharpen", int "calm", int "rep0",  int "rep2", int "X", int "SAD1", int "bs", int "limit", bool "external_denoiser")
{
# makes MDegrain1-3 for deinterlace
# Calm function is needed

X       = default( X,   3 )       # MVDegrain 1, 2 or 3
sharpen = default( sharpen,   0.45 ) #sharpen strenght
calm    = default( calm, 1)       # use calm() for predenoising as default
bs      = default( bs,  16 )      # blocksize
SAD1    = default( SAD1,    400 ) # Threshold for degraining. Decrease if you see ghosting
limit   = default( limit,   255 ) # Limits maximum change of a pixel. Default means no limit 
ov      = bs/2                    #overlap
rep0      = default( rep0,      4 )    #  repair temporalsoften-defects for searchclip
rep2      = default( rep2,      4 )    #  repair MDegrain-defects for output (stage2)

calm=(calm==1) ? o.Calm(rep0): o

     o_super  =    o.MSuper(pel=2, hpad=16, vpad=16, levels=1) # create the source superclip
  srch_super  = calm.MSuper(pel=2, hpad=16, vpad=16)           # create the calm superclip

bv3  = (X==3) ? srch_super.MAnalyse(isb=true , delta=3, blksize=bs, overlap=ov) : BlankClip
bv2  = (X>=2) ? srch_super.MAnalyse(isb=true , delta=2, blksize=bs, overlap=ov) : BlankClip
bv1  =          srch_super.MAnalyse(isb=true , delta=1, blksize=bs, overlap=ov)

fv1  =          srch_super.MAnalyse(isb=false, delta=1, blksize=bs, overlap=ov)
fv2  = (X>=2) ? srch_super.MAnalyse(isb=false, delta=2, blksize=bs, overlap=ov) : BlankClip
fv3  = (X==3) ? srch_super.MAnalyse(isb=false, delta=3, blksize=bs, overlap=ov) : BlankClip


NR    = (X==3) ? o.MDegrain3(o_super, bv1, fv1, bv2, fv2, bv3, fv3, thSAD=SAD1, limit=limit) : 
 \      (X==2) ? o.MDegrain2(o_super, bv1, fv1, bv2, fv2,           thSAD=SAD1, limit=limit) :
 \               o.MDegrain1(o_super, bv1, fv1,                     thSAD=SAD1, limit=limit)


#NR.mt_lutxy(NR.removegrain(11),"x x y - "+string(1.45)+" * +",U=3,V=3)
   NR.mt_lutxy(NR.removegrain(11),"x x y - "+string(sharpen)+" * +",U=3,V=3)
lt=NR.mt_lutxy(NR.removegrain(11),"x x y - "+string(sharpen)+" * +",U=3,V=3)
        ed0  = rep2<10 ? rep2 : rep2/10
        od0  = rep2<10 ?    0 : rep2-ed0*10
vcrep=lt.VCRep(o,ed=ed0,od=od0)
stackhorizontal(lt, vcrep,Overlay(lt, vcrep, mode="difference", pc_range=true).tweak(sat=3.75))
#return(NR)
return (lt)
return (vcrep)
#return (NR)
}



function Calm (clip clp, int "rep0") 
{
##################################
# PREPARES CLIP FOR MOTION SEARCH
#################################
#needs VCRep

        rep0 = default (rep0, 4)    #  repair temporalsoften-defects for searchclip
        ed0  = rep0<10 ? rep0 : rep0/10
        od0  = rep0<10 ?    0 : rep0-ed0*10
        ox = clp.width()
        oy = clp.height()

# create linearily weighted temporal averaging
ts1 = clp.temporalsoften(1,255,255,28,2)
ts2 = clp.temporalsoften(2,255,255,28,2)

# construct temporal gaussian average from linear averages
t = ts1.merge(ts2,0.357).merge(clp,0.125)

# IF rep0=true: Allow only bob-typical vertical differences
t2 = (rep0!=0) ? t.VCRep(clp,ed=ed0,od=od0) : t

# Create clip for motion search.
t3=mt_lutxy(t2,clp,"x 3 + y < x 3 + x 3 - y > x 3 - y ? ?",U=3,V=3) # small cheat for better motion search
searchclip = t2.removegrain(11).gaussresize(ox,oy,0,0,ox+.0001,oy+.0001,p=2)
 \             .merge(t2,0.1).mt_lutxy(t3,"x 7 + y < x 2 + x 7 - y > x 2 - x 51 * y 49 * + 100 / ? ?",U=3,V=3)
return (searchclip)
}


function VCRep(clip clp, clip ref, int "ed", int "od")
{
#####################################################################
# compare two clips, and allow only differences that are bob-typical
#####################################################################

ed = default(ed,1)  #  e'rosion d'istance: 1 = minimum, 5 = maximum
od = default(od,0)  #  o'ver-d'ilation of the eroded difference: 0=no, 1=somewhat, 2=somewhat more, 3=one full pixel

tD_2   = mt_makediff(ref,clp,U=3,V=3) 

tD1_2  = (ed>=3)        ? tD_2 .mt_inpand(mode="vertical",U=3,V=3) :   tD_2
tD1_2  =                  tD1_2.mt_inpand(mode="vertical",U=3,V=3) 
tD1_2  = (ed!=0&&ed!=3) ? tD1_2.mt_deflate(U=3,V=3)                :   tD1_2
tD1_2  = (ed==2||ed==5) ? tD1_2.removegrain(4)                     :   tD1_2
tD1_2  =                  tD1_2.mt_expand(mode="vertical",U=3,V=3)
tD1_2  = (ed>=2) ?        tD1_2.mt_expand(mode="vertical",U=3,V=3) :   tD1_2
tD1_2  = (ed>=5) ?        tD1_2.mt_expand(mode="vertical",U=3,V=3) :   tD1_2
tD1_2  = (od==0) ?        tD1_2 
 \     : (od==1) ?        tD1_2.mt_inflate(U=3,V=3) 
 \     : (od==2) ?        tD1_2.mt_inflate(U=3,V=3).mt_inflate(U=3,V=3)
 \               :        tD1_2.mt_expand(U=3,V=3)

tD2_2  = (ed>=3)        ? tD_2 .mt_expand(mode="vertical",U=3,V=3) :   tD_2
tD2_2  =                  tD2_2.mt_expand(mode="vertical",U=3,V=3) 
tD2_2  = (ed!=0&&ed!=3) ? tD2_2.mt_inflate(U=3,V=3)                :   tD2_2
tD2_2  = (ed==2||ed==5) ? tD2_2.removegrain(4)                     :   tD2_2
tD2_2  =                  tD2_2.mt_inpand(mode="vertical",U=3,V=3)
tD2_2  = (ed>=2) ?        tD2_2.mt_inpand(mode="vertical",U=3,V=3) :   tD2_2
tD2_2  = (ed>=5) ?        tD2_2.mt_inpand(mode="vertical",U=3,V=3) :   tD2_2
tD2_2  = (od==0) ?        tD2_2 
 \     : (od==1) ?        tD2_2.mt_deflate(U=3,V=3) 
 \     : (od==2) ?        tD2_2.mt_deflate(U=3,V=3).mt_deflate(U=3,V=3)
 \               :        tD2_2.mt_inpand(U=3,V=3)

tDD_2  = tD_2.mt_lutxy(tD1_2,"x 129 < x y 128 < 128 y ? ?",U=3,V=3).mt_lutxy(tD2_2,"x 127 > x y 128 > 128 y ? ?",U=3,V=3)
clp.mt_adddiff(tDD_2,U=3,V=3)
}
