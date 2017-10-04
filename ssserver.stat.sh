#!/bin/bash

timeFormat="%Y-%m-%d %H:%M:%S"
logfile="/var/log/shadowsocks.log"


function gen001 {

	echo 'ssserver stat ip'

	cat $logfile | grep connecting | gawk '{ print $7 }' | sed -e 's/:[0-9]*$//' | sort | uniq -c | sort -n -r

}

function gen002 {

	echo 'ssserver stat domain'

	cat $logfile | grep connecting | gawk '{ print $5 }' | sed -e 's/:[0-9]*$//' | sort | uniq -c | sort -n -r

}

function gen003 {

	echo 'ssserver stat ip+domain'

	cat $logfile | grep connecting | gawk '{printf("%s\t%s\n", $7, $5) }' | sed -e 's/:[0-9]*\t/\t/' -e 's/:[0-9]*$//' | sort | uniq -c | sort -n -r 

}

case ${1} in
"")
	gen001
	gen002
	gen003
	;;
*)
	gen${1}
	;;
esac

exit 0

