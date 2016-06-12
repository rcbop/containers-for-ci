########################################################################################################################################
# Dockerfile to build jenkins
# Based on jenkinsci/jenkins2.8
#######################################################################################################################################
FROM jenkinsci/jenkins:2.8
MAINTAINER Rogério Peixoto <rcbpeixoto@gmail.com>

USER root
#== Ubuntu flavors - common
RUN  echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR} main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR}-updates main universe\n" >> /etc/apt/sources.list

RUN apt-get update -qqy \
    && apt-get install -y \
      locales \
      nano \
      make \
      openssh-client \
    && locale-gen en_US.UTF-8 \
    && echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "LANG=en_US.UTF-8" >> /etc/environment \
    && echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale \
    && echo "LANG=en_US.UTF-8" >> /etc/default/locale

# =====================================
# Install docker-compose
# =====================================
RUN curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# add jenkins to sudoers without password for Docker-out-of-Docker to work
# TODO: bad for sec, improve this
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

USER jenkins

ENV JAVA_OPTS="-Dfile.encoding=UTF8"

# =====================================
# Install SSL certificates
# =====================================
# COPY CERT-https.pem /var/lib/jenkins/cert
# COPY CERT-https.key /var/lib/jenkins/pk
# ENV JENKINS_OPTS --httpPort=-1 --httpsPort=7083 --httpsCertificate=/var/lib/jenkins/cert --httpsPrivateKey=/var/lib/jenkins/pk
# EXPOSE 7083

COPY plugins.txt /usr/share/jenkins/plugins.txt
COPY executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
## END
