#!/bin/bash

## system have an old lua 5.1, anyway, let do the latest
git clone https://github.com/LuaDist/lua
cd lua
cmake .
make
mkdir -p /opt/apps/lua/bin
mkdir -p /opt/apps/lua/lib
cp lua luac /opt/apps/lua/bin
cp liblua.so /opt/apps/lua/lib

## lmod
git clone https://github.com/TACC/Lmod
