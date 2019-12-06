#! /bin/sh

# Entry point for rsnapshot backup
# This will create the config file (using environment variables),

# First part of rsnapshot config
cat > /tmp/rsnapshot.conf <<EOF
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
lockfile	/tmp/rsnapshot.pid
backup		${BACKUP_SOURCE}	.	${BACKUP_OPTS}
retain		${BACKUP_ROTATION}	${BACKUP_RETAIN}
EOF

# Add the user-provided config file
cat /backup.cfg >> /tmp/rsnapshot.conf

# start cron - we should be done!
/usr/bin/rsnapshot -c /tmp/rsnapshot.conf sync
/usr/bin/rsnapshot -c /tmp/rsnapshot.conf ${BACKUP_ROTATION}

