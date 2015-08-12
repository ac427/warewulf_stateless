* warewulf_stateless_provision
* centos-6.6 x86_64
* warewulf 3.6
* stateless provision
* passwd free ssh for all user across all nodes
* /home, /opt, /usr/local are NFS mounted from master node
* Lmod module environment
* Slurm job scheduler
* OpenMPI

To make yourself a warewulf Linux cluster, do 

1. configure eth0 as DHCP and eth1 static internal(172.16.2.250 for this demo) on master node, bring up network
2. run scripts in order, no input needed
3. you have a warewulf cluster!

Current testing status:

1. tested to step 5
2. step 6 slurm configuration is in progress


NOTE:
warewulf 3.6 has a bug in wwsh and wwvnfs script, which will cause errors like this:
##
wwvnfs --root /var/chroots/cent6
Using 'cent6' as the VNFS name
Creating VNFS image from cent6
Building new chroot...
Building and compressing the final image
Insecure $ENV{BASH_ENV} while running with -T switch at /usr/bin/wwvnfs line 429.

to fix: 

add a line after each of the sanitized PATH assignments (line 29 of wwsh and 267 of wwwvnfs)

delete @ENV{'PATH', 'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};

reference: https://groups.google.com/a/lbl.gov/forum/#!msg/warewulf/Q8prRTzLuT4/AcL-sxGTvyoJ
