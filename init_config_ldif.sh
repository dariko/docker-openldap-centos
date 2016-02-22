#!/bin/bash

OLB=${OPENLDAP_BASE:-/usr/local/openldap}
CONFIG_PATH=${CONFIG_PATH:-$OLB/etc/openldap/slapd.d/}
SLAPADD="$OLB/sbin/slapadd"



tee > /tmp/config.ldif

rm -rf "$CONFIG_PATH"/*

"$SLAPADD" -n0 -F "$CONFIG_PATH" -l /tmp/config.ldif
chown -R ldap:ldap $CONFIG_PATH


