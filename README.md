[![CircleCI](https://circleci.com/gh/stefaniuk/docker-redis.svg?style=shield "CircleCI")](https://circleci.com/gh/stefaniuk/docker-redis) [![Quay](https://quay.io/repository/stefaniuk/redis/status "Quay")](https://quay.io/repository/stefaniuk/redis)

Docker Redis
============

`Dockerfile` to create a Docker image for [Redis](http://redis.io/).

Installation
------------

Automated builds of the image are available on [Docker Hub](https://hub.docker.com/r/stefaniuk/redis/).

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
        --volume /srv/docker/redis:/var/lib/redis \
        stefaniuk/redis

Log in to Redis using:

    docker exec --interactive --tty redis \
        redis-cli

Todo
----

- Authentication
