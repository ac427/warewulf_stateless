#!/bin/bash
mkdir -p ~/bin
cp * ~/bin/
##install list on provision node
##yum -y groupinstall "Development tools"
##yum -y groupinstall "MySQL Database server"
yum -y install httpd dhcp tftp-server mod_perl tcpdump nfs-utils ntp man finger tcl gcc wget rsync
##yum -y install wget unzip emacs git
wget http://mirrors.mit.edu/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://warewulf.lbl.gov/downloads/repo/warewulf-rhel6.repo -O /etc/yum.repos.d/warewulf-rhel6.repo
rpm -Uvh epel-release-6-8.noarch.rpm

yum -y install pdsh munge munge-devel

echo disabling Selinux ...
sed -i 's+=enforcing+=disabled+g' /etc/selinux/config

echo installing warewulf ...
yum -y install warewulf-provision warewulf-cluster warewulf-provision-server warewulf-vnfs 

# fix version 3.6 bug in wwsh and wwvnfs
sed -i "29idelete @ENV{'PATH', 'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};" /usr/bin/wwsh
sed -i "267idelete @ENV{'PATH', 'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};" /usr/bin/wwvnfs

## edit /etc/warewulf/vnfs.conf, uncomment hybridpath= ...
echo turnning on hybridpath in /etc/warewulf/vnfs.conf ...
sed -i '/# hybridpath /s/^#//g'  /etc/warewulf/vnfs.conf

chkconfig iptables off

echo master is going to reboot now ...
sleep 3
reboot
