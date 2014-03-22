function LimitedRemoveDust(clip input, int "_mode", int "limit") { 
  limit = default(limit,4) 
  repmode = 2 
  clensed = Clense(input) 
  rep = Repair(clensed, input, mode=repmode) 
  rg = RemoveGrain(rep, mode=_mode) 
  rd = TemporalRepair(rg, rep) 
  return LimitChange(rd, input, limit, limitU=255) 
} 
