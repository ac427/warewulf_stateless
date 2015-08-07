#!/bin/bash

## new gcc
yum install gmp-devel mpfr-devel libmpc-devel
wget http://mirrors.concertpass.com/gcc/releases/gcc-5.2.0/gcc-5.2.0.tar.gz
tar xvzf gcc-5.2.0.tar.gz

cd gcc-5.2.0
mkdir build
cd build
../configure --enable-shared --prefix=/opt/apps/gcc/5.2.0 --disable-multilib --disable-bootstrap
make -j12
make install

## slurm

## openmpi, configed to do srun in slurm


## now we can kick start the app stack and module tree
