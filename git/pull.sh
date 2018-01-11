#!/bin/sh
for dir in $(ls -d */)
do
  cd $dir
  echo "into $dir"
  if [ -d ".git" ]; then
     git pull
  fi
  cd ..
done

