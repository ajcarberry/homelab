# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "baseimages/ubuntu-1542866700.box"
  config.vm.define :devVM do |t|
  end

  # Create a public network, which allows public network access via host
  #config.vm.network "public_network", bridge: "en5: Display Ethernet"
  config.vm.network "public_network", bridge: "en0: Wi-Fi (Wireless)"

  # Provider-specific configuration
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    # Set the name of the vm created in VB
    vb.name = "devVM"
    # Customize the amount of memory and cpu on the VM:
    vb.memory = 2048
    vb.cpus = 1
    vb.customize ["modifyvm", :id, "--vram", "128"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  # Enable provisioning with Ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/dev-machine.yml"
    ansible.groups = {
      "devEnv" => ["devVM"]
    }
#    ansible.verbose = "-vvv"
  end

end
