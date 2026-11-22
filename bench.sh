#!/bin/bash
# bench.sh - uji kinerja sederhana. Pemakaian:
# sudo bash -c "ulimit -n 65535 && bash ./bench.sh /mnt/data_ext4 ext4"
DIR=$1; LABEL=$2
for RUN in 1 2 3; do
  echo "===$LABEL | run $RUN ==="
  sync; echo 3 > /proc/sys/vm/drop_caches
  echo "--- tulis sekuensial 1 MiB x 256 MiB"
  fio --name=seq --directory=$DIR --rw=write --bs=1M --size=256M \
      --end_fsync=1 | grep -E "WRITE:|write:"
  sync; echo 3 > /proc/sys/vm/drop_caches
  echo "--- tulis acak 4 KiB x 128 MiB"
  fio --name=rnd --directory=$DIR --rw=randwrite --bs=4k --size=128M \
      --end_fsync=1 | grep -E "WRITE:|write:"
  sync; echo 3 > /proc/sys/vm/drop_caches
  echo "--- 2000 berkas kecil 4 KiB"
  fio --name=small --directory=$DIR --rw=write --bs=4k --size=8M \
      --nrfiles=2000 --end_fsync=1 | grep -E "WRITE:|write:"
  rm -f $DIR/seq.* $DIR/rnd.* $DIR/small.*
done
