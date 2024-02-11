# DEBIAN DOCKERFILE BASED ON DEBIAN TESTING DISTRIBUTION
# TO RUN SHELL IN IMAGE ENTER `docker run --entrypoint /bin/bash -it <image>`

FROM amd64/debian:testing as release

COPY debian-base/tools/* /usr/local/bin/

COPY debian-base/config/sources.list /etc/apt/sources.list

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Etc/UTC
ENV VERSION=2

# BASE SYSTEM SETUP
RUN apt-get update &&  \
    apt-get install -y aptitude

RUN aptitude update && \
    aptitude upgrade -y && \
    aptitude install -y --without-recommends \
          apt-transport-https openssl ca-certificates locales tzdata && \
    locale-gen en_US.UTF-8 ru_RU.UTF-8 && \
    dpkg-reconfigure tzdata && \
    rm -fr /var/lib/apt/lists/* && \
    mkdir -p /usr/local/share/ca-certificates && \
    aptitude clean

RUN update-ca-certificates
ENV SSL_CERT_DIR="/etc/ssl/certs"

# INSTALL UTILS
RUN apt-install wget curl vim procps

COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
