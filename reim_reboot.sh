#!/bin/bash

## reimage vnfs
wwvnfs -y --chroot /var/chroots/centos-6

## reboot all compute nodes
pdsh -w `grep eth0 /etc/hosts | awk '{print $1}' | paste -d, -s ` reboot
