#!/bin/sh
## usage: cmd username passwd
## can be replaced by wwuseradd?
useradd $1
echo $2 | passwd $1 --stdin
wwsh -y file import /etc/passwd
wwsh -y file import /etc/group
wwsh -y file import /etc/shadow
wwsh -y provision set --fileadd passwd,group,shadow
wwsh file sync

## wait many(3-5?) minuts for the account to take effect in all nodes
## the nfs mount will cause ownership=nobody issue, just wait
