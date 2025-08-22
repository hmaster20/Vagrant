#!/usr/bin/env bash

ZOO_VERSION=3.6.3

apt-get -yq install default-jdk default-jre

useradd zookeeper -m
usermod --shell /bin/bash zookeeper
echo zookeeper:zookeeper | chpasswd
usermod -aG sudo zookeeper


mkdir /zookeeper
chown -R zookeeper:zookeeper /zookeeper
cd /opt
wget echo https://dlcdn.apache.org/zookeeper/zookeeper-$ZOO_VERSION/apache-zookeeper-$ZOO_VERSION-bin.tar.gz
tar -xvzf apache-zookeeper-$ZOO_VERSION-bin.tar.gz
mv apache-zookeeper-$ZOO_VERSION-bin zookeeper
chown -R zookeeper:zookeeper /opt/zookeeper
rm -rf apache-zookeeper-$ZOO_VERSION-bin.tar*

mkdir /var/lib/zookeeper
mkdir /var/lib/zookeeper/data

cat >/opt/zookeeper/conf/zoo.cfg <<EOL
# minimal params
clientPort=2181
observerMasterPort=2191
tickTime=2000
dataDir=/var/lib/zookeeper/data

# extension params
dataLogDir=/var/lib/zookeeper/logs
globalOutstandingLimit=2000
preAllocSize=131072
snapCount=3000000
maxCnxns=80000
maxClientCnxns=2000
maxSessionTimeout=60000000
autopurge.snapRetainCount=10
autopurge.purgeInterval=1

# AdminServer configuration, conncection over http://<IP>:8088/commands
admin.enableServer=true
admin.enableServer=0.0.0.0
admin.serverPort=8088

# Cluster params
initLimit=30000
syncLimit=10
leaderServes=yes

EOL
