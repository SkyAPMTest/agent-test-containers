FROM tomcat:8.5.42-jdk8-openjdk
MAINTAINER zhangxin@apache.org
WORKDIR /usr/local/skywalking-agent-scenario

ENV AGENT_DIR /usr/local/skywalking-agent-scenario/agent
# scenario name
ENV SCENARIO_NAME NOOP_SCENARIO_NAME
# scenario packages
ENV SCENARIO_PACKAGES /usr/local/skywalking-agent-scenario/packages
# expected data
ENV SCENARIO_DATA /usr/local/skywalking-agent-scenario/data
# tested framework version
ENV SCENARIO_VERSION NOOP_VERSION
# tested framework name
ENV SCENARIO_SUPPORT_FRAMEWORK NOOP_SUPPORT_FRAMEWORK
# entry service of test scenario
ENV SCENARIO_ENTRY_SERVICE http://localhost:8080

COPY run.sh /
COPY catalina.sh /usr/local/tomcat/bin/

RUN wget -O skywalking-mock-collector.tar.gz https://github.com/SkyAPMTest/skywalking-mock-collector/releases/download/V6.0.0-2018/skywalking-mock-collector.tar.gz && \
    tar -xvf skywalking-mock-collector.tar.gz /usr/local/skywalking-agent-scenario/skywalking-mock-collector && \
    chmod +x /usr/local/tomcat/bin/catalina.sh && chmod +x /docker-entrypoint.sh

VOLUME /usr/local/skywalking-agent-scenario/agent
VOLUME /usr/local/skywalking-agent-scenario/data
VOLUME /usr/local/skywalking-agent-scenario/packages

RUN ["/run.sh"]
