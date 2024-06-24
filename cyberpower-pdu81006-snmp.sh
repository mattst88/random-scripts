#!/bin/sh

host=$1
user=$2
auth_pass=$3
priv_pass=$4

exec snmpwalk -v 3 -a SHA -A "$auth_pass" -l authPriv -u "$user" -x AES -X "$priv_pass" -m "${PWD}/CyberPower_MIB_v2.11.MIB" "$host" enterprises.3808
