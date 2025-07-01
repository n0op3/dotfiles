#!/bin/bash

backup() {
    sudo restic --repo /backups backup /bin /boot /etc /lib /lib64 /sbin /usr
}

echo "Checking whether a backup is advised..."
packages=$(paru -Quq | grep -i -E "linux|nvidia|hypr|aquamarine|sway")
backup_needed=$?

if [[ $backup_needed ]]; then
    echo "Found some packages which may break the system:"
    echo $packages
    echo
    echo "Starting a backup..."
    backup
    backup_success=$?
fi

if [[ $backup_success ]]; then
    echo "Backup succeeded, proceeding..."
else
    echo "Backup failed, aborting!"
    exit 1
fi

echo "Continuing the system upgrade..."
echo
paru
echo
echo "System was upgraded successfully."
