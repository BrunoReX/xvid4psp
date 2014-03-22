function LRemoveDust_YUY2(clip input, int clmode, int "limit")
{
clmode=default(clmode,17)
limit=default(limit,2)
repmode = 2
clensed = Clense(input, grey=true)
rep = Repair(clensed, input, mode=repmode, modeU=-1)
rg = RemoveGrain(rep, mode=_mode, modeU=-1)
return LimitChange(rg, input, limit, limitU=255)
}

function LRemoveDust_YV12(clip input, int clmode, int "limit")
{
clmode=default(clmode,17)
limit=default(limit,2)
repmode = 2
clensed = Clense(input)
rep = Repair(clensed, input, mode=repmode)
rg = RemoveGrain(rep, mode=clmode)
return LimitChange(rg, input, limit)
}