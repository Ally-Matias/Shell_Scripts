#!/bin/bash

# instalando tudo
apt-get update
apt-get install -y php mysql-client
apt-get install -y apache2 php-mysql php-curl libapache2-mod-php php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip

systemctl start apache2
systemctl enable apache2

echo -e "[client]\nuser=matias\npassword=senha123" > /root/.my.cnf

cd /home/ubuntu

curl -O https://wordpress.org/latest.tar.gz #> /dev/null

#mudei
#wget -c -P /home/ubuntu https://wordpress.org/latest.tar.gz

echo -e "<?php\ndefine( 'DB_NAME', 'scripts' );\ndefine( 'DB_USER', 'matias' );\ndefine( 'DB_PASSWORD', 'senha123' );\ndefine( 'DB_HOST', '172.31.13.117' );\ndefine( 'DB_CHARSET', 'utf8' );\ndefine( 'DB_COLLATE', '' );\n$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)\n\$table_prefix= 'wp_';\ndefine( 'WP_DEBUG', false );\nif ( ! defined( 'ABSPATH' ) ) {define( 'ABSPATH', __DIR__ . '/' );}\nrequire_once ABSPATH . 'wp-settings.php';" > wp-config.php

tar -xzvf /home/ubuntu/latest.tar.gz #> /dev/null

#mudei, descomentei
touch wordpress/.htaccess

cp -a wordpress/. /var/www/html/wordpress

cp wp-config.php /home/ubuntu/wordpress/

cp -fr /home/ubuntu/wordpress /var/www/html/

chown -R www-data:www-data /var/www/html/wordpress

find /var/www/html/wordpress/ -type d -exec chmod 750 {} \;

find /var/www/html/wordpress/ -type f -exec chmod 640 {} \;

cat<<EOF2 > /etc/apache2/sites-available/wordpress.conf
<Directory /var/www/html/wordpress/>
    AllowOverride All
</Directory>
EOF2

a2enmod rewrite

a2ensite wordpress

systemctl restart apache2


