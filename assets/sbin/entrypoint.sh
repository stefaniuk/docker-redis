#!/bin/bash
set -e

mkdir -p /run/redis
chmod -R 755 /run/redis
chown -R $REDIS_USER:$REDIS_USER /run/redis

if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
    chown -R $REDIS_USER .
    exec gosu $REDIS_USER "$0" "$@"
else
    exec "$@"
fi
