#!/bin/bash
sudo rsync --delete -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/external/*","/home/*"} / /external/backup
