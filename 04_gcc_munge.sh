#!/bin/bash

## add a testing user, critical step, will sync user account including munge to compute nodes 
~/bin/add_user opera opera1122
sleep 4

## install gcc to compute nodes 
yum --tolerant --installroot /var/chroots/centos-6 -y install `paste -s compute_node_yum_list`

## configure munge, slurm will need munge for communication
create-munge-key
chkconfig munge on
service munge start
echo testing  munge ...
munge -n | unmunge 

cp /etc/munge/munge.key /var/chroots/centos-6/etc/munge/munge.key
chown munge:munge /var/chroots/centos-6/etc/munge/munge.key

chroot /var/chroots/centos-6/ chkconfig munge on
## /var/log is excluded in image, so need to create it when booting
cat >> /var/chroots/centos-6/etc/rc.local << EOF
mkdir -p /var/log/munge
chown munge:munge /var/log/munge
service munge start
EOF

## reimage and reboot
##~/bin/reim_reboot
