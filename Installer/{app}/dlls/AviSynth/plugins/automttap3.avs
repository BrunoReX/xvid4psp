#autotap3 is now automttap3
# Optimisations by: wizboy11 and Didée
function automttap3(clip clp, int "dx", int "dy", int "mtaps3", int "thresh"){
	
	c = clp
	#g = clp.converttoy8()
	
	dx = default(dx, c.width*2)
	dy = default(dy, c.height*2)
	mtaps3 = default(mtaps3, 1)
	thresh = default(thresh, 256)
	
	t1 = lanczosresize(clp, dx, dy, taps=1)
	t2 = lanczosresize(clp, dx, dy, taps=2)
	t3 = lanczosresize(clp, dx, dy, taps=3)
	t4 = lanczosresize(clp, dx, dy, taps=4)
	t5 = lanczosresize(clp, dx, dy, taps=5)
	t6 = lanczosresize(clp, dx, dy, taps=9)
	t7 = lanczosresize(clp, dx, dy, taps=36)
	
	
	m1 = mt_makediff(clp, lanczosresize(t1, clp.width, clp.height, taps=1), u=1, v=1)
	m2 = mt_makediff(clp, lanczosresize(t2, clp.width, clp.height, taps=1), u=1, v=1)
	m3 = mt_makediff(clp, lanczosresize(t3, clp.width, clp.height, taps=1), u=1, v=1)
	m4 = mt_makediff(clp, lanczosresize(t4, clp.width, clp.height, taps=2), u=1, v=1)
	m5 = mt_makediff(clp, lanczosresize(t5, clp.width, clp.height, taps=2), u=1, v=1)
	m6 = mt_makediff(clp, lanczosresize(t6, clp.width, clp.height, taps=3), u=1, v=1)
	m7 = mt_makediff(clp, lanczosresize(t7, clp.width, clp.height, taps=6), u=1, v=1)
	
	
	cp1 = mt_merge(t1.blur(1.42), t2, lanczosresize(mt_lutxy(m1, m2, "x 128 - abs y 128 - abs - "+string(thresh)+" *", u=1, v=1), dx, dy, taps=mtaps3))
	m100 = mt_makediff(clp, bilinearresize(cp1, clp.width, clp.height), u=3, v=3)
	
	cp2 = mt_merge(cp1, t3, lanczosresize(mt_lutxy(m100, m3, "x 128 - abs y 128 - abs - "+string(thresh)+" *", u=1, v=1), dx, dy, taps=mtaps3))
	m101 = mt_makediff(clp, bilinearresize(cp2, clp.width, clp.height), u=3, v=3)
	
	cp3 = mt_merge(cp2, t4, lanczosresize(mt_lutxy(m101, m4, "x 128 - abs y 128 - abs - "+string(thresh)+" *", u=1, v=1), dx, dy, taps=mtaps3))
	m102 = mt_makediff(clp, bilinearresize(cp3, clp.width, clp.height), u=3, v=3)
	
	cp4 = mt_merge(cp3, t5, lanczosresize(mt_lutxy(m102, m5, "x 128 - abs y 128 - abs - "+string(thresh)+" *", u=1, v=1), dx, dy, taps=mtaps3))
	m103 = mt_makediff(clp, bilinearresize(cp4, clp.width, clp.height), u=3, v=3)

	cp5 = mt_merge(cp4, t6, lanczosresize(mt_lutxy(m103, m6, "x 128 - abs y 128 - abs - "+string(thresh)+" *", u=1, v=1), dx, dy, taps=mtaps3))
	m104 = mt_makediff(clp, bilinearresize(cp5, clp.width, clp.height), u=3, v=3)
	
	cp6 = mt_merge(cp5, t7, lanczosresize(mt_lutxy(m104, m7, "x 128 - abs y 128 - abs - "+string(thresh)+" *", u=1, v=1), dx, dy, taps=mtaps3))
	m105 = mt_makediff(clp, bilinearresize(cp6, clp.width, clp.height), u=3, v=3)
	
return(mergechroma(cp6, spline36resize(clp, dx, dy), 1))}




