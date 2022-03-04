#!/bin/sh

# Creating gogs user

adduser --disabled-password -gecos "" gogs

# Set gogs user MySQL user and password

echo -n "GOGS MySQL User:"
read user
echo "The MySQL user name will be: $user"
echo "The MySQL user name will be: $user" > gogs.db.parser.log

echo -n "GOGS MySQL Password: "
read password

# Set gogs MySQL database

echo -n "GOGS MySQL database name:"
read dbname
echo "The MySQL database name will be: $dbname"
echo "The MySQL database name will be: $dbname" >> gogs.db.parser.log

# Starting MySQL service

service mysql start

# Applying MySQL queries

mysql -u root -e "CREATE DATABASE gogs;"
mysql -u root -e "CREATE USER 'gogs'@'localhost' IDENTIFIED BY 'senhasegura123456';"
mysql -u root -e "GRANT ALL PRIVILEGES ON gogs.* TO 'gogs'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Building GOGS

cd /
wget -c https://go.dev/dl/go1.17.6.linux-armv6l.tar.gz
tar -vzxf go1.17.6.linux-armv6l.tar.gz
mv go /usr/local/
echo "PATH=$PATH:/usr/local/go/bin" >> /root/.bashrc

cd /
git clone --depth 1 https://github.com/gogs/gogs.git gogs
cd gogs/
go build -o gogs

cd /
mv gogs /usr/local/
echo "PATH=$PATH:/usr/local/gogs" >> /root/.bashrc

echo "All tasks are complete!"
