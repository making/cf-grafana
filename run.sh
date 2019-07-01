#!/bin/sh

GRAFANA_DIR=./grafana
CLEARDB=`echo $VCAP_SERVICES | grep "cleardb"`
PMYSQL=`echo $VCAP_SERVICES | grep "p-mysql"`

if [ "$CLEARDB" != "" ];then
	SERVICE="cleardb"
elif [ "$PMYSQL" != "" ]; then
	SERVICE="p-mysql"
fi

echo "Detected $SERVICE"

# MYSQL_HOSTNAME=`echo $VCAP_SERVICES | jq -r '.["'$SERVICE'"][0].credentials.hostname'`
# MYSQL_PASSWORD=`echo $VCAP_SERVICES | jq -r '.["'$SERVICE'"][0].credentials.password'`
# MYSQL_PORT=`echo $VCAP_SERVICES | jq -r '.["'$SERVICE'"][0].credentials.port'`
# MYSQL_USERNAME=`echo $VCAP_SERVICES | jq -r '.["'$SERVICE'"][0].credentials.username'`
# MYSQL_DATABASE=`echo $VCAP_SERVICES | jq -r '.["'$SERVICE'"][0].credentials.name'`

# SESSION_CONFIG="$MYSQL_USERNAME:$MYSQL_PASSWORD@tcp($MYSQL_HOSTNAME:$MYSQL_PORT)/$MYSQL_DATABASE"

cd $GRAFANA_DIR
export GF_DATABASE_TYPE=mysql
# drop ?reconnect=true from connection string because Grafana doesn't handle it properly
DATABASE_URL=${DATABASE_URL/?reconnect=true}
export GF_DATABASE_URL=${DATABASE_URL/mysql2/mysql} # replace "mysql2://..." which Grafana doesn't understand in $DATABASE_URL with "mysql://..."
# sed -i -e 's|max_idle_conn =|max_idle_conn = 1|' ./conf/defaults.ini
# sed -i -e 's|max_open_conn =|max_open_conn = 3|' ./conf/defaults.ini
# sed -i -e 's|provider = file|provider = mysql|' ./conf/defaults.ini
# sed -i -e 's|provider_config = sessions|provider_config = '$SESSION_CONFIG'|' ./conf/defaults.ini

echo "Start Grafana"
./bin/grafana-server web &
