#!/usr/bin/env bash

# fix multipath daemon error
# https://sleeplessbeastie.eu/2021/01/06/how-to-fix-multipath-daemon-error-about-missing-path-when-using-virtualbox/
# cat <<EOF | sudo tee -a /etc/multipath.conf
# blacklist {
#   device {
#     vendor "VBOX"
#     product "HARDDISK"
#   }
# }
# EOF

# echo "TEST"
# grep -c "HARDDISK" /etc/multipath.conf

isInFile=$(cat /etc/multipath.conf | grep -c "HARDDISK")

if [ $isInFile -eq 0 ]; then
cat <<EOF | sudo tee -a /etc/multipath.conf
blacklist {
  device {
    vendor "VBOX"
    product "HARDDISK"
  }
}
EOF
else
   echo "multipath tune skipping"
fi


# # fix multipath daemon error
# # machine.vm.provision :shell, inline: $multipath_daemon, args: "#{master_ip}"
# machine.vm.provision :shell, inline: $multipath_daemon
# machine.vm.provision "shell", inline: "sudo systemctl restart multipathd.service"

sudo systemctl restart multipathd.service
