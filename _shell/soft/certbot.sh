#!/usr/bin/env bash

# CertBot Let’s Encrypt
# apt-add-repository -r ppa:certbot/certbot
apt-get -yqq update
apt-get install -yq --no-install-recommends python3-certbot-nginx
