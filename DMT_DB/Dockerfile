# Install Ubuntu 22.04
FROM ubuntu:22.04

# Setting Time
ENV DEBIAN_FRONTEND=noninteractive

# Install Package
RUN sudo apt update
RUN sudo apt -y software-properties-common dirmngr ca-certificates apt-transport-https
#RUN sudo apt install mariadb-server mariadb-client

# Create User & Group
#RUN adduser maria
#RUN echo "maria:maria123" | chpasswd

# Create Directory
#RUN mkdir -p /var/log/mariadb /var/run/mariadb /etc/mariadb /mariadb/download /mariadb/data/ibdata /mariadb/data/iblog /mariadb/data/binlog
#RUN mkdir -p /mariadb/data/binlog/DMT_DB

# Install MariaDB 10.6.4
#WORKDIR /mariadb/download
#RUN wget https://downloads.mariadb.org/f/mariadb-10.6.4/bintar-linux-systemd-x86_64/mariadb-10.6.4-linux-systemd-x86_64.tar.gz
#RUN tar -xvf mariadb-10.6.4-linux-systemd-x86_64.tar.gz -C /mariadb/download

# Chack The Mariadb
#RUN mariadb --version
#RUN systemctl status mariadb
