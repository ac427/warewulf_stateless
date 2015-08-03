#!/bin/sh
##install list on provision node
yum groupinstall "Development tools"
yum groupinstall "MySQL Database server"
yum install httpd dhcp tftp-server mod_perl wget tcpdump emacs nfs-utils ntp man git
wget http://warewulf.lbl.gov/downloads/repo/warewulf-rhel6.repo -O /etc/yum.repos.d/warewulf-rhel6.repo
yum install warewulf-provision warewulf-cluster warewulf-provision-server warewulf-vnfs 
wget http://mirrors.mit.edu/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh epel-release-6-8.noarch.rpm
yum install pdsh
chkconfig iptables off
sed -i 's+=enforcing+=disabled+g' /etc/selinux/config
reboot