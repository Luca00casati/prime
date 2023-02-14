#!/bin/bash

#sudo apt install libc6-dev build-essential libncurses-dev bison flex libssl-dev libelf-dev musl on deb based

BUSYBOX_VERSION=1.36.0
LINUX_VERSION=5.15.0
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
    wget https://www.busybox.net/downloads/busybox-$BUSYBOX_VERSION.tar.bz2
    tar -xf busybox-$BUSYBOX_VERSION.tar.bz2
    cd busybox-$BUSYBOX_VERSION
        make defconfig
        sed 's/^.*CONFIG_STATIC[^_].*$/CONFIG_STATIC=y/g' -i .config
        make TARGET=x86_64-linux-musl busybox || exit
    cd ..
cd ..

cp src/linux-$LINUX_VERSION/arch/x86_64/boot/bzImage ./

#initrd
mkdir initrd
cd initrd
    mkdir -p bin dev proc sys
    cd bin

        cp ../../src/busybox-$BUSYBOX_VERSION/busybox ./
        for prog in $(./busybox --list); do
            ln -s /bin/busybox ./$prog
        done
    cd ..

    echo '#!/bin/sh' > init
    echo 'mount -t sysfs sysfs /sys' >> init
    echo 'mount -t proc proc /proc' >> init
    echo 'mount -t devtmpfs udev /dev' >> init
    echo 'sysctl -w kernel.printk="2 4 1 7"' >> init
    #echo 'clear' >> init
    echo '/bin/sh' >> init
    echo 'poweroff -f' >> init

    chmod -R 777 .

    find . | cpio -o -H newc > ../initrd.img
cd ..


