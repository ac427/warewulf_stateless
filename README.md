* warewulf_stateless_provision
* centos-6.6 x86_64
* warewulf 3.6
* stateless provision

1. configure eth0 as DHCP and eth1 static internal on master node, bring up network
2. run install_list.sh, will reboot after finish
3. run ww_setup.sh, do next step and wait till all compute nodes are recorded
4. set pxe boot on comput nodes and start them one by one
5. run add_ssh_key.sh 
6. add user with add_user.sh
