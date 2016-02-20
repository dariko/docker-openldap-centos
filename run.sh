#!/bin/bash

LOGLEVEL=${LOGLEVEL:-32768}


if [ ! -z "$INIT_CONFIG" ];then
  /init_config.sh
fi


/usr/local/openldap/libexec/slapd -h 'ldap://*:389 ldaps://*:636' -F /usr/local/openldap/etc/openldap/slapd.d -u ldap -g ldap -d $LOGLEVEL
