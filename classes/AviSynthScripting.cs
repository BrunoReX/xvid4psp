using System;
using System.IO;
using System.Collections.Generic;
using System.Text;

namespace XviD4PSP
{
   public static class AviSynthScripting
    {

       public enum Decoders
       {
           AVIFileSource = 1, //AviSynth
           AVISource,         //AviSynth
           OpenDMLSource,     //AviSynth
           MPEG2Source,       //DGDecode.dll
           DirectShowSource,  //DirectShowSource.dll
           FFmpegSource,      //ffmpegsource.dll
           FFAudioSource,     //ffmpegsource.dll
           QTInput,           //QuickTime player
           RawSource,         //RawSource.dll
           NicAC3Source,      //NicAudio.dll
           NicDTSSource,      //NicAudio.dll
           NicMPG123Source,   //NicAudio.dll
           RaWavSource,       //NicAudio.dll
           bassAudioSource,   //bassAudio.dll
           WAVSource,         //AviSynth
           AVCSource,         //DGAVCDecode.dll
           DGMultiSource,     //DGMultiDecodeNV.dll
           DSS2,              //avss.dll
           Import,
           BlankClip
       }

       public enum Resizers
       {
           BicubicResize = 1,
           BicubicResizePlus,
           BilinearResize,
           LanczosResize,
           Lanczos4Resize,
           Spline16Resize,
           Spline36Resize,
           Spline64Resize,
           GaussResize,
           PointResize
       }

       public enum ScriptMode
       {
           Info = 1,
           Autocrop,
           AudioOnly,
           Interlace,
           FastPreview,
           Normalize
       }

       public enum FramerateModifers { AssumeFPS = 1, ChangeFPS, ConvertFPS, MSUFrameRate }
       public enum SamplerateModifers { SSRC = 1, ResampleAudio, AssumeSampleRate }

       public static Massive CreateAutoAviSynthScript(Massive m)
       {

           //���������� ����������
           string ext = Path.GetExtension(m.infilepath).ToLower();
           //string aext = Path.GetExtension(m.audiopath).ToLower();

           //���������� ����� ������
           AudioStream instream;
           if (m.inaudiostreams.Count > 0)
               instream = (AudioStream)m.inaudiostreams[m.inaudiostream];
           else
               instream = new AudioStream();

           //�������� ������ ������
           m.script = "";

           // ��������� ��� �������
           m.script += "import(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\functions\\AudioFunctions.avs\")" + Environment.NewLine;
           m.script += "import(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\functions\\VideoFunctions.avs\")" + Environment.NewLine;
           
           //��������� ����������� ������� �������
           if (m.vdecoder == Decoders.MPEG2Source)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\apps\\DGMPGDec\\DGDecode.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.AVCSource)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\apps\\DGAVCDec\\DGAVCDecode.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.DGMultiSource)
               m.script += "loadplugin(\"" + m.dgdecnv_path + "DGMultiDecodeNV.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.DSS2)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\avss.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.RawSource)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\rawsource.dll\")" + Environment.NewLine;

           if (instream.decoder == Decoders.NicAC3Source || instream.decoder == Decoders.NicMPG123Source ||
               instream.decoder == Decoders.NicDTSSource || instream.decoder == Decoders.RaWavSource)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\NicAudio.dll\")" + Environment.NewLine;
           else if (instream.decoder == Decoders.bassAudioSource)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\bass\\bassAudio.dll\")" + Environment.NewLine;

           if (m.deinterlace == DeinterlaceType.TIVTC || m.deinterlace == DeinterlaceType.TDecimate ||
               m.interlace == SourceType.HYBRID_PROGRESSIVE_INTERLACED)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\TIVTC.dll\")" + Environment.NewLine;
           if (m.deinterlace == DeinterlaceType.TomsMoComp)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\TomsMoComp.dll\")" + Environment.NewLine;
           else if (m.deinterlace == DeinterlaceType.TDeint)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\TDeint.dll\")" + Environment.NewLine;
           else if (m.deinterlace == DeinterlaceType.TDeintEDI)
           {
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\TDeint.dll\")" + Environment.NewLine;
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\EEDI2.dll\")" + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.YadifModEDI)
           {
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\yadifmod.dll\")" + Environment.NewLine;
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\nnedi2.dll\")" + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.LeakKernelDeint)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\LeakKernelDeint.dll\")" + Environment.NewLine;
           else if (m.deinterlace == DeinterlaceType.Yadif)
               m.script += "loadcplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\yadif.dll\")" + Environment.NewLine;
           else if (m.deinterlace == DeinterlaceType.SmoothDeinterlace)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\SmoothDeinterlacer.dll\")" + Environment.NewLine;
           else if (m.deinterlace == DeinterlaceType.NNEDI)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\nnedi2.dll\")" + Environment.NewLine;
           else if (m.deinterlace == DeinterlaceType.MCBob)
           {
               m.script += "import(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\MCBob_mod.avs\")" + Environment.NewLine;
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\EEDI2.dll\")" + Environment.NewLine;
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\mt_masktools-25.dll\")" + Environment.NewLine;
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\mvtools.dll\")" + Environment.NewLine;
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\Repair.dll\")" + Environment.NewLine;
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\RemoveGrain.dll\")" + Environment.NewLine;
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\nnedi2.dll\")" + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.FieldDeinterlace)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\Decomb.dll\")" + Environment.NewLine;

           if (m.subtitlepath != null)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\VSFilter.dll\")" + Environment.NewLine;

           if (m.vdecoder == Decoders.FFmpegSource ||
               instream.decoder == Decoders.FFmpegSource ||
               instream.decoder == Decoders.FFAudioSource)
           {
               if (Settings.FFmpegSource2)
               {
                   m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\FFMS2.dll\")" + Environment.NewLine;
                   m.script += "import(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\FFMS2.avsi\")" + Environment.NewLine;
               }
               else
                   m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\FFMpegSource.dll\")" + Environment.NewLine;
           }

           if (m.vdecoder == Decoders.QTInput || instream.decoder == Decoders.QTInput)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\QTSource.dll\")" + Environment.NewLine;

           if (m.iscolormatrix)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\ColorMatrix.dll\")" + Environment.NewLine;

           if (instream.channelconverter != AudioOptions.ChannelConverters.KeepOriginalChannels)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\soxfilter.dll\")" + Environment.NewLine;

           if (m.frameratemodifer == FramerateModifers.MSUFrameRate)
               m.script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\MSU_FRC.dll\")" + Environment.NewLine;

           m.script += Environment.NewLine;

           //����������� ������ �����

           //������ ���� �� ����� don`t demux
           string hidden_apath = null;
           if (Settings.DontDemuxAudio &&
               m.inaudiostreams.Count > 0 &&
               instream.audiopath != null &&
               !File.Exists(instream.audiopath))
           {
               hidden_apath = instream.audiopath;
               instream.audiopath = null;
           }

           //�������������� ��������� fps
           string fps = "";
           if ((m.vdecoder == Decoders.DirectShowSource || m.vdecoder == Decoders.DSS2) && m.inframerate != "")// && m.isforcefps
               fps = ", fps=" + m.inframerate;

           //����� ����� �����
           string atrack = "";
           if (m.vdecoder == Decoders.FFmpegSource &&
               m.inaudiostreams.Count > 0 &&
               m.outaudiostreams.Count > 0 &&
               instream.audiopath == null)
               atrack = ", atrack = " + (instream.ffid);

           //�������������� ����������� �������
           string convertfps = "";
           if (m.vdecoder == Decoders.DirectShowSource && m.isconvertfps && Settings.DSS_ConvertFPS)
               convertfps = ", convertfps=true";

           //������ ��������� ����� ��� ����� �������
           string audio = "";
           if (m.vdecoder == Decoders.DirectShowSource)
           {
               if (instream.audiopath != null ||
                   m.outaudiostreams.Count == 0)
                   audio = ", audio=false";
           }
     
           //���������� �����
           string invideostring = "";

           if (m.vdecoder == Decoders.BlankClip) //������ ���� (������ �����)
           {
               invideostring = m.vdecoder.ToString() + "(length=" + m.inframes + ", width=128, height=96, fps=" + m.inframerate + ", color=$000000)";
           }
           else if (ext == ".d2v") //d2v � MPEG2Source
           {
               int n = 0;
               foreach (string file in m.infileslist)
               {
                   invideostring += m.vdecoder.ToString() + "(\"" + file + "\",cpu=0,info=3)";
                   n++;
                   if (n < m.infileslist.Length)
                       invideostring += " + ";
               }
           }
           else if (ext != ".d2v" && m.vdecoder == Decoders.MPEG2Source) //����2 � MPEG2Source
           {
               invideostring = m.vdecoder.ToString() + "(\"" + m.indexfile + "\",cpu=0,info=3)";
           }
           else if (ext == ".dga" || ext == ".dgi")
           {
               int n = 0;
               foreach (string file in m.infileslist)
               {
                   invideostring += m.vdecoder.ToString() + "(\"" + file + "\")";
                   n++;
                   if (n < m.infileslist.Length)
                       invideostring += " + ";
               }
           }
           else //������
           {
               int n = 0;
               foreach (string file in m.infileslist)
               {
                   //��������� ��� FFmpegSource2
                   string ffmpegsource2 = "";
                   string cache_path = "";
                   string assume_fps = "";
                   if (m.vdecoder == Decoders.FFmpegSource)
                   {
                       //������������� ������� fps �� FFmpegSource (1 � 2) - �� ����� ������ �������, � ����������� �������� � ����� ���������..
                       //���-�� ��� � �������������� ��������� ������� ��� DirectShowSource (1 � 2) - �� ����� ������ �������, � ���� �������� � ������ ���������..
                       //������ ������� - ������ ������ �������! ����������� ���������� ��������, � ����������, ������-�� ������� ������ �� ��� ���!
                       //� ������ �������, ��� �������� ���-����� ������ ������� ���, � ������� ������ ����� ������� - ��������� ���-�� ����� AssumeFPS, ������ ����� �����������.
                       //�� � ���� �������� �������, � �������, � ������� ���������� �������, ��������� - �� AssumeFPS ������ �� �� ��� �� ��������..
                       assume_fps = (m.inframerate != "" && Settings.FFmpegAssumeFPS) ? ".AssumeFPS(" + m.inframerate + ")" : "";
                       if (Settings.FFmpegSource2)
                       {
                           ffmpegsource2 = "2";
                           cache_path = ", rffmode = 0, cachefile = \"" + Settings.TempPath + "\\" + Path.GetFileNameWithoutExtension(file).ToLower() + ".ffindex\"";
                       }
                   }
                   invideostring += m.vdecoder.ToString() + ffmpegsource2 + "(\"" + file + "\"" + audio + fps + convertfps + atrack + cache_path + ")" + assume_fps;
                   n++;
                   if (n < m.infileslist.Length)
                       invideostring += " + ";
               }
           }

           //������� ��� ����������� ����� � �����
           if (m.inaudiostreams.Count > 0 &&
               m.outaudiostreams.Count > 0 &&
               instream.audiopath != null)
               invideostring = "video = " + invideostring;

           //����������� ������ ����� ��� ����� �����
           m.script += invideostring + Environment.NewLine; //video = (tralalalalalala)

           //������ ����!
           if (m.inaudiostreams.Count > 0 &&
               m.outaudiostreams.Count > 0 &&
               instream.audiopath != null)
           {
               //��������� ����
               string inaudiostring = "";
               if (instream.audiofiles != null &&
                   instream.audiofiles.Length > 0)
               {
                   int n = 0;
                   foreach (string file in instream.audiofiles)
                   {
                       inaudiostring += instream.decoder.ToString() + "(\"" + file + "\")";
                       n++;
                       if (n < instream.audiofiles.Length)
                           inaudiostring += " + ";
                   }
               }
               else
               {
                   inaudiostring += instream.decoder.ToString() + "(\"" + instream.audiopath + "\")";
               }
               m.script += "audio = " + inaudiostring + Environment.NewLine; //audio = (tralalalalalala)

               //�����������
               m.script += "AudioDub(video, audio)"
                   + Environment.NewLine;
           }

           m.script += Environment.NewLine;

           bool IsAssumeRateConvertion = false;
           if (m.inframerate != m.outframerate)
           {
               if (m.deinterlace == DeinterlaceType.TIVTC ||
                   m.deinterlace == DeinterlaceType.TDecimate)
               {
                   if (m.outframerate != "23.976")
                       if (m.frameratemodifer == FramerateModifers.AssumeFPS)
                           IsAssumeRateConvertion = true;
               }
               else
                   if (m.frameratemodifer == FramerateModifers.AssumeFPS)
                       IsAssumeRateConvertion = true;
           }

           //���� ��������� �����
           if (m.inaudiostreams.Count > 0 &&
               m.outaudiostreams.Count > 0)
           {
               AudioStream outstream = (AudioStream)m.outaudiostreams[m.outaudiostream];

               //������ �����������
               if (instream.channelconverter != AudioOptions.ChannelConverters.KeepOriginalChannels)
                   m.script += instream.channelconverter.ToString() + "()" + Environment.NewLine;

               //������ ��������
               if (instream.bits != outstream.bits)
                   m.script += "ConvertAudioTo16bit()" + Environment.NewLine;

               if (outstream.delay != 0)
                   m.script += "DelayAudio(" + Calculate.ConvertDoubleToPointString(Convert.ToDouble(outstream.delay) / 1000) + ")" + Environment.NewLine;

               //����������� ����� �������
               if (instream.samplerate != outstream.samplerate && !IsAssumeRateConvertion && outstream.samplerate != null)
                   m.script += m.sampleratemodifer + "(" + outstream.samplerate + ")" + Environment.NewLine;

               //������������ �����
               if (instream.gain != "0.0")
                   m.script += "AmplifydB(" + instream.gain + ")" + Environment.NewLine;
           }

           ///////////////////////
           //���� ������ � �����//
           ///////////////////////

           //����������� �������� ������������
           m.script += "ConvertToYV12(" + ((m.interlace != SourceType.UNKNOWN && m.interlace != SourceType.PROGRESSIVE &&
               m.interlace != SourceType.DECIMATING) ? "interlaced = true" : "") + ")" + Environment.NewLine;

           //Mod protection
           string mod2 = null;
           int modw = Format.GetValidModW(m), modh = Format.GetValidModH(m);
           if (m.inresw % modw != 0 || m.inresh % modh != 0)
           {
               m.script += "#Mod" + modw + "xMod" + modh + " protection" + Environment.NewLine;
               if (m.resizefilter == Resizers.BicubicResizePlus)
                   mod2 = "BicubicResize(" + Calculate.GetValid(m.inresw, modw) + ", " + Calculate.GetValid(m.inresh, modh) + ", 0, 0.75)";
               else
                   mod2 = m.resizefilter + "(" + Calculate.GetValid(m.inresw, modw) + ", " + Calculate.GetValid(m.inresh, modh) + ")";
               m.script += mod2 + Environment.NewLine;
           }

           //colormatrix
           if (m.iscolormatrix)
           {
               string colormatrix = "ColorMatrix(";
               if (m.vdecoder == Decoders.MPEG2Source)
               {
                   if (m.interlace == SourceType.DECIMATING ||
                       m.interlace == SourceType.FILM ||
                       m.interlace == SourceType.HYBRID_FILM_INTERLACED ||
                       m.interlace == SourceType.HYBRID_PROGRESSIVE_FILM ||
                       m.interlace == SourceType.HYBRID_PROGRESSIVE_INTERLACED ||
                       m.interlace == SourceType.INTERLACED)
                       colormatrix += "hints=true,interlaced=true)";
                   else
                       colormatrix += "hints=true)";
               }
               else
               {
                   if (m.interlace == SourceType.DECIMATING ||
                       m.interlace == SourceType.FILM ||
                       m.interlace == SourceType.HYBRID_FILM_INTERLACED ||
                       m.interlace == SourceType.HYBRID_PROGRESSIVE_FILM ||
                       m.interlace == SourceType.HYBRID_PROGRESSIVE_INTERLACED ||
                       m.interlace == SourceType.INTERLACED)
                       colormatrix += "interlaced=true)";
                   else
                       colormatrix += ")";
               }

               m.script += colormatrix + Environment.NewLine;
           }

           if (m.saturation != 1.0)
               m.script += "Tweak(sat=" + Calculate.ConvertDoubleToPointString(m.saturation, 1) + ")" + Environment.NewLine;
           if (m.brightness != 0)
               m.script += "Tweak(bright=" + m.brightness + ")" + Environment.NewLine;
           if (m.contrast != 1.00)
               m.script += "Tweak(cont=" + Calculate.ConvertDoubleToPointString(m.contrast, 2) + ")" + Environment.NewLine;
           if (m.hue != 0)
               m.script += "Tweak(hue=" + m.hue + ")" + Environment.NewLine;         
                      
           //��������� ��� ������������� �� ����
           if (m.interlace != SourceType.UNKNOWN && m.interlace != SourceType.PROGRESSIVE && m.interlace != SourceType.DECIMATING)
           {
               if (m.deinterlace == DeinterlaceType.Disabled)
               {
                   m.script += Environment.NewLine;
                   m.script += "SeparateFields()" + Environment.NewLine;
               }
           }

           //��������������
           int order = (m.fieldOrder == FieldOrder.TFF) ? 1 : (m.fieldOrder == FieldOrder.BFF) ? 0 : -1;
           string txt = "#.Subtitle(\"deinterlaced frame\", align=5)";
           if (m.deinterlace == DeinterlaceType.TomsMoComp)
           {
               string deinterlacer = "TomsMoComp(" + order + ", 5, 1)";
               m.script += ((m.interlace == SourceType.HYBRID_PROGRESSIVE_INTERLACED) ? "deint = " + deinterlacer + txt + Environment.NewLine +
                   "ScriptClip(last, \"IsCombedTIVTC(last, cthresh=7, MI=40)==true ? deint : last\")" : deinterlacer) + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.Yadif)
           {
               string deinterlacer = "Yadif(order=" + order + ")";
               m.script += ((m.interlace == SourceType.HYBRID_PROGRESSIVE_INTERLACED) ? "deint = " + deinterlacer + txt + Environment.NewLine +
                   "ScriptClip(last, \"IsCombedTIVTC(last, cthresh=7, MI=40)==true ? deint : last\")" : deinterlacer) + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.YadifModEDI)
           {
               string deinterlacer = "yadifmod(order=" + order + ", field=-1, mode=0, edeint=nnedi2())";
               m.script += ((m.interlace == SourceType.HYBRID_PROGRESSIVE_INTERLACED) ? "deint = " + deinterlacer + txt + Environment.NewLine +
                   "ScriptClip(last, \"IsCombedTIVTC(last, cthresh=7, MI=40)==true ? deint : last\")" : deinterlacer) + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.LeakKernelDeint)
           {
               string deinterlacer = "LeakKernelDeint(order=" + Math.Abs(order) + ", sharp=true)";
               m.script += ((m.interlace == SourceType.HYBRID_PROGRESSIVE_INTERLACED) ? "deint = " + deinterlacer + txt + Environment.NewLine +
               "ScriptClip(last, \"IsCombedTIVTC(last, cthresh=7, MI=40)==true ? deint : last\")" : deinterlacer) + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.FieldDeinterlace)
           {
               m.script += ((order == 1) ? "AssumeTFF()." : (order == 0) ? "AssumeBFF()." : "") + "FieldDeinterlace(" + ((m.interlace ==
                   SourceType.HYBRID_PROGRESSIVE_INTERLACED) ? "full=false, threshold=20" : "") + ")" + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.TDeint)
           {
               m.script += "TDeint(order=" + order + ((m.interlace == SourceType.HYBRID_PROGRESSIVE_INTERLACED) ?
                   ", full=false, cthresh=7, MI=40" : "") + ")" + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.TDeintEDI)
           {
               m.script += "edeintted = last.AssumeTFF().SeparateFields().SelectEven().EEDI2(field=-1)" + Environment.NewLine;
               m.script += "TDeint(order=" + order + ", edeint=edeintted" + ((m.interlace == SourceType.HYBRID_PROGRESSIVE_INTERLACED) ?
                   ", full=false, cthresh=7, MI=40" : "") + ")" + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.TIVTC)
           {
               m.script += "TFM(order=" + order + ").TDecimate(hybrid=1)" + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.TDecimate)
           {
               //SelectEven().Tdecimate()
               //TDecimate(Mode=7,Rate=23.976)
               //TDecimate(mode=0,cycleR=9,cycle=15)
               //SelectEven().Decimate(5) 

               if (m.inframerate != "29.970")
               {
                   m.script += "ChangeFPS(29.97)" + Environment.NewLine;
                   m.script += "TDecimate()" + Environment.NewLine;
               }
               else
                   m.script += "TDecimate(cycleR=1)" + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.SmoothDeinterlace)
           {
               m.script += "SmoothDeinterlace(" + ((order == 1) ? "tff=true, " : (order == 0) ? "tff=false, " : "") + "doublerate=true)" + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.MCBob)
           {
               m.script += "MCBobmod()" + Environment.NewLine;
           }
           else if (m.deinterlace == DeinterlaceType.NNEDI)
           {
               m.script += "nnedi2(field=" + ((order == 1) ? "3" : (order == 0) ? "2" : "-2") + ")" + Environment.NewLine;
           }

           //������� �� ��������, ���� � ���������� �� ������� "������� ������, ����� ����������"
           if (Settings.ResizeFirst == false)
           {
               if (m.filtering != "Disabled")
                   m.script += Environment.NewLine + LoadScript(Calculate.StartupPath + "\\presets\\filtering\\" + m.filtering + ".avs") + Environment.NewLine;
           }

           //���� ����������� ������ ���� ���������� ����������
           if (m.inresw != m.outresw || 
               m.inresh != m.outresh || 
               m.cropl != 0 || 
               m.cropr != 0 || 
               m.cropt != 0 || 
               m.cropb != 0 || 
               m.blackw != 0 || 
               m.blackh != 0)
           {
               int cropl = m.cropl;
               int cropr = m.cropr;
               int cropt = m.cropt;
               int cropb = m.cropb;
               int blackh = m.blackh;
               int blackw = m.blackw;
               int outresw = m.outresw;
               int outresh = m.outresh;

               //������������� ������� ��� ���������� �����
               if (m.interlace == SourceType.DECIMATING ||
                   m.interlace == SourceType.FILM ||
                   m.interlace == SourceType.HYBRID_FILM_INTERLACED ||
                   m.interlace == SourceType.HYBRID_PROGRESSIVE_FILM ||
                   m.interlace == SourceType.HYBRID_PROGRESSIVE_INTERLACED ||
                   m.interlace == SourceType.INTERLACED)
               {
                   if (m.deinterlace == DeinterlaceType.Disabled)
                   {        
                       outresh /= 2;
                       if (cropt != 0)
                           cropt /= 2;
                       if (cropb != 0)
                           cropb /= 2;
                       if (blackh != 0)
                           blackh /= 2;
                       cropt = Calculate.GetValid(cropt, 2);
                       cropb = Calculate.GetValid(cropb, 2);
                       blackh = Calculate.GetValid(blackh, 2);
                   }
               }

               if (cropl != 0 || cropr != 0 || cropt != 0 || cropb != 0)
                   m.script += "Crop(" + cropl + ", " + cropt + ", -" + cropr + ", -" + cropb + ")" + Environment.NewLine;

               string newres = null;
               if (m.resizefilter == Resizers.BicubicResizePlus)
                   newres = "BicubicResize(" + (outresw - (blackw * 2)) + ", " + (outresh - (blackh * 2)) + ", 0, 0.75)";
               else
                   newres = m.resizefilter + "(" + (outresw - (blackw * 2)) + ", " + (outresh - (blackh * 2)) + ")";

               //���� mod2 ������ ���������� �� ������� ����������
               if (cropl == 0 && cropr == 0 && cropt == 0 && cropb == 0 &&
                   newres != mod2)
               {
                   m.script += newres + Environment.NewLine;
               }
               else
               {
                   //���� mode2 ������ ����� ������� ����������, �� ���� ����
                   if (cropl != 0 || cropr != 0 || cropt != 0 || cropb != 0)
                   {
                       m.script += newres + Environment.NewLine;
                   }
               }

               if (blackw != 0 || blackh != 0)
                   m.script += "AddBorders(" + blackw + ", " + blackh + ", " + blackw + ", " + blackh + ")" + Environment.NewLine;
           }

           //������� �� ��������, ���� � ���������� ������� "������� ������, ����� ����������"
           if (Settings.ResizeFirst == true)
           {
               if (m.filtering != "Disabled") //������� ���������� ����� �������
                   m.script += Environment.NewLine + LoadScript(Calculate.StartupPath + "\\presets\\filtering\\" + m.filtering + ".avs") + Environment.NewLine;
           }
           
           //���������� ���� ��� �������������
           if (m.interlace != SourceType.UNKNOWN && m.interlace != SourceType.PROGRESSIVE && m.interlace != SourceType.DECIMATING)
           {
               if (m.deinterlace == DeinterlaceType.Disabled)
                   m.script += "Weave()" + Environment.NewLine;
           }

           //��������� ��������� ��� �����������
           if (m.levels != "Disabled")
               m.script += "Histogram(\"" + m.levels + "\")" + Environment.NewLine;
           
           //��������� ��������
           if (m.subtitlepath != null)
           {
               string subext = Path.GetExtension(m.subtitlepath).ToLower();
               if (subext == ".idx")
                    m.script += "VobSub(\"" + m.subtitlepath + "\")";
               else
                    m.script += "TextSub(\"" + m.subtitlepath + "\")";
           }

           //����������� ����� ����������
           if (m.deinterlace == DeinterlaceType.TIVTC ||
               m.deinterlace == DeinterlaceType.TDecimate)
           {
               if (m.outframerate != "23.976")
               {
                   if (IsAssumeRateConvertion)
                   {
                       //��������������� �������� �����
                       if (m.inaudiostreams.Count > 0 &&
                           m.outaudiostreams.Count > 0)
                       {
                           AudioStream outstream = (AudioStream)m.outaudiostreams[m.outaudiostream];
                           m.script += m.frameratemodifer + "(" + m.outframerate + ", true)" + Environment.NewLine;
                           if (outstream.samplerate != null)
                               m.script += "ResampleAudio(" + outstream.samplerate + ")" + Environment.NewLine;
                       }
                       else
                           m.script += m.frameratemodifer + "(" + m.outframerate + ")" + Environment.NewLine;
                   }
                   else
                   {
                       m.script += m.frameratemodifer + "(" + m.outframerate + ")" + Environment.NewLine;
                   }
               }
           }
           else if (m.deinterlace == DeinterlaceType.MCBob ||
               m.deinterlace == DeinterlaceType.NNEDI ||
               m.deinterlace == DeinterlaceType.SmoothDeinterlace)
           {
               double outframerate = Calculate.ConvertStringToDouble(m.outframerate);
               double outfr = Calculate.ConvertStringToDouble(m.inframerate) * 2.0;
               if (outframerate != outfr)
               {
                   if (IsAssumeRateConvertion)
                   {
                       //��������������� �������� �����
                       if (m.inaudiostreams.Count > 0 &&
                           m.outaudiostreams.Count > 0)
                       {
                           AudioStream outstream = (AudioStream)m.outaudiostreams[m.outaudiostream];
                           m.script += m.frameratemodifer + "(" + m.outframerate + ", true)" + Environment.NewLine;
                           if (outstream.samplerate != null)
                               m.script += "ResampleAudio(" + outstream.samplerate + ")" + Environment.NewLine;
                       }
                       else
                           m.script += m.frameratemodifer + "(" + m.outframerate + ")" + Environment.NewLine;
                   }
                   else
                   {
                       m.script += m.frameratemodifer + "(" + m.outframerate + ")" + Environment.NewLine;
                   }
               }
           }
           else if (m.frameratemodifer == FramerateModifers.MSUFrameRate)
           {
               double outfr = Calculate.ConvertStringToDouble(m.outframerate);
               double infr = Calculate.ConvertStringToDouble(m.inframerate);
               int closevalue = Convert.ToInt32(outfr / infr);
               if (closevalue > 1)
               {
                   //������ mod16
                   if (Calculate.GetValid(m.outresw, 16) != m.outresw ||
                       Calculate.GetValid(m.outresh, 16) != m.outresh)
                   {
                       m.script += Resizers.Lanczos4Resize + "(" + Calculate.GetValid(m.outresw, 16) + ", " +
                                   Calculate.GetValid(m.outresh, 16) + ")" + Environment.NewLine;
                   }
                   m.script += "MSU_FRC(" + closevalue + ", \"slow\")" + Environment.NewLine;
                   //������ mod16
                   if (Calculate.GetValid(m.outresw, 16) != m.outresw ||
                       Calculate.GetValid(m.outresh, 16) != m.outresh)
                   {
                       m.script += Resizers.Lanczos4Resize + "(" + m.outresw + ", " + m.outresh + ")" + Environment.NewLine;
                   }
               }
               if (closevalue * infr != outfr)
                   m.script += FramerateModifers.ChangeFPS + "(" + m.outframerate + ")" + Environment.NewLine;
           }
           else
           {
               if (m.inframerate != m.outframerate)
               {
                   if (IsAssumeRateConvertion)
                   {
                       //��������������� �������� �����
                       if (m.inaudiostreams.Count > 0 &&
                           m.outaudiostreams.Count > 0)
                       {
                           AudioStream outstream = (AudioStream)m.outaudiostreams[m.outaudiostream];
                           m.script += m.frameratemodifer + "(" + m.outframerate + ", true)" + Environment.NewLine;
                           if (outstream.samplerate != null)
                               m.script += "ResampleAudio(" + outstream.samplerate + ")" + Environment.NewLine;
                       }
                       else
                           m.script += m.frameratemodifer + "(" + m.outframerate + ")" + Environment.NewLine;
                   }
                   else
                   {
                       m.script += m.frameratemodifer + "(" + m.outframerate + ")" + Environment.NewLine;
                   }
               }
           }
           
           //����
           if (m.trim_start != 0 || m.trim_end != 0)
               m.script += "Trim(" + m.trim_start + "," + m.trim_end + ")" + Environment.NewLine;

           //�������� �������
           if (m.testscript)
               m.script += "SelectRangeEvery(FrameCount()/50,50) #2500 frames test-script\r\n\r\n";
           
           //��������� ���������� ���� � �����
           if (hidden_apath != null)
               instream.audiopath = hidden_apath;

           //������� ������ mod2 ������
           string[] separator = new string[] { Environment.NewLine };
           string[] lines = m.script.Split(separator, StringSplitOptions.None);
           string sorted = "";
           int i = 0;
           foreach (string line in lines)
           {
               if (line.StartsWith(m.resizefilter.ToString()))
               {
                   if (i + 1 <= lines.Length)
                   {
                       if (!lines[i + 1].StartsWith(m.resizefilter.ToString()))
                       {
                           sorted += line + Environment.NewLine;
                       }
                   }
               }
               else
               {
                   sorted += line + Environment.NewLine;
               }
               i++;
           }
           m.script = sorted; 

           return m;
       }

       public static Massive SetGain(Massive m)
       {
           //���������� ����� ������
           AudioStream instream = (AudioStream)m.inaudiostreams[m.inaudiostream];
           AudioStream outstream = (AudioStream)m.outaudiostreams[m.outaudiostream];

           //���� ��������� �����
           if (m.inaudiostreams.Count > 0 &&
               m.outaudiostreams.Count > 0)
           {
               string[] separator = new string[] { Environment.NewLine };
               string[] lines = m.script.Split(separator, StringSplitOptions.None);
               string newscript = "";

               //������
               foreach (string line in lines)
               {
                   if (line.ToLower().StartsWith("AmplifydB("))
                   {
                       if (instream.gain != "0.0")
                           newscript += "AmplifydB(" + instream.gain + ")" + Environment.NewLine;
                   }
                   else
                       newscript += line + Environment.NewLine;
               }

               //����������
               if (instream.gain != "0.0" && !newscript.Contains("AmplifydB"))
                   newscript += "AmplifydB(" + instream.gain + ")" + Environment.NewLine;

               m.script = newscript;
           }

           return m;
       }

       public static string GetPreviewScript(Massive m)
       {
           string[] separator = new string[] { Environment.NewLine };
           string[] lines = m.script.Split(separator, StringSplitOptions.None);
           string script = "";

           //������
           foreach (string line in lines)
               script += line + Environment.NewLine;

           //����������
           script += "ConvertToYUY2()" + Environment.NewLine; //��� ����� �� �������� ���������� ������ ��� ����������� ���� ��������� //(����� ��������)

           return script;
       }

       public static string GetInfoScript(Massive m, ScriptMode mode)
       {

           //���������� ����������
           string ext = Path.GetExtension(m.infilepath).ToLower();
           //string aext = Path.GetExtension(m.audiopath).ToLower();

           AudioStream instream;
           if (m.inaudiostreams.Count > 0)
               instream = (AudioStream)m.inaudiostreams[m.inaudiostream];
           else
               instream = new AudioStream();

           //�������� ������ ������
           string script = "";

           // ��������� ��� �������
           script += "import(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\functions\\AudioFunctions.avs\")" + Environment.NewLine;
           script += "import(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\functions\\VideoFunctions.avs\")" + Environment.NewLine;

           //��������� ����������� ������� �������
           if (m.vdecoder == Decoders.AVCSource)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\apps\\DGAVCDec\\DGAVCDecode.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.MPEG2Source)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\apps\\DGMPGDec\\DGDecode.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.DGMultiSource)
               script += "loadplugin(\"" + m.dgdecnv_path + "DGMultiDecodeNV.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.DSS2)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\avss.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.RawSource)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\rawsource.dll\")" + Environment.NewLine;

           if (instream.decoder == Decoders.NicAC3Source || instream.decoder == Decoders.NicMPG123Source ||
               instream.decoder == Decoders.NicDTSSource || instream.decoder == Decoders.RaWavSource)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\NicAudio.dll\")" + Environment.NewLine;
           else if (instream.decoder == Decoders.bassAudioSource)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\bass\\bassAudio.dll\")" + Environment.NewLine;

           if (mode == ScriptMode.Autocrop)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\AutoCrop.dll\")" + Environment.NewLine;
           if (mode == ScriptMode.Interlace)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\TIVTC.dll\")" + Environment.NewLine;

           if (m.vdecoder == Decoders.FFmpegSource || instream.decoder == Decoders.FFmpegSource ||
               instream.decoder == Decoders.FFAudioSource)
           {
               if (Settings.FFmpegSource2)
               {
                   script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\FFMS2.dll\")" + Environment.NewLine;
                   script += "import(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\FFMS2.avsi\")" + Environment.NewLine;
               }
               else
                   script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\FFMpegSource.dll\")" + Environment.NewLine;
           }

           if (instream.channelconverter != AudioOptions.ChannelConverters.KeepOriginalChannels)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\soxfilter.dll\")" + Environment.NewLine;

           script += Environment.NewLine;

           //����������� ������ �����

           //������ ���� �� ����� don`t demux
           string hidden_apath = null;
           if (Settings.DontDemuxAudio &&
               m.inaudiostreams.Count > 0 &&
               instream.audiopath != null &&
               !File.Exists(instream.audiopath))
           {
               hidden_apath = instream.audiopath;
               instream.audiopath = null;
           }

           //�������������� ��������� fps
           string fps = "";
           if ((m.vdecoder == Decoders.DirectShowSource || m.vdecoder == Decoders.DSS2) && m.inframerate != "")// && m.isforcefps
               fps = ", fps=" + m.inframerate;

           //�������������� ����������� �������
           string convertfps = "";
           if (m.vdecoder == Decoders.DirectShowSource && m.isconvertfps && Settings.DSS_ConvertFPS)
               convertfps = ", convertfps=true";

           //������ ��������� ����� ��� ����� �������
           string audio = "";
           if (m.vdecoder == Decoders.DirectShowSource &&
               instream.audiopath != null)
               audio = ", audio=false";

           //����� ����� �����
           string atrack = "";
           if (m.vdecoder == Decoders.FFmpegSource &&
               m.inaudiostreams.Count > 0 &&
               instream.audiopath == null)
               atrack = ", atrack = " +(instream.ffid);
           
           //���������� �����
           string invideostring = "";
           if (m.vdecoder == Decoders.BlankClip)
           {
               invideostring = m.vdecoder.ToString() + "(length=" + m.inframes + ", width=128, height=96, fps=" + m.inframerate + ", color=$000000)";
           }
           else if (ext == ".d2v")
           {
               int n = 0;
               foreach (string file in m.infileslist)
               {
                   invideostring += m.vdecoder.ToString() + "(\"" + file + "\",cpu=0,info=3)";
                   n++;
                   if (n < m.infileslist.Length)
                       invideostring += " + ";
               }
           }
           else if (ext != ".d2v" && m.vdecoder == Decoders.MPEG2Source)
           {
               invideostring = m.vdecoder.ToString() + "(\"" + m.indexfile + "\",cpu=0,info=3)";
           }
           else if (ext == ".dga" || ext == ".dgi")
           {
               int n = 0;
               foreach (string file in m.infileslist)
               {
                   invideostring += m.vdecoder.ToString() + "(\"" + file + "\")";
                   n++;
                   if (n < m.infileslist.Length)
                       invideostring += " + ";
               }
           }
           else
           {
               int n = 0;
               foreach (string file in m.infileslist)
               {
                   //��������� ��� FFmpegSource2
                   string ffmpegsource2 = "";
                   string cache_path = "";
                   string assume_fps = "";
                   if (m.vdecoder == Decoders.FFmpegSource)
                   {
                       //�����-�� �����������? :) 
                       assume_fps = (m.inframerate != "" && Settings.FFmpegAssumeFPS) ? ".AssumeFPS(" + m.inframerate + ")" : "";
                       if (Settings.FFmpegSource2)
                       {
                           ffmpegsource2 = "2";
                           cache_path = ", rffmode = 0, cachefile = \"" + Settings.TempPath + "\\" + Path.GetFileNameWithoutExtension(file).ToLower() + ".ffindex\"";
                       }
                   }
                   invideostring += m.vdecoder.ToString() + ffmpegsource2 + "(\"" + file + "\"" + audio + fps + convertfps + atrack + cache_path + ")" + assume_fps;
                   n += 1;
                   if (n < m.infileslist.Length)
                       invideostring += " + ";
               }
           }

           //������� ��� ����������� ����� � �����
           if (m.inaudiostreams.Count > 0 &&
               instream.audiopath != null)
               invideostring = "video = " + invideostring;

           //����������� ������ ����� ��� ����� �����
           script += invideostring + Environment.NewLine;

           //������ ����� � �����������
           if (m.inaudiostreams.Count > 0 &&
               instream.audiopath != null)
           {
               //��������� ����
               string inaudiostring = "";
               if (instream.audiofiles != null &&
                   instream.audiofiles.Length > 0)
               {
                   int n = 0;
                   foreach (string file in instream.audiofiles)
                   {
                       inaudiostring += instream.decoder.ToString() + "(\"" + file + "\")";
                       n++;
                       if (n < instream.audiofiles.Length)
                           inaudiostring += " + ";
                   }
               }
               else
               {
                   inaudiostring += instream.decoder.ToString() + "(\"" + instream.audiopath + "\")";
               }
               script += "audio = " + inaudiostring + Environment.NewLine;

               //�����������
               script += "AudioDub(video, audio)"
                   + Environment.NewLine;
           }

           if (mode == ScriptMode.FastPreview || mode == ScriptMode.Normalize)
           {
               //���� ��������� �����
               if (m.outaudiostreams.Count > 0)
               {
                   AudioStream outstream = (AudioStream)m.outaudiostreams[m.outaudiostream];

                   //������ �����������
                   if (instream.channelconverter != AudioOptions.ChannelConverters.KeepOriginalChannels)
                       script += instream.channelconverter.ToString() + "()" + Environment.NewLine;

                   //������ ��������
                   if (instream.bits != outstream.bits)
                       script += "ConvertAudioTo16bit()" + Environment.NewLine;

                   if (outstream.delay != 0)
                       script += "DelayAudio(" + Calculate.ConvertDoubleToPointString(Convert.ToDouble(outstream.delay) / 1000) + ")" + Environment.NewLine;

                   //����������� ����� �������
                   if (instream.samplerate != outstream.samplerate && outstream.samplerate != null)
                       script += m.sampleratemodifer + "(" + outstream.samplerate + ")" + Environment.NewLine;         

                   //������������ �����
                   if (mode != ScriptMode.Normalize && instream.gain != "0.0")
                       script += "AmplifydB(" + instream.gain + ")" + Environment.NewLine;
               }
           }

           //��������
           if (mode == ScriptMode.Autocrop)
           {
               script += "AutoYV12()" + Environment.NewLine;
               script += "autocrop(mode=2,wmultof=4,hmultof=4,samples=" + Settings.AutocropFrames + ",Aspect=0,threshold=" + Settings.AutocropSensivity +
                   ",samplestartframe=0,leftadd=0,rightadd=0,topadd=0,bottomadd=0, file=\"" + Settings.TempPath + "\\AutoCrop.log\")" + Environment.NewLine;
           }

           if (mode == ScriptMode.Interlace)
           {
               script += "AutoYV12()" + Environment.NewLine;
               script += "Trim(0, 1200)" + Environment.NewLine;
               //script += "SelectRangeEvery(FrameCount()/30,40";
           }

           //��������� ���������� ���� � �����
           if (hidden_apath != null)
               instream.audiopath = hidden_apath;

           return script;
       }

       public static string GetFramerateScript(Massive m)
       {
           //���������� ����������
           string ext = Path.GetExtension(m.infilepath).ToLower();

           //�������� ������ ������
           string script = "";

           //��������� ����������� ������� �������
           if(m.vdecoder == Decoders.AVCSource)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\apps\\DGAVCDec\\DGAVCDecode.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.MPEG2Source)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\apps\\DGMPGDec\\DGDecode.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.DGMultiSource)
               script += "loadplugin(\"" + m.dgdecnv_path + "DGMultiDecodeNV.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.DSS2)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\avss.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.RawSource)
               script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\rawsource.dll\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.FFmpegSource)
           {
               if (Settings.FFmpegSource2)
               {
                   script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\FFMS2.dll\")" + Environment.NewLine;
                   script += "import(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\FFMS2.avsi\")" + Environment.NewLine;
               }
               else
                   script += "loadplugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\FFMpegSource.dll\")" + Environment.NewLine;
           }
           
           script += Environment.NewLine;

           if (m.vdecoder == Decoders.MPEG2Source)
               script += m.vdecoder.ToString() + "(\"" + m.indexfile + "\",cpu=0,info=3)" + Environment.NewLine;
           else if (m.vdecoder == Decoders.AVCSource || m.vdecoder == Decoders.DGMultiSource)
               script += m.vdecoder.ToString() + "(\"" + m.indexfile + "\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.DirectShowSource)
               script += m.vdecoder.ToString() + "(\"" + m.infilepath + "\",audio=false)" + Environment.NewLine;
           else if (m.vdecoder == Decoders.DSS2)
               script += m.vdecoder.ToString() + "(\"" + m.infilepath + "\")" + Environment.NewLine;
           else if (m.vdecoder == Decoders.FFmpegSource)
           {
               //��������� ��� FFmpegSource2
               string ffmpegsource2 = "";
               string cache_path = "";
               if (Settings.FFmpegSource2)
               {
                   ffmpegsource2 = "2";
                   //���� DontDemuxAudio, �� ��������� ����, ���� ���� ����� ����������������� ������ � ��� (����� ����� ���������� ��������������)
                   string atrack = (m.inaudiostreams.Count > 0 && Settings.DontDemuxAudio) ? ", atrack = -1" : ", atrack = -2";
                   cache_path = atrack + ", rffmode = 0, cachefile = \"" + Settings.TempPath + "\\" + Path.GetFileNameWithoutExtension(m.infilepath).ToLower() + ".ffindex\"";
               }
               script += m.vdecoder.ToString() + ffmpegsource2 + "(\"" + m.infilepath + "\"" + cache_path + ")" + Environment.NewLine;
           }
          
           script += "ConvertToYUY2()" + Environment.NewLine;//���
           script += "Trim(0, 100)" + Environment.NewLine;

           return script;
       }

       public static string LoadScript(string scriptpath)
       {
           string line;
           string x = "";
           using (StreamReader sr = new StreamReader(scriptpath, System.Text.Encoding.Default))
           {
               while (sr.EndOfStream == false)
               {
                   line = sr.ReadLine();
                   if (line.StartsWith("#") && line.EndsWith(".dll"))
                       x += "LoadPlugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\" +
                           line.Replace("#", "") + "\")" +
                           Environment.NewLine;

                   else if (line.StartsWith("#") && line.EndsWith(".avs"))
                       x += "Import(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\" +
                           line.Replace("#", "") + "\")" +
                           Environment.NewLine;

                   else if (line.StartsWith("#") && line.EndsWith(".vdf"))
                       x += "LoadVirtualDubPlugin(\"" + Calculate.StartupPath + "\\dlls\\AviSynth\\plugins\\" +
                           line.Replace("#", "") + "\", ";

                   else if (line.StartsWith("#vdf_arguments:"))
                   {
                       string[] separator = new string[] { ":" };
                       string[] v = line.Split(separator, StringSplitOptions.None);
                       x += "\"" + v[1] + "\", " + v[2] + ")" +
                           Environment.NewLine;
                   }
                   else if (line.StartsWith("#")) //����� �����, ������������ � #, �� �� �� ������� ��� �������� ���-�� (�.�. ��� ��� ��� ���� ����)
                   {
                    if (Settings.HideComments != true)
                       x += line + Environment.NewLine;
                   }

                   if (!line.StartsWith("#"))// && line != ""
                       x += line + Environment.NewLine;
               }
           }
           return x;
       }

       public static Massive WriteScriptToFile(Massive m)
       {
           StreamWriter sw = new StreamWriter(Settings.TempPath + "\\" + m.key + ".avs", false, System.Text.Encoding.Default);
           string[] separator = new string[] { Environment.NewLine };
           string[] lines = m.script.Split(separator, StringSplitOptions.None);
           foreach (string line in lines)
                   sw.WriteLine(line);
           sw.Close();

           m.scriptpath = Settings.TempPath + "\\" + m.key + ".avs";

           return m;
       }

       public static void WriteScriptToFile(string script, string scriptname)
       {
           StreamWriter sw = new StreamWriter(Settings.TempPath + "\\" + scriptname + ".avs", false, System.Text.Encoding.Default);
           string[] separator = new string[] { Environment.NewLine };
           string[] lines = script.Split(separator, StringSplitOptions.None);
           foreach (string line in lines)
               sw.WriteLine(line);
           sw.Close();
       }
    }
}
