Function MedSharpD(Clip C, int "thresh", int "rad", int "mode")
{

	_Thr = Default(thresh, 256)
        _Rad = Default(rad, 1)
        Mode = Default(mode, 1)

        THR  = string(_Thr)
        RAD  = string(_Rad)
        RAD2 = string( round(_Rad/1.4142) )

        Diff = Mode == 0 ? MT_Luts(C, C, mode="med", pixels = "-"+RAD2+" -"+RAD2+"-"+RAD2+" "+RAD2+" "+RAD2+" -"+RAD2+" "+RAD2+" "+RAD2+" 0 "+RAD+" "+RAD+" 0 -"+RAD+" 0 0 -"+RAD ,\
          expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1)\
                         : MT_Luts(C, C, mode="med", pixels = "-"+RAD2+" -"+RAD2+"-"+RAD2+" "+RAD2+" "+RAD2+" -"+RAD2+" "+RAD2+" "+RAD2+" 0 "+RAD+" "+RAD+" 0 -"+RAD+" 0 0 -"+RAD+" 0 0" ,\
          expr = "X Y - X Y - X Y - abs 1 + * X Y - abs 1 + "+THR+" 1 >= "+THR+" 0.5 ^ "+THR+" ? + / - 128 +", u=1,v=1)
        MT_adddiff(C, Diff, u=2, v=2)

Return(Last)
}

