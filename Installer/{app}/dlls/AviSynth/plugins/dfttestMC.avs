#############################################
# Motion Compensated dfttest                #
# Really Really Really Slow                 #
#                                           #
# For best results, use a mcradius equal to #
# (tbsize-1)/2                              #
#                                           #
# MDegrain will also be run if mdg == true  #
#                                           #
# mcradius is hardlimited at 5              #
#                                           #
#############################################

function dfttestMC (clip input, bool "Y", bool "U", bool "V", int "ftype", float "sigma", float "sigma2", float "pmin", float "pmax",
        \ int "sbsize", int "smode", int "sosize", int "tbsize", int "dither", int "tmode", int "tosize", int "swin", int "twin", float "sbeta",
	\ float "tbeta", bool "zmean", float "f0beta", int "mcradius", bool "mdg", int "pp", int "ppstr", int "thSAD", int "mdgthSAD",
	\ int "thSCD1", int "thSCD2", int "blksize", int "pel", int "overlap", int "dct", int "search")
{
o = input

# dfttest-related options
Y = default(Y, true)
U = default(U, true)
V = default(V, true)
ftype = default(ftype, 0)
sigma = default(sigma, 16.0)
sigma2 = default(sigma2, 16.0)
pmin = default(pmin, 0.0)
pmax = default(pmax, 500.0)
sbsize = default(sbsize, 12)
smode = default(smode, 1)
sosize = default(sosize, 9)
tbsize = default(tbsize, 5)
dither = default(dither, 0)
tmode = default(tmode, 0)
tosize = default(tosize, 0)
swin = default(swin, 0)
twin = default(twin, 7)
sbeta = default(sbeta, 2.5)
tbeta = default(tbeta, 2.5)
zmean = default(zmean, true)
f0beta = default(f0beta, 1.0)

# mvtools-related options
mcradius = default(mcradius, 2)
mcradius = (mcradius>5) ? 5 : (mcradius<1) ? 1 : mcradius
mdg = default(mdg, false)
pp = default(pp, 1)
ppstr = default(ppstr, (pp>=2) ? 16 : (pp==1) ? 1 : 9001)
mdgthSAD = default(thSAD, 400)
thSAD = default(thSAD, 10000)
thSCD1 = default(thSCD1, 400)
thSCD2 = default(thSCD2, 130)
blksize = default(blksize, 8)
pel = default(pel, 2)
overlap = default(overlap, 2)
dct = default(dct, 0)
search = default(search, 5)

# Pre-ME denoising
pp = (pp >= 2) ? o.dfttest(sigma=ppstr) : (pp == 1) ? o.DeGrainMedian(mode=ppstr) : o

# MSuper
pp_super = pp.MSuper(pel=pel)

# Motion vector search
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

# Optional MDegrain
o_super = mdg ? o.MSuper(pel=pel,levels=1) : o
mdegrained = (mcradius>=3 && mdg) ? o.MDegrain3(o_super,b1vec,f1vec,b2vec,f2vec,b3vec,f3vec,thSAD=mdgthSAD,thSCD1=thSCD1,thSCD2=thSCD2) :
\            (mcradius==2 && mdg) ? o.MDegrain2(o_super,b1vec,f1vec,b2vec,f2vec,thSAD=mdgthSAD,thSCD1=thSCD1,thSCD2=thSCD2) :
\            (mdg)                ? o.MDegrain1(o_super,b1vec,f1vec,thSAD=mdgthSAD,thSCD1=thSCD1,thSCD2=thSCD2) : o

degrained = (mdg) ? mdegrained : o

# Motion Compensation
degrained_super =  degrained.MSuper(pel=pel,levels=1)
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

# Create compensated clip
interleaved = (mcradius>=5) ? Interleave(f5clip,f4clip,f3clip,f2clip,f1clip,degrained,b1clip,b2clip,b3clip,b4clip,b5clip) :
\ (mcradius==4) ? Interleave(f4clip,f3clip,f2clip,f1clip,degrained,b1clip,b2clip,b3clip,b4clip) :
\ (mcradius==3) ? Interleave(f3clip,f2clip,f1clip,degrained,b1clip,b2clip,b3clip) :
\ (mcradius==2) ? Interleave(f2clip,f1clip,degrained,b1clip,b2clip) :
\ Interleave(f1clip,degrained,b1clip)

# Perform dfttest
filtered = interleaved.dfttest(Y=Y,U=U,V=V,ftype=ftype,sigma=sigma,sigma2=sigma2,pmin=pmin,pmax=pmax,sbsize=sbsize,smode=smode,sosize=sosize,
	\ tbsize=tbsize,dither=dither,tmode=tmode,tosize=tosize,swin=swin,twin=twin,sbeta=sbeta,tbeta=tbeta,zmean=zmean,f0beta=f0beta)

output = filtered.SelectEvery(mcradius*2+1,mcradius)

return(output)
}
