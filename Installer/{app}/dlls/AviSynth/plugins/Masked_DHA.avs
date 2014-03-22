function Masked_DHA(clip clp, float "rx", float "ry", float "darkstr", float "brightstr", float "lowsens", float "highsens", int "msk_pull", int "msk_push", float "ss", bool "show_msk")
{
rx = default( rx, 2.0 )
ry = default( ry, 2.0 )
darkstr = default( darkstr, 1.0 )
brightstr = default( brightstr, 1.0 )
lowsens = default( lowsens, 50 )
highsens = default( highsens, 50 )
msk_pull = default( msk_pull, 48 )
msk_push = default( msk_push, 192 )
ss = default( ss, 1.5 )
show_msk = default( show_msk, false )

rx = max(rx, 1.0)
ry = max(ry, 1.0)
darkstr = max(min(darkstr, 1.0), 0.0)
lowsens = max(min(lowsens, 100), 0)
highsens = max(min(highsens, 100), 0)
msk_pull = max(min(msk_pull, 254), 0)
msk_push = max(min(msk_push, 255), msk_pull + 1)
ss = max(ss, 1.0)

LOS = string(lowsens)
HIS = string(highsens/100.0)
DRK = string(darkstr)
BRT = string(brightstr)
MPL = string(msk_pull)
MPS = string(msk_push)
ox = clp.width()
oy = clp.height()

# Parameters that can only be adjusted from within the script
uv = 1
uv2 = (uv==3) ? 3 : 2
mbl = 1.58

sm = clp.bicubicresize(m4(ox/rx),m4(oy/ry))
lg = sm.bicubicresize(ox,oy,1,0)
chl = mt_lutxy(clp.mt_expand(U=uv,V=uv),clp.mt_inpand(U=uv,V=uv),"x y -","x y -","x y -",U=uv,V=uv)
lhl = mt_lutxy(lg.mt_expand(U=uv,V=uv),lg.mt_inpand(U=uv,V=uv),"x y -","x y -","x y -",U=uv,V=uv)
mask_i = mt_lutxy(lhl,chl,"y x - y 0.001 + / 255 * "+LOS+" - y 256 + 512 / "+HIS+" + *")

mask_f = mt_lutxy(sm.mt_expand,sm.mt_inpand,"x y - 4 *").blur(mbl).bicubicresize(ox,oy,1.0,0)
\ .mt_lut(yExpr="255 255 "+MPL+" - 255 "+MPS+" - - / x "+MPL+" - *",U=-128,V=-128)

mmg = mt_merge(lg,clp,mask_i,U=uv,V=uv)
ssc = (ss==1.0) ? clp.repair(mmg,1,0)
\ : clp.spline64resize(m4(ox*ss),m4(oy*ss))
\ .mt_logic(mmg.mt_expand(U=uv,V=uv).bicubicresize(m4(ox*ss),m4(oy*ss)),"min",U=uv2,V=uv2)
\ .mt_logic(mmg.mt_inpand(U=uv,V=uv).bicubicresize(m4(ox*ss),m4(oy*ss)),"max",U=uv2,V=uv2)
\ .spline64resize(ox,oy)
umfc = mt_lutxy(clp,ssc,"x y < x x y - "+DRK+" * - x x y - "+BRT+" * - ?",U=2,V=2)
mfc = mt_merge(clp,umfc,mask_f)

return(show_msk ? mask_f : mfc)
}

function m4(float x) {return(x<16?16:int(round(x/4.0)*4))}

