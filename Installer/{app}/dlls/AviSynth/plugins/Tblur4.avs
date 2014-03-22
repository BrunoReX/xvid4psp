Function Tblur4(Clip c, int "thresh")
{

Thresh = Default(Thresh, 8)
B1 = C.yahr
Mt_LutXY(C, b1, " X Y - abs X Y - abs * X Y - * X Y - abs X Y - abs * "+string(thresh)+" + / 128 +", u=1, v=1)

Mt_AddDiff(last, b1, u=1, v=1)

Return(last)
}
