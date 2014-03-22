# Одиниз наиболее сильных скриптов антиайлизинга
Function santiag2 (clip c, int "strh", int "strv")
{
	strh = Default (strh, 1)
	strv = Default (strv, 1)

	c
	santiag_dir (strh)
	TurnLeft ()
	santiag_dir (strv)
	TurnRight ()
}

Function santiag_dir (clip c, int strength)
{
	c
	w = Width ()
	h = Height ()
	santiag_stronger (strength)
	Spline36Resize (w, h, 0, -0.5, w, h * 2)
}

Function santiag_stronger (clip c, int strength)
{
	c
	(strength <= 0)
\	?	NNEDI2 (dh=true, field=0)
\	:	santiag_stronger (strength - 1)
\	.	NNEDI2 (dh=false, field=(strength % 2))
}

