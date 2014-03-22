Function ExBorders( clip c)
{
w = c.width()
h = c.height()
vflip = c.FlipVertical()
hflip = c.FlipHorizontal()
c
stackhorizontal( hflip.crop( w-16, 0, 16, h ).addborders( 0, 16, 0, 16 ),
\ stackvertical( vflip.crop( 0, h-16, w, 16 ), c, vflip.crop( 0, 0, w, 16 ) ),
\ hflip.crop( 0, 0, 16, h ).addborders( 0, 16, 0, 16 ) )
Return last
}