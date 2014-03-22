#DeintPart, helper function by thetoof
#
#Output = 1 (29.97fps) or 2 (59.94fps)
#Decimation = 1 (CFR, no decimation) or 2 (VFR decimation)
#Bob = 1 (mcbob) or 2 (tempgaussmc_beta2)
#Block, hybriddup, pass = like in AnimeIVTC()
#Denoise = true (denoise before calculating metrics for VFR decimation) or false (don't)
#pstartx/endx = frame # in the unprocessed source where the progressive parts start and end
#istart1/end1 = frame # in the unprocessed source where the interlaced section starts and ends

function DeintPart(clip s, int "output", int "decimation", int "bob", int "block", float "hybriddup", int "pass", bool "denoise", int "pstart1", int "pend1", int "istart1", int "iend1", int "pstart2", int "pend2")
{
block=default(block, 16)
hybriddup=default(hybriddup, 0.9)
pass=default(pass,1)
denoise=default(denoise,true)

a = (output==1) ? s.trim(pstart1,pend1) : (output==2) ? s.trim(pstart1,pend1).changefps("ntsc_double") : nop()
b = (output==1 && bob==1) ? s.mcbob().selecteven().trim(istart1,iend1) : (output==1 && bob==2) ? s.tempgaussmc_beta2(edimode="nnedi").selecteven().trim(istart1,iend1) : (output==2 && bob==1) ? s.mcbob().trim(istart1*2,iend1*2) : (output==2 && bob==2) ? s.tempgaussmc_beta2(edimode="nnedi").trim(istart1*2,iend1*2) : nop()
c = (output==1) ? s.trim(pstart2,pend2) : (output==2) ? s.trim(pstart2,pend2).changefps("ntsc_double") : nop()

spliced = a+b+c

return (decimation = 1) ? spliced : (decimation = 2 && pass == 1 ) ? spliced.TDecimate(mode=4, output="stats.txt",denoise=denoise, blockx=block, blocky=block) : (decimation = 2 && pass == 2 ) ? spliced.TDecimate(mode=5, hybrid=2, dupthresh=hybriddup, input="stats.txt", mkvout="timecodes.txt",denoise=denoise, blockx=block, blocky=block) : nop()}