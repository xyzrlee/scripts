#!/bin/bash

if [ $UID != 0 ]; then
        echo "need root"
        exit -3
fi

if [ ! -d ~/auto-download ]; then
        mkdir ~/auto-download
fi

cd ~/auto-download
pwd

/usr/lib/xtables-addons/xt_geoip_dl

if [ $? != 0 ]; then
        echo "download error"
        exit -1
fi

if [ ! -d /usr/share/xt_geoip ]; then
        mkdir -p /usr/share/xt_geoip
fi

/usr/lib/xtables-addons/xt_geoip_build GeoIPCountryWhois.csv -D /usr/share/xt_geoip

if [ $? != 0 ]; then
        echo "build error"
	exit -2
fi

exit 0
