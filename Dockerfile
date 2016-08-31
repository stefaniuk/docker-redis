FROM stefaniuk/ubuntu:16.04-20160831
MAINTAINER daniel.stefaniuk@gmail.com
# SEE: https://github.com/docker-library/redis/blob/master/3.2/Dockerfile

ARG APT_PROXY
ENV REDIS_VERSION="3.2.3" \
    REDIS_DOWNLOAD_URL="http://download.redis.io/releases/redis-3.2.3.tar.gz" \
    REDIS_DOWNLOAD_SHA1="92d6d93ef2efc91e595c8bf578bf72baff397507" \
    REDIS_DATA_DIR=/var/lib/redis

RUN set -ex \
    \
    && buildDeps=' \
        gcc \
        libc6-dev \
        make \
    ' \
    && if [ -n "$APT_PROXY" ]; then echo "Acquire::http { Proxy \"$APT_PROXY\"; };" >> /etc/apt/apt.conf.d/00proxy; fi \
    && apt-get --yes update \
    && apt-get --yes install $buildDeps \
    \
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
    && sed 's/^# unixsocket \/tmp\/redis.sock/unixsocket \/run\/redis\/redis.sock/' -i /etc/redis/redis.conf \
    && sed 's/^# unixsocketperm 755/unixsocketperm 777/' -i /etc/redis/redis.conf \
    \
    && apt-get purge --yes --auto-remove $buildDeps \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/cache/apt/* \
    && rm -f /etc/apt/apt.conf.d/00proxy

WORKDIR /var/lib/redis
VOLUME [ "/var/lib/redis" ]
EXPOSE 6379

CMD [ "redis-server", "/etc/redis/redis.conf" ]
