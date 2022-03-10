FROM ubuntu:hirsute

ENV INSTALL_DIR="/opt"

RUN apt-get update; export DEBIAN_FRONTEND=noninteractive; apt-get -y install \
   curl \
   wget \
   rsync \
   adduser \
   mosh \
   strace \
   samtools \
   cutadapt \
   bwa \
   openjdk-11-jre-headless \
   build-essential \
   gcc-multilib \
   libncurses5-dev \
   libnss-sss \
   tzdata \
   zlib1g-dev \
   autoconf \
   netcat-openbsd && \
   export DEBIAN_FRONTEND=noninteractive; apt-get -y install openssh-client python3-setuptools python3-pip openssh-sftp-server openssh-server

RUN chown -R 1000:1000 /opt/*
USER 1000
