#! /bin/sh

# Entry point for rsnapshot backup
# This will create the config file (using environment variables),

# First part of rsnapshot config
cat > /backup/${BACKUP_NAME}-rsnapshot.conf <<EOF
config_version	1.2
snapshot_root	/backup/${BACKUP_NAME}/
no_create_root	0
cmd_cp		/bin/cp
cmd_rm		/bin/rm
cmd_rsync	/usr/bin/rsync
cmd_ssh		/usr/bin/ssh
cmd_du		/usr/bin/du
cmd_logger	/usr/bin/logger
cmd_rsnapshot_diff	/usr/bin/rsnapshot-diff
link_dest	1
sync_first	1
ssh_args	-i /ssh-id -o StrictHostKeychecking=no ${BACKUP_SSH_ARGS}
verbose		3
lockfile	/backup/${BACKUP_NAME}-rsnapshot.pid
backup		${BACKUP_SOURCE}	.	${BACKUP_OPTS}
EOF

# Dynamic parts - depending on the retain settings
# This will also create the crontab
if [ "${BACKUP_HOURLY}" -gt 0 ]
then
  echo "retain	hourly	${BACKUP_HOURLY}">> /backup/${BACKUP_NAME}-rsnapshot.conf
fi
if [ "${BACKUP_DAILY}" -gt 0 ]
then
  echo "retain	daily	${BACKUP_DAILY}">> /backup/${BACKUP_NAME}-rsnapshot.conf
fi
if [ "${BACKUP_WEEKLY}" -gt 0 ]
then
  echo "retain	weekly	${BACKUP_WEEKLY}">> /backup/${BACKUP_NAME}-rsnapshot.conf
fi
if [ "${BACKUP_MONTHLY}" -gt 0 ]
then
  echo "retain	monthly	${BACKUP_MONTHLY}">> /backup/${BACKUP_NAME}-rsnapshot.conf
fi
if [ "${BACKUP_YEARLY}" -gt 0 ]
then
  echo "retain	yearly	${BACKUP_YEARLY}">> /backup/${BACKUP_NAME}-rsnapshot.conf
fi

# Add the user-provided config file
cat /backup.cfg >> /backup/${BACKUP_NAME}-rsnapshot.conf

if [ "${BACKUP_ROTATION}" == "hourly" ] || ([ "${BACKUP_HOURLY}" -eq 0 ] && [ "${BACKUP_ROTATION}" == "daily" ]) || ([ "${BACKUP_HOURLY}" -eq 0 ] && [ "${BACKUP_DAILY}" -eq 0 ] && [ "${BACKUP_ROTATION}" == "weekly" ]) || ([ "${BACKUP_HOURLY}" -eq 0 ] && [ "${BACKUP_DAILY}" -eq 0 ] && [ "${BACKUP_WEEKLY}" -eq 0 ] && [ "${BACKUP_ROTATION}" == "monthly" ]) || ([ "${BACKUP_HOURLY}" -eq 0 ] && [ "${BACKUP_DAILY}" -eq 0 ] && [ "${BACKUP_ROTATION}" == "weekly" ]) || ([ "${BACKUP_HOURLY}" -eq 0 ] && [ "${BACKUP_DAILY}" -eq 0 ] && [ "${BACKUP_WEEKLY}" -eq 0 ] && [ "${BACKUP_MONTHLY}" -eq 0 ] && [ "${BACKUP_ROTATION}" == "yearly" ])
then
/usr/bin/rsnapshot -c /backup/${BACKUP_NAME}-rsnapshot.conf sync
fi
if [ "${BACKUP_ROTATION}" != "none" ]
then
/usr/bin/rsnapshot -c /backup/${BACKUP_NAME}-rsnapshot.conf ${BACKUP_ROTATION}
fi
