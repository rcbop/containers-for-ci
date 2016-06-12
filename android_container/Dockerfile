#######################################################################
# Dockerfile to build an Android slave image
# Based on Ubuntu
# Usage:
# docker build -t android .
# docker run -d --name=android --restart=unless-stopped android_slave
#######################################################################
FROM ubuntu:xenial
ENV UBUNTU_FLAVOR xenial
MAINTAINER Rogério Peixoto <rcbpeixoto@gmail.com>

#== Ubuntu flavors - common
RUN  echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR} main universe\n" > /etc/apt/sources.list \
  && echo "deb http://archive.ubuntu.com/ubuntu ${UBUNTU_FLAVOR}-updates main universe\n" >> /etc/apt/sources.list

USER root
RUN useradd -u 1000 -m -s /bin/bash jenkins
# Set password for the jenkins user >> CHANGE THAT <<.
RUN echo "jenkins:jenkins" | chpasswd

# Install utils and libs
RUN dpkg --add-architecture i386 \
   && apt-get -qqy update \
   && apt-get install -qqy --no-install-recommends libncurses5:i386 libstdc++6:i386 zlib1g:i386 \
   && apt-get install -qqy \
     expect \
     curl \
     git-core \
     nano \
     openjdk-8-jdk-headless \
     openssh-server \
   && apt-get -qqy upgrade \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download Android SDK
RUN cd /opt && curl -O http://dl.google.com/android/android-sdk_r24.3.4-linux.tgz \
  && tar xzf android-sdk_r24.3.4-linux.tgz \
  && rm -f android-sdk_r24.3.4-linux.tgz

USER jenkins

ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

USER root

# HACK avoid android hanging due to java's swt system arch check
# set ANDROID_SWT env variable to avoid that problem, or copy modified android
# binary to android-sdk dir
# RUN echo ${ANDROID_SWT}
COPY android ${ANDROID_HOME}/tools
RUN chown 284663:5000 ${ANDROID_HOME}/tools/android \
  && chmod 755 ${ANDROID_HOME}/tools/android

# Install Android platform tools and SDK
RUN echo "y" | android update sdk --filter tools --no-ui --force -a \
  && echo "y" | android update sdk --filter platform-tools --no-ui --force -a \
# && echo "y" | android update sdk --filter build-tools-21.1.2 --no-ui --force -a \
  && echo "y" | android update sdk --filter build-tools-23.0.3 --no-ui --force -a \
# && echo "y" | android update sdk --filter android-21 --no-ui --force -a \
  && echo "y" | android update sdk --filter android-23 --no-ui --force -a \
# && echo "y" | android update sdk --filter sys-img-armeabi-v7a-android-22 --no-ui --force -a \
  && echo "y" | android update sdk --filter extra-android-m2repository --no-ui --force -a \
  && echo "y" | android update sdk --filter extra-google-m2repository --no-ui --force -a \
  && echo "y" | android update sdk --filter extra-android-support --no-ui --force -a \
  && echo "y" | android update sdk --filter extra-google-google_play_services --no-ui --force -a

RUN chmod -vR 775 ${ANDROID_HOME} \
  && chown -vR jenkins:jenkins ${ANDROID_HOME} \
  && ls -la ${ANDROID_HOME} \
  && sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd \
  && mkdir -p /var/run/sshd

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
#END
