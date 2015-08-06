#!/bin/bash

## install gcc to compute nodes 
yum --tolerant --installroot /var/chroots/centos-6 -y install `paste -s compute_node_yum_list`

## install Lmod in /opt, copy script to /etc and image /etc

## 

## rebuild image 
#wwvnfs -y --chroot /var/chroots/centos-6
