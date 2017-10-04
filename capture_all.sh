#!/bin/bash

outfile=/srv/ftp/capture/capture_`date +"%Y%m%d%H%M%S%N"`.cap

sudo tcpdump tcp -w ${outfile}
