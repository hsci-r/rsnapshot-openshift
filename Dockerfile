FROM jefferyb/openshift-alpine

MAINTAINER Eetu Mäkelä <eetu.makela@helsinki.fi>

VOLUME /backup
VOLUME /data

ENV BACKUP_NAME=default
ENV BACKUP_SOURCE=/data
ENV BACKUP_OPTS=one_fs=1
ENV BACKUP_RETAIN=3
ENV BACKUP_ROTATION=daily
ENV BACKUP_SYNC=true

USER root

RUN touch /ssh-id && touch /backup.cfg

RUN apk add --update rsnapshot tzdata

USER 10001

ADD entry.sh /entry.sh

CMD ["/bin/sh", "/entry.sh"]
