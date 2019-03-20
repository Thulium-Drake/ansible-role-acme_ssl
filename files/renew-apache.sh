#!/bin/bash
# Install certificate and reload Apache
DOMAIN=$1

[[ -z $DOMAIN ]] && echo 'No domain specified!' && exit 2

[[ -f /etc/apache2/ssl/${DOMAIN}/${DOMAIN}.key ]] && cmp /root/certificates/${DOMAIN}/${DOMAIN}.key /etc/apache2/ssl/${DOMAIN}/${DOMAIN}.key && {
  exit 0
}

mkdir -p /etc/apache2/ssl/${DOMAIN}/
cp -r /root/certificates/${DOMAIN}/* /etc/apache2/ssl/${DOMAIN}

cat /etc/apache2/ssl/${DOMAIN}/${DOMAIN}.cer /etc/apache2/ssl/${DOMAIN}/ca.cer > /etc/apache2/ssl/${DOMAIN}/fullchain.cer
sed -i '/^$/d' /etc/apache2/ssl/${DOMAIN}/fullchain.cer

service apache2 reload
exit 1
