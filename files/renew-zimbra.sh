#!/bin/bash
# Install certificate and reload Zimbra
DOMAIN=$1

[[ -z $DOMAIN ]] && echo 'No domain specified!' && exit 2

[[ -f /opt/zimbra/ssl/zimbra/commercial/commercial.key ]] && cmp /root/certificates/${DOMAIN}/${DOMAIN}.key /opt/zimbra/ssl/zimbra/commercial/commercial.key && {
  exit 0
}

mv /opt/zimbra/ssl/zimbra/commercial/commercial.crt /opt/zimbra/ssl/zimbra/commercial/commercial.crt.old
mv /opt/zimbra/ssl/zimbra/commercial/commercial.key /opt/zimbra/ssl/zimbra/commercial/commercial.key.old
mv /opt/zimbra/ssl/zimbra/commercial/commercial_ca.crt /opt/zimbra/ssl/zimbra/commercial/commercial_ca.crt.old

cp /root/certificates/${DOMAIN}/${DOMAIN}.cer /opt/zimbra/ssl/zimbra/commercial/commercial.crt
cp /root/certificates/${DOMAIN}/${DOMAIN}.key /opt/zimbra/ssl/zimbra/commercial/commercial.key
cat /root/certificates/${DOMAIN}/ca.cer /root/certificates/root.cer > /opt/zimbra/ssl/zimbra/commercial/commercial_ca.crt

/opt/zimbra/bin/zmcertmgr verifycrt comm /opt/zimbra/ssl/zimbra/commercial/commercial.key /opt/zimbra/ssl/zimbra/commercial/commercial.crt || exit 1

/opt/zimbra/bin/zmcertmgr deploycrt comm /opt/zimbra/ssl/zimbra/commercial/commercial.crt /opt/zimbra/ssl/zimbra/commercial/commercial_ca.crt || exit 1

service zimbra restart
exit 1
