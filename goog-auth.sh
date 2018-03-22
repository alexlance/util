#!/bin/bash

DB="/tmp/l/data/data/com.google.android.apps.authenticator2/databases/databases"

sqlite3 "$DB" 'SELECT email,secret FROM accounts;' | while read line
do
  echo $line

#        NAME=`echo "$A" | cut -d '|' -f 1`
#        KEY=`echo "$A" | cut -d '|' -f 2`
#        CODE=`oathtool --totp -b "$KEY"`
#        #echo -e "\e[1;32m${CODE}\e[0m - \e[1;33m${NAME}\e[0m"
        
done
