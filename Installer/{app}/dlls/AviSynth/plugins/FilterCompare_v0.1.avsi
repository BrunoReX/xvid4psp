Function FilterCompare(clip input, clip filtered, int "frame", bool "info"){

  Assert( input.width==filtered.width && input.height==filtered.height, 
        \ "FilterCompare: two clips must have same resolution!!" )
  
  info     = Default( info, false )
  w        = input.width
  h        = input.height
  
  input    = info ? input.Info()
                        \.Subtitle("Original", x=w-62, y=1)
                        \.Subtitle("Original", x=w-62, y=h-21)
                        \.Subtitle("Original", x=3, y=h-21)
           \      : input
  filtered = info ? filtered.Info()
                           \.Subtitle("Filtered", x=w-60, y=1)
                           \.Subtitle("Filtered", x=w-60, y=h-21)
                           \.Subtitle("Filtered", x=3, y=h-21)
           \      : filtered
  
  return !Defined(frame) ? Interleave(input, filtered) : 
                         \ (frame==0) ? input.Trim(0, -1)++filtered.Trim(0, -1) :
                         \ input.Trim(frame, frame)++filtered.Trim(frame, frame)
}
