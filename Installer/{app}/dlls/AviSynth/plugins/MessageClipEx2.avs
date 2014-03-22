function MessageClipEx2(clip clp, string text, int "xx", int "yy", float "hy", \
                        int "first_frame", int "last_frame", string "font", \
                        string "effects", int "size_min", int "size_max", \
                        int "text_color", int "halo_color")
{
  # SubtitleEx(
  # clip clp
  # string text,
  # int "x",
  # int "y",
  # int "firstframe",
  # int "lastframe",
  # string "font",
  # string "effects",
  # int "size",
  # int "textcolor",
  # int "halocolor")
 
  size_max   = Default(size_max, 80)
  size_min   = Default(size_min, 40)
  hy         = Default(hy, 1.70)
  xx         = Default(xx, 50)
  yy         = Default(yy, 100)
  text_color = Default(text_color, $00FFFFFF)   # White color text by default...
  halo_color = Default(halo_color, $00000000)   # Halo color background by default...
 
  last         = clp
 
  size_max     = (size_max == size_min) ? size_max + size_min : size_max
  LengthString = StrLen(text)
  Step         = Ceil(LengthString / 2.0)
  StepHeight   = Int((size_max - size_min) / (Step - 1))
  WrkSize      = size_max
  WrkStr       = ""
 
  GScript("""
  for (i = 1, LengthString, 1) {
    WrkStr = MidStr(text, i, 1)
    if (i == 1) {
      SubTitleEx(last, WrkStr, x=xx, y=yy, effects=effects, size=size_max, textcolor=text_color, halocolor=halo_color, \
                 firstframe=first_frame, lastframe=last_frame, font=font)
    }
    else {
      if (i == LengthString) {
        if (size_max > size_min) {
          xx = xx + Int(size_max / hy)
        }
        if (size_max < size_min) {
          xx = xx + Int(WrkSize / hy)
        }
        SubTitleEx(last, WrkStr, x=xx, y=yy, effects=effects, size=size_max, textcolor=text_color, halocolor=halo_color, \
                   firstframe=first_frame, lastframe=last_frame, font=font)
      }
      else {
        if ((LengthString % 2) > 0) {
          if (i == Step) {
            if (size_max > size_min) {
              xx = xx + Int(WrkSize / hy)
            }
            WrkSize = WrkSize - StepHeight
            if (size_max < size_min) {
              xx = xx + Int(size_min / hy)
            }
            SubTitleEx(last, WrkStr, x=xx, y=yy, effects=effects, size=size_min, textcolor=text_color, halocolor=halo_color, \
                       firstframe=first_frame, lastframe=last_frame, font=font)
          }
          if (i < Step) {
            if (size_max > size_min) {
              xx = xx + Int(WrkSize / hy)
            }
            WrkSize = WrkSize - StepHeight
            if (size_max < size_min) {
              xx = xx + Int(WrkSize / hy)
            }
            SubTitleEx(last, WrkStr, x=xx, y=yy, effects=effects, size=WrkSize, textcolor=text_color, halocolor=halo_color, \
                       firstframe=first_frame, lastframe=last_frame, font=font)
          }
          if (i > Step) {
            if (size_max < size_min) {
              xx = xx + Int(WrkSize / hy)
            }
            WrkSize = WrkSize + StepHeight
            if (size_max > size_min) {
              xx = xx + Int(WrkSize / hy)
            }
            SubTitleEx(last, WrkStr, x=xx, y=yy, effects=effects, size=WrkSize, textcolor=text_color, halocolor=halo_color, \
                       firstframe=first_frame, lastframe=last_frame, font=font)
          }
        }
        if ((LengthString % 2) == 0) {
          if ((i == Step) || (i == Step + 1)) {
            if (i == Step) {
              if (size_max > size_min) {
                xx = xx + Int(WrkSize / hy)
              }
              if (size_max < size_min) {
                xx = xx + Int(size_min / hy)
              }
            }
            else {
              WrkSize = WrkSize - StepHeight
              xx = xx + Int(size_min / hy)
            }
            SubTitleEx(last, WrkStr, x=xx, y=yy, effects=effects, size=size_min, textcolor=text_color, halocolor=halo_color, \
                       firstframe=first_frame, lastframe=last_frame, font=font)
          }
          if (i < Step) {
            if (size_max > size_min) {
              xx = xx + Int(WrkSize / hy)
            }
            WrkSize = WrkSize - StepHeight
            if (size_max < size_min) {
              xx = xx + Int(WrkSize / hy)
            }
            SubTitleEx(last, WrkStr, x=xx, y=yy, effects=effects, size=WrkSize, textcolor=text_color, halocolor=halo_color, \
                       firstframe=first_frame, lastframe=last_frame, font=font)
          }
          if (i > Step + 1) {
            if (size_max < size_min) {
              xx = xx + Int(WrkSize / hy)
            }
            WrkSize = WrkSize + StepHeight
            if (size_max > size_min) {
              xx = xx + Int(WrkSize / hy)
            }
            SubTitleEx(last, WrkStr, x=xx, y=yy, effects=effects, size=WrkSize, textcolor=text_color, halocolor=halo_color, \
                       firstframe=first_frame, lastframe=last_frame, font=font)
          }
        }
      }
    }
    WrkStr = ""
  }
  """)
 
  clp = last
 
  return clp
}
