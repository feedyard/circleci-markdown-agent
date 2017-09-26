FROM alpine:3.6

MAINTAINER Nic Cheneweth <nic.cheneweth@thoughtworks.com>

RUN apk update && apk upgrade

# packages required for use as a circleci primary container
RUN apk add --no-cache git openssh tar gzip ca-certificates

# general packages to support markdown lint oriented docker images
RUN apk add --no-cache bash bash-doc bash-completion \
    openssl openrc python3 ruby ruby-bundler ruby-dev g++ libffi-dev \
    musl-dev make docker
RUN rc-update add docker boot

RUN python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    rm -r /root/.cache

# infrastructure specific build, deploy, test tools
RUN pip install invoke
RUN echo "gem: --no-document" > /etc/gemrc
RUN gem install inspec:1.35.1 mdl:0.4.0

HEALTHCHECK NONE