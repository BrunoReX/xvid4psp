function Calm (clip clp, int "rep0")
{
    ox = clp.width()
    oy = clp.height()

    # create linearily weighted temporal averaging
    ts1 = clp.temporalsoften(1,255,255,28,2)
    ts2 = clp.temporalsoften(2,255,255,28,2)

    # construct temporal gaussian average from linear averages
    t = ts1.merge(ts2,0.357).merge(clp,0.125)
    
    # Create clip for motion search.
    searchclip = t.removegrain(11).gaussresize(ox,oy,0,0,ox+.0001,oy+.0001,p=2)
     \             .merge(t,0.1).mt_lutxy(t3,"x 7 + y < x 2 + x 7 - y > x 2 - x 51 * y 49 * + 100 / ? ?",U=3,V=3)

    return (searchclip)
}