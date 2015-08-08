#!/bin/bash

yum install gmp-devel mpfr-devel libmpc-devel rpm-build redhat-rpm-config
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros

## new gcc
wget ‐P ~/rpmbuild/SOURCES http://mirrors.concertpass.com/gcc/releases/gcc-5.2.0/gcc-5.2.0.tar.gz
cp rpm_specs/* ~/rpmbuild/SPECS
## rpmbuild using gcc spec file
rpmbuild -ba ~/rpmbuild/SPECS/gcc-5.2.0.spec

## slurm

## openmpi, configed to do srun in slurm


## now we can kick start the app stack and module tree
