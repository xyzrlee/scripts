#!/bin/bash

timeFormat="%d/%b/%Y:%H:%M:%S"
logfile="/var/log/rinetd.log"

function gen001 {


	echo 'rinetd stat today - verbose'

	cat ${logfile} | 
	sort -k 2,6 | 
	gawk -v outF="%-20s %-20s %5s %-20.20s %5s %'15d %'15d\r\n" '{ sip=$2; lip=$3; lport=$4; dip=$5; dport=$6; if ( 1==NR ) { lsip=sip; llip=lip; llport=lport; ldip=dip; ldport=dport }; if ( sip==lsip && lip==llip && lport==llport && dip==ldip && dport==ldport ) { sRcv=sRcv+$7; sSnt=sSnt+$8 } else { printf( outF, lsip, llip, llport, ldip, ldport, sRcv, sSnt ); lsip=sip; llip=lip; llport=lport; ldip=dip; ldport=dport; sRcv=$7; sSnt=$8 } } END { printf( outF, lsip, llip, llport, ldip, ldport, sRcv, sSnt ) }' | 
	sort -k 2,5 -k 1

}

function gen002 {


	echo 'rinetd stat today - listen ip && listen port'

	cat ${logfile} | 
	sort -k 3,4 | 
	gawk -v outF="%-20s %-20s %5d %-20.20s %5s %'15d %'15d\r\n" '{ lip=$3; lport=$4; if ( 1==NR ) { llip=lip; llport=lport }; if ( lip==llip && lport==llport ) { sRcv=sRcv+$7; sSnt=sSnt+$8 } else { printf( outF, "", llip, llport, "", "", sRcv, sSnt ); llip=lip; llport=lport; sRcv=$7; sSnt=$8 } } END { printf( outF, "", llip, llport, "", "", sRcv, sSnt ) }' 

}

function gen003 {


	echo 'rinetd stat today - source ip'

	cat ${logfile} | 
	sort -k 2,2 | 
	gawk -v outF="%-20s %-20s %5s %-20.20s %5s %'15d %'15d\r\n" '{ sip=$2; if ( 1==NR ) { lsip=sip }; if ( lsip==sip ) { sRcv=sRcv+$7; sSnt=sSnt+$8 } else { printf( outF, lsip, "", "", "", "", sRcv, sSnt ); lsip=sip; sRcv=$7; sSnt=$8 } } END { printf( outF, lsip, "", "", "", "", sRcv, sSnt ) }' 

}

function gen004 {
	
	echo 'rinetd stat today - destination ip && destination port'

	if [ -e ${logfile} ]
	then

		cat ${logfile} |  
		sort -k 5,6 |
		gawk -v outF="%-20s %-20s %5s %-20.20s %5d %'15d %'15d\r\n" '{ dip=$5; dport=$6; if ( 1==NR ) { ldip=dip; ldport=dport }; if ( dip==ldip && dport==ldport ) { sRcv=sRcv+$7; sSnt=sSnt+$8 } else { printf( outF, "", "", "", ldip, ldport, sRcv, sSnt ); ldip=dip; ldport=dport; sRcv=$7; sSnt=$8 } } END { printf( outF, "", "", "", ldip, ldport, sRcv, sSnt ) }' 

	fi

}

function gen101 {
	
	echo 'rinetd stat yesterday - verbose'

	local yesterday=`date -d "yesterday" +"%Y%m%d"`
	local logfile="/var/log/rinetd.log-"${yesterday}

	if [ -e ${logfile} ]
	then

		cat ${logfile} |  
		sort -k 2,6 |
		gawk -v outF="%-20s %-20s %5d %-20.20s %5d %'15d %'15d\r\n" '{ sip=$2; lip=$3; lport=$4; dip=$5; dport=$6; if ( 1==NR ) { lsip=sip; llip=lip; llport=lport; ldip=dip; ldport=dport }; if ( sip==lsip && lip==llip && lport==llport && dip==ldip && dport==ldport ) { sRcv=sRcv+$7; sSnt=sSnt+$8 } else { printf( outF, lsip, llip, llport, ldip, ldport, sRcv, sSnt ); lsip=sip; llip=lip; llport=lport; ldip=dip; ldport=dport; sRcv=$7; sSnt=$8 } } END { printf( outF, lsip, llip, llport, ldip, ldport, sRcv, sSnt ) }' | 
		sort -k 2,5 -k 1

	fi

}

function gen102 {

	echo 'rinetd stat yesterday - listen ip && listen port'

	local yesterday=`date -d "yesterday" +"%Y%m%d"`
	local logfile="/var/log/rinetd.log-"${yesterday}

	if [ -e ${logfile} ]
	then

		cat ${logfile} | 
		sort -k 3,4 | 
		gawk -v outF="%-20s %-20s %5d %-20.20s %5s %'15d %'15d\r\n" '{ lip=$3; lport=$4; if ( 1==NR ) { llip=lip; llport=lport }; if ( lip==llip && lport==llport ) { sRcv=sRcv+$7; sSnt=sSnt+$8 } else { printf( outF, "", llip, llport, "", "", sRcv, sSnt ); llip=lip; llport=lport; sRcv=$7; sSnt=$8 } } END { printf( outF, "", llip, llport, "", "", sRcv, sSnt ) }' | 
		sort -k 2,5 -k 1

	fi

}

function gen103 {

	echo 'rinetd stat yesterday - source ip'

	local yesterday=`date -d "yesterday" +"%Y%m%d"`
	local logfile="/var/log/rinetd.log-"${yesterday}

	if [ -e ${logfile} ]
	then

		cat ${logfile} | 
		sort -k 2,2 | 
		gawk -v outF="%-20s %-20s %5s %-20.20s %5s %'15d %'15d\r\n" '{ sip=$2; if ( 1==NR ) { lsip=sip }; if ( lsip==sip ) { sRcv=sRcv+$7; sSnt=sSnt+$8 } else { printf( outF, lsip, "", "", "", "", sRcv, sSnt ); lsip=sip; sRcv=$7; sSnt=$8 } } END { printf( outF, lsip, "", "", "", "", sRcv, sSnt ) }' 

	fi

}

function gen104 {
	
	echo 'rinetd stat yesterday - destination ip && destination port'

	local yesterday=`date -d "yesterday" +"%Y%m%d"`
	local logfile="/var/log/rinetd.log-"${yesterday}

	if [ -e ${logfile} ]
	then

		cat ${logfile} |  
		sort -k 5,6 |
		gawk -v outF="%-20s %-20s %5s %-20.20s %5d %'15d %'15d\r\n" '{ dip=$5; dport=$6; if ( 1==NR ) { ldip=dip; ldport=dport }; if ( dip==ldip && dport==ldport ) { sRcv=sRcv+$7; sSnt=sSnt+$8 } else { printf( outF, "", "", "", ldip, ldport, sRcv, sSnt ); ldip=dip; ldport=dport; sRcv=$7; sSnt=$8 } } END { printf( outF, "", "", "", ldip, ldport, sRcv, sSnt ) }' 

	fi

}

case ${1} in
"")
	gen001
	gen002
	gen003
	gen004
	gen101
	gen102
	gen103
	gen104
	;;
*)
	gen${1}
	;;
esac

exit 0

