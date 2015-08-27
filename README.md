* centos-6.6 x86_64 minimum 
* warewulf 3.6, stateless provision
* passwd free ssh for all users across all nodes
* /home, /opt, /usr/local are NFS mounted from master node
* Lmod module environment
* Slurm job scheduler
* OpenMPI
* local disk /dev/sda on compute nodes are mounted as /scratch
* warewulf-monitor

To make yourself a warewulf Linux cluster, do 

1. configure eth0 as interface to outside(DHCP in this demo) and eth1 as internal(172.16.2.250 in this demo) on master node, bring up both network interfaces, set compute nodes to PXE boot
2. run scripts in order on master node, follow instructions to power up compute nodes in order
3. you have a well functioning Linux cluster!

Current testing status: tested to step 8 in VirtualBox

D3 bar chart: http://bl.ocks.org/mbostock/3885304

TODO:

1. add sub-provisioner and node health check(warewulf-nhc)
2. seperate NFS server from provision node 
3. tune up NFS performance
4. enable slurm account and configure slurm resource limits
5. enable Berkeley checkpoint/restart in slurm
6. install TACC Xalt

NOTE:
warewulf 3.6 has a bug in wwsh, wwvnfs and wwbootstrap etc, which will cause errors like this:
```
wwvnfs --root /var/chroots/centos-6
Using 'centos-6' as the VNFS name
Creating VNFS image from centos-6
Building new chroot...
Building and compressing the final image
Insecure $ENV{BASH_ENV} while running with -T switch at /usr/bin/wwvnfs line 429.
```
to fix: 

add a line after each of the sanitized PATH assignments (line 29 of wwsh and 267 of wwwvnfs)
```
delete @ENV{'PATH', 'IFS', 'CDPATH', 'ENV', 'BASH_ENV'};
```
script 01 takes care of that

reference: https://groups.google.com/a/lbl.gov/forum/#!msg/warewulf/Q8prRTzLuT4/AcL-sxGTvyoJ

NOTE2:

ALL MySQL password including warewulf and slurm is set to 'password', you will need to change it.
