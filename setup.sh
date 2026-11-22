#!/bin/bash
# setup.sh - membuat media virtual, 3 partisi, format, dan mount (jalankan per anggota)
set -e
mkdir -p ~/lab-fs && cd ~/lab-fs
truncate -s 2G disk.img
sudo parted -s disk.img mklabel gpt \
  mkpart system 1MiB 257MiB \
  mkpart data_ext4 257MiB 1025MiB \
  mkpart data_f2fs 1025MiB 100%
LOOP=$(sudo losetup -fP --show disk.img)
echo "LOOP=$LOOP"
sudo mkfs.ext4 -F -L system ${LOOP}p1
sudo mkfs.ext4 -F -L data_ext4 -O encrypt ${LOOP}p2
sudo mkfs.f2fs -f -l data_f2fs -O encrypt ${LOOP}p3
sudo mkdir -p /mnt/system /mnt/data_ext4 /mnt/data_f2fs
sudo mount ${LOOP}p1 /mnt/system
sudo cp /bin/ls /bin/cat /mnt/system/        # isi contoh untuk partisi sistem
sudo mount -o remount,ro /mnt/system         # sistem: hanya-baca
sudo mount -o noatime,nosuid,nodev ${LOOP}p2 /mnt/data_ext4
sudo mount -o noatime,nosuid,nodev ${LOOP}p3 /mnt/data_f2fs
findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS | grep /mnt
