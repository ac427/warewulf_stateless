#!/bin/bash

## install gcc to compute nodes 
yum --tolerant --installroot /var/chroots/centos-6 -y install gdb gcc gcc-c++ gcc-gfortran

## install Lmod

## 

## rebuild image 
#wwvnfs -y --chroot /var/chroots/centos-6
