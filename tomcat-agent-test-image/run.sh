#!/usr/bin/env bash

mkdir -p ${SCENARIO_DATA}/${SCENARIO_NAME}_${SCENARIO_VERSION}
cp ${expected_data} ${SCENARIO_DATA}/${SCENARIO_NAME}_${SCENARIO_VERSION}
# build structure
DEPLOY_PACKAGES=($(cd ${SCENARIO_PACKAGES} && ls -p | grep -v /))
echo "[${SCENARIO_NAME}] deploy packages: ${DEPLOY_PACKAGES[@]}"
cp ${SCENARIO_PACKAGES}/*.war /usr/local/tomcat/webapps/
# start mock collector
/usr/local/skywalking-agent-scenario/skywalking-mock-collector/collector-startup.sh &
sleep 30
/usr/local/tomcat/bin/catalina.sh start
# validate message
sleep 60
curl ${SCENARIO_ENTRY_SERVICE}
sleep 40
curl http://localhost:12800/receiveData > ${SCENARIO_DATA}/${SCENARIO_NAME}_${SCENARIO_VERSION}/actualData.yaml
#
echo "Scenario[${SCENARIO_NAME}, ${SCENARIO_VERSION}] build successfully!"
