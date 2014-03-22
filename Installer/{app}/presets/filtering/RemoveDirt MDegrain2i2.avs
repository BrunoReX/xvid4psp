#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#RemoveGrainSSE2.dll
#RemoveGrainTSSE2.dll
#RemoveDirt.dll
#RepairSSE3.dll
#Warpsharp.dll
#mvtools2.dll
#mt_masktools-26.dll
#Gradfun2db.dll
#AddGrainC.dll
#GrainFactory3.avs

setmtmode(2)
# setmemorymax(640)

ConvertToYV12(interlaced=true)
ConvertToRGB32(interlaced=true).CamCD(9,1).ConvertToYV12(interlaced=true) # Derainbow & Color denoiced

fields = last.AssumeTFF().SeparateFields() 
filtered = fields.RemoveDirt(false,10)

dark   = 32
bright = 196
mask1  = mt_lut(fields,"x "+string(dark)+" < 255 x "+string(bright)+" > 255 0 ? ?",U=1,V=1).removegrain(19,-1,-1)

min   = 16
max   = 255
mask2 = mt_lutxy(fields,filtered,"x y - abs "+string(min)+" < 0 x y - abs "+string(max)+" > 0 255 ? ?",U=1,V=1).removegrain(19,-1,-1)
rdr = mt_merge(fields,filtered,mt_logic(mask1,mask2,"min"),luma=true)
blksize = 16
overlap = blksize/2
chroma = true
planes = chroma?4:0
thSAD = 400
preNR_super = filtered.MSuper(pel=2, sharp=2, rfilter=2, chroma=chroma)
rdr_super = rdr.MSuper(pel=2, sharp=2, levels=1, chroma=chroma)
vb4 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=4, blksize=blksize, overlap=overlap, dct=5, chroma=chroma)
vb2 = MAnalyse(preNR_super, isb=true, truemotion=false, delta=2, blksize=blksize, overlap=overlap, dct=5, chroma=chroma)
vf2 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=2, blksize=blksize, overlap=overlap, dct=5, chroma=chroma)
vf4 = MAnalyse(preNR_super,isb=false, truemotion=false, delta=4, blksize=blksize, overlap=overlap, dct=5, chroma=chroma)
MDegrain2(rdr,rdr_super,vb2,vf2,vb4,vf4,thSAD=thSAD,plane=planes).unsharpmask(40,1,0)
sharpen(0.2).sharpen(0.2).blur(0.1)
Gradfun2db().GrainFactory3(1,1,1)
Weave()

# для обработки интерлейсного видео с сохранением интерлейса, сохранением скрипа и кодированием его в Carbon Coder или CCE SP2

