#!/usr/bin/env bash
# reduce the default SSL security level, as our client certificates do not satisfy level 2

sed "s:SECLEVEL=2:SECLEVEL=1:g" /etc/ssl/openssl.cnf > /etc/ssl/openssl.cnf.tmp
mv -f /etc/ssl/openssl.cnf.tmp /etc/ssl/openssl.cnf
