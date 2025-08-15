#!/usr/bin/env bash

# View VM info
ip a | grep "inet "
cat /etc/os-release
hostnamectl
hostname -I
lscpu | grep VT-x
