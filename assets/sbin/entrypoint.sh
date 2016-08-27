#!/bin/bash
set -e

if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
    set -- redis-server "$@"
fi

if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
    chown -R $REDIS_USER .
    exec gosu $REDIS_USER "$0" "$@"
fi

exec "$@"
