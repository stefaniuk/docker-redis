FROM stefaniuk/ubuntu:14.04.5-20160828
MAINTAINER daniel.stefaniuk@gmail.com

ENV REDIS_VERSION="3.2.3" \
    REDIS_DOWNLOAD_URL="http://download.redis.io/releases/redis-3.2.3.tar.gz" \
    REDIS_DOWNLOAD_SHA1="92d6d93ef2efc91e595c8bf578bf72baff397507" \
    REDIS_USER="redis" \
    REDIS_DATA_DIR=/var/lib/redis

RUN set -ex \
    \
    &&apt-get --yes update \
    && apt-get --yes install \
        gcc \
        libc6-dev \
        make \
    && wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL" \
    && echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c - \
    && mkdir -p /usr/src/redis \
    && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
    && rm redis.tar.gz \
    && grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 1$' /usr/src/redis/src/server.h \
    && sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' /usr/src/redis/src/server.h \
    && grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 0$' /usr/src/redis/src/server.h \
    && make -C /usr/src/redis \
    && make -C /usr/src/redis install \
    && mkdir /etc/redis \
    && cp /usr/src/redis/redis.conf /etc/redis/redis.conf \
    && rm -r /usr/src/redis \
    && apt-get purge --yes --auto-remove \
        gcc \
        libc6-dev \
        make \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* \
    \
    && groupadd --system $REDIS_USER \
    && useradd --system --gid $REDIS_USER $REDIS_USER \
    && mkdir $REDIS_DATA_DIR \
    && chown $REDIS_USER:$REDIS_USER $REDIS_DATA_DIR \
    \
    && sed 's/^# unixsocket \/tmp\/redis.sock/unixsocket \/run\/redis\/redis.sock/' -i /etc/redis/redis.conf \
    && sed 's/^# unixsocketperm 755/unixsocketperm 777/' -i /etc/redis/redis.conf

WORKDIR $REDIS_DATA_DIR
VOLUME [ "$REDIS_DATA_DIR" ]
EXPOSE 6379

COPY assets/sbin/entrypoint.sh /sbin/entrypoint.sh
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD [ "redis-server", "/etc/redis/redis.conf" ]
