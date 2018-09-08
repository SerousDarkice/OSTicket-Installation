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

echo "Installing Remi's Repo for php 7.0"

dnf install $remiFedora25RepoURL -y
dnf config-manager --set-enabled remi

echo "Importing Remi's PGP Keys"

rpm --import $remiPGPKey
rpm --import $remiPGPKey2017
rpm --import $remiPGPKey2018

echo "Installing Packages -- Thanks SAM for the list!"

dnf install $installPackages -y

echo "All done!"