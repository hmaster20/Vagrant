#!/usr/bin/env bash

# # OpenVPN
machine.vm.provision "shell", inline: "
echo \"deb https://repo.pritunl.com/stable/apt focal main\" | sudo tee /etc/apt/sources.list.d/pritunl.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7AE645C0CF8E292A
sudo apt update -yq
sudo apt install -yq pritunl-client-electron pritunl-client
sudo apt install -yq network-manager network-manager-openvpn
"
# sudo nmcli connection import type openvpn file ar-develop-ru_user_ar-develop-ru.ovpn
# nmcli connection up ar-develop-ru_user_ar-develop-ru
# pritunl-client add ar-develop-ru_user_ar-develop-ru.ovpn
# sudo openvpn ar-develop-ru_user_ar-develop-ru.ovpn
