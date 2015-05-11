#!/bin/bash

# STOP COLLECTIONSPACE
$CSPACE_JEESERVER_HOME/bin/shutdown.sh -force

psql -U csadmin -d postgres -f $CSPACE_JEESERVER_HOME/cspace/services/db/postgresql/init_nuxeo_db.sql
psql -U csadmin -d postgres -f $CSPACE_JEESERVER_HOME/cspace/services/db/postgresql/init_cspace_db.sql

cd $CSPACE_JEESERVER_HOME
rm -rf webapps/collectionspace*  webapps/cspace-ui* temp/*

cd /home/cspace/custom_cspace_source/application 
mvn clean install -DskipTests

cd /home/cspace/custom_cspace_source/services/services/JaxRsServiceProvider
ant deploy_services_artifacts

cd /home/cspace/custom_cspace_source/services/
ant undeploy deploy create_db -Drecreate_db=true import

cd /home/cspace/custom_cspace_source/ui 
mvn clean install -DskipTests

# RE/SET COLLECTIONSPACE PERMISSIONS
chown -R cspace:cspace /home/cspace/custom_cspace_source/

# START COLLECTIONSPACE
$CSPACE_JEESERVER_HOME/bin/startup.sh
#sleep 60

#cd /home/cspace/custom_cspace_source/
#./init-authorities.sh


