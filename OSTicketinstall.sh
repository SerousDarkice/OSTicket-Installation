#!/bin/bash

#Installing everything for OSTicket from a fresh, minimal install of Fedora 27

#Credits
#Remi for making older PHP available:  https://rpms.remirepo.net/
#Scott Alan Miller for knowing what packages to install:  https://mangolassi.it/topic/11624/installing-osticket-1-10-on-centos-7

# Let's set some variables

remiFedora25RepoURL=http://rpms.remirepo.net/fedora/remi-release-25.rpm
remiPGPKey=https://rpms.remirepo.net/RPM-GPG-KEY-remi
remiPGPKey2017=https://rpms.remirepo.net/RPM-GPG-KEY-remi2017
remiPGPKey2018=https://rpms.remirepo.net/RPM-GPG-KEY-remi2018
installPackages="mariadb mariadb-server httpd php70 php70-php-mysql php70-php-imap php70-php-xml php70-php-mbstring php70-php-pecl-apcu php70-php-pecl-zendopcache php70-php-intl php70-php-gd"
serverFQDN=osticket.lab.ejs.llc
OSTicketDownloadURL=http://osticket.com/sites/default/files/download/osTicket-v1.10.4.zip
OSTicketZipFile=osTicket-v1.10.4.zip
apacheOSTicketDir=/var/www/html/

echo "Settting the hostname"

hostnamectl set-hostname $serverFQDN

echo "Installing Remi's Repo for php 7.0"

dnf install $remiFedora25RepoURL -y
dnf config-manager --set-enabled remi

echo "Importing Remi's PGP Keys"

rpm --import $remiPGPKey
rpm --import $remiPGPKey2017
rpm --import $remiPGPKey2018

echo "Installing Packages -- Thanks SAM for the list!"

dnf install $installPackages -y

echo "All done installing dependencies"

echo "Starting and enabling Apache"

systemctl start httpd
systemctl enable httpd

echo "Opening port 80 on the public firewall"

firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload

echo "Starting and enabling MariaDB"

systemctl start mariadb
systemctl enable mariadb

echo "Downloading OSTicket"

wget $OSTicketDownloadURL

echo "Installing to $apacheOSTicketDir"

unzip $OSTicketZipFile
cp -rpv upload/* $apacheOSTicketDir
chown -R apache:apache $apacheOSTicketDir
cp $apacheOSTicketDir/include/ost-sampleconfig.php $apacheOSTicketDir/include/ost-config.php
chmod 0666 $apacheOSTicketDir/include/ost-config.php