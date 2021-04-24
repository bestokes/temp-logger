#!/bin/bash

export SCRIPTDIR=/home/pi/dash

show_next() {
	python3 ${SCRIPTDIR}/next.py 
	sleep 3
}

while true; do 
	DATA=$(python3 /home/pi/Adafruit_Python_DHT/examples/AdafruitDHT.py 11 17)
	TEMP=$(echo $DATA | cut -c 6-9)
	if [ "$(echo ${TEMP} | grep -c \*)" == "1" ]; then
		TEMP=$(echo ${TEMP} | cut -c 1-3)
	fi
	HUMIDITY=$(echo $DATA | cut -c 21-24)
	if [ "$(echo ${HUMIDITY} | grep -c \%)" == "1" ]; then
		HUMIDITY=$(echo ${HUMIDITY} | cut -c 1-3)
	fi
	CPUTEMP=$(/opt/vc/bin/vcgencmd measure_temp | cut -c 6-9)

	curl -s -i -XPOST 'http://192.168.1.104:8086/write?db=hive' --data-binary "gpio_sensor_temp,host=pi value=${TEMP}" -o /dev/null
	curl -s -i -XPOST 'http://192.168.1.104:8086/write?db=hive' --data-binary "gpio_sensor_humidity,host=pi value=${HUMIDITY}" -o /dev/null

	cat $SCRIPTDIR/cputemp.py  | sed s"/VAR/${CPUTEMP}/"g  > $SCRIPTDIR/next.py ; show_next
	cat $SCRIPTDIR/humidity.py | sed s"/VAR/${HUMIDITY}/"g > $SCRIPTDIR/next.py ; show_next
	cat $SCRIPTDIR/temp.py     | sed s"/VAR/${TEMP}/"g     > $SCRIPTDIR/next.py ; show_next

	sleep 30
done


