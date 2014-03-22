# script for remover Spot by Tempter57
function SpotRemover (clip input, int "mcradius", bool "mdg", int "pp", int "noise", bool "_grey", int "repmode", 
	\ int "thSAD", int "mdgthSAD", int "thSCD1", int "thSCD2", int "blksize", int "pel", int "overlap", int "dct", int "search")
{

# mvtools-related options
mcradius = default(mcradius, 2)
mcradius = (mcradius>6) ? 6 : (mcradius<1) ? 1 : mcradius
mdg = default(mdg, true)
pp = default(pp, 1)
noise = default(noise, 6)
_grey = default(_grey, false)
repmode = default(repmode, 16)
mdgthSAD = default(thSAD, 400)
thSAD = default(thSAD, 10000)
thSCD1 = default(thSCD1, 400)
thSCD2 = default(thSCD2, 130)
blksize = default(blksize, 4)
pel = default(pel, 2)
overlap = default(overlap, 2)
dct = default(dct, 5)
search = default(search, 5)

o = input

# Pre-ME denoising
pp = (pp >= 2) ? o.RemoveDirt(_grey, repmode) : (pp == 1) ? o.DeFlicker(noise=noise).Blur(1.58) : o

pp_super = pp.MSuper(pel=2, sharp=0)
o_super = o.MSuper(pel=2, sharp=0, levels=1)

# Motion vector search
b6vec = (mcradius>=6) ?
\ MAnalyse(pp_super,isb=true,search=search,delta=6,overlap=overlap,blksize=blksize,dct=dct) : NOP
b5vec = (mcradius>=5) ?
\ MAnalyse(pp_super,isb=true,search=search,delta=5,overlap=overlap,blksize=blksize,dct=dct) : NOP
b4vec = (mcradius>=4) ?
\ MAnalyse(pp_super,isb=true,search=search,delta=4,overlap=overlap,blksize=blksize,dct=dct) : NOP
b3vec = (mcradius>=3) ?
\ MAnalyse(pp_super,isb=true,search=search,delta=3,overlap=overlap,blksize=blksize,dct=dct) : NOP
b2vec = (mcradius>=2) ?
\ MAnalyse(pp_super,isb=true,search=search,delta=2,overlap=overlap,blksize=blksize,dct=dct) : NOP
b1vec = MAnalyse(pp_super,isb=true, search=search,delta=1,overlap=overlap,blksize=blksize,dct=dct)
f1vec = MAnalyse(pp_super,isb=false,search=search,delta=1,overlap=overlap,blksize=blksize,dct=dct)
f2vec = (mcradius>=2) ?
\ MAnalyse(pp_super,isb=false,search=search,delta=2,overlap=overlap,blksize=blksize,dct=dct) : NOP
f3vec = (mcradius>=3) ?
\ MAnalyse(pp_super,isb=false,search=search,delta=3,overlap=overlap,blksize=blksize,dct=dct) : NOP
f4vec = (mcradius>=4) ?
\ MAnalyse(pp_super,isb=false,search=search,delta=4,overlap=overlap,blksize=blksize,dct=dct) : NOP
f5vec = (mcradius>=5) ?
\ MAnalyse(pp_super,isb=false,search=search,delta=5,overlap=overlap,blksize=blksize,dct=dct) : NOP
f6vec = (mcradius>=6) ?
\ MAnalyse(pp_super,isb=false,search=search,delta=6,overlap=overlap,blksize=blksize,dct=dct) : NOP

# Optional MDegrain
o_super = mdg ? o.MSuper(pel=pel,levels=1) : o
mdegrained = (mcradius>=3 && mdg) ? o.MDegrain3(o_super,b1vec,f1vec,b2vec,f2vec,b3vec,f3vec,thSAD=mdgthSAD,thSCD1=thSCD1,thSCD2=thSCD2) :
\            (mcradius==2 && mdg) ? o.MDegrain2(o_super,b1vec,f1vec,b2vec,f2vec,thSAD=mdgthSAD,thSCD1=thSCD1,thSCD2=thSCD2) :
\            (mdg)                ? o.MDegrain1(o_super,b1vec,f1vec,thSAD=mdgthSAD,thSCD1=thSCD1,thSCD2=thSCD2) : o

degrained = (mdg) ? mdegrained : o

# Motion Compensation
degrained_super =  degrained.MSuper(pel=pel,levels=1)
b6clip = (mcradius>=6) ?
\ degrained.MCompensate(degrained_super,b6vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2) : NOP
b5clip = (mcradius>=5) ?
\ degrained.MCompensate(degrained_super,b5vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2) : NOP
b4clip = (mcradius>=4) ?
\ degrained.MCompensate(degrained_super,b4vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2) : NOP
b3clip = (mcradius>=3) ?
\ degrained.MCompensate(degrained_super,b3vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2) : NOP
b2clip = (mcradius>=2) ?
\ degrained.MCompensate(degrained_super,b2vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2) : NOP
b1clip = degrained.MCompensate(degrained_super,b1vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2)
f1clip = degrained.MCompensate(degrained_super,f1vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2)
f2clip = (mcradius>=2) ?
\ degrained.MCompensate(degrained_super,f2vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2) : NOP
f3clip = (mcradius>=3) ?
\ degrained.MCompensate(degrained_super,f3vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2) : NOP
f4clip = (mcradius>=4) ?
\ degrained.MCompensate(degrained_super,f4vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2) : NOP
f5clip = (mcradius>=5) ?
\ degrained.MCompensate(degrained_super,f5vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2) : NOP
f6clip = (mcradius>=6) ?
\ degrained.MCompensate(degrained_super,f6vec,thSAD=thSAD,thSCD1=thSCD1,thSCD2=thSCD2) : NOP

# Create compensated clip
interleaved = (mcradius>=6) ? Interleave(f6clip,f5clip,f4clip,f3clip,f2clip,f1clip,degrained,b1clip,b2clip,b3clip,b4clip,b5clip,b6clip) :
            \ (mcradius>=5) ? Interleave(f5clip,f4clip,f3clip,f2clip,f1clip,degrained,b1clip,b2clip,b3clip,b4clip,b5clip) :
            \ (mcradius==4) ? Interleave(f4clip,f3clip,f2clip,f1clip,degrained,b1clip,b2clip,b3clip,b4clip) :
            \ (mcradius==3) ? Interleave(f3clip,f2clip,f1clip,degrained,b1clip,b2clip,b3clip) :
            \ (mcradius==2) ? Interleave(f2clip,f1clip,degrained,b1clip,b2clip) :
            \ Interleave(f1clip,degrained,b1clip)

# Perform SpotRemover

filtered = interleaved.ConvertToRGB32().SpotRemover("SSI:0 SSC:-5 SKW:3 SLI:2 SLC:2 SLD:0 DLS:24 DLC:15 DPC:14 DSF:1 DSD:0 MTX:16 MTY:12 MTL:22 MDX:1 MDY:1 MIH:0","").ConvertToYV12()
# filtered = interleaved.ConvertToRGB32().SpotRemover("SSI:0 SSC:-5 SKW:3 SLI:2 SLC:2 SLD:0 DLS:26 DLC:18 DPC:10 DSF:2 DSD:0 MTX:16 MTY:12 MTL:22 MDX:1 MDY:1 MIH:0 ","").ConvertToYV12()

output = filtered.SelectEvery(mcradius*2+1,mcradius+1)

return(output)
}

