FROM ubuntu:hirsute

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

RUN python3 -m pip install --user --upgrade cutadapt
RUN python3 -m pip install --user --upgrade bwa
