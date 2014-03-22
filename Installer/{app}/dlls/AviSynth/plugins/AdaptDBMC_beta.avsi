FUNCTION AdaptDBMC(clip i,
\                  float "Y",         float "Cb",        float  "Cr",
\                  float "grainY",   float "grainC",   string "f3k_param",
\                  float "Luma_Cpst", float "Fade_Cpst", float  "Blue_Cpst",
\                  int "radius", int "blksize",   int "overlap", bool "truemotion", bool "MVGlobal",
\                  int "pel",    int "pelsearch", int "search",  int "searchparam",
\                  int "thSAD",  int "thSAD2",    int "thSCD1",  int "thSCD2",
\                  bool "info")
{

last = i
res  = width * height

Y           = Default( Y,             24 )
Cb          = Default( Cb,            24 )
Cr          = Default( Cr,            24 )
grainY     = Default( grainY,       24 )
grainC     = Default( grainC,       24 )

Luma_Cpst   = Default( Luma_Cpst,      2 ) # Luma compensate factor
Fade_Cpst   = Default( Fade_Cpst,      1 ) # Fade compensate addition
Blue_Cpst   = Default( Blue_Cpst,      1 ) # Blue compensate addition

radius      = Default( radius,         2 )
blksize     = ( res <= 589824 ) ? Default( blksize,  8 ) :
\                                 Default( blksize, 16 )
overlap     = ( res <= 589824 ) ? Default( overlap,  4 ) :
\                                 Default( overlap,  8 )
pel         = Default( pel,            2 )
pelsearch   = Default( pelsearch,      2 )
search      = Default( search,         2 )
searchparam = Default( searchparam,    2 )
MVGlobal    = Default( MVGlobal,    true )
truemotion  = Default( truemotion, false )
thSAD       = Default( thSAD,        300 )
thSAD2      = Default( thSAD2,       300 )
thSCD1      = Default( thSCD1,       300 )
thSCD2      = Default( thSCD2,       100 )

info        = Default( info,       false )

Assert( Y>=0,  "AdaptDBMC: Y can't be negative!" )
Assert( Cb>=0, "AdaptDBMC: Cb can't be negative!" )
Assert( Cr>=0, "AdaptDBMC: Cr can't be negative!" )
Assert( grainY>=0, "AdaptDBMC: grainY can't be negative!" )
Assert( grainC>=0, "AdaptDBMC: grainC can't be negative!" )
Assert( Luma_Cpst>=0, "AdaptDBMC: Luma_Cpst can't be negative!" )
Assert( Fade_Cpst>=0, "AdaptDBMC: Fade_Cpst can't be negative!" )
Assert( Blue_Cpst>=0, "AdaptDBMC: Blue_Cpst can't be negative!" )
Assert( radius>0 && radius <=6, "AdaptDBMC: radius ranges from 1 to 6!" )

nullclip    = BlankClip()

MVS = MSuper(hpad=0, vpad=0, pel=pel, sharp=0, chroma=false)
f1v = (radius<1) ? nullclip
\   :              MVS.MAnalyse(isb=false, delta=1, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)
f2v = (radius<2) ? nullclip
\   :              MVS.MAnalyse(isb=false, delta=2, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)
f3v = (radius<3) ? nullclip
\   :              MVS.MAnalyse(isb=false, delta=3, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)
f4v = (radius<4) ? nullclip
\   :              MVS.MAnalyse(isb=false, delta=4, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)
f5v = (radius<5) ? nullclip
\   :              MVS.MAnalyse(isb=false, delta=5, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)
f6v = (radius<6) ? nullclip
\   :              MVS.MAnalyse(isb=false, delta=6, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)
b1v = (radius<1) ? nullclip
\   :              MVS.MAnalyse(isb=true, delta=1, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)
b2v = (radius<2) ? nullclip
\   :              MVS.MAnalyse(isb=true, delta=2, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)
b3v = (radius<3) ? nullclip
\   :              MVS.MAnalyse(isb=true, delta=3, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)
b4v = (radius<4) ? nullclip
\   :              MVS.MAnalyse(isb=true, delta=4, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)
b5v = (radius<5) ? nullclip
\   :              MVS.MAnalyse(isb=true, delta=5, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)
b6v = (radius<6) ? nullclip
\   :              MVS.MAnalyse(isb=true, delta=6, truemotion=truemotion, blksize=blksize, overlap=overlap, pelsearch=pelsearch, search=search, searchparam=searchparam, DCT=0, global=MVglobal, chroma=false)

SAD_f1m = MMask(f1v, kind=1, ml=thSAD, gamma=0.999, Ysc=255)
SAD_b1m = MMask(b1v, kind=1, ml=thSAD, gamma=0.999, Ysc=255)
f1c     = MCompensate(MVS, f1v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2)
b1c     = MCompensate(MVS, b1v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2)

b2c = (radius>=2)  ? i.MCompensate(MVS, b2v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2) : nullclip
b3c = (radius>=3)  ? i.MCompensate(MVS, b3v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2) : nullclip
b4c = (radius>=4)  ? i.MCompensate(MVS, b4v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2) : nullclip
b5c = (radius>=5)  ? i.MCompensate(MVS, b5v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2) : nullclip
b6c = (radius>=6)  ? i.MCompensate(MVS, b6v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2) : nullclip
f2c = (radius>=2)  ? i.MCompensate(MVS, f2v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2) : nullclip
f3c = (radius>=3)  ? i.MCompensate(MVS, f3v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2) : nullclip
f4c = (radius>=4)  ? i.MCompensate(MVS, f4v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2) : nullclip
f5c = (radius>=5)  ? i.MCompensate(MVS, f5v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2) : nullclip
f6c = (radius>=6)  ? i.MCompensate(MVS, f6v, thSAD=thSAD, thSCD1=thSCD1, thSCD2=thSCD2) : nullclip

c = (radius==6) ? interleave(f6c, f5c, f4c, f3c, f2c, f1c, i, b1c, b2c, b3c, b4c, b5c, b6c)
\ : (radius==5) ? interleave(     f5c, f4c, f3c, f2c, f1c, i, b1c, b2c, b3c, b4c, b5c     )
\ : (radius==4) ? interleave(          f4c, f3c, f2c, f1c, i, b1c, b2c, b3c, b4c          )
\ : (radius==3) ? interleave(               f3c, f2c, f1c, i, b1c, b2c, b3c               )
\ : (radius==2) ? interleave(                    f2c, f1c, i, b1c, b2c                    )
\ : (radius==1) ? interleave(                         f1c, i, b1c                         )
\ : i

last = c

### Luma adaptive factor
global AdaptLuma = (Luma_Cpst==0) ? "1"
\                : "( ( ( AverageLuma > 160 ) ? Pow( ( 256.0 - AverageLuma ) / 96, "+String(Luma_Cpst)+" ) : Log( ( 256.0 - AverageLuma ) / 96 ) * "+String(Luma_Cpst)+" + 1 ) / "+String(Luma_Cpst)+" / 2 + 1 )"

### Blue compensate value
global AdaptBlue = """( AverageLuma( CRGB32.ShowBlue("YV12").Overlay(CRGB32.ShowRed("YV12"), mode="subtract") ) / 96.0 * """+String(Blue_Cpst)+" )"

### Fade compensate value
global FadeDenom = ( radius==0 ) ? 1 : 384.0 * radius
global AdaptFade = (Fade_Cpst==0) ? "0"
\                : (radius==1) ? "( log( (YDifferenceFromPrevious+YDifferenceToNext)/"+String(FadeDenom)+"+1 ) * "+String(Fade_Cpst)+" )"
\                : (radius==2) ? "( log( (loop(2,0,-1).YDifferenceFromPrevious+YDifferenceFromPrevious+YDifferenceToNext+loop(0,0,-1).YDifferenceToNext)/"+String(FadeDenom)+"+1 ) * "+String(Fade_Cpst)+" )"
\                : (radius==3) ? "( log( (loop(3,0,-1).YDifferenceFromPrevious+loop(2,0,-1).YDifferenceFromPrevious+YDifferenceFromPrevious+YDifferenceToNext+loop(0,0,-1).YDifferenceToNext+loop(0,0,1).YDifferenceToNext)/"+String(FadeDenom)+"+1 ) * "+String(Fade_Cpst)+" )"
\                : (radius==4) ? "( log( (loop(4,0,-1).YDifferenceFromPrevious+loop(3,0,-1).YDifferenceFromPrevious+loop(2,0,-1).YDifferenceFromPrevious+YDifferenceFromPrevious+YDifferenceToNext+loop(0,0,-1).YDifferenceToNext+loop(0,0,1).YDifferenceToNext+loop(0,0,2).YDifferenceToNext)/"+String(FadeDenom)+"+1 ) * "+String(Fade_Cpst)+" )"
\                : (radius==5) ? "( log( (loop(5,0,-1).YDifferenceFromPrevious+loop(4,0,-1).YDifferenceFromPrevious+loop(3,0,-1).YDifferenceFromPrevious+loop(2,0,-1).YDifferenceFromPrevious+YDifferenceFromPrevious+YDifferenceToNext+loop(0,0,-1).YDifferenceToNext+loop(0,0,1).YDifferenceToNext+loop(0,0,2).YDifferenceToNext+loop(0,0,3).YDifferenceToNext)/"+String(FadeDenom)+"+1 ) * "+String(Fade_Cpst)+" )"
\                : (radius==6) ? "( log( (loop(6,0,-1).YDifferenceFromPrevious+loop(5,0,-1).YDifferenceFromPrevious+loop(4,0,-1).YDifferenceFromPrevious+loop(3,0,-1).YDifferenceFromPrevious+loop(2,0,-1).YDifferenceFromPrevious+YDifferenceFromPrevious+YDifferenceToNext+loop(0,0,-1).YDifferenceToNext+loop(0,0,1).YDifferenceToNext+loop(0,0,2).YDifferenceToNext+loop(0,0,3).YDifferenceToNext+loop(0,0,4).YDifferenceToNext)/"+String(FadeDenom)+"+1 ) * "+String(Fade_Cpst)+" )"
\                : "0"
### Calculate complexity of a frame
global c_Complex = "Exp( LumaDifference( RemoveGrain(24, 0, 0) ) + 1 )"
### Fading frames should have comparatively low luma value and low complexity
global AdaptFade = "Exp( " + AdaptLuma + " * 7 ) / 200 * " + AdaptFade + " / " + c_Complex

### Mix all factors and calculate final factor of strength
global strFact   = "( " + AdaptLuma + " * ( 1 + " + AdaptFade + " ) * ( 1 + " + AdaptBlue + " ) )"

global f3kdb_eval = "f3kdb( Y=int("+String(Y)+"*"+strFact+
\                       "), Cb=int("+String(Cb)+"*"+strFact+
\                       "), Cr=int("+String(Cr)+"*"+strFact+
\                       "), grainY=int("+String(grainY)+"*"+strFact+
\                       "), grainC=int("+String(grainC)+"*"+strFact+
\                           ( Defined(f3k_param) ? "), "+f3k_param+" )"
\                                                : ") )" )

Info ? ScriptClip( f3kdb_eval+""".Subtitle( "Final factor: "+String( Eval(strFact) ), x=8, y=8 ).Subtitle( "Luma adaptive factor: "+String( Eval(AdaptLuma) ), x=8, y=38 ).Subtitle( "Fade adaptive factor: "+String( 1+Eval(AdaptFade) ), x=8, y=58 ).Subtitle( "Blue adaptive factor: "+String( 1+Eval(AdaptBlue) ), x=8, y=78 ).Subtitle( "Frame complexity: "+String( Eval(c_Complex) ), x=8, y=108 )""" )
\    : ScriptClip( f3kdb_eval )

return SelectEvery( 1 + radius * 2, radius)
}


### Fixed ConvertToRGB32 ###

function CRGB32(clip c, string "matrix", bool "interlaced") {
  matrix     = ( c.width>1024 || c.height>576 ) ? Default(matrix, "Rec709") : Default(matrix, "Rec601")
  interlaced = Default(interlaced, false)
  return
\ c.IsRGB32 ? c :
\ c.IsRGB   ? c.ConvertToRGB32(interlaced=interlaced) :
\             c.ConvertToRGB32(interlaced=interlaced, matrix=matrix)
}
