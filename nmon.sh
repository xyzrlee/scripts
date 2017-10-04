#!/bin/sh
#
#       /etc/init.d/nmon
#
# chkconfig: 345 70 55
# description: nmon init script

NMON=/usr/bin/nmon
LOGDIR=/var/log/nmon
PIDFILE=/var/run/nmon.pid

if [ ! -d $LOGDIR ]; then
  mkdir -p $LOGDIR
  chown -R root:root $LOGDIR
  chmod -R 755 $LOGDIR
fi

if [ ! -e $NMON ]; then
  exit 5
fi

# collect NMON data every INTERVAL seconds
INTERVAL=10

# just use the plain hostname for the filename, logrotate will rename each day
FILENAME=`hostname`.nmon

start() {
  if [ -f $PIDFILE ]; then
   echo "Already running!"
   return 0;
  else
    $NMON -F $FILENAME -T -s $INTERVAL -m $LOGDIR -p -c -1> $PIDFILE
    # just assume nmon started ok; exectue true so the output is correct
    return 0
  fi
}

stop() {
  if [ -f $PIDFILE ]; then
    kill -s USR2 `cat /var/run/nmon.pid` 2> /dev/null
  else
    killall -s USR2 $NMON 2> /dev/null
  fi
  
  rm -f $PIDFILE
  
  return 0
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  status)
    status nmon
    ;;
  *)
    echo "Usage: nmon {start|stop|restart|status}"
    exit 1
    ;;
esac
exit $?
