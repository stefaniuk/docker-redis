#!/bin/bash

mkdir -p /run/redis
chown -R $SYSTEM_USER:$SYSTEM_USER /run/redis

mkdir -p /var/lib/redis
chown -R $SYSTEM_USER:$SYSTEM_USER /var/lib/redis

chown $SYSTEM_USER:$SYSTEM_USER /etc/redis/*
