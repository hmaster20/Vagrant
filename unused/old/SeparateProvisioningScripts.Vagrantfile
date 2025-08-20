# https://stackoverflow.com/questions/26513814/vagrant-multiple-vm-with-separate-provisioning-scripts

Currently trying to set up multiple VMs, with separate provisioning scripts.
Vagrantfile is as follows;

dir = Dir.pwd
vagrant_dir = File.expand_path(File.dirname(__FILE__))

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    box_name = "puppetlabs/centos-6.5-64-puppet"

    # our web/app servers and their IPs - format 192.168.1.8##
    app_servers = {

        'web11' => {
            :name => 'web11',
            :ip => '192.168.1.811',
            :box => box_name,
            :forwarded_port_guest => 811,
            :forwarded_port_host => 8811
        },

        'web21' => {
            :name => 'web21',
            :ip => '192.168.1.821',
            :box => box_name,
            :forwarded_port_guest => 821,
            :forwarded_port_host => 8821
        },

        'learninglocker' => {
            :name => 'learninglocker',
            :ip => '192.168.1.899',
            :box => box_name,
            :forwarded_port_guest => 899,
            :forwarded_port_host => 8899
        }

    }

    app_servers.each do |key,value|

        boxname = value[:name]

        config.vm.define boxname do |app_config|

            app_config.vm.provision "shell", inline: "echo !!!thisname!!!! #{key}"
            app_config.vm.provision "shell", inline: "echo !!!thisip!!!! #{value[:ip]}"

            app_config.vm.box = value[:box]
            app_config.vm.host_name = "%s.vagrant" % value[:name]

            app_config.vm.network "private_network", ip: value[:ip]
            app_config.vm.network "forwarded_port", guest: value[:forwarded_port_guest], host: value[:forwarded_port_host]

            app_config.ssh.forward_agent = true

            provision_filename = key.to_s + "-provision.sh"
            config.vm.provision "shell", inline: "echo #{provision_filename}"

            # provisioning
            if File.exists?(File.join(vagrant_dir,'provision',boxname + "-provision.sh")) then
                config.vm.provision "shell", inline: "echo +++exists+++"
                config.vm.provision :shell, :path => File.join( "provision", boxname + "-provision.sh" )
            else
                config.vm.provision "shell", inline: "echo PROVISION FILE DOES NOT EXIST!"
            end

            # Shared NFS folder
            # config.vm.synced_folder "shared/nfs/", "/vagrant/", type: "nfs"
            config.vm.synced_folder "shared/nfs/", "/vagrant/"

        end # config.vm.define opts[:name] do |config|

    end # app_servers.each


# I also have a provision/web11-provision.sh file (but no web21 or learninglocker equivalents) 
# which basically just prints out a message for now.

# The problem: When running a vagrant up when it brings up web11 it prints the message that the 
# file exists (expected). When it brings up web21, boxname is still web11 on first go around and 
# so runs the provisioning script, then it goes again and changes to web21 so doesn't find the file. 
# The same thing happens for learninglocker - runs web11, then web21, then learninglocker.

# I'm clearly being dumb in terms of my .each statement, but can't figure out what it is... help?


# Currently trying to set up multiple VMs, with separate provisioning scripts.
# Vagrantfile is as follows;

dir = Dir.pwd
vagrant_dir = File.expand_path(File.dirname(__FILE__))

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    box_name = "puppetlabs/centos-6.5-64-puppet"

    # our web/app servers and their IPs - format 192.168.1.8##
    app_servers = {

        'web11' => {
            :name => 'web11',
            :ip => '192.168.1.811',
            :box => box_name,
            :forwarded_port_guest => 811,
            :forwarded_port_host => 8811
        },

        'web21' => {
            :name => 'web21',
            :ip => '192.168.1.821',
            :box => box_name,
            :forwarded_port_guest => 821,
            :forwarded_port_host => 8821
        },

        'learninglocker' => {
            :name => 'learninglocker',
            :ip => '192.168.1.899',
            :box => box_name,
            :forwarded_port_guest => 899,
            :forwarded_port_host => 8899
        }

    }

    app_servers.each do |key,value|

        boxname = value[:name]

        config.vm.define boxname do |app_config|

            app_config.vm.provision "shell", inline: "echo !!!thisname!!!! #{key}"
            app_config.vm.provision "shell", inline: "echo !!!thisip!!!! #{value[:ip]}"

            app_config.vm.box = value[:box]
            app_config.vm.host_name = "%s.vagrant" % value[:name]

            app_config.vm.network "private_network", ip: value[:ip]
            app_config.vm.network "forwarded_port", guest: value[:forwarded_port_guest], host: value[:forwarded_port_host]

            app_config.ssh.forward_agent = true

            provision_filename = key.to_s + "-provision.sh"
            config.vm.provision "shell", inline: "echo #{provision_filename}"

            # provisioning
            if File.exists?(File.join(vagrant_dir,'provision',boxname + "-provision.sh")) then
                config.vm.provision "shell", inline: "echo +++exists+++"
                config.vm.provision :shell, :path => File.join( "provision", boxname + "-provision.sh" )
            else
                config.vm.provision "shell", inline: "echo PROVISION FILE DOES NOT EXIST!"
            end

            # Shared NFS folder
            # config.vm.synced_folder "shared/nfs/", "/vagrant/", type: "nfs"
            config.vm.synced_folder "shared/nfs/", "/vagrant/"

        end # config.vm.define opts[:name] do |config|

    end # app_servers.each

# I also have a provision/web11-provision.sh file (but no web21 or learninglocker equivalents) which basically just prints out a message for now.

# The problem: When running a vagrant up when it brings up web11 it prints the message that the file exists (expected). When it brings up web21, boxname is still web11 on first go around and so runs the provisioning script, then it goes again and changes to web21 so doesn't find the file. The same thing happens for learninglocker - runs web11, then web21, then learninglocker.

# =========================================================================
# Answer 

# Damn it.

# Always the way. Ask a question and then find the answer.
# I have config.vm.provision a few times in each rather than app_config.vm.provision
# i.e. it should be

app_servers.each do |key,value|

    boxname = value[:name]
    config.vm.provision :shell, inline: 'echo boxname: ' + boxname

    config.vm.define boxname do |app_config|

        app_config.vm.provision "shell", inline: "echo !!!thisname!!!! #{key}"
        app_config.vm.provision "shell", inline: "echo !!!thisip!!!! #{value[:ip]}"

        app_config.vm.box = value[:box]
        app_config.vm.host_name = "%s.vagrant" % value[:name]

        app_config.vm.network "private_network", ip: value[:ip]
        app_config.vm.network "forwarded_port", guest: value[:forwarded_port_guest], host: value[:forwarded_port_host]

        app_config.ssh.forward_agent = true

        provision_filename = key.to_s + "-provision.sh"
        app_config.vm.provision "shell", inline: "echo #{provision_filename}"

        # provisioning
        if File.exists?(File.join(vagrant_dir,'provision',boxname + "-provision.sh")) then
            app_config.vm.provision "shell", inline: "echo +++exists+++"
            app_config.vm.provision :shell, :path => File.join( "provision", boxname + "-provision.sh" )
        else
            app_config.vm.provision "shell", inline: "echo PROVISION FILE DOES NOT EXIST!"
        end

        # Shared NFS folder
        # app_config.vm.synced_folder "shared/nfs/", "/vagrant/", type: "nfs"
        app_config.vm.synced_folder "shared/nfs/", "/vagrant/"

    end # config.vm.define opts[:name] do |config|

end # app_servers.each
