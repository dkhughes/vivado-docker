#!/bin/sh

if [ -z "$1" ]; then
	echo "Usage: run_vivado.sh [docker image] [--rm]"
	exit 1
fi

docker run -ti -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix $2 $1 /opt/Xilinx/Vivado/2015.4/bin/vivado

