function filldropsI (clip c)
{
  even = c.SeparateFields().SelectEven()
  super_even=MSuper(even,pel=2)
  vfe=manalyse(super_even,truemotion=true,isb=false,delta=1)
  vbe=manalyse(super_even,truemotion=true,isb=true,delta=1)
  filldrops_e = mflowinter(even,super_even,vbe,vfe,time=50)

  odd  = c.SeparateFields().SelectOdd()
  super_odd=MSuper(odd,pel=2)
  vfo=manalyse(super_odd,truemotion=true,isb=false,delta=1)
  vbo=manalyse(super_odd,truemotion=true,isb=true,delta=1)
  filldrops_o = mflowinter(odd,super_odd,vbo,vfo,time=50)

  evenfixed = ConditionalFilter(even, filldrops_e, even, "YDifferenceFromPrevious()", "lessthan", "0.1")
  oddfixed  = ConditionalFilter(odd,  filldrops_o, odd,  "YDifferenceFromPrevious()", "lessthan", "0.1")

  Interleave(evenfixed,oddfixed)
  Weave()
}