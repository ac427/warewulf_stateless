* warewulf_stateless_provision
* centos-6.6 x86_64 minimum 
* warewulf 3.6, stateless provision
* passwd free ssh for all user across all nodes
* /home, /opt, /usr/local are NFS mounted from master node
* Lmod module environment
* Slurm job scheduler
* OpenMPI

To make yourself a warewulf Linux cluster, do 

1. configure eth0 as DHCP and eth1 static internal(172.16.2.250 for this demo) on master node, bring up both network interface
2. run scripts in order, follow instructions
3. you have a stateless Linux cluster!

Current testing status:

1. tested to step 7
2. step 8 ganglia configuration is in progress
3. but you can use pdtop, and use D3 library to visulaize cluster utilization, so ganglia is not needed...

D3 bar chart: http://bl.ocks.org/mbostock/3885304

TODO:

1. mount local /tmp and swap disk
2. enable slurm account and configure slurm resource limits
3. enable Berkeley checkpoint/restart in slurm

NOTE:
warewulf 3.6 has a bug in wwsh and wwvnfs script, which will cause errors like this:
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
