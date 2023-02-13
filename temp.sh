#!/bin/bash

#sudo apt install libc6-dev build-essential libncurses-dev bison flex libssl-dev libelf-dev musl on deb based
qemu-system-x86_64 -kernel bzimage -initrd initrd.img
