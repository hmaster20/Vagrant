#!/bin/bash

# Install VirtualBox
echo "Do you want to install VirtualBox? [Y/n]"
read INPUT
if [[ "$INPUT" == 'Y' || "$INPUT" == 'y' ]]; then
	# Select major version	
	DEFAULT=4.2
	echo "Select version e.g. $DEFAULT"
	read VER
	
	# Add repo
	wget -q -O - http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc | sudo apt-key add -
	sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian raring non-free contrib" >> /etc/apt/sources.list.d/virtualbox.org.list'
	apt-get update
	apt-get install virtualbox-${VER:=$DEFAULT}=*
	
	# Add user to group	
	usermod -a -G vboxusers $(whoami)
	
	# Get installed version
	VER=$(vboxmanage --version)
	VER=${VER%%r*}

	# Install extension pack
	wget -O ~/Downloads/Oracle_VM_VirtualBox_Extension_Pack-$VER.vbox-extpack http://download.virtualbox.org/virtualbox/$VER/Oracle_VM_VirtualBox_Extension_Pack-$VER.vbox-extpack
	vboxmanage extpack install ~/Downloads/Oracle_VM_VirtualBox_Extension_Pack-$VER.vbox-extpack

	echo "You must log out / in before your user group memberships are updated"
fi