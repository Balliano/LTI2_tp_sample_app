#!/usr/bin/env bash
#!/bin/bash
#
# Starts the mysql database & runs the rails app.
#
[ -z "$HOST_PROTOCOL" ] && export HOST_PROTOCOL=http
[ -z "$HOST_DOMAIN" ] && export HOST_DOMAIN=localhost
[ -z "$HOST_PORT" ] && export HOST_PORT=3000
[ -z "$HOST" ] && export HOST="$HOST_PROTOCOL://$HOST_DOMAIN:$HOST_PORT"

#TODO: would like to support these parameters at some point
#[ -z "$MYSQL_HOST" ] && export MYSQL_HOST=`/sbin/ip route|awk '/default/ { print $3 }'`
#[ -z "$MYSQL_PORT" ] && export MYSQL_PORT=5984


#Setup the database
service mysql start
mysql --user="root" --execute="CREATE DATABASE tpsampleapp;"
mysql --user="root" tpsampleapp < ./data/tpsampleapp.sql

mysql  --user="root" --database "tpsampleapp" \
      --execute="update lti2_tp_registries set content = '$HOST' where name = 'tp_deployment_url'"

##Migrate the database
#rake db:migrate RAILS_ENV=development

#run the app
rails s -p 3000