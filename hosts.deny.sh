#!/bin/bash

if [ ! -d ~/auto-download ]; then
        mkdir ~/auto-download
fi

cd ~/auto-download

if [ $? != 0 ]; then
	exit -3
fi

pwd

wget http://www.openbl.org/lists/hosts.deny -N -T 600 --random-wait

if [ $? != 0 ]; then
        echo "wget error"
fi

if [ $UID != 0 ]; then
        echo "no root privileges"
else
	touch /etc/hosts.deny
	cat ~/auto-download/hosts.deny >> /etc/hosts.deny
	service ssh restart
fi

exit 0

