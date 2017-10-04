#!/bin/bash

echo `date -R`

targetDir=${HOME}/auto-backup
targetFile=${targetDir}/script.zip
srcDir=${HOME}/script

echo ${targetDir}
echo ${targetFile}
echo ${srcDir}

if [ ! -d ${targetDir} ]; then
	mkdir ${targetDir}
fi

if [ -e ${targetFile} ]
then
	rm -fv ${targetFile}
fi

if [ -d ${srcDir} ]
then
	zip -v -r ${targetFile} ${srcDir} 
else
	echo "dir not found: "${srcDir}
fi

exit 0
