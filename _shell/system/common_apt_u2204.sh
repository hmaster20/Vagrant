#!/usr/bin/env bash

# # fix (disable) auto upgrades
# apt remove -yq unattended-upgrades
# apt purge -y unattended-upgrades
# apt remove -yq cron-apt

# # Remove AppArmor
# apt remove --assume-yes --purge apparmor


# Remove unused packs
apt remove --assume-yes --purge apparmor unattended-upgrades cron-apt

# apt -yqq update
apt -yq update
apt install -yq --no-install-recommends \
nano mc htop atop iotop iftop git net-tools dnsutils bash-completion \
jq ncdu nload tmux tcpdump mlocate sysstat

# Desktop
# apt install -yq remmina remmina-plugin-rdp remmina-plugin-secret remmina-plugin-spice
