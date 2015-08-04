#!/bin/sh
wwsh -y file import /etc/passwd
wwsh -y file import /etc/group
wwsh -y provision set --fileadd passwd,group
wwsh file sync
