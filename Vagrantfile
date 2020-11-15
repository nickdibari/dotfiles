# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]  # Disable virtualbox logging
  end

  config.vm.define "dotfiles" do |dotfiles|
    dotfiles.vm.synced_folder ".", "/home/vagrant/dotfiles"

    # Add custom colors for VM prompt to separate VM login
    # from local machine bash session
    $provision_script = <<-SCRIPT
    {
      echo "export user_prompt_color=97";
      echo "export host_prompt_color=31";
    } > ~/.dotfiles_config
    SCRIPT

    dotfiles.vm.provision "shell" do |shell|
      shell.inline = $provision_script
      shell.privileged = false
    end
  end
end
