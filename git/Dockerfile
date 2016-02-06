FROM noughmad/dgbs-base

MAINTAINER Miha Cancula <miha@noughmad.eu>

EXPOSE 22
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd

ENV GIT_USER="git" GIT_PASSWORD="insecure"
RUN useradd -m -p $(openssl passwd -1 ${GIT_PASSWORD}) ${GIT_USER}
