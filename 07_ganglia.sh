#!/bin/bash

yum -y install libganglia ganglia-gmond ganglia-gmetad ganglia-web
chkconfig gmetad on
chkconfig gmond on

service gmond start
service gmetad start

yum --tolerant --installroot /var/chroots/centos-6 -y install libganglia ganglia-gmond

## edit the two /etc/ganglia/gmond.conf files
