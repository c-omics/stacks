#!/bin/bash

/usr/sbin/apachectl &

if [[ ! -z ${MYSQL_HOST} ]] ; then
  sed -i "s/\(host=\).*/\1$MYSQL_HOST/" /root/.my.cnf
  sed -i "s/\(^\$db_host\).*/\1 = \"$MYSQL_HOST\"/" /software/applications/stacks/1.44/share/stacks/php/constants.php
fi

if [[ ! -z ${MYSQL_USER} ]] ; then
  sed -i "s/\(user=\).*/\1$MYSQL_USER/" /root/.my.cnf
  sed -i "s/\(^\$db_user\).*/\1 = \"$MYSQL_USER\"/" /software/applications/stacks/1.44/share/stacks/php/constants.php
fi

if [[ ! -z ${MYSQL_PWD} ]] ; then
  sed -i "s/\(password=\).*/\1$MYSQL_PWD/" /root/.my.cnf
  sed -i "s/\(^\$db_pass\).*/\1 = \"$MYSQL_PWD\"/" /software/applications/stacks/1.44/share/stacks/php/constants.php
fi

exec "$@"

