#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# update wildcard dns
sed -i -r "s/local/${DOMAIN}/g" /usr/local/bin/backend.conf

# convert all environment variables prefixed with PDNS_ into pdns config directives
PDNS_LOAD_MODULES="$(echo $PDNS_LOAD_MODULES | sed 's/^,//')"
printenv | grep ^PDNS_ | cut -f2- -d_ | while read var; do
  val="${var#*=}"
  var="${var%%=*}"
  var="$(echo $var | sed -e 's/_/-/g' | tr '[:upper:]' '[:lower:]')"
  [[ -z "$TRACE" ]] || echo "$var=$val"
  sed -r -i "s#^[# ]*$var=.*#$var=$val#g" /etc/pdns/pdns.conf
done

trap "pdns_control quit" SIGHUP SIGINT SIGTERM

pdns_server "$@" &
wait
