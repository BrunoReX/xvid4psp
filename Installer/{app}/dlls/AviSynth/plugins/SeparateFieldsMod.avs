# Separates frame-based material into fields using a resizer rather than simply dropping alternate lines.
# The resize effectively performs a vertical low-pass to produce result that will interpolate more easily
# May output with different dimensions. Note that NewHeight refers to the frame height, not the field height
# E.g. given progressive HD input, interlace to SD like so: SeparateFieldsMod(720,480).Weave()

function SeparateFieldsMod( clip c, int "NewWidth", int "NewHeight" )
{
	Assert( c.IsFrameBased(), \
	        "SeparateFieldsMod: SeparateFieldsMod should be applied on frame-based material: use AssumeFrameBased() beforehand" )
	Assert( !c.IsYV12() || c.Height()%4 == 0, "SeparateFieldsMod: YV12 height must be multiple of 4" )
	Assert( c.Height()%2 == 0, "SeparateFieldsMod: height must be even" )
	
	NewWidth  = default( NewWidth,  c.Width()  )
	NewHeight = default( NewHeight, c.Height() )

	shift = (c.GetParity() ? -0.5 : 0.5) * c.Height() / Float(NewHeight) 
	c.Spline36Resize( NewWidth,c.Height() )
	e  = Spline36Resize( NewWidth,NewHeight/2, 0, shift )
	o  = Spline36Resize( NewWidth,NewHeight/2, 0,-shift )
	ec = c.IsYV12() ? Spline36Resize( NewWidth,NewHeight/2, 0, 2*shift ) : NOP()
	oc = c.IsYV12() ? Spline36Resize( NewWidth,NewHeight/2, 0,-2*shift ) : NOP()

	Interleave( e, o )
	c.IsYV12() ? MergeChroma(Interleave( ec, oc )) : last 

	AssumeFieldBased()
	return c.GetParity() ? AssumeTFF() : AssumeBFF()
}

