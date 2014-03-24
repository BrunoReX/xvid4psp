#RgTools.dll
#mvtools2.dll
#nnedi3.dll
#flash3kyuu_deband.dll
#mt_masktools-26.dll
#dfttest.dll
#SDIAdapt.avs


# setmtmode(2)
# setmemorymax(768)

Global thicknessline=2# thickness horizontal spike in pixels at field scale (not frame)
Global radvertmed=2*thicknessline-1
Global distser=25# distance between short lines
Global halflength=3# detect line longer 2*halflength+1 pixels

source=last.AssumeTFF().ConvertToYV12(interlaced=true)
bobnn=source.nnedi3(field=-2,threads=1)
# bobbing for better motion estimation
bobnnmed=bobnn.mt_luts(bobnn,mode="median",pixels=mt_rectangle(0,radvertmed),U=3,V=3)
# vertical median filter
bobnnmedf=bobnnmed.dfttest(tbsize=1,ftype=1,sbsize=8,sosize=6,sigma=1000,U=false,V=false)
#dft filter remove segregation after median vertical filter
super=MSuper(bobnn)
superf=MSuper(bobnnmedf,chroma=false)
bw2 = MAnalyse(superf, blksize=8, isb = true, delta = 4, overlap=4, dct=5,chroma=false)
bw1 = MAnalyse(superf, blksize=8, isb = true, delta = 2, overlap=4, dct=5,chroma=false)
fw1 = MAnalyse(superf, blksize=8, isb = false,delta = 2, overlap=4, dct=5,chroma=false)
fw2 = MAnalyse(superf, blksize=8, isb = false,delta = 4, overlap=4, dct=5,chroma=false)
bc1 = MCompensate(bobnn, super, bw1, thSAD=16000, thSCD1=16000)
bc2 = MCompensate(bobnn, super, bw2, thSAD=16000, thSCD1=16000)
fc1 = MCompensate(bobnn, super, fw1, thSAD=16000, thSCD1=16000)
fc2 = MCompensate(bobnn, super, fw2, thSAD=16000, thSCD1=16000)
# motion estimation on filtered and compensating on source
bwabs1=mt_lutxy(bobnn,bc1,"x y - abs")
bwabs2=mt_lutxy(bobnn,bc2,"x y - abs")
fwabs1=mt_lutxy(bobnn,fc1,"x y - abs")
fwabs2=mt_lutxy(bobnn,fc2,"x y - abs")
# calculation absolute difference between source and compensated 
SDIc=SDIAdapt(bwabs1,fwabs1)
SDIb=SDIAdapt(bwabs1,bwabs2)
SDIf=SDIAdapt(fwabs1,fwabs2)
# calculation spike detection index for center, forwad and backward
mb1sad=bobnnmedf.MMask(bw1,kind=1,ml=100,Ysc=255, thSCD1=16000)
mb2sad=bobnnmedf.MMask(bw2,kind=1,ml=100,Ysc=255, thSCD1=16000)
mf1sad=bobnnmedf.MMask(fw1,kind=1,ml=100,Ysc=255, thSCD1=16000)
mf2sad=bobnnmedf.MMask(fw2,kind=1,ml=100,Ysc=255, thSCD1=16000)
# calculating SAD for filtered for estimation better choice for motion compensation
centersad=mt_logic(mf1sad,mb1sad,"max")#,U=2,V=2)
# maximum SAD from forward and backward measure for quality center compensation
bwsad=mt_logic(mb1sad,mb2sad,"max")
#for backward compensation
fwsad=mt_logic(mf1sad,mf2sad,"max")
#for forward compensation
centermask=mt_invert(centersad)
bwmask=mt_invert(bwsad)
fwmask=mt_invert(fwsad)
# inverting mask for using mt_merge
mcfcenter=clense(bc1, bobnn,fc1,increment=0, grey=false)
mcfbw=clense(bc1, bobnn,bc2,increment=0, grey=false)
mcffw=clense(fc1, bobnn,fc2,increment=0, grey=false)
# motion compensated median filtering for center, backward and forward compensation

# sort SAD for finding better motion compensated median filtering, this approach can use without SDI for pixels and 1 line thickness stripes
mt_logic(mt_lutxy(centersad,bwsad,"x y <= "), mt_lutxy(centersad,fwsad,"x y <="),"and")
maskcentersad=mt_lutxy(last,centersad,"x 255 y - 0 ?") # center filtered

mt_logic(mt_lutxy(bwsad,centersad,"x y < "), mt_lutxy(bwsad,fwsad,"x y <="),"and")
maskbwsad=mt_lutxy(last,bwsad,"x 255 y - 0 ?") # backward filtered

mt_logic(mt_lutxy(fwsad,centersad,"x y < "), mt_lutxy(fwsad,bwsad,"x y < "),"and")
maskfwsad=mt_lutxy(last,fwsad,"x 255 y - 0 ?") # forward filtered

mcfmaskedsad=mt_merge(bobnnmed,mcfbw,maskbwsad,luma=true)
mcfmaskedsad=mt_merge(mcfmaskedsad,mcffw,maskfwsad,luma=true)
mcfcentersad=mt_merge(mcfmaskedsad,mcfcenter,maskcentersad,luma=true)
#best value based on 3 motion compensated median time filtered value and spatial filtered
# where motion compensation bad, work only for one sequintial frame with spike
mcfbwsad=mt_merge(bobnnmed,mcfbw,maskbwsad,luma=true)
mcffwsad=mt_merge(bobnnmed,mcffw,maskfwsad,luma=true)
# backward and forward compensated full for SDI approach and spatial filtered where motion compensation bad
#end sort SAD

# sort SDI for choose center, forward or forward compensation work with 2 sequential frames, for 3 need 2 pass filtering, for 4 3 pass
maskcentersdi=mt_logic(mt_logic(mt_lutxy(SDIc,SDIb,"x y >= "), mt_lutxy(SDIc,SDIf,"x y >="),"and"),SDIc,"and").mt_lut("x 255 0 ?") # center SDI
maskbwsdi=mt_logic(mt_lutxy(SDIb,SDIc,"x y > "), mt_lutxy(SDIb,SDIf,"x y >="),"and").mt_lut("x 255 0 ?") # backward SDI
maskfwsdi=mt_logic(mt_lutxy(SDIf,SDIc,"x y > "), mt_lutxy(SDIf,SDIb,"x y >"),"and").mt_lut("x 255 0 ?") # forward SDI

maskedsdi=mt_merge(bobnn,mcfcentersad,maskcentersdi,luma=true)
maskedsdi=mt_merge(maskedsdi,mcffwsad,maskfwsdi,luma=true)
maskedsdi=mt_merge(maskedsdi,mcfbwsad,maskbwsdi,luma=true) #end sort SDI

# this place for repair now I am thinking
fieldmaskedsdi = maskedsdi.AssumeTFF().SeparateFields().SelectEvery(4,0,3)
#fieldmaskedsdi = SDIc.AssumeTFF().SeparateFields().SelectEvery(4,0,3)
#StackVertical(Separatefields(source),fieldmaskedsdi,mt_makediff(fieldmaskedsdi,Separatefields(source),u=3,v=3))
#StackVertical(Separatefields(source),mt_makediff(fieldmaskedsdi,Separatefields(source),u=3,v=3))
Weave(fieldmaskedsdi)
# some kind comparing and weave for interlaced source, may be at double rate and for second pass not need bobbing
# Spike Detection Function

# ==== DeBanding & AddGrain ====
f3kdb(sample_mode=2,dynamic_grain=true,keep_tv_range=false,dither_algo=3,y=64,cb=48,cr=48,grainY=0,grainC=0)

# Пресет предназначен для обработки старых VHS видеокассет с выбросами пульсирующих белых и черных линий в интерлейсном виде с последующей обработкой в Carbon Coder 
