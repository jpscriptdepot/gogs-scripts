#!/bin/sh

# Installing GO

cd /
wget -c https://go.dev/dl/go1.17.6.linux-armv6l.tar.gz
tar -vzxf go1.17.6.linux-armv6l.tar.gz
mv go /usr/local/
echo "PATH=$PATH:/usr/local/go/bin" >> /root/.bashrc

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

mysql -u root -e "CREATE DATABASE $dbname;"
mysql -u root -e "CREATE USER '$user'@'localhost' IDENTIFIED BY '$password';"
mysql -u root -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$user'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Building GOGS

cd /
git clone --depth 1 https://github.com/gogs/gogs.git gogs
cd gogs/
/usr/local/go/bin/go build -o gogs

cd /
mv gogs /home/gogs/
echo "PATH=$PATH:/home/gogs/gogs" >> /home/gogs/.bashrc

echo "All tasks are complete!"
