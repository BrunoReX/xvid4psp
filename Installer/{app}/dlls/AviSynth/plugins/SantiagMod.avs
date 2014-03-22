# Одиниз наиболее сильных скриптов антиайлизинга
function SantiagMod(clip input, string "type", int "strh", int "strv") {
  type = Default(type, "NNEDI3")
  strh = Default(strh, 1)
  strv = Default(strv, 1)

  input

  strh > 0 ? AntiAliasing(type=type, strength=strh) : NOP()
  TurnLeft()
  strv > 0 ? AntiAliasing(type=type, strength=strv) : NOP()
  TurnRight()

  function AntiAliasing(clip input, string "type", int "strength") {
    input

    GScript("""
      if (type == "EEDI3") {
        EEDI3(dh=True, field=0)
        for (i = 2, strength) {
          EEDI3(dh=False, field=(i + 1) % 2)
        }
      }
      else if (type == "NNEDI2") {
        NNEDI2(dh=True, field=0)
        for (i = 2, strength) {
          NNEDI2(dh=False, field=(i + 1) % 2)
        }
      }
      else {
        NNEDI3(dh=True, field=0)
        for (i = 2, strength) {
          NNEDI3(dh=False, field=(i + 1) % 2)
        }
      }
    """)

    Spline36Resize(input.Width(), input.Height(), 0, 0.5, input.Width(), input.Height() * 2)
  }
}