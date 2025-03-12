#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <yournewdomain>"
  exit 1
fi

# Assign the first argument to the variable
export yournewdomain="$1"
echo "[+] The domain has been set to: $yournewdomain"

# Apache Config
mkdir -p /var/www/${yournewdomain} /var/www/${yournewdomain}/html /var/www/${yournewdomain}/logs
cd /etc/apache2/sites-available
cp 000-default.conf 001-${yournewdomain}.conf
sed -i -e "/ServerAdmin */a ServerName ${yournewdomain}" /etc/apache2/sites-available/001-${yournewdomain}.conf
sed -i -e "/DocumentRoot */a ServerAlias www.${yournewdomain}" /etc/apache2/sites-available/001-${yournewdomain}.conf
sed -i -e "s/\/var\/www\/html/\/var\/www\/${yournewdomain}\/html/g" /etc/apache2/sites-available/001-${yournewdomain}.conf
sed -i 's,${APACHE_LOG_DIR},/var/www/'"${yournewdomain}"'/logs,g' /etc/apache2/sites-available/001-${yournewdomain}.conf

# Create backup
cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bk
sed -i "/<Directory \/var\/www\/>/a Options FollowSymLinks\n\tAllowOverride None\n\tRequire all granted\n</Directory>\n\n<Directory \/var\/www\/${yournewdomain}\/html>" /etc/apache2/apache2.conf
# disable Directory listing
sed -i "s/Indexes/-Indexes/g" /etc/apache2/apache2.conf 

# Config site and Restart Apache service
apachectl configtest
a2ensite 001-${yournewdomain}.conf
service apache2 restart

# Activate HTTPS for the new domain.
certbot --agree-tos --register-unsafely-without-email -d ${yournewdomain}

# optional download fake website
wget https://github.com/dc971162/website/raw/refs/heads/main/Atlas.zip -O /tmp/Atlas.zip
unzip /tmp/Atlas.zip -d /tmp/
mv /tmp/Atlas/* /var/www/${yournewdomain}/html/
