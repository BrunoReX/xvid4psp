#avstp.dll
#RgTools.dll
#mvtools2mod.dll
#Dither.dll
#AddGrainC.dll
#mt_masktools-26.dll
#flash3kyuu_deband.dll
#minblur.avs
#Dither.avsi
#HighPassSharp.avs
#mt_xxpand_multi.avsi
#Contrasharpening.avs


RemoveGrain(0)            # No-Op filter, just to do frame request
ChangeFPS(last,last,true) # initiate a small forward buffer
RemoveGrain(0)            # not sure if this 2nd one is needed. But surely it doesn't hurt

# SetMTMode(2)
# setmemorymax(1024)

source = last.assumeframebased()
maskstar = source.mt_binarize(upper=false) 

blksize = 16 # ��� ���������� �������� ��������� ���������� 16
overlap = blksize/2
hpad = blksize
vpad = blksize
thSAD = 150 
halfblksize = blksize/2                    
halfoverlap = overlap/2                    
halfthSAD   = thSAD/2
chroma = true
planes = chroma?4:0 
search = 5
tr = 2   # Temporal radius
pre = source.removegrain(11)
psuper = pre.MSuper(hpad=hpad, vpad=vpad, pel=1, sharp=1, rfilter=3, chroma=chroma)
ssuper = source.MSuper(hpad=hpad, vpad=vpad, pel=1, sharp=2, rfilter=3, chroma=chroma, levels=1)
Recalculate = pre.MSuper(hpad=hpad, vpad=vpad, pel=1, sharp=2, rfilter=3, chroma=chroma, levels=1)
multi_vec = MAnalyse (psuper, multi=true, delta=tr, blksize=blksize, overlap=overlap, chroma=chroma, truemotion=true, search=search, sadx264=3)
vb1 = multi_vec.SelectEvery (tr * 2, 0)
vf1 = multi_vec.SelectEvery (tr * 2, 1)
vb2 = multi_vec.SelectEvery (tr * 2, 2)
vf2 = multi_vec.SelectEvery (tr * 2, 3)
vbr1 = MRecalculate(Recalculate, vb1, overlap=halfoverlap, blksize=halfblksize, thSAD=halfthSAD, search=search, chroma=chroma, sadx264=3)
vfr1 = MRecalculate(Recalculate, vf1, overlap=halfoverlap, blksize=halfblksize, thSAD=halfthSAD, search=search, chroma=chroma, sadx264=3)
vbr2 = MRecalculate(Recalculate, vb2, overlap=halfoverlap, blksize=halfblksize, thSAD=halfthSAD, search=search, chroma=chroma, sadx264=3)
vfr2 = MRecalculate(Recalculate, vf2, overlap=halfoverlap, blksize=halfblksize, thSAD=halfthSAD, search=search, chroma=chroma, sadx264=3)
source.MDegrain2 (ssuper, vbr1, vfr1, vbr2, vfr2, thSAD=thSAD, plane=planes, lsb=true)

# DEBANDING
  f3kdb(20, 56, 40, 40, 0, 0, dynamic_grain=true, input_mode=1, output_mode=1)
# GradFun3 (thr=0.5, smode=0, radius=16, lsb_in=true, lsb=true)
DB = last.Dither_add_grain16 (var=0.08, uvar=0, soft=2)

# SHARPENING
den = DB.DitherPost(mode=-1) 
output = mt_merge(den,source,maskstar)
# sharp8 = Contrasharpening(output, source) 
sharp8 = output.HighPassSharp(r=0.15)
lsbctr = Dither_merge16_8 (DB,sharp8.Dither_convert_8_to_16(), DitherBuildMask(sharp8, output))
# lsb_out = lsbctr.DitherPost(mode=0) # for XviD encode  
lsb_out = lsbctr.DitherPost(mode=7, ampo=1, ampn=0) # for x264 encode 
lsb_out 



# ����������: ��� ��������� BD, ������� ��� ��������� �����������
# ��� ��������� ��������������: �� ������ ���������� ������� ������ �������� � �������� 2 � MRecalculate �� �������������� MDegrain2 
# ��� �������: Contrasharpening ��� HighPassSharp
# ������� ������� DeBanding �� ���������: ������� 
# �������� ���������: ���� ��������                    
# ����� ������� �������� ����� �������� � ������ #setmtmode(5,2) � ������������� ����������� ����������� ������ ��� threads=4 
