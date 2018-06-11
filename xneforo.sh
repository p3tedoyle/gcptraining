#!/bin/bash
yum update -y
yum install httpd wget perl perl-Net-SSLeay openssl perl-IO-Tty perl-Encode-Detect -y
systemctl enable httpd
service httpd start
wget https://prdownloads.sourceforge.net/webadmin/webmin-1.881-1.noarch.rpm
rpm -U webmin-1.881-1.noarch.rpm
/usr/libexec/webmin/changepass.pl /etc/webmin root password123
systemctl enable webmin
service webmin start
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm yum-utils -y
yum-config-manager --enable remi-php72   [Install PHP 7.2]
yum install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo -y
yum install gcc php-devel php-pear -y
yum install ImageMagick ImageMagick-devel -y
pecl install imagick
echo "extension=imagick.so" > /etc/php.d/imagick.ini
service httpd reload
yum -y install memcached
systemctl enable memcached
systemctl start memcached
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux && cat /etc/sysconfig/selinux

yum install mariadb mariadb-server -y
systemctl enable mariadb
systemctl start mariadb
mysql_secure_installation


yum install postfix cyrus-sasl-plain cyrus-sasl-md5 -y
echo relayhost = [smtp.sendgrid.net]:2525 >> /etc/postfix/main.cf
echo smtp_tls_security_level = encrypt >> /etc/postfix/main.cf
echo smtp_sasl_auth_enable = yes >> /etc/postfix/main.cf
echo smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd >> /etc/postfix/main.cf
echo header_size_limit = 4096000 >> /etc/postfix/main.cf
echo smtp_sasl_security_options = noanonymous >> /etc/postfix/main.cf
echo [smtp.sendgrid.net]:2525 chimaera450:Dejavu4u01 >> /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
rm -f /etc/postfix/sasl_passwd
postfix reload
