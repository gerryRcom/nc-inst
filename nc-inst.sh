#!/bin/bash
# to use run sudo nc-inst.sh and enter required values.
# run from a su shell to avoid issues with the mysql commands (depends on server config)
read -p "Enter url to current NextCloud zip: " dload
read -p "Enter required password for mysql user: " mysql_pwd
apt update
apt upgrade -y
apt install apache2 mariadb-server -y
apt install libapache2-mod-php -y
apt install php7.4-bz2 php7.4-curl php7.4-gd php7.4-intl php7.4-json php7.4-mbstring php7.4-mysql php7.4-xml php7.4-zip php-mime-type php-imagick -y
#mysql_secure_installation
echo 'Alias /nextcloud "/var/www/nextcloud/"' > /etc/apache2/sites-available/nextcloud.conf
echo '' >> /etc/apache2/sites-available/nextcloud.conf
echo '<Directory /var/www/nextcloud/>' >> /etc/apache2/sites-available/nextcloud.conf
echo 'Require all granted' >> /etc/apache2/sites-available/nextcloud.conf
echo '  AllowOverride All' >> /etc/apache2/sites-available/nextcloud.conf
echo '  Options FollowSymLinks MultiViews' >> /etc/apache2/sites-available/nextcloud.conf
echo '' >> /etc/apache2/sites-available/nextcloud.conf
echo '  <IfModule mod_dav.c>' >> /etc/apache2/sites-available/nextcloud.conf
echo '    Dav off' >> /etc/apache2/sites-available/nextcloud.conf
echo '  </IfModule>' >> /etc/apache2/sites-available/nextcloud.conf
echo '' >> /etc/apache2/sites-available/nextcloud.conf
echo '</Directory>' >> /etc/apache2/sites-available/nextcloud.conf
a2ensite nextcloud.conf
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime
a2enmod ssl
a2ensite default-ssl
service apache2 restart
apt install unzip
wget $dload -O ncsetup.zip
unzip ./ncsetup.zip
mkdir /srv/nc_data
mv ./nextcloud/* /var/www/nextcloud
chown -R www-data:www-data /var/www/nextcloud/
chown -R www-data:www-data /srv/nc_data/
mysql -u root -p -e "CREATE DATABASE nc_db;"
mysql -u root -p -e "CREATE USER 'nc_user'@'localhost' IDENTIFIED BY '$mysql_pwd'; GRANT ALL PRIVILEGES ON nc_db.* TO 'nc_user'@'localhost'; FLUSH PRIVILEGES;"
read -p "Press enter to continue"
clear
echo 'Installation should now be complete'
echo 'Please go to https://serveripaddress/nextcloud'
echo 'On the setup page enter the details below'
echo ''
echo 'Data folder: /srv/nc_data/'
echo 'DB User: nc_user'
echo 'DB Name: nc_db'
echo ''
echo 'Thank you!'
echo ''
read -p "Press enter to continue"
clear
