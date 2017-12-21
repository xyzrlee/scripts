#!/bin/bash
set -e
sudo apt-get update
sudo apt-get install -y gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake
tmpdir="/tmp/xyzrlee/shadowsocks-libev"
if [ ! -d ${tmpdir} ]; then
    mkdir -p ${tmpdir}
fi
pushd ${tmpdir}
if [ -x shadowsocks-libev/.git ]; then
    pushd shadowsocks-libev
    git pull
    popd
else
    git clone https://github.com/shadowsocks/shadowsocks-libev.git
fi
if [ -x simple-obfs/.git ]; then
    pushd simple-obfs
    git pull
    popd
else
    git clone https://github.com/shadowsocks/simple-obfs.git
fi
if [ -x mbedtls/.git ]; then
    pushd mbedtls
    git pull
    popd
else
    git clone https://github.com/ARMmbed/mbedtls.git
fi
if [ -x libsodium/.git ]; then
    pushd libsodium
    git pull
    popd
else
    git clone https://github.com/jedisct1/libsodium.git
fi
pushd libsodium
git checkout stable
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
if [ -d /etc/shadowsocks-libev ]; then
    sudo mkdir -p /etc/shadowsocks-libev
fi
sudo cp ./acl/gfwlist.acl /etc/shadowsocks-libev
popd
popd
rm -rf ${tmpdir}
[ ! -e /etc/systemd/system/shadowsocks-libev-server@.service ] && sudo cp systemd/shadowsocks-libev-server@.service /etc/systemd/system
[ ! -e /etc/systemd/system/shadowsocks-libev-local@.service ] && sudo cp systemd/shadowsocks-libev-local@.service /etc/systemd/system
[ ! -e /etc/rsyslog.d/30-shadowsocks-libev.conf ] && sudo cp rsyslog/30-shadowsocks-libev.conf /etc/rsyslog.d && sudo systemctl restart rsyslog
[ ! -e /etc/logrotate.d/shadowsocks-libev ] && sudo cp logrotate/shadowsocks-libev /etc/logrotate.d
[ ! -e /etc/sysctl.d/01-local.conf ] && sudo cp sysctl/01-local.conf /etc/sysctl.d && sudo sysctl -p
