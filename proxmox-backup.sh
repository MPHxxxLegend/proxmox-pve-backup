#!/bin/bash
#
# V0.1
# Script for backup important stuff of the proxmoxhost
#
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                                                                   #
#                                                   Proxmoxhost                                                     #
#                                                                                                                   #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#
#####Basic-Variables
#
Proxmox_IP="10.20.20.4"
SSH_USER="root"
SSH_KEY="/pathtoprivatekey/proxmoxhost"
keep_backups=7
current_datetime=$(date +"%Y%m%d-%H%M")
tmp_local="/tmp"

# # # # # # # # # # # # # # # # #
#            Source             #
# # # # # # # # # # # # # # # # #
#
# Folder /etc
etc_src="/etc"
# Folder /root
root_src="/root"
# Folder /var/spool/cron/crontabs
crontabs_src="/var/spool/cron/crontabs"


# # # # # # # # # # # # # # # # #
#            Destination        #
# # # # # # # # # # # # # # # # #
#
# Backup path for /etc
etc_des="/pathfordestination/etc"
# Backup path for /root
root_des="/pathfordestination/root"
# Backup path for /var/spool/cron/crontabs
crontabs_des="/pathfordestination/crontabs"


# # # # # # # # # # # # # # # # #
#            Commands           #
# # # # # # # # # # # # # # # # #
#
##### /etc files backup
# zip it to tar
ssh -i ${SSH_KEY} -p 50022 ${SSH_USER}@${Proxmox_IP} tar -cpf ${tmp_local}/etc-files-directories-${current_datetime}-backup.tar ${etc_src}
# compress archiv /etc
ssh -i ${SSH_KEY} -p 50022 ${SSH_USER}@${Proxmox_IP} gzip ${tmp_local}/etc-files-directories-${current_datetime}-backup.tar
# copy file over to backupserver
scp -i ${SSH_KEY} -P 50022 -r ${SSH_USER}@${Proxmox_IP}:${tmp_local}/etc-files-directories-${current_datetime}-backup.tar.gz ${etc_des}/
# delete file in /tmp directory
ssh -i ${SSH_KEY} -p 50022 ${SSH_USER}@${Proxmox_IP} rm ${tmp_local}/etc-files-directories-*

##### /root files backup
# zip it to tar
ssh -i ${SSH_KEY} -p 50022 ${SSH_USER}@${Proxmox_IP} tar -cpf ${tmp_local}/root-files-directories-${current_datetime}-backup.tar ${root_src}
# compress archiv /root
ssh -i ${SSH_KEY} -p 50022 ${SSH_USER}@${Proxmox_IP} gzip ${tmp_local}/root-files-directories-${current_datetime}-backup.tar
# copy file over to backupserver
scp -i ${SSH_KEY} -P 50022 -r ${SSH_USER}@${Proxmox_IP}:${tmp_local}/root-files-directories-${current_datetime}-backup.tar.gz ${root_des}/
# delete file in /tmp directory
ssh -i ${SSH_KEY} -p 50022 ${SSH_USER}@${Proxmox_IP} rm ${tmp_local}/root-files-directories-*

##### /var/spool/cron/crontabs
# zip it to tar
ssh -i ${SSH_KEY} -p 50022 ${SSH_USER}@${Proxmox_IP} tar -cpf ${tmp_local}/crontabs-files-directories-${current_datetime}-backup.tar ${crontabs_src}
# compress archiv /var/spool/cron/crontabs
ssh -i ${SSH_KEY} -p 50022 ${SSH_USER}@${Proxmox_IP} gzip ${tmp_local}/crontabs-files-directories-${current_datetime}-backup.tar
# copy file over to backupserver
scp -i ${SSH_KEY} -P 50022 -r ${SSH_USER}@${Proxmox_IP}:${tmp_local}/crontabs-files-directories-${current_datetime}-backup.tar.gz ${crontabs_des}/
# delete file in /tmp directory
ssh -i ${SSH_KEY} -p 50022 ${SSH_USER}@${Proxmox_IP} rm ${tmp_local}/crontabs-files-directories-*

##### Delete all older files but keep_backups value for /etc
pushd ${etc_des}; ls -tr ${etc_des}/etc-files-directories-* | head -n -${keep_backups} | xargs rm; popd
##### Delete all older files but keep_backups value for /root
pushd ${root_des}; ls -tr ${root_des}/root-files-directories-* | head -n -${keep_backups} | xargs rm; popd
##### Delete all older files but keep_backups value for /var/spool/cron/crontabs
pushd ${crontabs_des}; ls -tr ${crontabs_des}/crontabs-files-directories-* | head -n -${keep_backups} | xargs rm; popd
