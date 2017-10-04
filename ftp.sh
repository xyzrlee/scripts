#!/bin/bash

name=$1
dir=$2

if [ "$name" = "" ]; then
	echo "file name error"
	exit -2
fi

if [ "$dir" = "" ]; then
	dir="/var/ftp"
fi

echo $name
echo $dir

cd $dir

if [ $? != 0 ]; then
	exit -1
fi 

pwd

wget ftp://106.186.121.152/"$name" -N -T 600 --random-wait

exit 0


