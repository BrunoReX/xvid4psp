#dfttest.dll
#Deen.dll
#aWarpSharp.dll
#FFT3dGPU.dll
#aWarpSharp.dll
#Deblock.dll
#mt_masktools-26.dll
#RgTools.dll
#AddGrainC.dll
#dither.dll
#TEdgeMask.dll
#flash3kyuu_deband.dll
#LumaDB_v0.7.avsi
#GrainFactory3mod_v1.2.avsi
#Dither.avsi
#DeHalo_Alpha.avs
#FastLineDarken 1.4x MT MOD.avsi


setmtmode(2)
# setmemorymax(256)

Deblock()
dfttest(sigma=10, tbsize=3)
FastLineDarkenMod()
deen("a3d",4,8,9)
Spline36Resize(last.width*2,last.height*2)
AddBorders(4, 0, 4, 0)
aWarpSharp(depth=8,blurlevel=4,thresh=0.2,cm=1)
FastLineDarkenMod()
aWarpSharp(depth=4,blurlevel=4,thresh=0.7,cm=1)
Crop(4,0,-4,0)
FastLineDarkenMod()
DeHalo_Alpha()
setmtmode(5)
fft3dgpu(wintype=1,degrid=1,bw=16,bh=16,ow=8,oh=8,bt=1,sigma=8,plane=4,mode=1,precision=1,sharpen=1.3)
setmtmode(2)

Spline36Resize(last.width/2,last.height/2)

# DeBanding 
DB = LumaDB(g1str=1.2,g2str=1.0,g3str=0,g1const=false,g2const=false,temp_avg=40, mask=false) 
mask = mt_edge("prewitt",17,17,17,17,u=3,v=3)
maskf = mt_logic(mask,mt_logic(mask.utoy(),mask.vtoy(),"or").spline64resize(width,height),"or").mt_expand().mt_expand()
mt_merge(last,DB,maskf.mt_invert(),luma=true)


