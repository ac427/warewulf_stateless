* warewulf_stateless_provision
* centos-6.6 x86_64
* warewulf 3.6
* stateless provision



1. configure eth0 and eth1 on master nodes, bring up network
2. run install_list.sh, will reboot 
3. run ww_setup.sh, wait
4. start compute nodes one by one
5. run add_ssh_key.sh and rebuild vnfs
6. add user with add_user.sh
