#!/bin/bash

set -e
set -x

# Cleanup
rm -rf /var/www/html/*

# Copy frontend files
cp /speedtest/*.js /var/www/html/
cp /speedtest/favicon.ico /var/www/html/
# Set up backend side for standlone modes
if [ "$MODE" == "standalone" ]; then
  cp -r /speedtest/backend/ /var/www/html/backend
  if [ ! -z "$IPINFO_APIKEY" ]; then
    sed -i s/\$IPINFO_APIKEY=\"\"/\$IPINFO_APIKEY=\"$IPINFO_APIKEY\"/g /var/www/html/backend/getIP_ipInfo_apikey.php
  fi
fi

if [ "$MODE" == "backend" ]; then
  cp -r /speedtest/backend/* /var/www/html
  if [ ! -z "$IPINFO_APIKEY" ]; then
    sed -i s/\$IPINFO_APIKEY=\"\"/\$IPINFO_APIKEY=\"$IPINFO_APIKEY\"/g /var/www/html/getIP_ipInfo_apikey.php
  fi
fi


# Set up index.php for frontend-only or standalone modes
if [ "$MODE" == "frontend" ]; then
  cp /speedtest/frontend.php /var/www/html/index.php
elif [ "$MODE" == "standalone" ]; then
  cp /speedtest/standalone.php /var/www/html/index.php
fi

# Apply Telemetry settings when running in standalone or frontend mode and telemetry is enabled
if [[ "$TELEMETRY" == "true" && (( "$MODE" == "frontend" || "$MODE" == "standalone" )) ]]
then
  cp -r /speedtest/results /var/www/html/results
  if  [ "$DB_TYPE" == "mysql" ]; then
    sed -i 's/$db_type='\"'.*'\"'/$db_type='\"$DB_TYPE\"\;'/g' /var/www/html/results/telemetry_settings.php
    sed -i 's/$MySql_username='\"'.*'\"'/$MySql_username='\"$DB_USERNAME\"'/g' /var/www/html/results/telemetry_settings.php
    sed -i 's/$MySql_password='\"'.*'\"'/$MySql_password='\"$DB_PASSWORD\"'/g' /var/www/html/results/telemetry_settings.php
    sed -i 's/$MySql_hostname='\"'.*'\"'/$MySql_hostname='\"$DB_HOSTNAME\"'/g' /var/www/html/results/telemetry_settings.php
    sed -i 's/$MySql_databasename='\"'.*'\"'/$MySql_databasename='\"$DB_NAME\"'/g' /var/www/html/results/telemetry_settings.php
  if  [ "$DB_PORT" != "" ]; then
      sed -i 's/$MySql_port='\"'.*'\"'/$MySql_port='\"$DB_PORT\"'/g' /var/www/html/results/telemetry_settings.php
  fi  
  elif  [ "$DB_TYPE" == "postgresql" ]; then
    sed -i 's/$db_type = '\"'.*'\"'/$db_type = '\"$DB_TYPE\"'/g' /var/www/html/results/telemetry_settings.php
    sed -i 's/$PostgreSql_username='\"'.*'\"'/$PostgreSql_username='\"$DB_USERNAME\"'/g' /var/www/html/results/telemetry_settings.php
    sed -i 's/$PostgreSql_password='\"'.*'\"'/$PostgreSql_password='\"$DB_PASSWORD\"'/g' /var/www/html/results/telemetry_settings.php
    sed -i 's/$PostgreSql_hostname='\"'.*'\"'/$PostgreSql_hostname='\"$DB_HOSTNAME\"'/g' /var/www/html/results/telemetry_settings.php
    sed -i 's/$PostgreSql_databasename='\"'.*'\"'/$PostgreSql_databasename='\"$DB_NAME\"'/g' /var/www/html/results/telemetry_settings.php
  else
    sed -i s/\$db_type\ =\ \'.*\'/\$db_type\ =\ \'sqlite\'\/g /var/www/html/results/telemetry_settings.php
  fi
  
  sed -i s/\$Sqlite_db_file\ =\ \".*\"/\$Sqlite_db_file=\"\\\/database\\\/db.sql\"/g /var/www/html/results/telemetry_settings.php
  sed -i s/\$stats_password=\".*\"/\$stats_password=\"$PASSWORD\"/g /var/www/html/results/telemetry_settings.php
  
  if [ "$ENABLE_ID_OBFUSCATION" == "true" ]; then
    sed -i s/\$enable_id_obfuscation=.*\;/\$enable_id_obfuscation=true\;/g /var/www/html/results/telemetry_settings.php
  fi

  if [ "$REDACT_IP_ADDRESSES" == "true" ]; then
    sed -i s/\$redact_ip_addresses=.*\;/\$redact_ip_addresses=true\;/g /var/www/html/results/telemetry_settings.php
  fi

  mkdir -p /database/
  chown www-data /database/
fi

###Enable msqli
#sed -i 's/;extension=mysqli/extension=mysqli/g' /usr/local/etc/php/php.ini

chown -R www-data:www-data /var/www/html

echo "Done, Starting APACHE and PHP-FPM"
php-fpm &

nginx -g 'daemon off;'

