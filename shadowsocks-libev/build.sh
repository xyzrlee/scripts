#!/bin/bash
set -e
if [ -z "${1}" ]; then
    tmpdir=/tmp/xyzrlee/shadowsocks-libev
else
    tmpdir=${1}
fi
echo ${tmpdir}
sudo apt-get update
sudo apt-get install -y gettext build-essential autoconf libtool libpcre3-dev asciidoc xmlto libev-dev libc-ares-dev automake
if [ ! -d ${tmpdir} ]; then
    mkdir -p ${tmpdir}
fi
pushd ${tmpdir}
git -C shadowsocks-libev pull   || git clone https://github.com/shadowsocks/shadowsocks-libev.git
git -C simple-obfs pull         || git clone https://github.com/shadowsocks/simple-obfs.git
git -C mbedtls pull             || git clone https://github.com/ARMmbed/mbedtls.git
git -C libsodium pull           || git clone https://github.com/jedisct1/libsodium.git
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
[ ! -e /etc/systemd/system/shadowsocks-libev-server@.service ] && sudo cp systemd/shadowsocks-libev-server@.service /etc/systemd/system
[ ! -e /etc/systemd/system/shadowsocks-libev-local@.service ] && sudo cp systemd/shadowsocks-libev-local@.service /etc/systemd/system
[ ! -e /etc/rsyslog.d/30-shadowsocks-libev.conf ] && sudo cp rsyslog/30-shadowsocks-libev.conf /etc/rsyslog.d && sudo systemctl restart rsyslog
[ ! -e /etc/logrotate.d/shadowsocks-libev ] && sudo cp logrotate/shadowsocks-libev /etc/logrotate.d
[ ! -e /etc/sysctl.d/01-local.conf ] && sudo cp sysctl/01-local.conf /etc/sysctl.d && sudo sysctl -p
