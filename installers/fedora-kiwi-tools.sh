#!/bin/bash
################################################################################
## Install on Fedora 41

## always break on errors
set -e

################################################################################
## configs
RESUME=0
SUDO=sudo
PKG_ADD="dnf install -y"

################################################################################
## functions
failure() {
  local lineno=$1
  local msg=$2
  echo '[!]'" Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR

################################################################################
## usage

function usage() {
  echo "$0 [options]"
  echo "   -h          help screen"
  echo "   -c LINENO   continue from LINENO"
  exit
}

################################################################################
## parse options

while getopts ":hc:" opts; do
  case "${opts}" in
    h)
      usage
      ;;
    c)
      RESUME="${OPTARG}"
      ;;
    *)
      echo "Fatal Error: illegal option!"
      exit
      ;;
    esac
done
shift $((OPTIND-1))

if [ "$RESUME" -gt 0 ]; then
  ## let's resume from a specific line number
  cat $0 | tail -n +"$RESUME" | bash
  ## then exit (don't execute things twice.)
  exit
fi

################################################################################
## Make sure we are running Fedora 41
if [ $(rpm -E %fedora) -lt 41 ]; then
  echo "Error: Not running Fedora 41 or greater. Bailing..."
  exit
fi

echo '              ,--.,--.'
echo '             (  . \   \'
echo '             //_   `   |'
echo "            /' |       |"
echo "           '    \      ;"
echo '              __|`--\,/     -Offensive Security-'
echo '               /\    |         <system setup>'
echo '                    ~|~'

## Let's set up our Fedora system!

echo '[+] bye nano!'
$SUDO dnf remove nano -y

echo "[+] zsh"
$SUDO $PKG_ADD zsh
$SUDO chsh -s $(which zsh) $(whoami)

echo "[+] DNF packages"
## install development packages
$SUDO dnf group install "development-tools" -y

## install some basic packages
$SUDO $PKG_ADD \
  binwalk \
  boost-devel \
  cargo \
  clang \
  cmake \
  ftp \
  git \
  go \
  gron \
  hping3 \
  john \
  jq \
  lldb \
  masscan \
  ncrack \
  net-snmp-utils \
  nmap \
  open-vm-tools open-vm-tools-desktop \
  openldap-clients \
  openssl \
  openvpn \
  perl-Image-ExifTool \
  pkg-config openssl-devel \
  pwncat \
  python3-devel \
  python3-pip \
  python3-pwntools \
  python3-xmltodict \
  ripgrep \
  ruby-devel \
  samba-common-tools \
  snmpcheck \
  socat \
  stunnel \
  neovim \
  wireshark

###### Set Neovim configs ######
mkdir $HOME/.config/nvim
cat <<EOF>> $HOME/.config/nvim/init.vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
EOF

###### Update Ruby gems ######
$SUDO gem update --system

###### Install tools from git repos ######

## setup Dev
cd
mkdir -p Dev
cd Dev

echo "[+] kiwi tools"
(
  if [ ! -d kiwi-tools ]; then
    git clone https://github.com/unix-ninja/kiwi-tools.git
  fi
  cp kiwi-tools/rc/ffufrc $HOME/.ffufrc
  cp kiwi-tools/rc/vimrc $HOME/.vimrc
  cp kiwi-tools/rc/zshrc $HOME/.zshrc
)

echo "[+] cream"
(
  git clone git://git.z3bra.org/cream.git
  cd cream
  make
)

echo "[+] dirhunt"
(
  pip install dirhunt
)

echo "[+] enum4linux"
(
  git clone https://github.com/CiscoCXSecurity/enum4linux.git
)

echo "[+] fuzzr"
(
  ## installed with kiwi tools
  chmod +x $HOME/tools/fuzzr
)

echo "[+] ffuf"
(
  # (needs to be at least 1.5)
  git clone https://github.com/ffuf/ffuf.git
  cd ffuf
  go get
  go build
  mv ffuf $HOME/.local/bin/
)

echo "[+] impacket"
(
  git clone https://github.com/SecureAuthCorp/impacket.git
)

echo "[+] mitmproxy"
(
  pip install mitmproxy
)

echo "[+] recona"
(
  ## installed with kiwi tools
  chmod +x $HOME/tools/recona
)

echo "[+] scanhref"
(
  ## installed with kiwi tools
  chmod +x $HOME/tools/scanhref
)

echo "[+] Exploit DB"
(
  cd /usr/share
  $SUDO mkdir exploitdb
  $SUDO chown $USER exploitdb
  git clone https://gitlab.com/exploit-database/exploitdb.git
  $SUDO mkdir exploitdb-papers
  $SUDO chown $USER exploitdb-papers
  chmod 755 exploitdb/searchsploit
  $SUDO ln -s /usr/share/exploitdb/searchsploit /usr/bin/searchsploit
)

# this is installed via dnf now
#echo "[+] Ncrack"
#(
#  git clone https://github.com/nmap/ncrack.git
#  cd ncrack
#  ./configure
#  make
#  $SUDO make install
#)

echo "[+] SecLists"
(
  git clone https://github.com/danielmiessler/SecLists.git
)

echo "[+] shellfire"
(
  pip install shellfire
)

echo "[+] smbmap"
(
  git clone https://github.com/ShawnDEvans/smbmap.git
)

echo "[+] sqlmap"
(
  git clone https://github.com/sqlmapproject/sqlmap.git
)

echo "[+] ssti-payload"
(
  git clone https://github.com/VikasVarshney/ssti-payload.git
)

echo "[+] webshells"
(
  git clone https://github.com/BlackArch/webshells.git
)

echo "[+] wig"
(
  git clone https://github.com/jekyc/wig.git
  cd wig
  $SUDO python3 setup.py install
)

echo "[+] Wordlists"
(
  ## TODO
  echo "[-] Please copy this file over by hand."
)

echo "[+] wpscan"
(
  gem install wpscan
)

################################################################################
## setup firewall rules

# open incoming 4444/tcp
#iptables -I INPUT -p tcp --dport 4444 -j ACCEPT
#$SUDO firewall-cmd --add-port=4444/tcp --permanent
