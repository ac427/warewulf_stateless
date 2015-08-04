#!/bin/sh
## this is unnecessary, use wwuseradd username -p password instead
useradd $@
su $1
logout
wwsh -y file import /etc/passwd
wwsh -y file import /etc/group
wwsh -y file import /etc/shadow
wwsh -y provision set --fileadd passwd,group,shadow
wwsh file sync
