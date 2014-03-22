########
# Levels transforms by Did?e
# Requires MaskTools v2.0 or greater
# last revision 2004-12-07; update to MaskTools v2.0 semantics 2008-03-09
#
# PARAMETERS:
#   "input_low"     : (Default: 0)
#   "gamma"         : (Default: 1.0)
#   "input_high"    : (Default: 255)
#   "output_low"    : (Default: 0)
#   "output_high"   : (Default: 255)
#   "show_function" : (Default: false) - the function to be made into a lookup-table
#                                        transform, shown in postfix notation
#
# USAGE:
#   YLevels(0, 1.2, 255, 0, 255, false)
#   YLevels(0, 1.2, 255)
#   YLevels(gamma=1.2)



# Constant
function Ylevels(clip clp,
\                int "input_low", float "gamma", int "input_high",
\                int "output_low", int "output_high", int "show_function")
{ 
    input_low = Default(input_low, 0)
    gamma = Default(gamma, 1.0)
    input_high = Default(input_high, 255)
    output_low = Default(output_low, 0)
    output_high = Default(output_high, 255)
    show_function = Default(show_function, false)
    
    wicked = "x " +string(input_low)+ " - " +string(input_high)+ " " +string(input_low)+ " - / 1 " +string(gamma)+
    \        " / ^ " +string(output_high)+ " " +string(output_low)+ " - * " +string(output_low)+ " +"
        
    return( show_function ? clp.subtitle(wicked) : clp.mt_lut(Yexpr = wicked, U=2,V=2) )  
}
         
# Gradient
function YlevelsG(clip clp,
\                int "input_low", float "gamma", int "input_high",
\                int "output_low", int "output_high", bool "show_function")
{ 
    input_low = Default(input_low, 0)
    gamma = Default(gamma, 1.0)
    input_high = Default(input_high, 255)
    output_low = Default(output_low, 0)
    output_high = Default(output_high, 255)
    show_function = Default(show_function, false)	
    
    wicked = gamma > 1.0
    \      ? "x " +string(input_low)+ " - " +string(input_high)+ " " +string(input_low)+ " - / 1 " +string(gamma)+
    \        " / ^ " +string(output_high)+ " " +string(output_low)+ " - * " +string(output_low)+ " + x * x 255 x - * + 255 /"
    \      : "x " +string(input_low)+ " - " +string(input_high)+ " " +string(input_low)+ " - / 1 " +string(gamma)+
    \        " / ^ " +string(output_high)+ " " +string(output_low)+ " - * " +string(output_low)+ " + 255 x - * x x * + 255 /"
    
    return( show_function ? clp.subtitle(wicked) : clp.mt_lut(Yexpr = wicked, U=2,V=2) )  
}

# Sine
function YlevelsS(clip clp,
\                int "input_low", float "gamma", int "input_high",
\                int "output_low", int "output_high", bool "show_function")
{ 
    input_low = Default(input_low, 0)
    gamma = Default(gamma, 1.0)
    input_high = Default(input_high, 255)
    output_low = Default(output_low, 0)
    output_high = Default(output_high, 255)
    show_function = Default(show_function, false)
    
    wicked="x " +string(input_low)+ " - " +string(input_high)+ " " +string(input_low)+ " - / 1 " +string(gamma)+
    \      " / ^ " +string(output_high)+ " " +string(output_low)+ " - * " +string(output_low)+ " + x 162,97466 /" +
    \      " sin 255 * * x 255 x 162,97466 / sin 255 * - * + 255 /"
    
    return( show_function ? clp.subtitle(wicked) : clp.mt_lut(Yexpr = wicked, U=2,V=2) )  
}

# Cosine
function YlevelsC(clip clp,
\                int "input_low", float "gamma", int "input_high",
\                int "output_low", int "output_high", bool "show_function")
{ 
    input_low = Default(input_low, 0)
    gamma = Default(gamma, 1.0)
    input_high = Default(input_high, 255)
    output_low = Default(output_low, 0)
    output_high = Default(output_high, 255)
    show_function = Default(show_function, false)
    
    wicked="x " +string(input_low)+ " - "+ string(input_high)+ " " +string(input_low)+ " - / 1 "+string(gamma)+
    \      " / ^ " +string(output_high)+ " " +string(output_low)+ " - * " +string(output_low)+ " + 255 x 162,97466" +
    \      " / cos 255 * - * x x 162,97466 / cos 255 * * + 255 /"
    
    return( show_function ? clp.subtitle(wicked) : clp.mt_lut(Yexpr = wicked, U=2,V=2) )  
}



