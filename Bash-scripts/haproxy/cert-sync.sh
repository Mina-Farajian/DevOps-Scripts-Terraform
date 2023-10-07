#!/bin/bash

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# certhash= hash of directory of letsencrypt or the modification date of last cert
cat /opt/scripts/rcert-kardix-customer/companies.lst | awk '{print $1}'| while read -r companyaddr
do
       echo "renewing cert for $companyaddr"
       certbot certonly --standalone -d $companyaddr --non-interactive --agree-tos --register-unsafely-without-email --http-01-port=54321 && \
       cat /etc/letsencrypt/live/$companyaddr/fullchain.pem /etc/letsencrypt/live/$companyaddr/privkey.pem > /etc/haproxy/ssl/customer-kardix/$companyaddr.pem
done

haproxy -c -f /etc/haproxy/haproxy.cfg && systemctl reload haproxy.service
