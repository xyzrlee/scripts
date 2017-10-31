#!/bin/bash

echo 'mtr'
echo `date -R`

scriptFileDir=$(cd "$(dirname "$0")"; pwd)
echo ${scriptFileDir}

while read line
do
	fileName="${statFileDir}/mtr.${line}"
    echo ${line}
    mtr -c 20 -r -n ${line}
done < ${scriptFileDir}/mtr.list

