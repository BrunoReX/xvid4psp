function supa_degrain( clip clp ) {
        clp
        supa_sad = 150
        supa = msuper( )
        supa_vf1 = manalyse( supa, isb=false, delta=1, overlap=4, truemotion=false, sadx264=0 )
        supa_vb1 = manalyse( supa, isb=true, delta=1, overlap=4, truemotion=false, sadx264=0 )
        supa_vf2 = manalyse( supa, isb=false, delta=2, overlap=4, truemotion=false, sadx264=0 )
        supa_vb2 = manalyse( supa, isb=true, delta=2, overlap=4, truemotion=false, sadx264=0 )
        supa_vf3 = manalyse( supa, isb=false, delta=3, overlap=4, truemotion=false, sadx264=0 )
        supa_vb3 = manalyse( supa, isb=true, delta=3, overlap=4, truemotion=false, sadx264=0 )
        mdegrain3( last, supa, supa_vb1, supa_vf1, supa_vb2, supa_vf2, supa_vb3, supa_vf3, thsad=supa_sad )
}