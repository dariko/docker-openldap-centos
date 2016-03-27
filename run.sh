#!/bin/bash

LOGLEVEL=${LOGLEVEL:-32768}


if [ ! -z "$INIT_CONFIG" ];then
  /init_config.sh
fi

SLAPD_ENDPOINTS="${SLAPD_ENDPOINTS:-ldap://*:389 ldaps://*:636}"

chown -R ldap:ldap /usr/local/openldap/etc/openldap/slapd.d
chown -R ldap:ldap /usr/local/openldap/var/openldap*


/usr/local/openldap/libexec/slapd -h "$SLAPD_ENDPOINTS" -F /usr/local/openldap/etc/openldap/slapd.d -u ldap -g ldap -d $LOGLEVEL
