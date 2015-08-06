#!/bin/bash

## system have an old lua without posix and lfs module 
wget http://sourceforge.net/projects/lmod/files/lua-5.1.4.8.tar.gz/download
tar xvzf download
cd lua-5.1.4.8
./configure --prefix=/opt/apps/lua/5.1.4
make
make install
ln -s /opt/apps/lua/5.1.4 /opt/apps/lua/lua
ln -s /opt/apps/lua/lua/bin/lua /usr/local/bin

## lmod
git clone https://github.com/TACC/Lmod
cd Lmod
./configure --prefix=/opt/apps
make install
