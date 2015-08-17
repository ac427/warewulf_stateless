#!/bin/bash
mkdir -p /var/www/wwload.com/public_html
chmod -R 755 /var/www
cp index.html /var/www/wwload.com/public_html/
cp data.tsv /var/www/wwload.com/public_html/
mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled

cat >> /etc/httpd/conf/httpd.conf <<'EOF'
IncludeOptional sites-enabled/*.conf
EOF

cat > /etc/httpd/sites-available/wwload.com.conf << 'EOF'
<VirtualHost *:80>

    ServerName www.wwload.com
    ServerAlias wwload.com
    DocumentRoot /var/www/wwload.com/public_html
    ErrorLog /var/www/wwload.com/error.log
    CustomLog /var/www/wwload.com/requests.log combined
</VirtualHost>
EOF

ln -s /etc/httpd/sites-available/wwload.com.conf /etc/httpd/sites-enabled/wwload.com.conf

echo "172.16.2.250 wwload.com" >> /etc/hosts

