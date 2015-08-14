#!/bin/bash

## if you don't want to monitor master, gmond is not required
yum -y install ganglia-gmond ganglia-gmetad ganglia-web bc
chkconfig gmetad on
chkconfig gmond on

service gmond start
service gmetad start

yum --tolerant --installroot /var/chroots/centos-6 -y install ganglia-gmond bc

## edit the two /etc/ganglia/gmond.conf files
