# CentOS 8 Workstation with Guest Additions Installation

To get full screen with CentOS 8 Workstation:

* VirtulBox: Select your `centos8-workstation` VM for example
* Go to Settings -> System -> Motherboard -> Pointing Devices to `USB Tablet`
* Go to Settings -> Display -> Screen -> Video Memory to `48 MB`
* Go to Settings -> Display -> Screen -> Graphics Controller to `VBoxVGA`

* In CentOS terminal, run:
```bash
sudo yum update --nobest
sudo yum install -y gcc
sudo yum install -y make perl

# This kernel-devel-$(uname -r) must be re-executed after each kernal update
sudo yum install -y kernel-devel-$(uname -r)

sudo yum install -y elfutils-libelf-devel
```

After each kernal update, re-run:
```bash
sudo yum install -y kernel-devel-$(uname -r)
```

* Go to VirtualBox menu: Devices -> `Insert Guest Additions CD image`
* In CentOS menu: Files -> `VBox_Guest_Additions DVD` -> Run
* Reboot
* Enter full screen mode after reboot

* Reference: https://youtu.be/NgR9Ly302E4
