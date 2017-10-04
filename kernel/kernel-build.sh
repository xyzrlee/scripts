#!/bin/bash

set -e

if [ $# != 1 ]; then
    echo "usage: ${scriptName} <version>"
    exit 1
fi

scriptName=$(basename $0)
lockFileDir="/tmp"
lockFile="${lockFileDir}/${scriptName}.lock"
logFileDir="/tmp/log"
logFile="${logFileDir}/build_kernel"

if [ ! -d ${lockFileDir} ]; then
    mkdir -p ${lockFileDir}
fi

exec 200>${lockFile}
flock -n 200

if [ ! -d ${logFileDir} ]; then
    mkdir -p ${logFileDir}
fi

exec 201>${logFile}
flock -n 201

ver=${1}

nohup make-kpkg --rootcmd fakeroot --initrd --revision ${ver} --append-to-version -xyz-${ver} kernel_image 1>${logFile} 2>&1 &

