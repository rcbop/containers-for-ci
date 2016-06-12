#######################################################################
# Dockerfile to build angular container image
# Based on base_node
#######################################################################
FROM base_node:latest

MAINTAINER Rogério Peixoto <rcbpeixoto@gmail.com>

RUN npm install -g bower \
  && npm install -g gulp

EXPOSE 3000

CMD ["/usr/sbin/sshd", "-D"]
