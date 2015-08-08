#!/bin/bash


yum install gmp-devel mpfr-devel libmpc-devel rpm-build redhat-rpm-config
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros

wget http://mirrors.concertpass.com/gcc/releases/gcc-5.2.0/gcc-5.2.0.tar.gz

## rpmbuild using gcc spec file



## slurm

## openmpi, configed to do srun in slurm


## now we can kick start the app stack and module tree
