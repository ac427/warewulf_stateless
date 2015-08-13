#!/bin/bash

yum install -y gmp-devel mpfr-devel libmpc-devel

## new gcc
wget -P  ~/rpmbuild/SOURCES/  http://mirrors.concertpass.com/gcc/releases/gcc-5.2.0/gcc-5.2.0.tar.gz
cp rpm_specs/* ~/rpmbuild/SPECS
## rpmbuild using gcc spec file, replace the HMS with your own name in SPEC file
cd ~/rpmbuild/SPECS/
rpmbuild -ba gcc-5.2.0.spec
##rpm -ivh ~/rpmbuild/RPMS/x86_64/gcc-5.2.*.rpm

## openmpi, configed to do srun in slurm
wget -P ~/rpmbuild/SOURCES/  http://www.open-mpi.org/software/ompi/v1.8/downloads/openmpi-1.8.8.tar.gz
rpmbuild -ba openmpi-1.8.8.spec
##rpm -ivh ~/rpmbuild/RPMS/x86_64/openmpi-1.8*.rpm
## now we can kick start the app stack and module tree
