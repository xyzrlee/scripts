#!/bin/bash

set -e

if [ ! -d ~/auto-download ]; then
        mkdir ~/auto-download
fi

cd ~/auto-download
pwd

wget ftp://106.186.121.152/chnroute.txt -N -T 600 --random-wait

cp -vf ~/auto-download/chnroute.txt /srv/ftp

cp -vf ~/auto-download/chnroute.txt /usr/local/share

exit 0
