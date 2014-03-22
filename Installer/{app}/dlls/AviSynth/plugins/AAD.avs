# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# AAD: Auto Anime Decomb
# Version 0.1.5a For Avisynth 2.5.x
# Script by diseac
# for more information read this: (Chinese)
# http://www.nmm-hd.org/bbs/thread-667-1-1.html
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Used Plugins:
# TIVTC	v1.0.5	author: tritical
# a60224	040315	author: ちよクロ
# TDeint	v1.1	author: tritical
# nnedi3	v0.9.4	author: tritical
# TMM	v1.0	author: tritical
# Vinverse	dll ver.	author: tritical & Did└e
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

function AAD (
\ clip v, int "mode", bool "tff", string "ovr", bool "debug",
\ bool "ivtc2pass", bool "ivtc3pass", bool "finalpass", bool "ultimate")
{
mode      = default(mode,1)
tff       = default(tff,true)
ovr       = default(ovr,"noovr")
debug     = default(debug,false)
ivtc2pass = default(ivtc2pass,true)
ivtc3pass = default(ivtc3pass,true)
finalpass = default(finalpass,true)
ultimate  = default(ultimate,false)

last =
\   mode == 0 ? AADmode0(v,"tfm_log.txt")
\ : mode == 1 ? AADmode1(v,mode,tff,ovr,debug,ivtc2pass,ivtc3pass,finalpass,ultimate)
\ : mode == 2 ? AADmode1(v,mode,tff,ovr,debug,ivtc2pass,ivtc3pass,finalpass,ultimate)
\ : blankclip(pixel_type="YV12").subtitle("AAD Error: mode="+string(mode)+" is not correct parameter")

return(last)
}

# AAD mode 0: Output tfm's log
function AADmode0 (clip v, string "output"){
last = v.tfm(mode=3,slow=2,pp=1,output=output,debug=true,display=true)
return(last)
}

# AAD mode 1: 30i->24p 4passes IVTC
# AAD mode 2: 30i->24p 3passes IVTC with AAD original IVTC arithmetic
function AADmode1 (
\ clip v, int "mode", bool "tff", string "ovr", bool "debug",
\ bool "ivtc2pass", bool "ivtc3pass", bool "finalpass", bool "ultimate"){

vy = v.height
finalpass = ultimate && ivtc3pass ? false : finalpass
last = v
mode==1
\ ? AADdebug(debug,120,"AAD mode 1: 4passes IVTC")
\ : AADdebug(debug,120,"AAD mode 2: Another way IVTC")

vp11 = tff
\ ? DoubleWeave.a60224().AssumeTFF
\ : DoubleWeave.a60224().AssumeBFF
vp12 = ovr=="noovr"
\ ? tfm(mode=3,slow=2,pp=0,debug=debug,display=debug).tdecimate(mode=1)
\ : tfm(mode=3,slow=2,pp=0,debug=debug,display=debug,ovr=ovr).tdecimate(mode=1)
vp2 = ovr=="noovr"
\ ? conditionalfilter(vp11,
\   vp12.AADdebug(debug,150,"1pass - a60224 [drop]").AADdebug(debug,170,"2pass - tfm [on]"),
\   vp11.AADdebug(debug,150,"1pass - a60224 [on]").AADdebug(debug,170,"2pass - tfm [drop]"),
\   "IsCombedTIVTC","==","true")
\ : conditionalfilter(vp12,
\   vp11.AADdebug(debug,150,"1pass - tfm [drop]").AADdebug(debug,170,"2pass - a60224 [on]"),
\   vp12.AADdebug(debug,150,"1pass - tfm [on]").AADdebug(debug,170,"2pass - a60224 [drop]"),
\   "IsCombedTIVTC","==","true")

mode==1
\ ? ivtc2pass
\   ? vp2
\   : ovr=="noovr"
\     ? vp11.AADdebug(debug,150,"1pass - a60224 [on]").AADdebug(debug,170,"2pass [off]")
\     : vp12.AADdebug(debug,150,"1pass - tfm [on]").AADdebug(debug,170,"2pass [off]")
\ : AADivtc(tff).AADdebug(debug,150,"1pass - AADivtc [on]").AADdebug(debug,170,"2pass [forced off]")


vp30 = Interleave(
       \ separatefields().selecteven().nnedi3(dh=true,Y=true,U=true,V=true,field=1),
       \ separatefields().selectodd().nnedi3(dh=true,Y=true,U=true,V=true,field=0)
       \ )

vp31 = TDeint(mode=2,slow=2,full=false,mtnmode=3,tryweave=true,emask=tmm(1),edeint=vp30)
\      .AADdebug(debug,190,"3pass [limit]")
vp32 = TDeint(mode=2,slow=2,mthreshL=0,mthreshC=0,edeint=vp30)
\      .AADdebug(debug,190,"3pass [ultimate]")

ivtc3pass ? ultimate ? vp32 : vp31 : AADdebug(debug,190,"3pass [off]")


vp4 = Vinverse().AADdebug(debug,210,"4pass [on]")

finalpass ? vp4 : AADdebug(debug,210,"4pass [off]")

ovr=="noovr" ? AADdebug(debug,240,"tfm's ovr [off]") : AADdebug(debug,260,"tfm's ovr [on]")

return(last)

}

# AAD original IVTC arithmetic
function AADivtc (clip v, bool "tff"){
tff=default(tff,true)
v1=v.DoubleWeave.selecteven
v2=v.DoubleWeave.selectodd
conditionalfilter(v1,v2,v1,"IsCombedTIVTC","==","true")
tff ? assumeTFF : assumeBFF
tdecimate(mode=1)
return(last)
}

# AAD debug function: for display debug infomation on screen
function AADdebug (clip v, bool "debug", int "y", string "showinfo"){
last=v
debug ? subtitle(showinfo,y=y) : nop
return(last)
}

# Up sample for DVD anime, from 480p to 720p
function AUS720(clip v, int "a", int "w", int "d", int "s"){
a = default(a,0)
w = default(w,0)
d = default(d,0)
s = default(s,0)
last=v
nnedi2_rpow2(rfactor=2)
lanczos4resize(1280,720,a*2,w*2,0-d*2,0-s*2)
return last
}

# Trim cilp and use some other functions or second clip
function AADTrim(clip v, int "stf", int "edf", string "func", string "func2", clip "clip1", clip "clip2"){
eof = v.framecount-1
stf = stf<0             ? 0           : stf
edf = edf>eof           ? eof         : edf
edf = (edf==0)&&(stf>0) ? eof         : edf
edf = edf<0             ? 0-edf+stf-1 : edf
edf = edf<stf           ? stf         : edf
vv  = defined(clip2)   ? clip2       : v
v  = defined(clip1)   ? clip1       : v

v1 =
\ defined(func2)
\ ? (stf==1)
\   ? eval("vv.trim(0,-1)."+func2)
\   : eval("vv.trim(0,stf-1)."+func2)
\ : (stf==1)
\   ? vv.trim(0,-1)
\   : vv.trim(0,stf-1)
v2 =
\ defined(func)
\ ? (stf==0)&&(edf==0)
\   ? eval("v.trim(0,-1)."+func)
\   : eval("v.trim(stf,edf)."+func)
\ : (stf==0)&&(edf==0)
\   ? v.trim(0,-1)
\   : v.trim(stf,edf)
v3 =
\ defined(func2)
\ ? eval("vv.trim(edf+1,eof)."+func2)
\ : vv.trim(edf+1,eof)

last=
\ stf==0   ? v2+v3 :
\ edf==eof ? v1+v2 :
\ v1+v2+v3

defined(clip2) ? (clip2.framecount-1==eof) ? nop :
\ blankclip(pixel_type="YV12").subtitle("AADTrim Error: clip2's framecount must be same as last clip") : nop
# last.framecount-1==eof ? nop :
# \ blankclip(pixel_type="YV12").subtitle("AADTrim Error: framecount doesn't match")

return(last)
}
