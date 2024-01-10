# Install Ubuntu 22.04
FROM ubuntu:22.04

# Install Package
RUN apt-get update
RUN apt-get install net-tools vim -y cron

# Create User & Group
RUN adduser maria
RUN echo "maria:maria123" | chpasswd

# Install MariaDB 10.6.4
RUN mkdir -p /mariadb/download
WORKDIR /mariadb/download
RUN wget https://downloads.mariadb.org/f/mariadb-10.11.6/bintar-linux-systemd-x86_64/mariadb-10.11.6-linux-systemd-x86_64.tar.gz
#RUN tar -xvf mariadb-10.11.6-linux-systemd-x86_64.tar.gz -C /mariadb/download

# Chack The Mariadb
#RUN mariadb --version

CMD cron && /bin/bash