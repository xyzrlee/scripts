#!/bin/bash
set -e
sudo apt-get install gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake
if [ -d /tmp/workspace ]; then
    rm -rf /tmp/workspace
fi
mkdir -p /tmp/workspace
pushd /tmp/workspace
git clone https://github.com/shadowsocks/shadowsocks-libev.git
git clone https://github.com/shadowsocks/simple-obfs.git
git clone https://github.com/ARMmbed/mbedtls.git
git clone https://github.com/jedisct1/libsodium.git
pushd libsodium
./autogen.sh
./configure --prefix=/usr && make
sudo make install
popd
sudo ldconfig
pushd mbedtls
make SHARED=1 CFLAGS=-fPIC
sudo make DESTDIR=/usr install
popd
sudo ldconfig
pushd simple-obfs
git submodule init && git submodule update
./autogen.sh
./configure
make
sudo make install
popd
pushd shadowsocks-libev
git submodule init && git submodule update
./autogen.sh
./configure
make
sudo make install
popd
popd

