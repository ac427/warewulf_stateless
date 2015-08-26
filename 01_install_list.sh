#!/bin/bash
mkdir -p ~/bin
cp * ~/bin/
mkdir -p /usr/local/bin
cp calc_cpu /usr/local/bin
cp pdtop /usr/local/bin
##install list on provision node
##yum -y groupinstall "Development tools"
yum -y groupinstall "MySQL Database server"
yum -y install httpd dhcp tftp-server mod_perl tcpdump nfs-utils ntp man finger tcl gcc rsync bc wget
##yum -y install wget unzip emacs git
wget http://mirrors.mit.edu/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://warewulf.lbl.gov/downloads/repo/warewulf-rhel6.repo -O /etc/yum.repos.d/warewulf-rhel6.repo
rpm -Uvh epel-release-6-8.noarch.rpm

yum -y install pdsh munge munge-devel

echo disabling Selinux ...
sed -i 's+=enforcing+=disabled+g' /etc/selinux/config

echo installing warewulf ...
yum -y install warewulf-provision warewulf-cluster warewulf-provision-server warewulf-vnfs 
yum -y install warewulf-monitor-legacy warewulf-monitor-legacy-proxy warewulf-monitor-legacy-tools warewulf-monitor-legacy-web

## also install warewulf-monitor-legacy to image, config wulfd.conf, wwproxy.conf in /etc/sysconfig/

# fix version 3.6 bug in wwsh, wwvnfs, wwbootstrap
sed -i "29idelete @ENV{'PATH', 'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};" /usr/bin/wwsh
sed -i "267idelete @ENV{'PATH', 'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};" /usr/bin/wwvnfs
sed -i "21idelete @ENV{'PATH', 'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};" /usr/bin/wwbootstrap

## edit /etc/warewulf/vnfs.conf, uncomment hybridpath= ...
echo turnning on hybridpath in /etc/warewulf/vnfs.conf ...
sed -i '/# hybridpath /s/^#//g'  /etc/warewulf/vnfs.conf

chkconfig iptables off

echo master is going to reboot now ...
sleep 3
reboot
