######################################################################
#                                                                                                                                                                                                       
#  ~HQDegrain v0.9.2 by Alek93j~  29/06/2011                                                                                                                                          
#                                                                                                                                                                                                        
# Required MVtools2.dll    http://avisynth.org.ru/mvtools/mvtools2.html                                                                                                                            
#       ttempsmooth.dll    http://avisynth.org.ru/docs/english/...tempSmooth.htm                           
#   mt_masktools-25.dll    http://manao4.free.fr/masktools-v2.0a48.zip                                  
#       blockbuster.dll    http://kvcd.net/sansgrip/avisynth/                             
#       removegrain.dll    http://avisynth.org/mediawiki/Removegrain 
#                                               
# ~Syntax~       
 ##################################################################################
#                                                                                                                   
# # It doesn't work perfectely with sudden luma changes such as fades, so it                            
# # is best not to filter those parts.                                                                              
#                                                                                                                  
# -Example of a Backup of a NTSC DvD-                                                                             
#                                                                                                                   
# MPEG2Source("C:\blabla.d2v")                                                                                    
# ivtc() (your prefer ivtc ectr)                                                                                 
# A=hqdegrain() (Clip normally processed)                                                                            
# B=ttempsmoothf(maxr=7,strength=5,lthresh=3,cthresh=4) (or your prefer denoise for clean fade)                 
# B.Trim(0,215)+A.Trim(216,31464)                                                                                
#                                                                                                                  
 ###########################################################################

Function HQDegrain(clip clp,int"Degrain",int"limit",string"preset",bool"HQ",\
                   int"maxr",int"strength",int"lthresh",int"cthresh",\
                   clip"PreNoise",int"BkSize",bool"noise",bool"lmask",\
                   int"Blk",int"PEL",int"DCT",int"Overlap",\
                   int "thSAD", int "thSADC",int "thSCD1", int "thSCD2")
{

#Presets available "Fast" - "Slow"

Preset=Default(Preset,"Slow")
pset=(Preset=="Fast") ? 0 : 1
	
#MDegrain Strength

Degrain = Default( Degrain , Select(pset,1,2)) # Means how many frame should be analyzed for a better result, 3 doesn't help much.
limit   = Default( limit   , 255   ) # limit of mvdegrain. (255 mean no limits)

#ttempsmoothf Strength

HQ      = Default( HQ      , Select(pset,false,true)) # Reduce artefact...
maxr    = Default( maxr    , Select(pset,3,5))
strength= Default( strength, Select(pset,3,4))
lthresh = Default( lthresh , Select(pset,2,3))
cthresh = Default( cthresh , Select(pset,3,4))

#Noise Filter

Noise   = Default( Noise   , true  )
BkSize  = Default( BkSize  , 8     )
lmask   = Default( lmask   , Select(pset,false,true)) #if lmask is true, noise will not be added in the parts of the image with high luma values, because generally there is no need to filter them.

#Motion Vector Analyse

Blk     = Default( Blk     , 8     ) # Use 16/for 1080p - 8/for 720p - 4/for 480p to avoid unnecessary slowdowns.
PEL     = Default( PEL     , 2     )
DCT     = Default( DCT     , 0     )
OPS     = Blk/2
Overlap = Default( Overlap , Select(pset,0,OPS))

#Threshold Setting

thSAD   = Default( thSAD   , 180   ) # Lower values will reduce artefacts for bad motion vectors, but they will also have a lighter denoising effect. For animated sources, 120 seems to be a good setting to start with.
thSADC  = Default( thSADC  , thSAD )
thSCD1  = Default( thSCD1  , 400   )
thSCD2  = Default( thSCD2  , 102   )

#Processing

input = clp

mask = clp.invert().levels(82,1,155,0,255,coring=false).Removegrain(12)

nse  = defined(PreNoise) ? PreNoise 
       \: (Noise==true) ? clp.blockbuster(method="noise",Block_size=BkSize) : clp

clp = (Noise==false) ? clp : (lmask==true) ? mt_merge(clp,nse,mask) : nse

sup = clp.Msuper(hpad=Blk,vpad=Blk,PEL=PEL,levels=0)

BV1 = MAnalyse(sup,isb=true ,truemotion=true,delta=1,blksize=Blk,blksizeV=Blk,DCT=DCT,overlap=Overlap)
FV1 = MAnalyse(sup,isb=false,truemotion=true,delta=1,blksize=Blk,blksizeV=Blk,DCT=DCT,overlap=Overlap)

BV2 = (Degrain>=2) ? MAnalyse(sup,isb=true ,truemotion=true,delta=2,blksize=Blk,blksizeV=Blk,DCT=DCT,overlap=Overlap) : Blackness () 
FV2 = (Degrain>=2) ? MAnalyse(sup,isb=false,truemotion=true,delta=2,blksize=Blk,blksizeV=Blk,DCT=DCT,overlap=Overlap) : Blackness () 

BV3 = (Degrain==3) ? MAnalyse(sup,isb=true ,truemotion=true,delta=3,blksize=Blk,blksizeV=Blk,DCT=DCT,overlap=Overlap) : Blackness () 
FV3 = (Degrain==3) ? MAnalyse(sup,isb=false,truemotion=true,delta=3,blksize=Blk,blksizeV=Blk,DCT=DCT,overlap=Overlap) : Blackness () 

clp = (degrain==1) ? clp.MDegrain1(sup,BV1,FV1,                thSAD=thSAD,thSADC=thSADC,thSCD1=thSCD1,thSCD2=thSCD2,limit=limit): 
 \    (degrain==2) ? clp.MDegrain2(sup,BV1,FV1,BV2,FV2,        thSAD=thSAD,thSADC=thSADC,thSCD1=thSCD1,thSCD2=thSCD2,limit=limit):
 \                   clp.MDegrain3(sup,BV1,FV1,BV2,FV2,BV3,FV3,thSAD=thSAD,thSADC=thSADC,thSCD1=thSCD1,thSCD2=thSCD2,limit=limit)

Diff1 = mt_makediff(input,clp,U=3,V=3)

clp2  = clp.ttempsmoothf(maxr=maxr,strength=strength,lthresh=lthresh,cthresh=cthresh)

Diff2 = mt_makediff(input,clp2,U=3,V=3)

lutxy = mt_lutxy(Diff1,Diff2,"x 128 - abs y 128 - abs < x y ?")

output = (HQ==true) ? Input.mt_makediff(lutxy,U=3,V=3) : clp2

output }
