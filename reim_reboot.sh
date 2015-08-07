#!/bin/bash

wwvnfs -y --chroot /var/chroots/centos-6
pdsh -w `grep eth0 /etc/hosts | awk '{print $1}' | paste -d, -s ` reboot
