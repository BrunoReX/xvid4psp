# 16/05/2007 by superqix 
#ie use: 
#LEM(ff="hqdn3d()",flem="LSFMOD()",mode="LEM") 
# 
#ff= function/filter that as be applied to "low importance zone" 
#flem= function/filter that as be applied to "high importance zone" 
#mode = "l" luma 
#mode = "e" Edge  
#mode = "m" Motion 
#nn()= function for no processing. 
#ie yellow zones are ff... 

function LEM( clip c, string "ff", string "flem", string "mode",  
\ int "th_low_luma", int "th_high_luma", int "th_motion", int "bl_sz_motion", int "th_edge" ){ 

mode=default(mode,"LEM") 
th_low_luma = default( th_low_luma, 60) 
th_high_luma = default( th_high_luma, 120) 
th_edge = default( th_edge, 4) 
bl_sz_motion = default( bl_sz_motion, 16) 
th_motion = default( th_motion, 16)

c_ff   = Eval("c." + ff   ) 
c_flem = Eval("c." + flem ) 
m_lem  = mask_lem(c,mode,th_low_luma,th_high_luma,th_motion,bl_sz_motion,th_edge) 

return mt_merge(c_ff , c_flem, m_lem , luma=true) 
} 

################################################################################ 

function mask_low_luma (clip i, int l1_th){return mt_binarize(i, threshold = l1_th).mt_invert()} 
function mask_high_luma(clip i, int l2_th){return mt_binarize(i, threshold = l2_th)} 

function mask_motion(clip i, int m_th, int bl_sz){ 
 global i_eval=i 
 super = i.MSuper() 
 v = MAnalyse(super, blksize=bl_sz) 
return MMask(super, v, ml=m_th, kind=1) 
} 
    
Function mask_edge(clip i, int e_th){return i.Msharpen(threshold=e_th,mask=true)} 

function mask_lem(clip i, string mode,  int l1_th, int l2_th, int m_th, int bl_sz, int e_th){ 
   Lenable = FindStr(UCase(mode),"L") 
   Eenable = FindStr(UCase(mode),"E") 
   Menable = FindStr(UCase(mode),"M") 
   L   = mt_logic( mask_low_luma(i,l1_th).mt_deflate() , mask_high_luma(i,l2_th).mt_deflate() , "or" ).mt_invert() 
   E   = mask_edge(i,e_th).mt_deflate().mt_deflate() 
   M   = mask_motion(i, m_th, bl_sz).mt_invert() 
   LE  = ( Lenable > 0 && Eenable > 0) ? mt_logic( L,E,"or") : ( Lenable > 0 ) ? L : ( Eenable > 0 ) ? E : M 
   LEM = ( Menable > 0 ) ? mt_logic(LE,M,"and") : LE 
return LEM} 

function nn(clip u){return u}