#!/bin/bash


# Settup mode

# for LED
ledout=5
gpio mode 0 in
gpio mode $ledout out

lightSensorIn=1
gpio mode $lightSensorIn in
DAY=0
NIGHT=1

PIRSensorIn=2
gpio mode $PIRSensorIn in
DETECTED=1
NO_DETECTED=0

hornOut=3
gpio mode $hornOut out
gpio write $hornOut 1
HORN_ON=0
HORN_OFF=1

while true; do 
	# Detected light sensor
	
	ledDetected=`gpio read 0` # GPIO. 0, physical pin 11
	if [ $ledDetected == 1 ]; then
		#return=`curl -i -H "Accept: text/plain" -H "Content-Type: text/plain" -X GET http://demo8311547.mockable.io/led`
		return=`curl -i -H "Accept: Application/json" -H "Content-Type: Application/json" -X GET http://sontieu.pythonanywhere.com/led`
		echo "GET led return = $return"
		ledstatus=$(echo $return | grep "ledon" | wc -l)
		ledsmart=$(echo $return | grep "smarton" | wc -l)
		lightSensorInValue=`gpio read $lightSensorIn` 
		echo "========= ledstatus = $ledstatus, ledsmart = $ledsmart, lightSensorInValue = $lightSensorInValue ======"
		if [ $ledstatus == 1 ]; then
			echo "ledon"
			if [ $ledsmart == 1 ]; then
				echo "smarton"
				if [ $lightSensorInValue == $NIGHT ]; then
					echo "NIGHT"
					gpio write $ledout 1	
				else
					echo "DAY"
					gpio write $ledout 0
				fi
			else
				echo "smartoff"
				gpio write $ledout 1
			fi
		else # ledstatus == off
			gpio write $ledout 0
		fi
    else
		echo "NO, the led is off"
		gpio write $ledout 0
    fi

	#return=`curl -i -H "Accept: text/plain" -H "Content-Type: text/plain" -X GET http://demo8311547.mockable.io/alarm`
	#echo "GET alarm return = $return"
	#alarmstatus=$(echo $return | grep "alarmon" | wc -l)
	#PIRSensorInValue=`gpio read $PIRSensorIn`
	#echo "========= alarmtatus = $alarmstatus, PIRSensorInValue = $PIRSensorInValue ======"

	#if [ $alarmstatus == 1 ]; then
	#	if [ $PIRSensorInValue == $DETECTED ]; then	
	#		gpio write $hornOut $HORN_ON
	#	else
	#		gpio write $hornOut $HORN_ON
	#	fi
	#else
	#	gpio write $hornOut $HORN_ON
	#fi
	
	sleep 0.5

done
