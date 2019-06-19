[![Build Status](https://drone.element-networks.nl/api/badges/Element-Networks/ansible-role-acme_ssl/status.svg)](https://drone.element-networks.nl/Element-Networks/ansible-role-acme_ssl)


# SSL certificates powered by ACME
This role will roll manage SSL certificates for given hosts using the ACME
protocol.

The default (and tested!) setup is using Pebble (https://github.com/letsencrypt/pebble), but when configured
accordingly, it should also work with any other ACME-compliant server.

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
After fulfilling the requirements above this role can be used as follows:

* Install the role (either from Galaxy or directly from GitHub)
* Copy the defaults file to your inventory (or wherever you store them) and
  fill in the blanks
* Add the role to your master playbook
* Run Ansible
* ???
* Profit!
