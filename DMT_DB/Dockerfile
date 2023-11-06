# Install Ubuntu 22.04
FROM ubuntu:22.04

# Setting Time
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul
RUN apt-get install -y tzdata

# Install Package
RUN apt-get update
RUN apt-get install net-tools vim -y

# Create User & Group
RUN adduser maria
RUN echo "maria:maria123" | chpasswd

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

CMD [ "/usr/sbin/init" ]