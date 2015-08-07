#!/bin/bash

## add a testing user, critical step, will sync user account including munge to compute nodes 
./add_user opera opera1122
sleep 4

## install gcc to compute nodes 
yum --tolerant --installroot /var/chroots/centos-6 -y install `paste -s compute_node_yum_list`

## configure munge, slurm will need munge for communication
create-munge-key
chkconfig munge on
service munge start
echo testing  munge ...
munge -n | unmunge 

## this step along does not sync user accounts to compute nodes!!, use add_user instead
#cp /etc/passwd /var/chroots/centos-6/etc/passwd
#cp /etc/group /var/chroots/centos-6/etc/group
#cp /etc/shadow /var/chroots/centos-6/etc/shadow

cp /etc/munge/munge.key /var/chroots/centos-6/etc/munge/munge.key
chown munge:munge /var/chroots/centos-6/etc/munge/munge.key

## /var/log is excluded in image, so need to create it when booting
cat >> /var/chroots/centos-6/etc/rc.local << EOF
mkdir -p /var/log/munge
chown munge:munge /var/log/munge
chkconfig munge on
service munge start
EOF

## reimage and reboot
./reim_reboot
