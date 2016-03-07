#!/bin/bash

OLB=${OPENLDAP_BASE:-/usr/local/openldap}
CONFIG_PATH=${CONFIG_PATH:-$OLB/etc/openldap/slapd.d/}
SLAPADD="$OLB/sbin/slapadd"

rm -rf /usr/local/openldap/etc/openldap/etc/slapd.d/c*

tee > /tmp/config.ldif

for db_path in $(cat /tmp/config.ldif |sed -n 's/^olcdbdirectory: \(.*\)$/\1/pI')
do
  mkdir -p "$db_path"
  chown -R ldap:ldap "$db_path"
done

pid_file=$(sed -n 's/^olcpidfile: \(.*\)$/\1/pI' /tmp/config.ldif)
pid_dir="$(dirname $pid_file)"
rm -rf "$pid_file"
mkdir -p "$pid_dir"
chown -R ldap:ldap "$pid_dir"

rm -rf "$CONFIG_PATH"/*

"$SLAPADD" -n0 -F "$CONFIG_PATH" -l /tmp/config.ldif
chown -R ldap:ldap $CONFIG_PATH


