#!/bin/bash
set -e
sudo apt-get update
sudo apt-get install -y libgnutls28-dev nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libcppunit-dev autoconf automake autotools-dev autopoint libtool git gcc g++ 
tmpdir="/tmp/xyzrlee/aria2"
if [ -d ${tmpdir} ]; then
    rm -rf ${tmpdir}
fi
mkdir -p ${tmpdir}
pushd ${tmpdir}
git clone https://github.com/aria2/aria2.git
pushd aria2
autoreconf -i
./configure
make
popd
popd
