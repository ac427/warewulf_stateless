#!/bin/bash
## openmpi will depend on slurm pmi header, so install slurm first and then openmpi
yum install -y mysql-devel
# mysql-devel is needed for slurm database plugin

## slurm
wget -P ~/rpmbuild/SOURCES https://github.com/SchedMD/slurm/archive/slurm-14-11-8-1.tar.gz
cd ~/rpmbuild/SOURCES
## you can also do rpmbuild -ta slurm*.gz and rpm install the rpm
## configuration guide can also be figured out from the slurm.spec file inside tar file
# centos-7 uses: systemctl start xxx.service instead of service
tar xvzf slurm-14-11-8-1.tar.gz
cd slurm-slurm-14-11-8-1
./configure --prefix=/opt/slurm/14.11.8 --sysconfdir=/opt/slurm/14.11.8/etc
## if want berkeley checkpoint restart install BLCR and add --with-blcr=PATH
make 
make install
make install-contrib
## somehow this need a fix
sed -i 's+${exec_prefix}+/opt/slurm/14.11.8+g' etc/*

## sample scripts for deamon service and configuration
## do same to the image, omit slurmdbd
if [ -d /etc/init.d ]; then
  install -D -m755 etc/init.d.slurm    /etc/init.d/slurm
  install -D -m755 etc/init.d.slurmdbd /etc/init.d/slurmdbd
  mkdir -p "/usr/sbin"
  ln -s /etc/init.d/slurm    /usr/sbin/rcslurm
  ln -s /etc/init.d/slurmdbd /usr/sbin/rcslurmdbd
  
  cp /etc/init.d/slurm /var/chroots/centos-6/etc/init.d/slurm
  cp /usr/sbin/rcslurm /var/chroots/centos-6/usr/sbin/rcslurm
fi
## this is for centos-7
if [ -d /usr/lib/systemd/system ]; then
  install -D -m755 etc/slurmctld.service /usr/lib/systemd/system/slurmctld.service
  install -D -m755 etc/slurmd.service    /usr/lib/systemd/system/slurmd.service
  install -D -m755 etc/slurmdbd.service  /usr/lib/systemd/system/slurmdbd.service
  
  cp /usr/lib/systemd/system/slurmd.service /var/chroots/centos-6/usr/lib/systemd/system/
fi
# slurm resource config, need manual config
install -D -m644 etc/slurm.conf.example /opt/slurm/14.11.8/etc/slurm.conf
# slurm database config
install -D -m644 etc/slurmdbd.conf.example /opt/slurm/14.11.8/etc/slurmdbd.conf

install -D -m644 etc/cgroup.conf.example /opt/slurm/14.11.8/etc/cgroup.conf.example
install -D -m644 etc/cgroup_allowed_devices_file.conf.example /opt/slurm/14.11.8/etc/cgroup_allowed_devices_file.conf.example
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup.release_common.example
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup/release_freezer
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup/release_cpuset
install -D -m755 etc/cgroup.release_common.example /opt/slurm/14.11.8/etc/cgroup/release_memory
install -D -m755 etc/slurm.epilog.clean /opt/slurm/14.11.8/etc/slurm.epilog.clean
install -D -m755 contribs/sgather/sgather /opt/slurm/14.11.8/bin/sgather
install -D -m755 contribs/sjstat /opt/slurm/14.11.8/bin/sjstat

cat > /etc/profile.d/slurm.sh << 'EOF'
#!/bin/sh
export PATH=/opt/slurm/14.11.8/bin:/opt/slurm/14.11.8/sbin:$PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
 export LD_LIBRARY_PATH=:
fi
export LD_LIBRARY_PATH=/opt/slurm/14.11.8/lib:$LD_LIBRARY_PATH

if [ -z "$MANPATH" ] ; then
 export MANPATH=:
fi
export MANPATH=/opt/slurm/14.11.8/share/man:$MANPATH
EOF

chmod +x /etc/profile.d/slurm.sh
cp /etc/profile.d/slurm.sh /var/chroots/centos-6/etc/profile.d/slurm.sh

## create slurm admin user
##echo "slurm:x:2000:2000:slurm admin:/home/slurm:/bin/bash" >> /etc/passwd
##echo "slurm:x:2000:slurm" >> /etc/group
##pwconv
~/bin/add_user slurm opera1122

## start slurmd on compute nodes and slurmctld on master node on boot
## init.d/slurm also starts slurmctld on compute nodes, need fix 
chkconfig slurm on
chkconfig slurmdbd on

cat >> /var/chroots/centos-6/etc/rc.local << 'EOF'
chkconfig slurm on
service slurm start
EOF

## reimage vnfs
wwvnfs -y --chroot /var/chroots/centos-6

mkdir -p /opt/slurm/14.11.8/state
chown -R slurm:slurm /opt/slurm/14.11.8/state

## mysql database for slurm, need to agree with slurmdbd.conf
mysql -u root -ppassword << 'EOF'
create database slurm_acct_db;
create user 'slurm'@'localhost';
set password for 'slurm'@'localhost' = password('password');
grant usage on *.* to 'slurm'@'localhost';
grant all privileges on slurm_acct_db.* to 'slurm'@'localhost';
flush privileges;
EOF

echo @
echo @
echo "you will need to edit configuration file slurm.conf and slurmdbd.conf,"
echo "using the html tool in doc folder under install directory,"
echo @
echo "for SECURITY: "
echo "set StateSaveLocation other than /tmp and write permission only to slurm user"
echo @
echo "after done reboot master and compute nodes,"
echo "and optionally use sacctmgr to manage slurm accounts."
echo @
echo @
