################################################################################################################
#
# MTstack - multithreading tool for AviSynth 2.5
#
# Version 0.2 by shellgen & nonsens112
#
################################################################################################################
#
# Requires MT 0.7
#
# Usage: clip.MTstack("filter", threads)
#
################################################################################################################

function stackht(clip clp , clip sliced, int slices, int i ) {
snum = i
sliced = (snum == 1) ? clp : stackhorizontal(sliced, clp.trim(snum-1,0)+clp.blankclip(length=snum-1))
return (snum>=slices) ? sliced : stackht(clp, sliced,slices,snum+1)
}

function deslice(clip clp, clip buf, int slices, int w, int i) {
i = default(i,1)
snum = i == 0 ? 1 : i
buf = snum == 1 ? clp.crop(0,0,w*(snum-slices),0) : buf+clp.crop(w*(snum-1),0,w*(snum-slices),0)
return (snum>=slices) ? scriptclip(buf,"interleave("+trimsequence("",buf.framecount()/slices,slices,0)+")") : \
deslice(clp, buf, slices, w, snum+1)
}

function trimsequence(string cmd, int len, int threads, int i) {
scount = i
cmd = cmd + "trim(" + string(scount*len) +"," + string(len+(scount*len)-1) + ")"
cmd = (scount == (threads-1)) ? cmd : cmd + ","
return (scount >= (threads-1)) ? cmd : trimsequence(cmd, len, threads, scount+1)
}

function MTstack(clip c, string filter, int "threads") {
threads = default(threads, 2)

sw = c.width
frate = c.framerate()
buf = c.blankclip(length=1)

stackht(c,buf,threads,1)
MT(filter+"""selectevery("""+string(threads)+""",0)""",threads=threads,overlap=0,splitvertical=true)
return (threads < 2) ? c : \
deslice(last, buf, threads, sw, 0).trim(0,c.framecount()-1).assumefps(frate)
}