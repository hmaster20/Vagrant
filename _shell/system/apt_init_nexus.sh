#!/usr/bin/env bash

# Ansible
echo "deb http://nexus.local/repository/apt-ansible-ubuntu/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/ansible.list

# ClickHouse
echo "deb http://nexus.local/repository/apt-clickhouse-arhive/ main/" > /etc/apt/sources.list.d/clickhouse.list

# Docker
echo "deb http://nexus.local/repository/apt-ubuntu-docker/ $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Helm
echo "deb http://nexus.local/repository/apt-helm/ all main" > /etc/apt/sources.list.d/helm.list

# Kubernetes
echo "deb http://nexus.local/repository/apt-kubernetes/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list

# PostgreSQL
echo "deb http://nexus.local/repository/apt-postgresql/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pg.list

# Ubuntu Core
echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs) main restricted" > /etc/apt/sources.list
echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs)-updates main restricted" >> /etc/apt/sources.list
echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs) universe" >> /etc/apt/sources.list
echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs)-updates universe" >> /etc/apt/sources.list
echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs) multiverse" >> /etc/apt/sources.list
echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs)-updates multiverse" >> /etc/apt/sources.list
echo "deb http://nexus.local/repository/apt-ubuntu-focal $(lsb_release -cs)-backports main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb http://nexus.local/repository/apt-ubuntu-security $(lsb_release -cs)-security main restricted" >> /etc/apt/sources.list
echo "deb http://nexus.local/repository/apt-ubuntu-security $(lsb_release -cs)-security universe" >> /etc/apt/sources.list
echo "deb http://nexus.local/repository/apt-ubuntu-security $(lsb_release -cs)-security multiverse" >> /etc/apt/sources.list
