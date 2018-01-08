#!/bin/bash

mkdir -p /tmp/capture
outfile=/tmp/capture/capture_`date +"%Y%m%d%H%M%S%N"`.cap

sudo tcpdump tcp -w ${outfile}
