function SDIAdapt(clip b1,clip b2)
{
	threshsp=10
	# threshold for pixels value absolute difference from 2 sequitial frames for spike detection
	THP=string(threshsp)
	threshavg=2
	# threshold how much times actual SDI greater avearage and decimated SDI for remove false alarm for bad motion compensation 
	THAVG=string(threshavg)
	SDI=mt_lutxy(b1,b2,"x "+THP+" > y "+THP+" > | 1 x y - x y + / abs - 255 * 0 ? ")
	#  SDI calculation
	SDIavg=SDI.mt_luts(SDI,mode="avg",pixels=mt_square(5))
	# SDI averaging
	SDIAvgblk=SDIavg.PointResize(90,72)# for PAL (90,72), FOR NTSC (90,60)
	# decimation
	SDIavgblkX=SDIAvgblk.mt_luts(SDIAvgblk,mode="median",pixels="1 -1 0 0 -1 1 1 1 -1 -1")
	# median point at X position
	SDIavgblkCross=SDIAvgblk.mt_luts(SDIAvgblk,mode="median",pixels="1 0 0 0 -1 0 0 1 0 -1")
	#median point at Cross position
	SDIAvgblk=clense(SDIAvgblk,SDIavgblkCross,SDIavgblkX,increment=0, grey=true).mt_lut("x")
	# multi median filtering for remove false alarm SDI
	SDIavg=SDIAvgblk.PointResize(720,576)# for PAL (720,576), FOR NTSC (720,480)
	# backward resize to original frame size
	SDIad=mt_lutxy(SDI,SDIavg,"x "+THAVG+" y * > x 128 > & 255 0 ?")
	# comparing with actual SDI and if greater it is real spike, value 128 can increase to 192
	# be carefull I can not find this at original paper, big value can loose spike, small false alarm
	SDIad = (radvertmed>1) ? SDIad.mt_luts(SDIad,mode="median",pixels=mt_rectangle(0,radvertmed-1)) : SDIad
	# rectangle size could one less than for bobnnmed, for thinner lines need additional pass with thiknessline=thicknessline-1 until thicknessline=1
	SDIad = SDIad.mt_luts(SDIad,mode="median",pixels=mt_rectangle(thicknessline,0))
	#remove line shotter than thicknessline+1
	SDIadleft=SDIad.mt_luts(SDIad,mode="max",pixels=mt_freerectangle(-distser,0,0,0))
	# fill distser pixels from spike left side 
	SDIadright=SDIad.mt_luts(SDIad,mode="max",pixels=mt_freerectangle(0,0,distser,0))
	# fill distser pixels from spike right side
	SDIadser=mt_logic(SDIadleft,SDIadright,"min")
	# if pixels exist at  SDIadleft and SDIadright fill pixels between 2 short lines
	SDIadser = (radvertmed>1) ? SDIadser.mt_luts(SDIadser,mode="median",pixels=mt_rectangle(0,radvertmed-1)) : SDIadser
	# ADDITIONAL VERTICAL MEDIAN FILTER FOR REMOVE THIN JOIN PART
	SDImask=SDIadser.mt_luts(SDIadser,mode="min",pixels=mt_rectangle(halflength,0))                            
	# remove spikes shorter than 2*halflength+1 pixels tune for source                  
	SDImask=SDImask.mt_luts(SDImask,mode="max",pixels=mt_rectangle(halflength,0))                            
	# expand after shrinking                  
	SDIad=mt_logic(SDIad,SDImask,"min")              
	# combination source and adapting SDI for better robustness  
#	SDIad = SDIad.mt_luts(SDIad,mode="median",pixels=mt_rectangle(thicknessline,0))
	# additional remove short spikes which can be artefacts
	return(SDIad)

}

