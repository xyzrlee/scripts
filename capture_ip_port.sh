#!/bin/bash

mkdir -p /tmp/capture
outfile=/tmp/capture/capture_`date +"%Y%m%d-%H%M%S-%N"`.cap
port=$2
ip=$1

sudo tcpdump tcp port ${port} and host ${ip} -w ${outfile}
