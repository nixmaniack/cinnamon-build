#!/bin/bash - 
#===============================================================================
#
#          FILE:  cinnamon-build.sh
# 
#         USAGE:  ./cinnamon-build.sh 
# 
#   DESCRIPTION:  Build the latest cinnanmon from git. (Tested on Ubuntu 11.10)
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: Muneeb Shaikh <iammuneeb@gmail.com>
#       COMPANY: 
#       CREATED: 01/12/2012 06:02:17 PM IST
#      REVISION:  0.1
#     COPYRIGHT: (C) 2012, Muneeb Shaikh
#       LICENSE: GPLv2+
#===============================================================================

set -o nounset                              # Treat unset variables as an error
set -x

sudo echo "I want to take sudo password to work without bothering you :)"

arch=`uname -m`
if [ ${arch} == 'x86_64' ]; then
    arch="amd64"
else
    arch="i386"
fi

builddir="/tmp/cinnamon"
mkdir -p ${builddir}

cd ${builddir}
git clone git://github.com/linuxmint/Cinnamon.git
git clone git://github.com/linuxmint/cinnamon-settings.git
sudo apt-get install build-essential dpkg-dev
sudo apt-get build-dep gnome-shell

if [ ! -f "muffin_1.0.0_debs.tar.gz" ]; then
    wget https://github.com/downloads/linuxmint/muffin/muffin_1.0.0_debs.tar.gz
fi

tar xvf muffin_1.0.0_debs.tar.gz
cd muffin_1.0.0_debs/
sudo dpkg -i *{arch}.deb

cd ${builddir}/Cinnamon
./autogen.sh  # This might not be needed in the future, but since SHELL is not getting populated properly, this is workaround
dpkg-buildpackage -us -uc

cd ${builddir}/cinnamon-settings
dpkg-buildpackage -us -uc

cd ${builddir}
debs=(*.deb)
sudo dpkg -i ${debs[@]}

# Uncomment following to set the panel at top
# gsettings set org.cinnamon desktop-layout 'flipped'

echo "Restart cinnamon using Alt+F2 then 'r' OR cinnamon --replace"
echo "You can now remove ${builddir}"
