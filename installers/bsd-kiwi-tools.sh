#!/bin/sh
set -e

# fix time
# rdate -ncv pool.ntp.org

## fetch ports
#(
#cd /tmp
#ftp https://cdn.openbsd.org/pub/OpenBSD/$(uname -r)/{ports.tar.gz,SHA256.sig}
#signify -Cp /etc/signify/openbsd-$(uname -r | cut -c 1,3)-base.pub -x SHA256.sig ports.tar.gz
#)

SUDO=doas

# zsh
$SUDO pkg_add zsh
chsh -s zsh

# python 3
$SUDO pkg_add python3 py3-pip
$SUDO pip install setuptools

# nmap
$SUDO pkg_add nmap

# gron
$SUDO pkg_add gron

# jq
$SUDO pkg_add jq

# openvpn
$SUDO pkg_add openvpn

# socat
$SUDO pkg_add socat

# exiftool
$SUDO pkg_add p5-Image-ExifTool

# ripgrep
$SUDO pkg_add ripgrep

# git
$SUDO pkg_add git

# go
$SUDO pkg_add go

# snmp-utils
$SUDO pkg_add net-snmp

# openldap-clients
$SUDO pkg_add openldap-client

# rust
$SUDO pkg_add rust

# pwncat
# TODO

## setup Dev
cd
mkdir Dev
cd Dev

## enum4linux
(
  git clone https://github.com/CiscoCXSecurity/enum4linux.git
)

## impacket
(
  git clone https://github.com/SecureAuthCorp/impacket.git
)

## SecLists
(
  git clone https://github.com/danielmiessler/SecLists.git
)

## smbmap
(
  git clone https://github.com/ShawnDEvans/smbmap.git
)

## sqlmap
(
  git clone https://github.com/sqlmapproject/sqlmap.git
)

## ssti-payload
(
  git clone https://github.com/VikasVarshney/ssti-payload.git
)

## wig
(
  git clone https://github.com/jekyc/wig.git
  cd wig
  python3 setup.py install
)

## mitmproxy
(
  pip install mitmproxy
  # modified boringtun-0.6.0/src/sleepyinstant/unix.rs to use CLOCK_MONOTONIC instead of CLOCK_BOOTTIME (like macOS)
  # export OPENSSL_DIR="/usr"
)
