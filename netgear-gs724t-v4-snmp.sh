#!/bin/sh

host=$1
auth_pass=$2
priv_pass=$3

exec snmpwalk -v 3 -a SHA-512 -A "$auth_pass" -l authPriv -u admin -x AES -X "$priv_pass" -M "${PWD}/gs7xxt-v6.3.1.43-mibs:/usr/share/snmp/mibs/" -m ALL "$host" enterprises.4526
