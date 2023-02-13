#!/bin/bash

#sudo apt install libc6-dev on deb based
BUSYBOX_VERSION=1.36.0
LINUX_VERSION=5.15.2
mkdir -p src
cd src
    #linux    
    LINUX_MAJOR=$(echo $LINUX_VERSION | sed 's/\([0-9]*\)[^0-9].*/\1/')
    wget https://mirrors.edge.kernel.org/pub/linux/kernel/v$LINUX_MAJOR.x/linux-$LINUX_VERSION.tar.xz
    tar -xf linux-$LINUX_VERSION.tar.xz
    cd linux-$LINUX_VERSION
        make defconfig
        make || exit
    cd ..
    
    #busybox
    #wget https://www.busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2
    #tar -xf busybox-$BUSYBOX_VERSION.tar.bz2

cd ..
