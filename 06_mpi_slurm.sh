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
wget -P ~/rpmbuild/SOURCES https://github.com/SchedMD/slurm/archive/slurm-14-11-8-1.tar.gz
cd ~/rpmbuild/SOURCES
tar xvzf slurm-14-11-8-1.tar.gz
cd slurm-slurm-14-11-8-1
./configure --prefix=/opt/slurm/14.11.8 --sysconfdir=/opt/slurm/14.11.8/etc
make 
make install
## you will need to configure file slurm.conf using the html tool in doc folder under install directory

## openmpi, configed to do srun in slurm
wget -P ~/rpmbuild/SOURCES http://www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.8.tar.gz
rpmbuild -ba ~/rpmbuild/SPECS/openmpi-1.8.8.spec

## now we can kick start the app stack and module tree
