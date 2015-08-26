#!/bin/bash
yum install -y rpm-build redhat-rpm-config 
# mysql-devel is needed for slurm database plugin
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros

## system have an old lua without posix and lfs module 
wget -P ~/rpmbuild/SOURCES  http://sourceforge.net/projects/lmod/files/lua-5.1.4.8.tar.gz/download
cd ~/rpmbuild/SOURCES
tar xvzf download
cd lua-5.1.4.8
./configure --prefix=/opt/apps/lua/5.1.4
make
make install
ln -s /opt/apps/lua/5.1.4 /opt/apps/lua/lua
ln -s /opt/apps/lua/lua/bin/lua /usr/local/bin

## lmod
## git clone https://github.com/TACC/Lmod
wget -P ~/rpmbuild/SOURCES  https://github.com/TACC/Lmod/archive/6.0.8.tar.gz
cd ~/rpmbuild/SOURCES
tar xvzf 6.0.8.tar.gz
cd Lmod-6.0.8
./configure --prefix=/opt/apps
make install

## ln -s or cp??
cp /opt/apps/lmod/lmod/init/profile /etc/profile.d/modules.sh
cp /opt/apps/lmod/lmod/init/cshrc /etc/profile.d/modules.csh

## standard set of module
mkdir -p /opt/apps/modulefiles/Core
cat > /opt/apps/modulefiles/Core/StdEnv.lua << 'EOF'
load("lmod")
EOF

cat > /etc/profile.d/z00_StdEnv.sh << 'EOF'
if [ -z "$__Init_Default_Modules" -o -z "$LD_LIBRARY_PATH" ]; then
  __Init_Default_Modules=1; export __Init_Default_Modules;
  module getdefault default || module load StdEnv
fi
EOF

cat > /etc/profile.d/z00_StdEnv.csh << 'EOF'
if ( ! $?__Init_Default_Modules || ! $?LD_LIBRARY_PATH ) then
  module getdefault default
  if ( $status != 0 ) then
    module load StdEnv
  endif
  setenv __Init_Default_Modules 1
endif
EOF

cp /etc/profile.d/modules.* /var/chroots/centos-6/etc/profile.d
cp /etc/profile.d/z00_* /var/chroots/centos-6/etc/profile.d

## reimage vnfs
##~/bin/reim_reboot
