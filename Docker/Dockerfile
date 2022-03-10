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

RUN python3 -m pip install --target="/opt" cutadapt

ENV BWA_VERSION 0.7.15

RUN cd /tmp/ \
    && wget --no-check-certificate -q http://downloads.sourceforge.net/project/bio-bwa/bwa-${BWA_VERSION}.tar.bz2 && tar xvf bwa-${BWA_VERSION}.tar.bz2 \
    && cd /tmp/bwa-${BWA_VERSION} \
    && sed -i 's/CFLAGS=\\t\\t-g -Wall -Wno-unused-function -O2/CFLAGS=-g -Wall -Wno-unused-function -O2 -static/' Makefile \
    && make \
    && cp /tmp/bwa-${BWA_VERSION}/bwa /usr/local/bin \
    && rm -rf /tmp/bwa-${BWA_VERSION}

RUN chown -R 1000:1000 /opt/*
USER 1000

COPY --from=builder /usr/local/bin/bwa /usr/local/bin/
