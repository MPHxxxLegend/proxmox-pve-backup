# Proxmox-Pve-Backup
The bash script creates a backup of the important files for a complete restore of the proxmoxnode/host.
## Path `/etc`
This path includes all nessaccery files like network config, pve directories and so on, in a case of a restore, you need to pick specific files and restore these, because configuration is alwys diffrent from setup to setup
## Path `/root`
Backups all the root path where ssh keys or different scripts are stored
## Path `/var/spool/cron/crontabs`
Backups all the cronjobs set for different stuff

# **!!! Warning !!!**
Always document your initial setup so that it is easier to back up and restore data. Also do a test restore to see if it works.
