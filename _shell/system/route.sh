#!/usr/bin/env bash

ip route del 0/0
route add default gw 10.0.2.99 enp0s3

# default via 10.0.2.2 dev enp0s3 proto dhcp src 10.0.2.15 metric 100
# sudo route add default gw 10.0.2.15 enp0s3

# ip route add default via my-gateway
# ip route del default

# Вывести второе значние строки с вхождением blackhole
# ip route | grep blackhole | awk '{print $2}'

# Трафик по умолчанию в черную дыру
# https://serverfault.com/questions/294690/blackhole-route-private-intranet-traffic
ip route add blackhole 10.0.0.0/8
ip route add blackhole 172.16.0.0/12
ip route add blackhole 192.168.0.0/16
