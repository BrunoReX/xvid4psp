
# Practically Didée's madness:


###############DeblockMT########################




function myDeblock(last)
{
o=last
fft   = o.fft3dfilter(sigma=16,sigma2=6,sigma3=1,sigma4=0,bw=12,bh=12,ow=6,oh=6,bt=5,plane=4,ncpu=2)
fftD  = mt_makediff(o,fft,U=3,V=3)
rg11D = mt_makediff(fft,fft.removegrain(20),U=3,V=3).mt_lut("x 128 - 1.49 * 128 +",U=3,V=3)
DD    = mt_lutxy(fftD,rg11D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",U=3,V=3)
#DD  = rg11D.repair(fftD,1) # try: 14,13,12,1  # note: "1", not "11" !
fin   = fft.mt_adddiff(DD,U=3,V=3)
return (fin)
}

###############MCDeblockMT########################


function MCDeblockMT(last)
{
o=last
vectors = o.MVAnalyse(isb = false, lambda = 1000)
compensation = o.MVCompensate(vectors, mode = 0)
compensation.pre()
return (last)
}


function Pre(last)
{
o=last
fft   = o.fft3dfilter(sigma=16,sigma2=6,sigma3=1,sigma4=0,bw=12,bh=12,ow=6,oh=6,bt=5,plane=4,ncpu=2)
fftD  = mt_makediff(o,fft,U=3,V=3)
rg11D = mt_makediff(fft,fft.removegrain(20),U=3,V=3).mt_lut("x 128 - 1.49 * 128 +",U=3,V=3)
DD    = mt_lutxy(fftD,rg11D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",U=3,V=3)
#DD  = rg11D.repair(fftD,1) # try: 14,13,12,1  # note: "1", not "11" !
fin   = fft.mt_adddiff(DD,U=3,V=3)
return (last)
}


#################Soothe###################


####Igual que deblockMT pero con compensacion temporal y sharpener de soothe, ejecutar como a continuacion:
#Soothe(last,fin,keep=0)



function fin(last)
{
o     = last
fft   = o.fft3dfilter(sigma=16,sigma2=6,sigma3=1,sigma4=0,bw=12,bh=12,ow=6,oh=6,bt=5,plane=4,ncpu=2)
fftD  = mt_makediff(o,fft,U=3,V=3)
rg11D = mt_makediff(fft,fft.removegrain(20),U=3,V=3).mt_lut("x 128 - 1.49 * 128 +",U=3,V=3)
DD    = mt_lutxy(fftD,rg11D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",U=3,V=3)
#DD  = rg11D.repair(fftD,1) # try: 14,13,12,1  # note: "1", not "11" !
fin   = fft.mt_adddiff(DD,U=3,V=3)
return fin
}


function Soothe(clip sharp, clip orig, int "keep")
{
Assert(sharp.width == orig.width && sharp.height == orig.height,
 \  "Soothe: clip dimensions must match!")
keep  = default(keep, 24)
keep  = (keep>100) ? 100 : (keep<0) ? 0 : keep
KP    = string(keep)
diff  = mt_makediff(orig,sharp)
diff2 = diff.temporalsoften(1,255,0,32,2)
diff3 = mt_lutxy(diff,diff2,  "x 128 - y 128 - * 0 < x 128 - 100 / "  + KP 
 \                           + " * 128 + x 128 - abs y 128 - abs > x " + KP 
 \                           + " * y 100 " + KP + " - * + 100 / x ? ?")
return( mt_makediff(orig,diff3,chroma="copy first") )
}


#################SootheCl###################




####Introduce una nueva variante (Clense) respecto a Soothe y preserva el chroma. Usar como a continuacion:
#SootheCl(last,fin2,keep=0,chroma=true)
# Clense necesita RemoveGrain.dll (a secas) o el paquete RemoveGrain1.0b


function fin2(last)
{
o     = last
fft   = o.fft3dfilter(sigma=16,sigma2=6,sigma3=1,sigma4=0,bw=12,bh=12,ow=6,oh=6,bt=5,plane=4,ncpu=2)
fftD  = mt_makediff(o,fft,U=3,V=3)
rg11D = mt_makediff(fft,fft.removegrain(20),U=3,V=3).mt_lut("x 128 - 1.49 * 128 +",U=3,V=3)
DD    = mt_lutxy(fftD,rg11D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",U=3,V=3)
#DD  = rg11D.repair(fftD,1) # try: 14,13,12,1  # note: "1", not "11" !
fin   = fft.mt_adddiff(DD,U=3,V=3)
return fin
}



function SootheCl(clip sharp, clip orig, int "keep", bool "chroma")
{
Assert(sharp.width == orig.width && sharp.height == orig.height,
 \  "Soothe: clip dimensions must match!")
chroma= default(chroma,false)
keep  = default(keep, 24)
keep  = (keep>100) ? 100 : (keep<0) ? 0 : keep
uv = chroma ? 3 : 2
KP    = string(keep)
diff  = mt_makediff(orig,sharp,U=uv,V=uv)
diff2 = diff.clense(reduceflicker=false)
diff3 = mt_lutxy(diff,diff2,  "x 128 - y 128 - * 0 < x 128 - 100 / "  + KP 
 \                           + " * 128 + x 128 - abs y 128 - abs > x " + KP 
 \                           + " * y 100 " + KP + " - * + 100 / x ? ?",U=uv,V=uv)
return( mt_makediff(orig,diff3,U=uv,V=uv) )
}


##################MCSoothe###################


##Realmente un motion compensated Clense. Usar: MCSoothe() 
##Normalmente mejor acompañado con un previo Deblock_QED para el blocking estatico (o a traves de un denoiser tipo dfttest)
# Clense necesita RemoveGrain.dll (a secas) o RemoveGrainSSE3.dll/RemoveGrainSSE2.dll de RemoveGrain1.0b.zip

function MCsoothe(last)
{
o     = last
fft   = o.fft3dfilter(sigma=16,sigma2=6,sigma3=1,sigma4=0,bw=12,bh=12,ow=6,oh=6,bt=5,plane=4,ncpu=2)
fftD  = mt_makediff(o,fft,U=3,V=3)
rg11D = mt_makediff(fft,fft.removegrain(20),U=3,V=3).mt_lut("x 128 - 1.49 * 128 +",U=3,V=3)
DD    = mt_lutxy(fftD,rg11D,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",U=3,V=3)
#DD  = rg11D.repair(fftD,1) # try: 14,13,12,1  # note: "1", not "11" !
fin   = fft.mt_adddiff(DD,U=3,V=3)

fftsup=fft.MSuper()
bv = fftsup.MAnalyse(isb=true,blksize=16,overlap=8,truemotion=false)
fv = fftsup.Manalyse(isb=false,blksize=16,overlap=8,truemotion=false)
finD=mt_makediff(o,fin,U=3,V=3)
osup=o.MSuper()
interleave(o.MCompensate(osup,fv,thSCD1=255,thSCD2=255),fin,o.MCompensate(osup,bv,thSCD1=255,thSCD2=255))
raw=Clense(reduceflicker=false).selectevery(3,1)
rawD=mt_makediff(raw,fin,U=3,V=3)
rawDD=mt_lutxy(rawD,finD,"x 128 - y 128 - * 0 < 128 x 128 - abs y 128 - abs < x y ? ?",U=3,V=3)
fin3=fin.mt_adddiff(rawDD,U=3,V=3)
return fin3
}

