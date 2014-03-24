#avstp.dll
#ccd_sse2.vdf
#vdf_arguments:CamCD:0
#Depan.dll
#DepanEstimate.dll
#GetDups.dll
#DeSpot.dll
#deflicker.dll
#Removedirt.dll
#RgTools.dll
#mvtools2mod.dll
#Warpsharp.dll
#mt_masktools-26.dll
#AddGrainC.dll
#Gradfun2db.dll
#Gradfun2dbmod 1.5.avsi
##Removedirt.avs
#LimitedSharpenFaster mod.avs

  
# SetMTMode(2)
# setmemorymax(640)

ConvertToRGB32()
CamCD(9,1)       # удаление радужности и цветового шума
ConvertToYV12()

# STABILIZING/CROPPING

dxmax=32 dymax=24 # for AR 4:3
# dxmax=36 dymax=20 # for AR 16:9
source = last.trim(1,0)
stab_reference = source.crop(dxmax*2,dymax*2,-dxmax*2,-dymax*2).tweak(cont=1.04).mt_binarize(threshold=80,upper=true,U=-128,V=-128)
mdata = DePanEstimate(stab_reference,trust=5.0,pixaspect=1.094,dxmax=dxmax,dymax=dymax) # trust=1...100 подобрать иначе рывки
stab1 = DePanStabilize(source,data=mdata,cutoff=0.5,dxmax=dxmax,dymax=dymax,pixaspect=1.094,method=0,mirror=15) # or pixaspect=0.911 for NTSC
stab = stab1.tweak(sat=1.05).crop(dxmax,dymax,-dxmax,-dymax)
 
filtered = stab.RemoveDirt(false,16)

dark   = 32
bright = 196
lmask1  = mt_lut(stab,"x "+string(dark)+" < 255 x "+string(bright)+" > 255 0 ? ?",U=1,V=1).removegrain(19,-1,-1)

min   = 16
max   = 255
lmask2 = mt_lutxy(stab,filtered,"x y - abs "+string(min)+" < 0 x y - abs "+string(max)+" > 0 255 ? ?",U=1,V=1).removegrain(19,-1,-1)
rdr = mt_merge(stab,filtered,mt_logic(lmask1,lmask2,"min"),luma=true)
preNR_super = filtered.MSuper(pel=2, sharp=0, rfilter=2)
rdr_super = rdr.MSuper(pel=2, sharp=0, levels=1)
vb2 = MAnalyse(preNR_super, isb=true, truemotion=true, delta=2, blksize=8, overlap=4, dct=5)
vb1 = MAnalyse(preNR_super, isb=true, truemotion=true, delta=1, blksize=8, overlap=4, dct=5)
vf1 = MAnalyse(preNR_super,isb=false, truemotion=true, delta=1, blksize=8, overlap=4, dct=5)
vf2 = MAnalyse(preNR_super,isb=false, truemotion=true, delta=2, blksize=8, overlap=4, dct=5)

# анализируеи и компенсируем движение вперед и назад (к текущему кадру)
ml = 130     # масштаб маски
thscd1 = 400 # порог смены сцены
cf = MFlow(rdr, rdr_super, vf1, thscd1 = thscd1) 
cb = MFlow(rdr, rdr_super, vb1, thscd1 = thscd1)

sadf = stab.MMask(vf1, ml=ml, kind=1, gamma=1, thscd1=thscd1) # маска SAD вперед
sadb = stab.MMask(vb1, ml=ml, kind=1, gamma=1, thscd1=thscd1) # маска SAD назад
msadf = sadf.MT_Binarize(20,upper=true) # двоичная инвертированная маска SAD вперед
msadb = sadb.MT_Binarize(20,upper=true) # двоичная инвертированная маска SAD назад
 
msad = MT_Logic(msadf,msadb,"or") # комбинированная инвертированная маска SAD
msad = msad.MT_Expand() # расширенная маска
msadi = Interleave(msad, msad, msad) # тройное повторение маски
interleave(cf, rdr.MDegrain2(rdr_super,vb1,vf1,vb2,vf2,thscd1=400), cb) 

# ==== большие черные пятна ====
# DeSpot(mthres=8,mwidth=7,mheight=5,merode=33,interlaced=false,median=false,p1=15,p2=8,pwidth=50,pheight=50,ranked=true,sign=1,maxpts=0,\
#        p1percent=10,dilate=1,fitluma=true,blur=1,tsmooth=0,show=0,mark_v=255,motpn=false,seg=2,color=true,mscene=40,minpts=0,extmask=msadi)
 
# ==== толстые линии типа волос (избегают реальных волос)  ====
# DeSpot(mthres=13,mwidth=7,mheight=5,merode=24,interlaced=false,median=false,p1=15,p2=13,pwidth=140,pheight=100,ranked=true,sign=-1,maxpts=0,\
#        p1percent=10,dilate=1,fitluma=true,blur=1,tsmooth=0,show=0,mark_v=255,motpn=false,seg=2,color=true,mscene=40,minpts=0,extmask=msadi)
 
# ==== линии, входящие в контакт с движением, избегите области движения ====
# DeSpot(mthres=13,mwidth=7,mheight=5,merode=16,interlaced=false,median=false,p1=15,p2=13,pwidth=140,pheight=100,ranked=true,sign=-1,maxpts=0,\
#        p1percent=10,dilate=1,fitluma=true,blur=1,tsmooth=0,show=0,mark_v=255,motpn=false,seg=1,color=true,mscene=40,minpts=0,extmask=msadi)
 
# ==== маленькие точки и пыль ====
# DeSpot(mthres=12,mwidth=7,mheight=5,merode=33,interlaced=false,median=false,p1=15,p2=8,pwidth=6,pheight=5,ranked=true,sign=0,maxpts=0,\
#        p1percent=10,dilate=1,fitluma=true,blur=1,tsmooth=2,show=0,mark_v=255,motpn=false,seg=1,color=true,mscene=40,minpts=0,extmask=msadi)

# DeSpot(mthres=8,mwidth=7,mheight=5,merode=25,interlaced=false,median=false,p1=10,p2=6,pwidth=720,pheight=576,ranked=true,sign=2,maxpts=0,\
#        p1percent=2,dilate=1,fitluma=true,blur=4,tsmooth=4,show=0,mark_v=255,motpn=false,seg=1,color=true,mscene=40,minpts=0,extmask=msadi)
 
# ==== Длинные горизонтальные затиры ====
# DeSpot(mthres=12,mwidth=7,mheight=5,merode=25,interlaced=false,median=false,p1=15,p2=8,pwidth=100,pheight=2,ranked=true,sign=-1,maxpts=0,\
#        p1percent=2,dilate=1,fitluma=true,blur=4,tsmooth=4,show=0,mark_v=255,motpn=false,seg=2,color=true,mscene=40,minpts=0,extmask=msadi)
 
# ==== Маленькие компактные пятна ====
# DeSpot(mthres=12,mwidth=7,mheight=5,merode=25,interlaced=false,median=false,p1=15,p2=8,pwidth=10,pheight=10,ranked=true,sign=-1,maxpts=0,\
#        p1percent=2,dilate=1,fitluma=true,blur=4,tsmooth=4,show=0,mark_v=255,motpn=false,seg=2,color=true,mscene=40,minpts=0,extmask=msadi)
 
# =====================================
  DeSpot(p1=20,p2=4,pwidth=200,pheight=150,mthres=22, merode=33,sign=2,show=0,seg=0,color=false,motpn=true,fitluma=true, extmask=msadi)
# DeSpot(p1=20,p2=12,pwidth=768,pheight=576,mthres=80,merode=33,sign=0,show=0,seg=0,color=true,motpn=true,extmask=msadi)
# DeSpot(p1=12,p2=22,pwidth=100,pheight=100,mthres=22,merode=25,p1percent=10,sign=0,show=0,seg=1,color=true,motpn=true,extmask=msadi)
# DeSpot(p1=15,p2=1, pwidth=40, pheight=40, mthres=4, merode=25,p1percent=10,sign=0,show=0,seg=1,color=true,motpn=true,extmask=msadi)

# DeSpot(p1=35,p2=11,pwidth=250,pheight=250,mthres=23,merode=40,p1percent=1,sign=1,show=0,seg=2,\
#        color=true,motpn=false,minpts=6,dilate=1,mscene=100,fitluma=true,blur=1,extmask=msadi)

# DeSpot(p1=22,p2=5, pwidth=100,pheight=140,mthres=11,merode=58,p1percent=25,sign=1,show=0,seg=1,color=true,motpn=false,minpts=6,maxpts=1200,\
#        mwidth=7,mheight=5,dilate=2,mscene=90,fitluma=true,blur=2,ranked=true,interlaced=false,extmask=msadi)

# DeSpot(p1=30,p2=22,pwidth=400,pheight=300, mthres=20,merode=33,p1percent=10,sign=1,show=0,seg=2,color=true,motpn=true,extmask=msadi)

SelectEvery(3,1) 

LSFMod(strength=75, smode=3)
LSFMod(strength=30, smode=1)
Gradfun2dbmod(thr=1.4,thrC=1.6,str=0.8,strC=0,temp=50,adapt=64)


