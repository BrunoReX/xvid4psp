# DLL併用 Destripe ver 0.3

# Destripe.avs(このファイル)とCullResize.dllを別の場所に置く場合修正が必要
# LoadPlugin("CullResize.dll")

function Destripe(clip clip, int "hh", int "rt", int "sft1", int "sft2", int "addb", int "mode") {
  addb = default(addb, 0)
  mode = default(mode, 1)

  Assert(hh>=1 && hh<=2048,"hhは1～2048")
  Assert(rt>=1 && rt<=64,"rtは1～64")
  Assert(sft1>=(-rt*4) && sft1<=(rt*4),"sft1範囲エラー")
  Assert(sft2>=(-rt*4) && sft2<=(rt*4),"sft2範囲エラー")
  Assert(addb>=0 && addb<=256 && (addb%2)==0,"addbは0～256の偶数")
  Assert(mode>=-158 && mode<=100, "modeは-158～100")

  w = clip.width()
  c = ((addb == 0) ? clip : clip.AddBorders(0, 0, 0, addb)).Separatefields()
  ve = c.SelectEven()
  vo = c.SelectOdd()
  ve = (mode == 0) ? ve.CullBicubicResize(w, hh, scale=rt, phase=-rt + sft1) : (
     \ (mode == 1) ? ve.CullSpline36Resize(w, hh, scale=rt, phase=-rt + sft1) : (
     \ ve.blur(0, -(float(mode) / 100.0)).CullSpline36Resize(w, hh, scale=rt, phase=-rt + sft1)))
  vo = (mode == 0) ? vo.CullBicubicResize(w, hh, scale=rt, phase=-rt + sft2) : (
     \ (mode == 1) ? vo.CullSpline36Resize(w, hh, scale=rt, phase=-rt + sft2) : (
     \ vo.blur(0, -(float(mode) / 100.0)).CullSpline36Resize(w, hh, scale=rt, phase=-rt + sft2)))
  return Interleave(ve, vo).Weave()
}

function TestDestripe(clip clip, int "hh", int "rt", int "sft1", int "sft2", int "addb", int "mode") {
  addb = default(addb, 0)
  mode = default(mode, 1)
  setinfo = String(hh)+" "+String(rt)+" "+String(sft1)+" "+String(sft2)
  setinfo = (addb != 0) ? (setinfo + " +" + String(addb)) : setinfo
  setinfo = (mode != 1) ? (setinfo + " m" + String(mode)) : setinfo
  return Interleave(
    \ clip.AddBorders(0, 0, 0, addb).
    \ SubTitle("Original", size=32, align=5),
    \ clip.Destripe(hh, rt, sft1, sft2, addb, mode).
    \ Lanczos4Resize(clip.Width(), clip.Height() + addb).
    \ SubTitle("Destripe " + setinfo, size=32, align=5))
}

function Zoom2(clip clip) {
  w = clip.Width()
  h = clip.Height()
  return clip.PointResize(w, h, w / 4, h / 4, w / 2, h / 2)
}
