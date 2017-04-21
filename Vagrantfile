# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  # provided example ha been built with packer
  config.vm.box = "xubuntu-16-04"
  
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  _user_homedir=ENV['USERPROFILE']
  if _user_homedir.to_s == ''
    _user_homedir=ENV['HOME']
  end
  if _user_homedir.to_s != ''
    config.vm.synced_folder _user_homedir.to_s, "/mnt/host-home"
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
  
    # Customize hardware on the VM:
    vb.memory = "4096"
    vb.cpus   = 2
    vb.customize ["modifyvm", :id, "--vram", "64"]
    # Enable the use of hardware virtualization extensions (Intel VT-x or AMD-V) in the processor of your host system
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]
    # (Needs Guest Additions) hardware 3D acceleration
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
  end

  #Set my timezone
  config.vm.provision :shell, :inline => "sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime", run: "always"

  # disable the apt-daily systemd service (avoid lock dpkg before the provisioning)
  # https://medium.com/@koalallama/vagrant-up-failing-could-not-get-lock-var-lib-dpkg-lock-13c73225782d#.4pe85ug76
  config.vm.provision "shell", inline: <<-SHELL
    systemctl disable apt-daily.service
    systemctl disable apt-daily.timer


    if (systemctl list-units --all apt-daily.service | fgrep -q apt-daily.service) then
      systemctl kill --kill-who=all apt-daily.service

      # wait until `apt-get updated` has been killed
      while ! (systemctl list-units --all apt-daily.service | fgrep -q dead); do
          sleep 1;
      done
    fi

  SHELL

  #This provisioning also installs ansible in the guest
  #it enables ansible provisioning directly from the guest, as ansible is
  #not officially supported and cumbersome to install on a Windows host
  config.vm.provision "shell", path: "provisioning/install-ansible.sh"
  
  #do the actual provisioning, passing host username as a first argument just in case
  _host_user = `id -u -n`.chomp
  config.vm.provision :shell do |shell|
	shell.path = "provisioning/run-ansible-playbook.sh"
	shell.args = _host_user
  end

end
