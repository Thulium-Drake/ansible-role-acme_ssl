# SSL certificates powered by ACME
This role will roll manage SSL certificates for given hosts using the ACME
protocol.

The default (and tested!) setup is using Let's Encrypt, but when configured
accordingly, it should also work with any other ACME server.

NOTE: This role is still in development, it is NOT ready for production use just yet! Stay tuned!

# Requirements
The succesful execution of this role requires the following on the Ansible Control Host:

* Access to a DNS authoratative server for the DNS domain you wish you supply with certificates
  This is only required when you use the DNS-01 check (personal recommendation, this is what you want!)
 OR
* Access to the webserver that serves the website you wish to get a certificate for
* HTTPS access to the ACME server's API

This role will request the certificates on the Ansible Control Host and distribute them from there on, this allows for using the same certificate on multiple systems (for example, on a reverse proxy for webmail and the mailserver as well)

# Usage
T.B.W.

Not ready for production use just yet, so no docs available...
