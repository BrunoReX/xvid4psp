########################################
# [DSP: Convert To Stereo]
########################################
function ConvertToStereo(clip a)
{
   a = (HasAudio(a)==True) ? ConvertAudioToFloat(a) : a
   a = (AudioChannels(a)==1) ? GetChannel(a, 1, 1) : a    
   a = (AudioChannels(a)==2) ? a : a
   
   FrontLeft = (AudioChannels(a)==3) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.5, 0.5) : 0
   FrontRight = (AudioChannels(a)==3) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.5, 0.5) : 0
   a = (AudioChannels(a)==3) ? MergeChannels(FrontLeft, FrontRight) : a

   TotalLeft = (AudioChannels(a)==4) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.5, 0.5) : 0
   TotalRight = (AudioChannels(a)==4) ? MixAudio(GetChannel(a, 2), GetChannel(a, 4), 0.5, 0.5) : 0
   a = (AudioChannels(a)==4) ? MergeChannels(TotalLeft, TotalRight) : a

   FrontLeft = (AudioChannels(a)==5) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.3694, 0.2612) : 0
   FrontRight = (AudioChannels(a)==5) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.3694, 0.2612) : 0
   TotalLeft = (AudioChannels(a)==5) ? MixAudio(FrontLeft, GetChannel(a, 4), 1, 0.3694) : 0
   TotalRight = (AudioChannels(a)==5) ? MixAudio(FrontRight, GetChannel(a, 5), 1, 0.3694) : 0
   a = (AudioChannels(a)==5) ? MergeChannels(TotalLeft, TotalRight) : a

   l_sl = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 1), GetChannel(a, 5), 0.2929, 0.2929) : 0
   c_lfe = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 4), GetChannel(a, 3), 0.2071, 0.2071) : 0
   r_sr = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 2), GetChannel(a, 6), 0.2929, 0.2929) : 0
   l = (AudioChannels(a)>=6) ? MixAudio(l_sl, c_lfe, 1.0, 1.0) : 0
   r = (AudioChannels(a)>=6) ? MixAudio(r_sr, c_lfe, 1.0, 1.0) : 0
   a = (AudioChannels(a)>=6) ? MergeChannels(l, r) : a

   a = (HasAudio(a)==True) ? ConvertAudioTo16bit(a) : a
   return(a)
}

########################################
# [DSP: Convert To DPL I]
########################################
function ConvertToDolbyProLogic(clip a)
{
   a = (HasAudio(a)==True) ? ConvertAudioToFloat(a) : a
   a = (AudioChannels(a)==1) ? GetChannel(a, 1, 1) : a    
   a = (AudioChannels(a)==2) ? a : a
   
   FrontLeft = (AudioChannels(a)==3) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.5, 0.5) : 0
   FrontRight = (AudioChannels(a)==3) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.5, 0.5) : 0
   a = (AudioChannels(a)==3) ? MergeChannels(FrontLeft, FrontRight) : a

   TotalLeft = (AudioChannels(a)==4) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.5, 0.5) : 0
   TotalRight = (AudioChannels(a)==4) ? MixAudio(GetChannel(a, 2), GetChannel(a, 4), 0.5, 0.5) : 0
   a = (AudioChannels(a)==4) ? MergeChannels(TotalLeft, TotalRight) : a

   FrontLeft = (AudioChannels(a)==5) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.3694, 0.2612) : 0
   FrontRight = (AudioChannels(a)==5) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.3694, 0.2612) : 0
   TotalLeft = (AudioChannels(a)==5) ? MixAudio(FrontLeft, GetChannel(a, 4), 1, 0.3694) : 0
   TotalRight = (AudioChannels(a)==5) ? MixAudio(FrontRight, GetChannel(a, 5), 1, 0.3694) : 0
   a = (AudioChannels(a)==5) ? MergeChannels(TotalLeft, TotalRight) : a

   ssr = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 5), GetChannel(a, 6), 0.2222, 0.2222) : 0
   ssl = (AudioChannels(a)>=6) ? Amplify(ssr, -1.0) : 0
   fl_c = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.3254, 0.2301) : 0
   fr_c = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.3254, 0.2301) : 0
   l = (AudioChannels(a)>=6) ? MixAudio(ssl, fl_c, 1.0, 1.0) : 0
   r = (AudioChannels(a)>=6) ? MixAudio(ssr, fr_c, 1.0, 1.0) : 0
   a = (AudioChannels(a)>=6) ? MergeChannels(l, r) : a

   a = (HasAudio(a)==True) ? ConvertAudioTo16bit(a) : a
   return(a)
}

########################################
# [DSP: Convert To DPL II]
########################################
function ConvertToDolbyProLogicII(clip a)
{
   a = (HasAudio(a)==True) ? ConvertAudioToFloat(a) : a
   a = (AudioChannels(a)==1) ? GetChannel(a, 1, 1) : a    
   a = (AudioChannels(a)==2) ? a : a
   
   FrontLeft = (AudioChannels(a)==3) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.5, 0.5) : 0
   FrontRight = (AudioChannels(a)==3) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.5, 0.5) : 0
   a = (AudioChannels(a)==3) ? MergeChannels(FrontLeft, FrontRight) : a

   TotalLeft = (AudioChannels(a)==4) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.5, 0.5) : 0
   TotalRight = (AudioChannels(a)==4) ? MixAudio(GetChannel(a, 2), GetChannel(a, 4), 0.5, 0.5) : 0
   a = (AudioChannels(a)==4) ? MergeChannels(TotalLeft, TotalRight) : a

   FrontLeft = (AudioChannels(a)==5) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.3694, 0.2612) : 0
   FrontRight = (AudioChannels(a)==5) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.3694, 0.2612) : 0
   TotalLeft = (AudioChannels(a)==5) ? MixAudio(FrontLeft, GetChannel(a, 4), 1, 0.3694) : 0
   TotalRight = (AudioChannels(a)==5) ? MixAudio(FrontRight, GetChannel(a, 5), 1, 0.3694) : 0
   a = (AudioChannels(a)==5) ? MergeChannels(TotalLeft, TotalRight) : a
   
   ssl = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 5), GetChannel(a, 6), 0.2818, 0.1627).Amplify(-1.0) : 0
   fl_c = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.3254, 0.2301) : 0
   ssr = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 5), GetChannel(a, 6), 0.1627, 0.2818) : 0
   fr_c = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.3254, 0.2301) : 0
   l = (AudioChannels(a)>=6) ? MixAudio(ssl, fl_c, 1.0, 1.0) : 0
   r = (AudioChannels(a)>=6) ? MixAudio(ssr, fr_c, 1.0, 1.0) : 0
   a = (AudioChannels(a)>=6) ? MergeChannels(l, r) : a

   a = (HasAudio(a)==True) ? ConvertAudioTo16bit(a) : a
   return(a)
}

########################################
# [DSP: Convert To DPL II (LFE)]
########################################
function ConvertToDolbyProLogicIILFE(clip a)
{
   a = (HasAudio(a)==True) ? ConvertAudioToFloat(a) : a
   a = (AudioChannels(a)==1) ? GetChannel(a, 1, 1) : a    
   a = (AudioChannels(a)==2) ? a : a
   
   FrontLeft = (AudioChannels(a)==3) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.5, 0.5) : 0
   FrontRight = (AudioChannels(a)==3) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.5, 0.5) : 0
   a = (AudioChannels(a)==3) ? MergeChannels(FrontLeft, FrontRight) : a

   TotalLeft = (AudioChannels(a)==4) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.5, 0.5) : 0
   TotalRight = (AudioChannels(a)==4) ? MixAudio(GetChannel(a, 2), GetChannel(a, 4), 0.5, 0.5) : 0
   a = (AudioChannels(a)==4) ? MergeChannels(TotalLeft, TotalRight) : a

   FrontLeft = (AudioChannels(a)==5) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.3694, 0.2612) : 0
   FrontRight = (AudioChannels(a)==5) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.3694, 0.2612) : 0
   TotalLeft = (AudioChannels(a)==5) ? MixAudio(FrontLeft, GetChannel(a, 4), 1, 0.3694) : 0
   TotalRight = (AudioChannels(a)==5) ? MixAudio(FrontRight, GetChannel(a, 5), 1, 0.3694) : 0
   a = (AudioChannels(a)==5) ? MergeChannels(TotalLeft, TotalRight) : a
   
   c_lfe = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 3), GetChannel(a, 4), 0.1871, 0.1870) : 0
   fl_c_lfe = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 1), c_lfe, 0.2645, 1.0) : 0
   fr_c_lfe = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 2), c_lfe, 0.2645, 1.0) : 0
   ssl = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 5), GetChannel(a, 6), 0.2291, 0.1323).Amplify(-1.0) : 0
   ssr = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 5), GetChannel(a, 6), 0.1323, 0.2291) : 0
   l = (AudioChannels(a)>=6) ? MixAudio(ssl, fl_c_lfe, 1.0, 1.0) : 0
   r = (AudioChannels(a)>=6) ? MixAudio(ssr, fr_c_lfe, 1.0, 1.0) : 0
   a = (AudioChannels(a)>=6) ? MergeChannels(l, r) : a

   a = (HasAudio(a)==True) ? ConvertAudioTo16bit(a) : a
   return(a)
}

########################################
# [DSP: 5.1 Convert To Upmix - Audio with mostly dialog (ie. Comedy, Drama)]
########################################
function ConvertToUpmixDialog(clip a)
{
# Audio with mostly dialog (ie. Comedy, Drama)
# Profile to use with audio sources that have mostly mono content. 20ms delay and -3db attenuation on surround
# Note: the center channel is very weak for this profile
   a = (AudioChannels(a)>=3) ? DownmixToStereo(a) : a
   a = (HasAudio(a)==True) ? ConvertAudioToFloat(a) : a
   front = a.soxfilter("filter 20-20000")
   back = a.soxfilter("filter 100-7000")
   fl = mixaudio(front.GetLeftChannel(),front.GetRightChannel(),0.794,-0.794)
   fr = mixaudio(front.GetRightChannel(),front.GetLeftChannel(),0.794,-0.794)
   cc = mixaudio(mixaudio(front.GetLeftChannel(),fl,1,-1),mixaudio(front.GetRightChannel(),fr,1,-1),0.224,0.224)
   lfe = ConvertToMono(a).SoxFilter("lowpass 120","vol -0.596")
   sl = mixaudio(back.GetLeftChannel(),back.GetRightChannel(),0.562,-0.562)
   sr = mixaudio(back.GetRightChannel(),back.GetLeftChannel(),0.562,-0.562)
   sl = DelayAudio(sl,0.02)
   sr = DelayAudio(sr,0.02)
   a = (HasAudio(a)==True) ? MergeChannels( fl, fr, cc, lfe, sl, sr) : a
   a = (HasAudio(a)==True) ? ConvertAudioTo16bit(a) : a
   return(a)
}

########################################
# [DSP: 5.1 Upmix - Audio with a mix of sounds (ie. Action, Adventure)]
########################################
function ConvertToUpmixAction(clip a)
{
# Audio with a mix of sounds (ie. Action, Adventure)
# Profile to use with audio sources that have a wider range of sound content. 20ms delay and -3db attenuation on surround
# Note: General purpose profile
   a = (AudioChannels(a)>=3) ? DownmixToStereo(a) : a
   a = (HasAudio(a)==True) ? ConvertAudioToFloat(a) : a
   front = a.soxfilter("filter 20-20000")
   back = a.soxfilter("filter 100-7000")
   fl = mixaudio(front.GetLeftChannel(),front.GetRightChannel(),0.668,-0.668)
   fr = mixaudio(front.GetRightChannel(),front.GetLeftChannel(),0.668,-0.668)
   cc = mixaudio(mixaudio(front.GetLeftChannel(),fl,1,-1),mixaudio(front.GetRightChannel(),fr,1,-1),0.398,0.398)
   lfe = ConvertToMono(a).SoxFilter("lowpass 120","vol -0.447")
   sl = mixaudio(back.GetLeftChannel(),back.GetRightChannel(),0.473,-0.473)
   sr = mixaudio(back.GetRightChannel(),back.GetLeftChannel(),0.473,-0.473)
   sl = DelayAudio(sl,0.02)
   sr = DelayAudio(sr,0.02)
   a = (HasAudio(a)==True) ? MergeChannels( fl, fr, cc, lfe, sl, sr) : a
   a = (HasAudio(a)==True) ? ConvertAudioTo16bit(a) : a
   return(a)
}

########################################
# [DSP: 5.1 Upmix - Gerzen Profile]
########################################
function ConvertToUpmixGerzen(clip a)
{
# Gerzen Profile
# Gerzen approach Profile modified with 20ms delay and some attenuation on surround
   a = (AudioChannels(a)>=3) ? DownmixToStereo(a) : a
   a = (HasAudio(a)==True) ? ConvertAudioToFloat(a) : a
   front = a.soxfilter("filter 20-20000")
   back = a.soxfilter("filter 100-7000")
   fl = mixaudio(front.GetLeftChannel(),front.GetRightChannel(),0.885,-0.115)
   fr = mixaudio(front.GetRightChannel(),front.GetLeftChannel(),0.885,-0.115)
   cc = mixaudio(front.GetRightChannel(),front.GetLeftChannel,0.4511,0.4511)
   lfe = ConvertToMono(a).SoxFilter("lowpass 120","vol -0.5")
   sl = mixaudio(back.GetLeftChannel(),back.GetRightChannel(),0.668,-0.668)
   sr = mixaudio(back.GetRightChannel(),back.GetLeftChannel(),0.668,-0.668)
   sl = DelayAudio(sl,0.02)
   sr = DelayAudio(sr,0.02)
   a = (HasAudio(a)==True) ? MergeChannels( fl, fr, cc, lfe, sl, sr) : a
   a = (HasAudio(a)==True) ? ConvertAudioTo16bit(a) : a
   return(a)
}

########################################
# [DSP: 5.1 Upmix - Farina Profile]
########################################
function ConvertToUpmixFarina(clip a)
{
# Farina Profile
# Farina/Sursound approach Profile M=L+R, S=L-R, c=0.75, L' = (1-c/4)*M+(1+c/4)*S, C' = c*M, R' = (1-c/4)*M-(1+c/4)*S
# also added with 20ms delay and some attenuation on surround
   a = (AudioChannels(a)>=3) ? DownmixToStereo(a) : a
   a = (HasAudio(a)==True) ? ConvertAudioToFloat(a) : a
   front = a.soxfilter("filter 20-20000")
   back = a.soxfilter("filter 100-7000")
   fl = mixaudio(mixaudio(front.GetLeftChannel(),front.GetRightChannel(),0.500,0.500),mixaudio(front.GetLeftChannel(),front.GetRightChannel(),0.500,-0.500),0.8125,1.1875)
   fr = mixaudio(mixaudio(front.GetLeftChannel(),front.GetRightChannel(),0.500,0.500),mixaudio(front.GetLeftChannel(),front.GetRightChannel(),0.500,-0.500),0.8125,-1.1875)
   cc = mixaudio(front.GetRightChannel(),front.GetLeftChannel,0.375,0.375)
   lfe = ConvertToMono(a).SoxFilter("lowpass 120","vol -0.5")
   sl = mixaudio(back.GetLeftChannel(),back.GetRightChannel(),0.668,-0.668)
   sr = mixaudio(back.GetRightChannel(),back.GetLeftChannel(),0.668,-0.668)
   sl = DelayAudio(sl,0.02)
   sr = DelayAudio(sr,0.02)
   a = (HasAudio(a)==True) ? MergeChannels( fl, fr, cc, lfe, sl, sr) : a
   a = (HasAudio(a)==True) ? ConvertAudioTo16bit(a) : a
   return(a)
}

########################################
# [DSP: 5.1 Upmix - Multisonic Profile]
########################################
function ConvertToUpmixMultisonic(clip a)
{
# Multisonic Profile
# Multisonic approach Profile modified with 20ms delay and some attenuation on surround
   a = (AudioChannels(a)>=3) ? DownmixToStereo(a) : a
   a = (HasAudio(a)==True) ? ConvertAudioToFloat(a) : a
   front = a.soxfilter("filter 20-20000")
   back = a.soxfilter("filter 100-7000")
   fl = mixaudio(front.GetLeftChannel(),front.GetRightChannel(),1,-0.5)
   fr = mixaudio(front.GetRightChannel(),front.GetLeftChannel(),1,-0.5)
   cc = mixaudio(front.GetRightChannel(),front.GetLeftChannel,0.5,0.5)
   lfe = ConvertToMono(a).SoxFilter("lowpass 120","vol -0.5")
   sl = mixaudio(back.GetLeftChannel(),back.GetRightChannel(),0.668,-0.668)
   sr = mixaudio(back.GetRightChannel(),back.GetLeftChannel(),0.668,-0.668)
   sl = DelayAudio(sl,0.02)
   sr = DelayAudio(sr,0.02)
   a = (HasAudio(a)==True) ? MergeChannels( fl, fr, cc, lfe, sl, sr) : a
   a = (HasAudio(a)==True) ? ConvertAudioTo16bit(a) : a
   return(a)
}

########################################
# [DSP: 5.1 Upmix - Sound On Sound Profile]
########################################
function ConvertToUpmixSoundOnSound(clip a)
{
# Sound On Sound Profile
# SOS approach Profile with 20ms delay and some attenuation on surround
   a = (AudioChannels(a)>=3) ? DownmixToStereo(a) : a
   a = (HasAudio(a)==True) ? ConvertAudioToFloat(a) : a
   back = a.soxfilter("filter 100-7000")
   fl = a.GetLeftChannel()
   fr = a.GetRightChannel()
   cc = mixaudio(a.GetRightChannel(),a.GetLeftChannel,0.5,0.5)
   lfe = ConvertToMono(a).SoxFilter("lowpass 120","vol -0.5")
   sl = mixaudio(back.GetLeftChannel(),back.GetRightChannel(),0.668,-0.668)
   sr = mixaudio(back.GetRightChannel(),back.GetLeftChannel(),0.668,-0.668)
   sl = DelayAudio(sl,0.02)
   sr = DelayAudio(sr,0.02)
   a = (HasAudio(a)==True) ? MergeChannels( fl, fr, cc, lfe, sl, sr) : a
   a = (HasAudio(a)==True) ? ConvertAudioTo16bit(a) : a
   return(a)
}

function FAVCStereoDSS(clip a) 
{
   a = (HasAudio(a)==True) ? ConvertAudioToFloat(a) : a
   a = (AudioChannels(a)==1) ? GetChannel(a, 1, 1) : a    
   a = (AudioChannels(a)==2) ? a : a
   
   FrontLeft = (AudioChannels(a)==3) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.5, 0.5) : 0
   FrontRight = (AudioChannels(a)==3) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.5, 0.5) : 0
   a = (AudioChannels(a)==3) ? MergeChannels(FrontLeft, FrontRight) : a

   TotalLeft = (AudioChannels(a)==4) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.5, 0.5) : 0
   TotalRight = (AudioChannels(a)==4) ? MixAudio(GetChannel(a, 2), GetChannel(a, 4), 0.5, 0.5) : 0
   a = (AudioChannels(a)==4) ? MergeChannels(TotalLeft, TotalRight) : a

   FrontLeft = (AudioChannels(a)==5) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.3694, 0.2612) : 0
   FrontRight = (AudioChannels(a)==5) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.3694, 0.2612) : 0
   TotalLeft = (AudioChannels(a)==5) ? MixAudio(FrontLeft, GetChannel(a, 4), 1, 0.3694) : 0
   TotalRight = (AudioChannels(a)==5) ? MixAudio(FrontRight, GetChannel(a, 5), 1, 0.3694) : 0
   a = (AudioChannels(a)==5) ? MergeChannels(TotalLeft, TotalRight) : a

   BackLeft = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 5), GetChannel(a, 4), 0.2698, 0.2698) : 0
   BackRight = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 6), GetChannel(a, 4), 0.2698, 0.2698) : 0
   FrontLeft = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 1), GetChannel(a, 3), 0.2698, 0.1906) : 0
   FrontRight = (AudioChannels(a)>=6) ? MixAudio(GetChannel(a, 2), GetChannel(a, 3), 0.2698, 0.1906) : 0
   TotalLeft = (AudioChannels(a)>=6) ? MixAudio(FrontLeft, BackLeft, 1, 1) : 0
   TotalRight = (AudioChannels(a)>=6) ? MixAudio(FrontRight, BackRight, 1, 1) : 0
   a = (AudioChannels(a)>=6) ? MergeChannels(TotalLeft, TotalRight) : a

   a = (HasAudio(a)==True) ? ConvertAudioTo16bit(a) : a
   return(a)
}

function DownMixtoStereo(clip a)
{
   a=ConvertAudioToFloat(a)
   fl = GetChannel(a, 1)
   fr = GetChannel(a, 2)
   c = GetChannel(a, 3)
   lfe = GetChannel(a, 4)
   sl = GetChannel(a, 5)
   sr = GetChannel(a, 6)
   l_sl = MixAudio(fl, sl, 0.2929, 0.2929)
   c_lfe = MixAudio(lfe, c, 0.2071, 0.2071)
   r_sr = MixAudio(fr, sr, 0.2929, 0.2929)
   l = MixAudio(l_sl, c_lfe, 1.0, 1.0)
   r = MixAudio(r_sr, c_lfe, 1.0, 1.0)
   return MergeChannels(l, r)
}