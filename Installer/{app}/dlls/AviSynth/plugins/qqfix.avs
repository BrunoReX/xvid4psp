# qqfix v. 036
# qqfix(source, 18, 1.5, 15, 1, false) 
# qqfix(source, 20, 3.0, 15, 1, false) 
 
function qqfix(clip v, int "blockthres", float "messthres", float "diffthres", int "delta", bool "debug") {
 
blockthres = default(blockthres, 18) # how likely an edge is to be counted as a block edge
messthres = default(messthres,1.5)   # how much block edges there needs to be to be considered corrupted (VERY dependent on blockthres)
diffthres = default(diffthres,15)    # if frame changes this much from last frame and gets detected, don't do interpolation, but do heavy deblocking instead
delta = default(delta,1)             # how far to calculate fixes from: more = longer corruptions handled, but 
debug = default(debug,false)         # instead of fixing anything, show debugging information
 
padX = v.width%8 == 0 ? 0 : (8 - v.width%8)
padY = v.height%8 == 0 ? 0 : (8 - v.height%8)
v=v.addborders(0, 0, padX, padY)
 
v2 = v.Levels(0, 2, 255, 0, 255)
sub = subtract(v2,v2.deblock_qed(30,30))
db = v.deblock_qed(30,30)
 
vedge2 = v.mt_LutSpa(relative=false, expr="x 8 % 1 < 255 0 ?")
vedge1 = v.mt_LutSpa(relative=false, expr="1 x + 8 % 1 < 255 0 ?")
hedge2 = v.mt_LutSpa(relative=false, expr="y 8 % 1 < 255 0 ?")
hedge1 = v.mt_LutSpa(relative=false, expr="1 y + 8 % 1 < 255 0 ?")
  
vm1=sub.converttorgb().GeneralConvolution(0, "0  0  0 0  -1  1 0 0 0 ", 1)
vm1=blankclip(sub).overlay(vm1,mask=vedge1).mt_binarize(blockthres)
vm1=vm1.bilinearresize(vm1.width,vm1.height/8).mt_binarize(220).pointresize(vm1.width,vm1.height)
 
vm2=sub.converttorgb().GeneralConvolution(0, "0 0 0 1  -1  0 0 0 0 ", 1)
vm2=blankclip(sub).overlay(vm2,mask=vedge2).mt_binarize(blockthres)
vm2=vm2.bilinearresize(vm2.width,vm2.height/8).mt_binarize(220).pointresize(vm2.width,vm2.height)
 
hm1=sub.converttorgb().GeneralConvolution(0, "0  0  0 0  -1  0 0 1 0 ", 1)
hm1=blankclip(sub).overlay(hm1,mask=hedge1).mt_binarize(blockthres)
hm1=hm1.bilinearresize(hm1.width/8,hm1.height).mt_binarize(220).pointresize(hm1.width,hm1.height)
 
hm2=sub.converttorgb().GeneralConvolution(0, "0  1  0 0 -1  0 0 0 0 ", 1)
hm2=blankclip(sub).overlay(hm2,mask=hedge2).mt_binarize(blockthres)
hm2=hm2.bilinearresize(hm2.width/8,hm2.height).mt_binarize(220).pointresize(hm2.width,hm2.height)
 
vm=mt_logic(vm1,vm2,"or")
hm=mt_logic(hm1,hm2,"or")
m=mt_logic(vm,hm,"or")

db

blksize = 16
blksizeV = blksize/2
overlap = blksize/2
overlapV = blksizeV/2

psuper = MSuper(db.blur(1),pel=2,rfilter=4)
rec_sup = MSuper(db.blur(1),pel=2,rfilter=4,levels=1)
ssuper =  MSuper(db,pel=2,rfilter=4,levels=1)
b_vec11 = MAnalyse(psuper,isb=true, blksize=blksize,blksizeV=blksizeV,search=5,overlap=overlap,overlapV=overlapV,dct=0)
f_vec11 = MAnalyse(psuper,isb=false,blksize=blksize,blksizeV=blksizeV,search=5,overlap=overlap,overlapV=overlapV,dct=0)
b_vec12 = MRecalculate(rec_sup,b_vec11, blksize=blksize/2,blksizeV=blksizeV/2,search=5,overlap=overlap/2,overlapV=overlapV/2,dct=0)
f_vec12 = MRecalculate(rec_sup,f_vec11,blksize=blksize/2,blksizeV=blksizeV/2,search=5,overlap=overlap/2,overlapV=overlapV/2,dct=0)
#inter = MFlowInter(db,ssuper,b_vec12,f_vec12,blend=true,time=50,ml=70,thSCD1=70)
inter = MFlowBlur(db,ssuper,b_vec12,f_vec12, blur=15)
 
d1 = v2.scriptclip("""subtitle("YDifference: " + String(ydifferencefromprevious()))""")
d2 = v2.scriptclip("""subtitle("YDifference: " + String(ydifferencefromprevious()))""").subtitle("High motion!", y=20)
dc = conditionalfilter(v,d2,d1,"ydifferencefromprevious()", ">", String(diffthres))
 
v=debug?dc:v
 
debug?Eval("""
   v = conditionalfilter(m,v,v,"averageluma()",">",String(messthres),true)
   v = v.tweak(cont=0.5).overlay(m,mask=m)
"""):Eval("""
   vi=conditionalfilter(m,inter,v,"averageluma()",">",String(messthres))
   v=conditionalfilter(v,db,vi,"ydifferencefromprevious()", ">", String(diffthres))
""")
return v.crop(0, 0, -padX, -padY)
}


