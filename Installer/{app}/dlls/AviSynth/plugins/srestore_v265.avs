function srestore(clip source, float "frate", int "dmode", "omode", float "speed", float "blocks", float "thresh", bool "chroma", int "cache", clip "dclip", float "pthresh", clip "pclip")
{
###### parameters & other necessary vars ######
	rad     = isfloat(speed) && speed>=1 ? sqrt(speed)*16 : 48
    cache   = default(cache,-1)
    irate   = framerate(source)
    bsize   = isfloat(blocks) && blocks>=1 ? sqrt(blocks)*4 : 16

global  dm      = default(dmode,4)
global  om      = default(omode,6)
global  thr     = abs(default(thresh,22))+0.01
global  pthr    = default(pthresh,16)*25.6
global  frfac   = isstring(om) || abs(om-3)<2.5 ? 1 : isfloat(frate) ? frate*5<irate || frate>irate ? 1 :
            \ abs(frate)/irate : round(irate*10010)%30000==0 ? 1001./2400. : 480./1001.                     #framerate factor
global  bfac    = sqrt(bsize*0.25)*0.54                                                                             #blend factor

global  numr    = abs(frfac*1001-round(frfac*1001))<0.01 ? round(frfac*1001) :
                \ abs(1001/frfac-round(1001/frfac))<0.01 ? 1001 : round(frfac*9000)
global  numr    = isfloat(frate) && abs(irate*numr/float(round(numr/frfac))-frate) >
                \ abs(irate*round(frate*100)/float(round(irate*100))-frate) ? round(frate*100) : numr
global  denm    = round(numr/frfac)


###### source preparation & lut ######
global  out = source

global  det	= default(dclip,source).killaudio().converttoyv12()
global  det	= det.pointresize(int(width(det)/rad+1)*16, int(height(det)/rad+1)*16).trim(2,0)
global  det	= default(chroma,false) ? stackvertical(stackhorizontal(det.utoy(),det.vtoy()),det) : det

    code0	= "x 128 == y 128 == | x y + 256 == | 0 x 128 - abs y 128 - abs < x 128 - abs x y + 256 - abs < & x 128 - abs 1 - " +
            \ "y 128 - abs x y + 256 - abs < y 128 - abs 1 - x y + 256 - abs 1 - ? ? 2.4 ^ x 128 - y 128 - * 0 > -0.6 0.6 ? * ? 128 +"
    code1   = "x 128 - y 128 - * 1 < 0 x 128 - abs y 128 - abs < x 128 - abs 0.5 ^ x 128 - abs - y 128 - abs 0.5 ^ y 128 - abs - ? ? " +
            \ "128 + x y - abs 0.5 ^ - x y - abs 1.2 ^ +"
	diff 	= mt_makediff(det,det.trim(1,0),y=3,u=1,v=1)
global  bclp    = abs(dm)==1 ? nop() : isstring(om)==false ? mt_lutxy(diff,diff.trim(1,0),expr=code0,y=3,u=1,v=1):
                \ mt_lutxy(diff.trim(1,0),mt_adddiff(diff,diff.trim(2,0),y=3,u=1,v=1),expr=code1,y=3,u=1,v=1)
global  bclp    = abs(dm)==1 ? nop() : bclp.bilinearresize(round(width(det)/bsize+4)*4,round(height(det)/bsize+4)*4)
global  dclp    = diff.trim(1,0).mt_lut("x 128 - abs 1.1 ^ 1 -",y=3,u=1,v=1).bilinearresize(round(width(det)/(bsize*2)+4)*4,round(height(det)/(bsize*2)+4)*4)

global  pclip   = isclip(pclip) ? pclip : nop()

###### POSTPROCESSING ######
    unblend1    = isstring(om) ? average(out.trim(2,0), -1.0, out.trim(3,0), 2.0) : nop()
    unblend2    = isstring(om) ? average(out.trim(4,0), 2.0, out.trim(5,0), -1.0) : nop()

    qmask1  = isstring(om) ? mt_makediff(unblend1.removegrain(mode=19,modeU=-1,modeV=-1),unblend1,y=3,u=1,v=1) : nop()
    qmask2  = isstring(om) ? mt_makediff(unblend2.removegrain(mode=19,modeU=-1,modeV=-1),unblend2,y=3,u=1,v=1) : nop()
    diffm   = isstring(om) ? mt_makediff(out.trim(2,0),out.trim(3,0),y=3,u=1,v=1).mt_lut("x y - abs",y=3,u=1,v=1).mt_expand() : nop()
    bmask	= isstring(om) ? mt_lutxy(qmask1,qmask2,expr="x y - == 128 x 128 - 2 ^ x 128 - 2 ^ y 128 - 2 ^ + / 255 *",y=3,u=1,v=1) : nop()
    dmask	= isstring(om) ? mt_lutxy(diffm,diffm.trim(2,0),expr="x 2 * y < x 4 < & 0 y 2 * x < y 4 < & 255 x x y + / 200 * 28 + ? ?",y=3,u=1,v=1) : nop()
    pmask	= isstring(om) ? mt_lutxy(dmask, bmask, expr="y 0 > y 255 < & x 0 == x 255 == | & x y ?",y=3,u=1,v=1) : nop()

    pp0 	= isstring(om) ? average(out.trim(2,0), -0.5, out.trim(3,0), 1.0, out.trim(4,0), 1.0, out.trim(5,0), -0.5) : nop()
    pp1 	= isstring(om) ? mt_merge(unblend1,unblend2,dmask.removegrain(mode=12,modeU=-1,modeV=-1).greyscale(),y=3,u=3,v=3) : nop()
    pp2 	= isstring(om) ? mt_merge(unblend1,unblend2,bmask.removegrain(mode=12,modeU=-1,modeV=-1),luma=true) : nop()
    pp3 	= isstring(om) ? mt_merge(unblend1,unblend2,pmask.removegrain(mode=12,modeU=-1,modeV=-1),luma=true).removegrain(mode=0,modeU=12,modeV=12) : nop()

global  fin  = isstring(om) ? eval(om) : nop()


###### helper function ######
function min4(a,b,c,d)
{
    e = a<b ? a : b
    f = c<d ? c : d
    return (e<f ? e : f)
}


###### initialise variables ######
global  lfr     = -100
global  offs    = 0
global  ldet    = -100
global  lpos    = 0

###### function for output calculation ######
function ocalc(cfr,b_v,c_v,d_v,m_v)
{
 ### preparation ###
        jmp = lfr+1==cfr
        cfo = (((cfr%denm)*numr*2+denm+(versionnumber()>2.575 ? numr : 0))%(2*denm))-denm
        bfo = cfo>-numr && cfo<=numr

    global  lfr     = cfr
    global  offs    = bfo && offs<=-4*numr ? offs+2*denm : bfo && offs>=4*numr ? offs-2*denm : offs

        pos = frfac==1 ? 0 : bfo ? -round((cfo+offs)/(2.*numr)) : lpos
        cof = cfo+offs+2*numr*pos
        
    global  ldet    = cfr+pos==ldet ? -1 : cfr+pos
    
        b_v = b_v>128 ? 0 : (128-b_v) * bfac
        c_v = c_v<128 ? 0 : (c_v-128) * bfac
        m_v = m_v*10+0.001
        
  ## blend value shifting ##
    global  bp3 = jmp ? bp2 : b_v
 	global  bp2	= jmp ? bp1 : b_v
	global  bp1	= jmp ? bn0 : b_v
	global  bn0	= jmp ? bn1 : b_v
	global  bn1	= jmp ? bn2 : b_v
	global  bn2	= jmp ? bn3 : b_v
	global  bn3 = b_v
	
  ## clear value shifting ##
	global  cp3	= jmp ? cp2 : c_v
	global  cp2	= jmp ? cp1 : c_v
	global  cp1	= jmp ? cn0 : c_v
	global  cn0 = jmp ? cn1 : c_v
	global  cn1 = jmp ? cn2 : c_v
	global  cn2 = jmp ? cn3 : c_v
	global  cn3 = c_v
   
  ## diff value shifting ##
    global  d43 = jmp ? d32 : d_v
 	global  d32 = jmp ? d21 : d_v
	global  d21 = jmp ? d10 : d_v
	global  d10 = jmp ? d01 : d_v
	global  d01 = jmp ? d12 : d_v
	global  d12 = jmp ? d23 : d_v
	global  d23 = jmp ? d34 : d_v
    global  d34 = d_v

  ## diff value shifting ##
    global  m64 = jmp ? m53 : m_v
    global  m53 = jmp ? m42 : m_v
 	global  m42 = jmp ? m31 : m_v
    global  m31 = jmp ? m20 : m_v
	global  m20 = jmp ? m11 : m_v
	global  m11 = jmp ? m02 : m_v
	global  m02 = jmp ? m13 : m_v
	global  m13 = jmp ? m24 : m_v
    global  m24 = m_v
	
  ## used detection values ##
        bb  = select(pos+2,bp3,bp2,bp1,bn0,bn1)
        bc  = select(pos+2,bp2,bp1,bn0,bn1,bn2)
        bn  = select(pos+2,bp1,bn0,bn1,bn2,bn3)
        
        cb  = select(pos+2,cp3,cp2,cp1,cn0,cn1)
        cc  = select(pos+2,cp2,cp1,cn0,cn1,cn2)
        cn  = select(pos+2,cp1,cn0,cn1,cn2,cn3)
        
        dbb = select(pos+2,d43,d32,d21,d10,d01)
        dbc = select(pos+2,d32,d21,d10,d01,d12)
        dcn = select(pos+2,d21,d10,d01,d12,d23)
        dnn = select(pos+2,d10,d01,d12,d23,d34)

        mb2 = select(pos+2,m64,m53,m42,m31,m20)
        mb1 = select(pos+2,m53,m42,m31,m20,m11)
        mb  = select(pos+2,m42,m31,m20,m11,m02)
        mc  = select(pos+2,m31,m20,m11,m02,m13)
        mn  = select(pos+2,m20,m11,m02,m13,m24)
        mn1 = select(pos+2,m11,m02,m13,m24,0.001)
        mn2 = select(pos+2,m02,m13,m24,0.001,0.001)
        

 ### basic calculation ###
        bthr    = 1+thr*frfac*0.04
        
        pan     = frfac<.46 || frfac>.54 || dbc*9<dcn || dcn*9<dbc || .6*bc>bb && .6*bc>bn ? 0 : (mb2<1.2*mb && mb<1.2*mb2 ||
                \ mn2<1.2*mn && mn<1.2*mn2) && mb<1.2*mn && mn<1.2*mb && mn1<.8*mc && mb1<.8*mc ? mb/thr*mn/thr :
                \ mc>.4*thr && mc<1.2*mb1 && mb1<1.2*mc && mc<1.2*mn1 && mn1<1.2*mc && (mn<.7*mb || mb<.7*mn) &&
                \ (mb<.7*mb2 || mb2<.7*mb || mn<.7*mn2 || mn2<.7*mn) ? -1 : 0

        blend   = bc+cb>bb+bthr*cc && bc+cn>bn+bthr*cc && (bc>bthr*cc || abs(dm)<4) && dbc*9>dcn && dcn*9>dbc ?
                \ min4(bc+cb-bb-cc,bc+cn-bn-cc,abs(dm)<4 ? thr : bc-cc,.5*(dbc+dcn))/thr : 0
                
        clear   = cc+bb>(cb+bc)*(1+thr*(1-frfac)*0.04) && cc+bn>(cn+bc)*(1+thr*(1-frfac)*0.04) && cc*bb>=cb*bc && cc*bn>=cn*bc &&
                \ cc>=cb && cc>=cn && (frfac>.55 || abs(dm)<4 || cb*bthr<bb && cn*bthr<bn) && dbc*9>dcn && dcn*9>dbc ?
                \ min4(cc+bb-cb-bc,cc+bn-cn-bc,abs(dm)<4 ? thr : cc,.5*(dbc+dcn))/thr : 0

        highd   = dcn>10 && dcn>9*dbc && dcn>9*dnn && mc<700 && mn<700 ? 1-frfac : 0

        lowd    = dbc>10 && dnn>10 && (dcn*9<dbc && dcn*9<dnn || dcn*dcn<dbc && dcn*dcn<dnn) && (frfac<.51 || dbb>10 && dcn*dcn<dbb) &&
                \ mc<700 && mn<700 && frfac>0.35 ? 1-frfac : 0
                
        clear   = pan==-1 ? 0 : (bc+cb>1.1*bb+cc && bc+cn>1.1*bn+cc || pan<0.17 || pan>6 ? clear*clear*clear : pan) * (1-frfac)
        blend   = blend<=0 || pan>0.17 && pan<6 && (bb>.6*bc || bn>.6*bc) ? 0 : blend*blend*blend*frfac

 ### offset calculation ###
        odw     = lowd>0 ? lowd : highd>0 ? highd : blend>0 ? blend : clear
        odm     = highd>0 ? denm-numr : blend>0 ? denm : clear>0 ? 0 : lowd>0 ? 2*denm-numr : cof
        odm     = odm+round((cof-odm)/(2.*denm))*2*denm
        odr     = (highd>0 ? numr : blend>0 ? denm-numr : lowd>0 ? (frfac<0.5 ? 2*numr : 2*(denm-numr)) : numr) * 0.9

        cof     = ldet<0 ? cof :cof>odm+odr ? cof-odw*denm<odm+odr ? odm+odr : cof-odw*denm :
                \ cof<odm-odr ? cof+odw*denm>odm-odr ? odm-odr : cof+odw*denm : cof

    global  offs    = frfac==1 ? 0 : cof-cfo-2*numr*pos
    global  lpos    = pos
        opos    = frfac==1 ? 0 : -round((cfo+offs+(bfo && offs<=-4*numr ? denm : 0))/(2.*numr))
        pos     = opos<-2 ? -2 : opos>2 ? 2 : opos


 ### frame output calculation - resync - dup ###
        bb  = select(pos+2,bp3,bp2,bp1,bn0,bn1)
        bc  = select(pos+2,bp2,bp1,bn0,bn1,bn2)
        bn  = select(pos+2,bp1,bn0,bn1,bn2,bn3)

        dbb = select(pos+2,d43,d32,d21,d10,d01)
        dbc = select(pos+2,d32,d21,d10,d01,d12)
        dcn = select(pos+2,d21,d10,d01,d12,d23)
        dnn = select(pos+2,d10,d01,d12,d23,d34)
        
        mb  = select(pos+2,m42,m31,m20,m11,m02)
        mc  = select(pos+2,m31,m20,m11,m02,m13)
        mn  = select(pos+2,m20,m11,m02,m13,m24)

  ## dup_hq ##
        dup     = opos<-2 || opos>2 || dm<0 ? 0 : dcn*5<dbc && dnn*5<dbc && (dcn<thr || bn<=bc) ||
                \ (dcn*dcn<dbc || dcn*9<dbc) && bn<=bc && dnn<.9*dbc ? 1 : (dbc*dbc<dcn || dbc*9<dcn) && bb<=bc && dbb<.9*dcn ||
                \ dbb*5<dcn && dbc*5<dcn && (dbc<thr || bb<=bc) ? -1 : 0

  ## deblend - post deblend - doubleblend removal - postprocessing ##
        pval    = bb-select(pos+2,cp3,cp2,cp1,cn0,cn1)-thr*0.1
        cval    = bc-select(pos+2,cp2,cp1,cn0,cn1,cn2)-thr*0.1
        add     = pval>bn2-cn2 && cval>bn2-cn2 && cn2+bn1>cn1+bn2+thr*0.1
        dup     = isstring(om) ? (cval>bp2-cp2 && (cval>bp1-cp1 && bn0+cn1>bn1+cn0 || cval>bn1-cn1 && bn0+cp1>=bp1+cn0)
                \ && cval>bn2-cn2 && (cval>bp3-cp3 || cval>bn3-cn3) ? (d12*d12<d01 || d12*9<d01) && (d12*d12<d10 || d12*9<d10) ? 1 :
                \ (d10*d10<d01 || d10*9<d01) && (d10*d10<d12 || d10*9<d12) ? 0 : 4 :
                \ pval>bp3-cp3 && (pval>bp2-cp2 && bp1+cn0>bn0+cp1 || pval>bn0-cn0 && bp1+cp2>=bp2+cp1) && pval>bn1-cn1 ? 1 : 0) :
                \ dup!=0 ? dup : om>0 && om<5 ? (cval<=bp1-cp1 || cval<=bn1-cn1 ? 0 : om==4 && bp1+cn1<bn1+cp1 || om==3 && d10<d01 || om==1 ? -1 : 1) :
                \ om==5 ? (pval>bp2-cp2 && cval>bp2-cp2 && cp2+bn1>cn1+bp2+thr*0.1 && (add==false || cp2+bn2>cn2+bp2) ? -2 : add ? 2 :
                \ cval>bp1-cp1 && (cval<bn1-cn1 || cp1+bn1>cn1+bp1) ? -1 : cval>bn1-cn1 ? 1 : 0) :
                \ (opos<-2 || opos>2 || cval<bb-select(pos+2,cp3,cp2,cp1,cn0,cn1) || cval<bn-select(pos+2,cp1,cn0,cn1,cn2,cn3) ? 0 :
                \ dbc*dbc<dcn || dbc*7<dcn ? -1 : dcn*dcn<dbc || dcn*7<dbc ? 1 : 0)
                
        ppw     = isclip(pclip)==false ? 0 : pthr==0 ? 1 : dup==-1 ? mb/pthr*(dbb<dbc ? .2+1.6*dbb/(dbb+dbc+1) : .4*1.2*dbc/(dbb+dbc+1)) : dup==0 ?
                \ mc/pthr*(dbc<dcn ? .2+1.6*dbc/(dbc+dcn+1) : .4+1.2*dcn/(dbc+dcn+1)) : dup==1 ? mn/pthr*(dcn<dnn ? .2+1.6*dcn/(dcn+dnn+1) : .4+1.2*dnn/(dcn+dnn+1)) : 0
 
  ## resync ##
        res     = (offs<-1.15*denm || offs>1.25*denm || offs<-0.95*denm && (mb>400 || mn>400)) && (dbc*dbc<dbb && dcn*dcn<dbb && dnn*dnn<dbb ||
                \ dbb*dbb<dnn && dbc*dbc<dnn && dcn*dcn<dnn || mb*11<mn || mn*9<mb) ||
                \ (offs<-1.15*denm || offs>1.25*denm) && min4(m42,m20,m02,m24)*3<thr && min4(d43,d32,d21,d10)*3<thr && min4(d01,d12,d23,d34)*3<thr
    global offs    = res && offs<0 ? offs+2*denm : res && offs>0 ? offs-2*denm : offs


 ### output clip ###
        oclp    = abs(ppw)<0.1 ? out : ppw>=1 ? pclip : mergeluma(out,pclip,ppw<=-1 ? 1 : abs(ppw))
        oclp    = ppw<0.1 || ppw>=1 ? oclp : mergechroma(oclp,pclip,ppw)
        opos    = opos + dup
    return (dup==4 ? fin : opos<0 ? oclp.loop(1-opos,0,0) : oclp.trim(opos,0))
}


###### evaluation call & return output ######
scriptclip(source, """ ocalc(current_frame, (abs(dm)==1 || abs(dm)==3 ? 128 : yplanemin(bclp)), (abs(dm)==1 || abs(dm)==2 ? 128 : yplanemax(bclp)),
                    \ yplanemax(dclp), lumadifference(det,det.trim(2,0))) """)


###### final decimation & caching ######
cache<0 ? last : last.RequestLinear(8, cache, 5, false, false)

    temp    = frameratenumerator(det)*float(numr)>2147483600. ? det.assumescaledfps(numr,denm) : nop()
isclip(temp) ? last.changefps(temp,linear=true) : last.changefps(frameratenumerator(source)*numr,frameratedenominator(source)*denm,linear=true)


return last
}