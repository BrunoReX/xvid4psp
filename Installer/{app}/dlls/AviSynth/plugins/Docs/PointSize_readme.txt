PointSize v0.1 - A collection of resiziers for AviSynth
-------------------------------------------------------

+---------+
| Filters |
+---------+

PointSize contains the following filters:

scale2x(clip)	- Scale2x resize
scale3x(clip)	- Scale3x resize
lq2x(clip)		- LQ2x resize
lq3x(clip)		- LQ3x resize
lq4x(clip)		- LQ4x resize
hq2x(clip)		- HQ2x resize
hq3x(clip)		- HQ3x resize
hq4x(clip)		- HQ4x resize

ALL filters take ONLY RGB32 input and produce ONLY RGB32 output.

For an explanation of the various filters, please see:
http://en.wikipedia.org/wiki/Pixel_art_scaling_algorithms


+-----+
| FAQ |
+-----+

Q: Why isn't the 2xSaI (and friends) family of filters included?
A: The code for these filters is either buggy or I am calling them
	incorrectly.  If you know how to get these to work, please let
	me know and I will include them in a future release.

Q: Why aren't the anamorphic resiziers included (LQ2x3, etc.)?
A: I don't see much need for these, but if you want them just ask
	and I can add them w/o much trouble.

Q: Do you plan to support more color spaces (e.g. YV12)?
A: Not at the moment.  Use the various converting functions in
	AviSynth if you need to use other color spaces.


+---------+
| License |
+---------+

PointSize is licensed under the GPLv2, which is included along with
the source code for the program.
