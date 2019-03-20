#!/bin/bash
# Install certificate and reload NginX
DOMAIN=$1

[[ -z $DOMAIN ]] && echo 'No domain specified!' && exit 2

[[ -f /etc/nginx/ssl/${DOMAIN}/${DOMAIN}.key ]] && cmp /root/certificates/${DOMAIN}/${DOMAIN}.key /etc/nginx/ssl/${DOMAIN}/${DOMAIN}.key && {
  exit 0
}

mkdir -p /etc/nginx/ssl/${DOMAIN}/
cp -r /root/certificates/${DOMAIN}/* /etc/nginx/ssl/${DOMAIN}

cat /etc/nginx/ssl/${DOMAIN}/${DOMAIN}.cer /etc/nginx/ssl/${DOMAIN}/ca.cer > /etc/nginx/ssl/${DOMAIN}/fullchain.cer
sed -i '/^$/d' /etc/nginx/ssl/${DOMAIN}/fullchain.cer

service nginx reload
exit 1
