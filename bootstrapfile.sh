#!/bin/bash

# https://github.com/hashicorp/terraform/issues/2740

devpath=$(readlink -f /dev/sdh)

sudo file -s $devpath | grep -q ext4
if [[ 1 == $? && -b $devpath ]]; then
  sudo mkfs -t ext4 $devpath
fi

sudo mkdir /data
sudo chown riak:riak /data
sudo chmod 0775 /data

echo "$devpath /data ext4 defaults,nofail,noatime,nodiratime,barrier=0,data=writeback 0 2" | sudo tee -a /etc/fstab > /dev/null
sudo mount /data

# TODO: /etc/rc3.d/S99local to maintain on reboot
echo deadline | sudo tee /sys/block/$(basename "$devpath")/queue/scheduler
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled
