function TGMC_SVP_Test( clip Input, bool "SVP" )
{
	SVP = default( SVP, true )
		
	Prefilter  = 2    # Prefilter for search clip: 0 = none, 1 = Gauss blur + slight back blend, 2 = Full TGMC pre-filter
	Sharpness  = 1.5  # TGMC range not QTGMC range
	EdiThreads = 1

	w = Input.Width()
	h = Input.Height()
	epsilon = 0.0001

	bobbed = Input.bob(0,0.5)

	ts1       = bobbed.TemporalSoften( 1, 255,255, 28, 2 )
	ts2       = bobbed.TemporalSoften( 2, 255,255, 28, 2 )
	binomial0 = ts1.Merge( ts2, 0.357 ).Merge( bobbed, 0.125 )

	repair0 = binomial0.DeshimmerRepair( bobbed )

	spatialBlur = Prefilter > 0 ? repair0.RemoveGrain( 12,12 ).GaussResize( w,h, 0,0, w+epsilon,h+epsilon, p=2 ).MergeLuma( repair0, 0.1 ) : repair0
	tweaked     = Prefilter > 1 ? mt_lutxy( repair0, bobbed, "x 3 + y < x 3 + x 3 - y > x 3 - y ? ?", U=3,V=3 ) : NOP()
	srchClip    = Prefilter > 1 ? spatialBlur.mt_lutxy( tweaked, "x 7 + y < x 2 + x 7 - y > x 2 - x 51 * y 49 * + 100 / ? ?", U=3,V=3 ) : spatialBlur

	
	#----------MOTION ANALYSIS - MVTools and/or SVPflow-------------

	# Initial test - have only matched the TGMC overlap to the SVPflow setting, all other settings are the defaults for TGMC or SVPflow
	
	# SVPflow settings for SVSuper and SVAnalyse
	svSuper   = "{ gpu:1, pel:2, scale:{up:2, down:2} }"
	svBlock   = "w:16, overlap:2"
	svSearch  = "type:4, distance:-4, satd:false, coarse:{type:4, distance:-10, satd:true}"
	svPenalty = "lambda:10.0, plevel:1.5, lsad:8000, pnew:50, pglobal:50, pzero:100, pnbour:50, prev:0"
	svAnalyse = "{ gpu:1, vectors:3, block:{" + svBlock + "}, main:{ search:{" + svSearch + "}, penalty:{" + svPenalty + "}}}"

	# MVTools settings for MVSuper and MVAnalyse
	mvSuper   = "pel=2"
	mvBlock   = "blksize=16, overlap=4"
	mvSearch  = "search=4, searchparam=2, pelsearch=2"
	mvPenalty = "truemotion=false, lambda=100*(16*16)/(8*8), lsad=400, pnew=25, plevel=0, global=true, DCT=0"    # (16*16)/(8*8) is (blksize/8)^2
	mvAnalyse = mvBlock + ", " + mvSearch + ", " + mvPenalty
	
	# Calculate forward and backward vectors from search clip using either MVTools2 or SVPflow
	srchSuper = SVP ? srchClip.SVSuper( svSuper ) : Eval("srchClip.MSuper(" + mvSuper + ")")
	vecs1  = SVP ? srchSuper.SVAnalyse( svAnalyse ) : NOP()
	vecs2e = SVP ? srchSuper.SelectEven().SVAnalyse( svAnalyse ) : NOP()
	vecs2o = SVP ? srchSuper.SelectOdd(). SVAnalyse( svAnalyse ) : NOP()
	fVec1 = SVP ? vecs1.SVConvert( isb=false ) : Eval("srchSuper.MAnalyse( isb=false, delta=1, " + mvAnalyse + ")")
	bVec1 = SVP ? vecs1.SVConvert( isb=true  ) : Eval("srchSuper.MAnalyse( isb=true,  delta=1, " + mvAnalyse + ")")
	fVec2 = SVP ? Interleave(vecs2e.SVConvert( isb=false ), vecs2o.SVConvert( isb=false )) : Eval("srchSuper.MAnalyse( isb=false, delta=2, " + mvAnalyse + ")")
	bVec2 = SVP ? Interleave(vecs2e.SVConvert( isb=true  ), vecs2o.SVConvert( isb=true  )) : Eval("srchSuper.MAnalyse( isb=true,  delta=2, " + mvAnalyse + ")")

	#-----------------------------------------------------------

	
	edi = Input.NNEDI3( field=-2, nsize=1, nns=1, qual=1, threads=EdiThreads, U=true,V=true )

	ediSuper = edi.MSuper( pel=2, levels=1 )
	bComp1   = edi.MCompensate( ediSuper, bVec1, thSCD1=180,thSCD2=98 )
	fComp1   = edi.MCompensate( ediSuper, fVec1, thSCD1=180,thSCD2=98 )
	tMax     = edi.mt_logic( fComp1, "max", U=3,V=3 ).mt_logic( bComp1, "max", U=3,V=3 )
	tMin     = edi.mt_logic( fComp1, "min", U=3,V=3 ).mt_logic( bComp1, "min", U=3,V=3 )

	degrain1  = edi.MDegrain1( ediSuper, bVec1,fVec1, thSAD=10*(8*8), thSCD1=180,thSCD2=98 )
	degrain2  = edi.MDegrain1( ediSuper, bVec2,fVec2, thSAD=10*(8*8), thSCD1=180,thSCD2=98 )
	binomial1 = degrain1.Merge( degrain2, 0.2 ).Merge( edi, 0.0625 )

	vresharp = Merge( binomial1.mt_expand( mode="vertical", U=3,V=3 ), binomial1.mt_inpand( mode="vertical", U=3,V=3 ) )
	resharp  = binomial1.mt_lutxy( vresharp.RemoveGrain(12), "x x y - "+ string(Sharpness) + " * +", U=3,V=3 )

	backBlend1 = resharp.mt_makediff( mt_makediff( resharp, binomial1, U=1,V=1 ).RemoveGrain( 12, -1 ).GaussResize( w,h, 0,0, w+epsilon,h+epsilon, p=5 ), U=2,V=2 )

	sharpLimit1 = backBlend1.mt_clamp( tMax,tMin, 0,0, U=3,V=3 )

	stableSuper = sharpLimit1.MSuper( pel=2, levels=1 )
	stable      = sharpLimit1.MDegrain1( stableSuper, bVec1,fVec1, thSAD=4*(8*8), thSCD1=180,thSCD2=98 )

	repair2 = stable.DeshimmerRepair( edi )

	return repair2	
}
	
function DeshimmerRepair( clip Input, clip Ref )
{
	bobdiff   = mt_makediff( Ref, Input, U=3,V=3 )
	choke1    = bobdiff.mt_inpand( mode="vertical", U=3,V=3 ).mt_inpand( mode="vertical", U=3,V=3 ).mt_deflate( U=3,V=3 )
	choke1    = choke1.mt_expand( mode="vertical", U=3,V=3 ).mt_expand( mode="vertical", U=3,V=3 )
	choke2    = bobdiff.mt_expand( mode="vertical", U=3,V=3 ).mt_expand( mode="vertical", U=3,V=3 ).mt_inflate( U=3,V=3 )
	choke2    = choke2.mt_inpand( mode="vertical", U=3,V=3 ).mt_inpand( mode="vertical", U=3,V=3 )
	bobrepair = bobdiff.mt_lutxy( choke1, "x 129 < x y 128 < 128 y ? ?", U=3,V=3 ).mt_lutxy( choke2, "x 127 > x y 128 > 128 y ? ?", U=3,V=3 )
	return      Input.mt_adddiff( bobrepair, U=3,V=3 )
}