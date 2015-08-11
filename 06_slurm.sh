#!/bin/bash
## openmpi will depend on slurm, so install slurm first and then openmpi
yum install -y rpm-build redhat-rpm-config
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros

## slurm
wget -P ~/rpmbuild/SOURCES https://github.com/SchedMD/slurm/archive/slurm-14-11-8-1.tar.gz
cd ~/rpmbuild/SOURCES
## you can also do rpmbuild -ta slurm*.gz and rpm install the rpm
## configuration guide can also be figured out from the slurm.spec file inside tar file
# centos-7 uses: systemctl start xxx.service instead of service
tar xvzf slurm-14-11-8-1.tar.gz
cd slurm-slurm-14-11-8-1
./configure --prefix=/opt/slurm/14.11.8 --sysconfdir=/opt/slurm/14.11.8/etc
make 
make install
make install-contrib
## somehow this need a fix
sed -i 's+${exec_prefix}+/opt/slurm/14.11.8+g' *

## sample scripts for deamon service and configuration
##cp -r etc /opt/slurm/14.11.8/
if [ -d /etc/init.d ]; then
  install -D -m755 etc/init.d.slurm    /etc/init.d/slurm
  install -D -m755 etc/init.d.slurmdbd /etc/init.d/slurmdbd
  mkdir -p "/usr/sbin"
  ln -s /etc/init.d/slurm    /usr/sbin/rcslurm
  ln -s /etc/init.d/slurmdbd /usr/sbin/rcslurmdbd
fi
## this is for centos-7
if [ -d /usr/lib/systemd/system ]; then
  install -D -m755 etc/slurmctld.service /usr/lib/systemd/system/slurmctld.service
  install -D -m755 etc/slurmd.service    /usr/lib/systemd/system/slurmd.service
  install -D -m755 etc/slurmdbd.service  /usr/lib/systemd/system/slurmdbd.service
fi
# slurm resource config
install -D -m644 etc/slurm.conf.example /opt/slurm/14.11.8/etc/slurm.conf

install -D -m644 etc/cgroup.conf.example /opt/slurm/14.11.8/etc/cgroup.conf.example
install -D -m644 etc/cgroup_allowed_devices_file.conf.example /opt/slurm/14.11.8/etc/cgroup_allowed_devices_file.conf.example
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup.release_common.example
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup/release_freezer
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup/release_cpuset
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup/release_memory

# slurm database config
install -D -m644 etc/slurmdbd.conf.example /opt/slurm/14.11.8/etc/slurmdbd.conf

install -D -m755 etc/slurm.epilog.clean /opt/slurm/14.11.8/etc/slurm.epilog.clean
install -D -m755 contribs/sgather/sgather /opt/slurm/14.11.8/bin/sgather
install -D -m755 contribs/sjstat /opt/slurm/14.11.8/bin/sjstat
##start slurmd on compute nodes and slurmctld on master node on boot

## you will need to configure file slurm.conf using the html tool in doc folder under install directory
## and slurmdbd.conf

## create slurm admin user
echo "slurm:x:2000:2000:slurm admin:/home/slurm:/bin/bash" >> /etc/passwd
echo "slurm:x:2000:slurm" >> /etc/group
pwconv

mkdir /var/spool/slurm
chown -R slurm:slurm /var/spool/slurm
mkdir /var/log/slurm
chown -R slurm:slurm /var/log/slurm

## mysql database for slurm
mysqladmin -u root password 'password'
mysql -u root -ppassword << EOF
create database slurm_acct_db;
create user 'slurm'@'localhost';
set password for 'slurm'@'localhost' = password('password');
grant usage on *.* to 'slurm'@'localhost';
grant all privileges on slurm_acct_db.* to 'slurm'@'localhost';
flush privileges;
EOF

