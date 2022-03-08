FROM ubuntu:xenial AS builder

RUN apt-get update -y && apt-get install --no-install-recommends  -y \
    bzip2 \
    build-essential \
    gcc-multilib \
    libncurses5-dev \
    libnss-sss \
    tzdata \
    unzip \
    wget \
    zlib1g-dev \
    python3-pip \
    python3-setuptools \
    python3-setuptools-scm

#################
# CUTADAPT      #
#################
RUN pip3 install --user --upgrade cutadapt

################
#### SAMBAMBA ##
################

RUN mkdir /opt/sambamba/ \
    && wget --no-check-certificate https://github.com/lomereiter/sambamba/releases/download/v0.6.4/sambamba_v0.6.4_linux.tar.bz2 \
    && tar --extract --bzip2 --directory=/opt/sambamba --file=sambamba_v0.6.4_linux.tar.bz2 \
    && ln -s /opt/sambamba/sambamba_v0.6.4 /usr/local/bin/sambamba

############
#BWA 0.7.15#
############

ENV BWA_VERSION 0.7.15

RUN cd /tmp/ \
    && wget --no-check-certificate -q http://downloads.sourceforge.net/project/bio-bwa/bwa-${BWA_VERSION}.tar.bz2 && tar xvf bwa-${BWA_VERSION}.tar.bz2 \
    && cd /tmp/bwa-${BWA_VERSION} \
    && sed -i 's/CFLAGS=\\t\\t-g -Wall -Wno-unused-function -O2/CFLAGS=-g -Wall -Wno-unused-function -O2 -static/' Makefile \
    && make \
    && cp /tmp/bwa-${BWA_VERSION}/bwa /usr/local/bin \
    && rm -rf /tmp/bwa-${BWA_VERSION}

FROM ubuntu:xenial

COPY --from=builder /usr/local/bin/bwa /usr/local/bin/
COPY --from=builder /usr/local/bin/sambamba /usr/local/bin/
