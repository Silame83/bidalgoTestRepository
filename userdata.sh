#! /bin/bash
sudo apt-get -y update
sudo apt-get install -y python3-pip
sudo apt-get purge mysql*
sudo apt-get autoremove
sudo apt-get autoclean
sudo apt-get dist-upgrade
sudo apt-get install -y mysql-server
sudo pip3 install -y pymysql
sudo apt-get install -y apache2
sudo a2dismod mpm_event
sudo a2enmod mpm_prefork cgi

cat << EOF > /etc/apache2/sites-enabled/000-default.conf
<VirtualHost *:80>
   <Directory /var/www/>
       Options +ExecCGI
       DirectoryIndex index.py
   </Directory>
   AddHandler cgi-script .py
  # The ServerName directive sets the request scheme, hostname and port that
  # the server uses to identify itself. This is used when creating
  # redirection URLs. In the context of virtual hosts, the ServerName
  # specifies what hostname must appear in the request's Host: header to
  # match this virtual host. For the default virtual host (this file) this
  # value is not decisive as it is used as a last resort host regardless.
  # However, you must set it for any further virtual host explicitly.
  #ServerName www.example.com

  ServerAdmin webmaster@localhost
  DocumentRoot /var/www/html

  # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
  # error, crit, alert, emerg.
  # It is also possible to configure the loglevel for particular
  # modules, e.g.
  #LogLevel info ssl:warn

  ErrorLog ${APACHE_LOG_DIR}/error.log
  CustomLog ${APACHE_LOG_DIR}/access.log combined

  # For most configuration files from conf-available/, which are
  # enabled or disabled at a global level, it is possible to
  # include a line for only one particular virtual host. For example the
  # following line enables the CGI configuration for this host only
  # after it has been globally disabled with "a2disconf".
  #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
EOF

sudo systemctl restart apache2

#sudo mysql
#CREATE USER 'ubuntu'@'localhost' IDENTIFIED BY 'Silame83@gmail.com';
#GRANT FILE ON *.* TO 'ubuntu'@'localhost';
#FLUSH PRIVILEGES;