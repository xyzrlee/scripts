#!/bin/bash

mkdir -p /tmp/tracker
pushd /tmp/tracker
rm -rf *
wget https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt
wget https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt
wget https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_udp.txt
wget https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_http.txt
wget https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_https.txt
wget https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best_ip.txt
wget https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all_ip.txt
popd
cp -r /tmp/tracker /srv/ftp

