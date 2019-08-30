#!/usr/bin/env bash

function healthCheck() {
    HEALTH_CHECK_URL=$1

    for ((i=1;i<=10;i++));
    do
        STATUS_CODE="$(curl -Is ${HEALTH_CHECK_URL} | head -n 1)"
        if [[ $STATUS_CODE == *"200"* ]]; then
          echo "${HEALTH_CHECK_URL}: ${STATUS_CODE}"
          return 0
        fi
        sleep 2
    done

    echo "WARNING: health check failed!!!!"
}

SCENARIO_HOME=/usr/local/skywalking-agent-scenario/
mkdir -p ${SCENARIO_HOME}
# build structure
DEPLOY_PACKAGES=($(cd ${SCENARIO_PACKAGES} && ls -p | grep -v /))
echo "[${SCENARIO_NAME}] deploy packages: ${DEPLOY_PACKAGES[@]}"
cp ${SCENARIO_PACKAGES}/*.war /usr/local/tomcat/webapps/
# start mock collector
echo "To start mock collector"
${SCENARIO_HOME}/skywalking-mock-collector/bin/collector-startup.sh >/dev/null 2>&1 &
healthCheck http://localhost:12800/receiveData
echo "To start tomcat"
/usr/local/tomcat/bin/catalina.sh start >/dev/null 2>&1
healthCheck ${SCENARIO_HEALTH_CHECK_URL}
echo "To visit entry service"
curl ${SCENARIO_ENTRY_SERVICE}
sleep 5
echo "To receive actual data"
curl -s http://localhost:12800/receiveData > ${SCENARIO_DATA}/actualData.yaml
#
echo "Scenario[${SCENARIO_NAME}, ${SCENARIO_VERSION}] build successfully!"
