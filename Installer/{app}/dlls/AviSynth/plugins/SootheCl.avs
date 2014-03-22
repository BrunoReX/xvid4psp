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

