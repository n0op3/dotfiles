#!/bin/bash
sudo rsync -aAXHv --exclude='/swapfile' --exclude='/dev/*' --exclude='/proc/*' --exclude='/sys/*' --exclude='/tmp/*' --exclude='/run/*' --exclude='/mnt/*' --exclude='/media/*' --exclude='/lost+found/' --exclude='/backup/*' --exclude='external/*' --exclude='/home/*' / /backup
