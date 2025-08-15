Vagrant.configure("2") do |config|
  config.vm.box = "hmaster20/windows98se-ru"
  config.vm.box_version = "1.1.0"
  config.vm.guest = "windows"
  config.vm.communicator = "winrm"
  config.vm.boot_timeout = 25
  config.winrm.username = "Administrator"
  # config.winrm.host = "127.0.0.1"
  config.winrm.guest_port = "139"
  config.winrm.port = "1139"
  # config.winrm.transport:negotiate
  config.winrm.transport = "plaintext"
  config.winrm.basic_auth_only = true
  config.winrm.execution_time_limit = "PT1H"
  # config.vm.network "forwarded_port", guest: 22, host: 22, disabled: true
  config.vm.network "forwarded_port", guest: 139, host: 1139, protocol: "tcp", id: "session"
  # config.vm.network "forwarded_port", guest: 5985, host: 55985, protocol: "tcp", id: "winrm"
  # config.vm.network "forwarded_port", guest: 5986, host: 55986, protocol: "tcp", id: "winrm-ssl"

end
