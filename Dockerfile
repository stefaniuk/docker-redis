FROM stefaniuk/ubuntu:14.04.20160819
MAINTAINER daniel.stefaniuk@gmail.com

ENV REDIS_USER="redis" \
    REDIS_DATA_DIR=/var/lib/redis \
    REDIS_LOG_DIR=/var/log/redis

RUN apt-get --yes update \
    && apt-get --yes install \
        redis-server \
    && sed 's/^daemonize yes/daemonize no/' -i /etc/redis/redis.conf \
    && sed 's/^bind 127.0.0.1/bind 0.0.0.0/' -i /etc/redis/redis.conf \
    && sed 's/^# unixsocket /unixsocket /' -i /etc/redis/redis.conf \
    && sed 's/^# unixsocketperm 755/unixsocketperm 777/' -i /etc/redis/redis.conf \
    && sed '/^logfile/d' -i /etc/redis/redis.conf \
    && rm -rf /tmp /var/tmp /var/lib/apt/lists/*

VOLUME [ "${REDIS_DATA_DIR}" ]
EXPOSE 6379
COPY assets/sbin/entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
