#!/bin/bash
set -e
sudo apt-get update
sudo apt-get install gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake
tmpdir="/tmp/`cat /proc/sys/kernel/random/uuid`"
if [ -d ${tmpdir} ]; then
    rm -rf ${tmpdir}
fi
mkdir -p ${tmpdir}
pushd ${tmpdir}
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
rm -rf ${tmpdir}
sudo cp systemd/shadowsocks-libev-server@.service /etc/systemd/system
sudo cp systemd/shadowsocks-libev-local@.service /etc/systemd/system
sudo cp rsyslog/30-shadowsocks-libev.conf /etc/rsyslog.d 
sudo cp logrotate/shadowsocks-libev /etc/logrotate.d
sudo cp sysctl/01-local.conf /etc/sysctl.d
sudo systemctl restart rsyslog
sudo sysctl -p
