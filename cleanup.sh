# pembersihan setelah semua bukti diambil
sudo fscrypt lock /mnt/data_ext4/rahasia ; sudo fscrypt lock /mnt/data_f2fs/rahasia
sudo umount /mnt/system /mnt/data_ext4 /mnt/data_f2fs
sudo losetup -d $(losetup -j ~/lab-fs/disk.img | cut -d: -f1)
