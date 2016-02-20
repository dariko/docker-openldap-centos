#!/bin/bash

LOGLEVEL=${LOGLEVEL:-32768}

/usr/local/openldap/libexec/slapd -h 'ldap://*:389 ldaps://*:636' -f /usr/local/openldap/etc/openldap/slapd.conf -u ldap -g ldap -d $LOGLEVEL
