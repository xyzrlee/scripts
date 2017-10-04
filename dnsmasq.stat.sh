#!/bin/bash

timeFormat="%b %e %H:%M:%S"
logfile="/var/log/dnsmasq.log"


function getBeginEndTime() {

	local min=10
	local sec=0

	local beginTimeS=`date +%s --date="${min} minutes ago ${sec} seconds ago"`
	local endTimeS=`date +%s`
	local todayDate=`date +'%Y%m%d'`
	local todayBeginTimeS=`date -d "${todayDate}" +%s`

	if [ ${beginTimeS} -lt ${todayBeginTimeS} ];
	then
        	beginTimeS=${todayBeginTimeS}
	fi

	beginTime=`date -d "@${beginTimeS}" +"${timeFormat}"`
	endTime=`date -d "@${endTimeS}" +"${timeFormat}"`
	todayBeginTime=`date -d "@${todayBeginTimeS}" +"${timeFormat}"`

}

function gen001 {

	echo 'dnsmasq stat ip from' ${beginTime} 'to' ${endTime}

	cat ${logfile} | egrep "query[[A-Za-z]+]" | gawk -v st="${beginTime}" -v et="${endTime}" '{ t=substr($0,1,15); if ( t>=st && t<=et ) { print $8 } }' | sort | uniq -c | sort -n -r | head -n 10

}

function gen002 {

	echo 'dnsmasq stat domain from' ${beginTime} 'to' ${endTime}

	cat $logfile | egrep "query[[A-Za-z]+]" | sed 's/query\[\([A-Za-z]*\)\]/\1/g' | gawk -v st="${beginTime}" -v et="${endTime}" '{ t=substr( $0, 1, 15 ); if ( t>=st && t<=et ) { printf("%-5s %s\n", $5, $6) } }' | sort | uniq -c | sort -n -r | head -n 10

}

function gen003 {

	echo 'dnsmasq stat ip and domain from' ${beginTime} 'to' ${endTime}

	cat ${logfile} | egrep "query[[A-Za-z]+]" | sed 's/query\[\([A-Za-z]*\)\]/\1/g' | gawk -v st="${beginTime}" -v et="${endTime}" '{ t=substr( $0, 1, 15 ); if ( t>=st && t<=et ) { printf("%-15s %-5s %s\n", $8 ,$5, $6) } }' | sort | uniq -c | sort -n -r | head -n 40

}

function gen004 {

	echo 'dnsmasq stat query type from' ${beginTime} 'to' ${endTime}

	cat ${logfile} | egrep "query[[A-Za-z]+]" | sed 's/query\[\([A-Za-z]*\)\]/\1/g' | gawk -v st="${beginTime}" -v et="${endTime}" '{ t=substr( $0, 1, 15 ); if ( t>=st && t<=et ) { printf("%s\n", $5) } }' | sort | uniq -c | sort -n -r | head -n 10

}

function gen101 {

	local yesterday=`date -d "yesterday" +"%Y%m%d"`
	local logfile="/var/log/dnsmasq.log-"${yesterday}
	
	echo 'dnsmasq stat yesterday - ip'

	cat ${logfile} | egrep "query[[A-Za-z]+]" | gawk '{ print $8 }' | sort | uniq -c | sort -n -r 

}

function gen102 {

	local yesterday=`date -d "yesterday" +"%Y%m%d"`
	local logfile="/var/log/dnsmasq.log-"${yesterday}

	echo 'dnsmasq stat yesterday - domain'

	cat $logfile | egrep "query[[A-Za-z]+]" | sed 's/query\[\([A-Za-z]*\)\]/\1/g' | gawk '{ printf("%-5s %s\n", $5, $6) }' | sort | uniq -c | sort -n -r

}

function gen103 {

	local yesterday=`date -d "yesterday" +"%Y%m%d"`
	local logfile="/var/log/dnsmasq.log-"${yesterday}

	echo 'dnsmasq stat yesterday - ip and domain'

	cat ${logfile} | egrep "query[[A-Za-z]+]" | sed 's/query\[\([A-Za-z]*\)\]/\1/g' | gawk '{ printf("%-15s %-5s %s\n", $8 ,$5, $6) }' | sort | uniq -c | sort -n -r 

}

function gen104 {

	local yesterday=`date -d "yesterday" +"%Y%m%d"`
	local logfile="/var/log/dnsmasq.log-"${yesterday}

	echo 'dnsmasq stat yesterday - query type'

	cat ${logfile} | egrep "query[[A-Za-z]+]" | sed 's/query\[\([A-Za-z]*\)\]/\1/g' | gawk '{ printf("%s\n", $5) }' | sort | uniq -c | sort -n -r 

}

getBeginEndTime min sec

case ${1} in
"")
	gen001
	gen002
	gen003
	gen004
	;;
*)
	gen${1}
	;;
esac

exit 0

