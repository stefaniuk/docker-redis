[![Circle CI](https://circleci.com/gh/stefaniuk/docker-redis.svg?style=shield "CircleCI")](https://circleci.com/gh/stefaniuk/docker-redis)&nbsp;[![Size](https://images.microbadger.com/badges/image/stefaniuk/redis.svg)](http://microbadger.com/images/stefaniuk/redis)&nbsp;[![Version](https://images.microbadger.com/badges/version/stefaniuk/redis.svg)](http://microbadger.com/images/stefaniuk/redis)&nbsp;[![Commit](https://images.microbadger.com/badges/commit/stefaniuk/redis.svg)](http://microbadger.com/images/stefaniuk/redis)&nbsp;[![Docker Hub](https://img.shields.io/docker/pulls/stefaniuk/redis.svg)](https://hub.docker.com/r/stefaniuk/redis/)

Docker Redis
============

[Redis](http://redis.io/) is an open source, in-memory data structure store used as database, cache and message broker.

Installation
------------

Builds of the image are available on [Docker Hub](https://hub.docker.com/r/stefaniuk/redis/).

    docker pull stefaniuk/redis:latest

Alternatively you can build the image yourself.

    docker build --tag stefaniuk/redis \
        github.com/stefaniuk/docker-redis

Quickstart
----------

Start container using:

    docker run --detach --restart always \
        --name redis \
        --hostname redis \
        --publish 6379:6379 \
        stefaniuk/redis

Todo
----

- Authentication
