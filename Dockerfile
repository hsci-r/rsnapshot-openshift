FROM alpine

MAINTAINER Eetu Mäkelä <eetu.makela@helsinki.fi>

VOLUME /backup
VOLUME /data

ENV BACKUP_SOURCE=/data
ENV BACKUP_OPTS=one_fs=1
ENV BACKUP_RETAIN=3
ENV BACKUP_ROTATION=daily

RUN touch /ssh-id && touch /backup.cfg

RUN apk add --update rsnapshot tzdata

ADD entry.sh /entry.sh

CMD ["/bin/sh", "/entry.sh"]
