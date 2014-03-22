function MVDouble(Clip, "PFC", bool "IsPlanar", "bs", "olap", "precision", "sharpness", "matchmethod",\
                          "badSADth", "badSADrange", int "lamfactor", int "ml", bool "blend", bool "debug", "diag_sw")
{
	Prefiltered = Default(PFC, Clip.blur(1.0)) 
	IsPlanar = Default(IsPlanar, false)
	bs = Default(bs, 16)			# (Default blocksize in MAnalyse is 8)
	olap = Default(olap, bs/2)
	precision=Default(precision, 2)  	# (The MVTools default is 2)
	sharpness = Default(sharpness, 2)	# (The MVTools default is 2)
	matchmethod = Default(matchmethod, 0)	# (The MVTools default is 0 (SAD). Try also 5 (SATD).
	badSADth = Default(badSADth, 10000)	# (The MVTools default is 10000 (off). Lower threshold = likelier
						#        to reject best local match, and search further afield.)
	badSADrange = Default(badSADrange, 24)	# (The MVTools default is 24 pixels)
	lamfactor = Default(lamfactor, 1000)
	lam = lamfactor*bs*bs/64
	ml = Default(ml, 100)
	blend = Default(blend, false)	# 
	debug = Default(debug, false)
	diag_sw = Default(diag_sw, false)	# 
 
	Super = Clip.MSuper(planar=IsPlanar, levels=1, hpad=bs, vpad=bs, pel=precision, sharp=sharpness)	# one level is enough for MCompensate
	SuperFilt = Prefiltered.MSuper(planar=IsPlanar, hpad=bs, vpad=bs, pel=precision, sharp=sharpness)  	# all levels for MAnalyse
 
	# Obtain vectors (with overlap):
	bw1 = MAnalyse(SuperFilt, isb = true, blksize=bs, levels=0, lambda=lam, overlap=olap,\
                                                  dct=matchmethod, badSAD=badSADth, badrange=badSADrange)
	fw1 = MAnalyse(SuperFilt, isb = false, blksize=bs, levels=0, lambda=lam, overlap=olap, \
                                                dct=matchmethod, badSAD=badSADth, badrange=badSADrange)
    
	# Next step: Interpolation of new frames.
	Plus50 = MFlowInter(Clip, Super, bw1, fw1, 50, planar=IsPlanar, ml=ml, blend=blend)
	Diag = MShow (SuperFilt.levels(0,1,255,0,191), bw1, scale=1, planar=IsPlanar, showsad=false).crop(bs,bs,width(Clip),Height(clip) ) 
	Diag2 = Interleave(Diag, Plus50.levels(0,1,255,0,191) )
	Diag3 = Average( Diag2, 0.333, Diag2, 0.333, Diag2.DuplicateFrame(0), 0.333 )
	Interp = diag_sw ? Diag3 : debug ? Diag3 : Interleave(Clip, Plus50)
 
	return(Interp)
}
