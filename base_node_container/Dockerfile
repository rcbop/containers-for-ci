########################################################################################################################################
# Dockerfile to build base_node_container
# loosely inspired by elgalu/selenium
#######################################################################################################################################
FROM ubuntu:xenial
MAINTAINER Rogério Peixoto <rcbpeixoto@gmail.com>

ENV UBUNTU_FLAVOR xenial
ENV NODE_VERSION 6.2.1

#== Ubuntu flavors - common
RUN  echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR} main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR}-updates main universe\n" >> /etc/apt/sources.list

#==============================
# Locale and encoding settings
#==============================
ENV LANG_WHICH en
ENV LANG_WHERE US
ENV ENCODING UTF-8
ENV LANGUAGE ${LANG_WHICH}_${LANG_WHERE}.${ENCODING}
ENV LANG ${LANGUAGE}
RUN locale-gen ${LANGUAGE} \
  && dpkg-reconfigure --frontend noninteractive locales \
  && apt-get update -qqy \
  && apt-get -qqy install \
  && rm -rf /var/lib/apt/lists/*

#========================
# Utilities packages
#========================
# net-tools - arp, hostname, ifconfig, netstat, route, plipconfig, iptunnel
# iputils-ping - ping, ping6 - send ICMP ECHO_REQUEST to network hosts
# apt-utils - commandline utilities related to package management with APT
# wget - The non-interactive network downloader
# curl - transfer a URL
# grc is a terminal colorizer that works nice with tail https://github.com/garabik/grc
# tree - console utility for showing file system directories
# grc - colored console output
# zip - compressing files CLI utility
# unzip - uncompressing files CLI utility
# git - git distributed version control system
# nano - CLI lightweight text editor
# moreutils -  collection of the unix tools
RUN  apt-get update -qqy \
  && apt-get -qy install \
  net-tools \
  iputils-ping \
  apt-utils \
  wget \
  curl \
  pwgen \
  grc \
  tree \
  zip \
  unzip \
  git-core \
  nano \
  moreutils \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

#======================
# OpenSSH server (sshd)
#======================
# http://linux.die.net/man/5/sshd_config
# http://www.openbsd.org/cgi-bin/man.cgi/OpenBSD-current/man5/sshd_config.5
RUN apt-get update -qqy \
  && apt-get -qqy install \
    openssh-server \
  && echo "PidFile ${RUN_DIR}/sshd.pid" >> /etc/ssh/sshd_config \
  && sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd \
  && mkdir -p /var/run/sshd \
  && adduser --quiet jenkins \
  && echo "jenkins:jenkins" | chpasswd \
  && chown -R jenkins:jenkins /home/jenkins \
  && rm -rf /var/lib/apt/lists/*

EXPOSE 22

#===================
# Timezone settings
#===================
# Full list at https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
# e.g. "US/Pacific" for Los Angeles, California, USA
# e.g. ENV TZ "US/Pacific"
ENV TZ "America/Recife"
# Apply TimeZone
RUN echo "Setting time zone to '${TZ}'" \
  && echo ${TZ} > /etc/timezone \
  && dpkg-reconfigure --frontend noninteractive tzdata

#==============================
# Java8 - OpenJDK JRE headless
# Minimal runtime used for executing non GUI Java programs
#==============================
RUN apt-get update -qqy \
  && apt-get -qqy install \
    openjdk-8-jdk-headless \
  && sed -i 's/securerandom.source=file:\/dev\/urandom/securerandom.source=file:\/dev\/.\/urandom/g' \
       /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security \
  && sed -i 's/securerandom.source=file:\/dev\/random/securerandom.source=file:\/dev\/.\/urandom/g' \
       /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/java.security \
  && rm -rf /var/lib/apt/lists/*

#========================================
# Python 2.7 for npm modules install
#========================================
RUN apt-get update -qqy \
  && apt-get -qqy install \
    python2.7 \
    python-pip \
  && alias python=/usr/local/bin/python2.7 \
  && rm -rf /var/lib/apt/lists/*

ENV PYTHONPATH=/usr/bin/python2.7
ENV PYTHON=/usr/bin/python2.7

# gpg keys listed at https://github.com/nodejs/node
RUN set -ex \
  && for key in \
    9554F04D7259F04124DE6B476D5A82AC7E37093B \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    0034A06D9D9B0064CE8ADF6BF1747F4AD2306D93 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
  ; do \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
  && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && npm install -g npm
