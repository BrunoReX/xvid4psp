function Lanczosmtplus(   clip c, int "dx", int "dy", int "thresh", int "thresh2", int "athresh",
\                       float "sharp1", float "sharp2", float "blur1", float "blur2",
\                       int "mtaps1", int "mtaps2", int "ttaps", int "ltaps", bool "preblur",
\                       int "depth", float "wthresh", float "wblur", int "mtaps3"){

	dx      = default(dx, c.width*2)
	dy      = default(dy, c.height*2)
	thresh  = default(thresh, 0)
	thresh2 = Default(thresh2, ((thresh+1)*(thresh+1))*64/(thresh+1))
	sharp1  = default(sharp1, 1)
	sharp2  = default(sharp2, 4)
	blur1   = default(blur1, 0.33)
	blur2   = default(blur2, 1.25)
	mtaps1  = default(mtaps1, 1)
	mtaps2  = default(mtaps2, 1)
	ttaps   = default(ttaps, 1)
	ltaps   = default(ltaps, 1)
	depth   = default(depth, 2)
	wthresh = default(wthresh, 0.90)
	wblur   = default(wblur, 2)
	mtaps3 = default(mtaps3, 1)
	preblur = default(preblur, false)
	athresh = default(athresh, 256)
	
	c
	s = c
	
	fd1     = lanczosresize(c, dx, dy, taps=mtaps1)
	fre1    = fd1.lanczosresize( c.width, c.height, taps=mtaps1)
	fre2    = fre1.automttap3(  ((c.width/16)*8 >= 144 ? (c.width/16)*8 : 144), ((c.height/16)*8 >= 144 ? (c.height/16)*8 : 144), \
							mtaps3=mtaps3, thresh=athresh).automttap3( c.width, c.height, mtaps3=mtaps3, thresh=athresh)
	m1      = mt_lutxy(fre1, s, "x y - abs "+string(thresh)+" - "+string(thresh2)+" *", u=1, v=1)
	m2      = lanczosresize(lanczosresize(frfun7(m1, 2.01, 256, 256),  (c.width/16)*8, (c.height/16)*8, taps=ttaps),   \
	                        dx, dy, taps=ttaps)

	d = preblur ? mt_merge(c, fre2, m1) :  c
	d2  = d.automttap3(dx, dy, mtaps3=mtaps3, thresh=athresh)
	d3  = lanczosresize(lanczosresize(d, c.width, c.height, taps=ttaps),   \
	                    d2.width, d2.height, taps=ttaps)
	d4  = mt_merge(  mt_lutxy(d2, d3 , "x y - "+string(sharp1)+" * x +" , u=1, v=1),    \
	                    mt_lutxy(d2, d3 , "y x - "+string(blur1)+" * x +" , u=1, v=1), m2)
	d5  = d4.automttap3(d.width, d.height, mtaps3=mtaps3, thresh=athresh)
		
	e   = mt_merge(d5, c, m1).automttap3(dx, dy, mtaps3=mtaps3, thresh=athresh)
	e   = e.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	e   = e.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	e   = e.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	e   = e.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	
	
	fd12    = lanczosresize(e, ((e.width*(dx/c.width))/16)*16, ((e.height*(dy/c.height))/16)*16, taps=mtaps2)
	fre12   = fd12.lanczosresize( e.width, e.height, taps=mtaps2)
	fre22   = fre12.lanczosresize( (e.width/16)*8, (e.height/16)*8, taps=mtaps2).lanczosresize( e.width, e.height, taps=mtaps2)
	m12     = mt_lutxy(fre12, e, "x y - abs "+string(thresh)+" - "+string(thresh2*1)+" *", u=1, v=1)
	m12     = m12.lanczosresize( (e.width/16)*8, (e.height/16)*8, taps=mtaps2).lanczosresize( e.width, e.height, taps=mtaps2)
	
	
	e2  = lanczosresize(lanczosresize(e, c.width, c.height, taps=ltaps),   \
	                    e.width, e.height, taps=ltaps)
	e2  = e2.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	e2  = e2.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	e2  = e2.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	e2  = e2.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	
	e3  = mt_merge(  mt_lutxy(e, e2 , "y x - "+string(blur2)+" * x +" , u=1, v=1),  \
	                 mt_lutxy(e, e2 , "x y - "+string(sharp2)+" * x +" , u=1, v=1), \
	                 m12)
	e3  = e3.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	e3  = e3.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	e3  = e3.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	e3  = e3.awarpsharp(depth=depth, cm=0, blurlevel=wblur, thresh=wthresh)
	
	
	mt_merge(d4, e3, m2)
	
return(last.mergechroma(spline36resize(c, dx, dy), 1))}
