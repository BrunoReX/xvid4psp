function DeBanding (clip input, float "dithery", float "ditherc") {
 dithery = default (dithery,  56)
 ditherc = default (ditherc,  56)
 mask = mt_lutxy(input.mt_expand().mt_expand(), input.mt_inpand().mt_inpand(),"x y -",u=1,v=1). \
             mt_lut(expr="255 x 1 2 / * 2 ^ /",u=1,v=1).removegrain(19,-1)
 b = input.f3kdb(sample_mode=2, precision_mode=3, y=64, cb=64, cr=64, dithery=dithery, ditherc=ditherc)
 output = mt_merge(input, b, mask, luma=true, u=3, v=3)
 return(output)
 }
