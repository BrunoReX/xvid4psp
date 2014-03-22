function Demosaic(clip input, int "Mode", int "x_Offset", int "y_Offset") {
  last = input
  y_Offset == 0 ? AssumeFrameBased().SeparateFields().SelectOdd() : AssumeFrameBased().SeparateFields().SelectEven()
  TurnRight()
  x_Offset == 0 ? AssumeFrameBased().SeparateFields().SelectEven() : AssumeFrameBased().SeparateFields().SelectOdd()
  TurnLeft()
  y_Offset == 0 ? NNEDI(dh=True, field=1, Y=True, U=False, V=False) : NNEDI(dh=True, field=0, Y=True, U=False, V=False)
  TurnRight()
  x_Offset == 0 ? NNEDI(dh=True, field=0, Y=True, U=False, V=False) : NNEDI(dh=True, field=1, Y=True, U=False, V=False)
  TurnLeft()
  R = last

  last = input
  y_Offset == 0 ? AssumeFrameBased().SeparateFields().SelectEven() : AssumeFrameBased().SeparateFields().SelectOdd()
  TurnRight()
  x_Offset == 0 ? AssumeFrameBased().SeparateFields().SelectEven() : AssumeFrameBased().SeparateFields().SelectOdd()
  TurnLeft()
  y_Offset == 0 ? NNEDI(dh=True, field=0, Y=True, U=False, V=False) : NNEDI(dh=True, field=1, Y=True, U=False, V=False)
  TurnRight()
  x_Offset == 0 ? NNEDI(dh=True, field=0, Y=True, U=False, V=False) : NNEDI(dh=True, field=1, Y=True, U=False, V=False)
  TurnLeft()
  G1 = last

  last = input
  y_Offset == 0 ? AssumeFrameBased().SeparateFields().SelectOdd() : AssumeFrameBased().SeparateFields().SelectEven()
  TurnRight()
  x_Offset == 0 ? AssumeFrameBased().SeparateFields().SelectOdd() : AssumeFrameBased().SeparateFields().SelectEven()
  TurnLeft()
  y_Offset == 0 ? NNEDI(dh=True, field=1, Y=True, U=False, V=False) : NNEDI(dh=True, field=0, Y=True, U=False, V=False)
  TurnRight()
  x_Offset == 0 ? NNEDI(dh=True, field=1, Y=True, U=False, V=False) : NNEDI(dh=True, field=0, Y=True, U=False, V=False)
  TurnLeft()
  G2 = last

  Mode == 1  ? Eval("""
    G = G1.MergeLuma(G2, 0.5)
  """) : Eval(""" 
    NOP()
  """)

  Mode == 2  ? Eval("""
    G1.TurnRight()
    g11 = AssumeFrameBased().SeparateFields().SelectEven()
    g12 = AssumeFrameBased().SeparateFields().SelectOdd()

    G2.TurnRight()
    g21 = AssumeFrameBased().SeparateFields().SelectEven()
    g22 = AssumeFrameBased().SeparateFields().SelectOdd()

    x_Offset == 0 ? Interleave(g11, g12.MergeLuma(g22, 0.5)) : Interleave(g11.MergeLuma(g21, 0.5), g12)
    AssumeFieldBased()
    Weave()
    TurnLeft()
    G1 = last

    x_Offset == 0 ? Interleave(g21.MergeLuma(g11, 0.5), g22) : Interleave(g21, g22.MergeLuma(g12, 0.5))
    AssumeFieldBased()
    Weave()
    TurnLeft()
    G2 = last

    y_Offset == 0 ? \
      Interleave(G1.AssumeFrameBased().SeparateFields().SelectEven(), G2.AssumeFrameBased().SeparateFields().SelectOdd()) : \
      Interleave(G2.AssumeFrameBased().SeparateFields().SelectEven(), G1.AssumeFrameBased().SeparateFields().SelectOdd())
    AssumeFieldBased()
    Weave()

    NNEDI(dh=True, field=0, Y=True, U=False, V=False)
    TurnRight()
    NNEDI(dh=True, field=0, Y=True, U=False, V=False)
    TurnLeft()

    Spline36Resize(last.Width / 2, last.Height / 2)

    G = last
  """) : Eval(""" 
    NOP()
  """)

  (Mode < 1) || (Mode > 2)  ? Eval("""
    G = G1.MergeLuma(G2, 0.5)
  """) : Eval(""" 
    NOP()
  """)

  last = input
  y_Offset == 0 ? AssumeFrameBased().SeparateFields().SelectEven() : AssumeFrameBased().SeparateFields().SelectOdd()
  TurnRight()
  x_Offset == 0 ? AssumeFrameBased().SeparateFields().SelectOdd() : AssumeFrameBased().SeparateFields().SelectEven()
  TurnLeft()
  y_Offset == 0 ? NNEDI(dh=True, field=0, Y=True, U=False, V=False) : NNEDI(dh=True, field=1, Y=True, U=False, V=False)
  TurnRight()
  x_Offset == 0 ? NNEDI(dh=True, field=1, Y=True, U=False, V=False) : NNEDI(dh=True, field=0, Y=True, U=False, V=False)
  TurnLeft()
  B = last

  MergeRGB(R, G, B)
} 
     
