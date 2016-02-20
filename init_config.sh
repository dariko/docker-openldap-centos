#!/bin/bash


OLB=${OPENLDAP_BASE:-/usr/local/openldap}
SLAPPASSWD="$OLB/sbin/slappasswd"
SLAPADD="$OLB/sbin/slapadd"


SLAPD_D_PATH=${SLAPD_D_PATH:-$OLB/etc/openldap/slapd.d/}

CONFIG_ROOTDN="${CONFIG_ROOTDN:-cn=config}"
CONFIG_ROOTPW="${CONFIG_ROOTPW:-password}"
CONFIG_ROOTPW_ENCRYPTED="$($SLAPPASSWD -h '{SSHA}' -s $CONFIG_ROOTPW)"


BASE_DN="${BASE_DN:-dc=example,dc=com}"

DATA_PATH="${DATA_PATH:-/usr/local/openldap/var/openldap-data}"


cat << EOF > /tmp/config.ldif
dn: cn=config
objectClass: olcGlobal
cn: config

dn: olcDatabase={0}config,cn=config
objectClass: olcDatabaseConfig
olcDatabase: config
olcRootDN: $CONFIG_ROOTDN
olcRootPW: $CONFIG_ROOTPW_ENCRYPTED

EOF

if [ ! -z "$BASE_DN" ];then
cat << EOF >> /tmp/config.ldif
dn: olcDatabase=mdb,cn=config
objectClass: olcDatabaseConfig
objectClass: olcMdbConfig
olcDatabase: mdb
olcDbDirectory: $DATA_PATH
olcSuffix: $BASE_DN
EOF
  rm -rf "$DATA_PATH"
  mkdir "$DATA_PATH"
  chown ldap:ldap "$DATA_PATH"
fi

echo "##"
cat /tmp/config.ldif
echo "##"

rm -rf "$SLAPD_D_PATH"/*
mkdir "$SLAPD_D_PATH"
"$SLAPADD" -n0 -F "$SLAPD_D_PATH" -l /tmp/config.ldif
chown -R ldap:ldap "$SLAPD_D_PATH"

find "$SLAPD_D_PATH"

rm /tmp/config.ldif
cat /usr/local/openldap/etc/openldap/slapd.d/cn=config/olcDatabase=*


