# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos-64-x64-vbox4210"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

#  config.vm.box = "precise"
#  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

# config.vm.box = "lxc-raring-amd64-2013-07-12"
# config.vm.box_url = http://dl.dropbox.com/u/13510779/lxc-raring-amd64-2013-07-12.box

#  config.vm.box = "lxc-centos6.5-2013-12-02"
#  config.vm.box_url = "https://dl.dropboxusercontent.com/s/x1085661891dhkz/lxc-centos6.5-2013-12-02.box"

  config.vm.define "client" do |client|
    config.vm.box = "centos-64-x64-vbox4210"
    config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    config.vm.hostname = "elk-client01.ghostlab.net"
    config.vm.provider "virtualbox" do |vm|
      vm.name = "elk-client"
      vm.memory = 1024
    end
    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "site.pp"
      puppet.module_path = "modules"
      config.vm.network "private_network", ip: "192.168.65.11"
      puppet.facter = {
        "vagrant" => "1"
      }    
    end
    config.vm.synced_folder "data", "/vagrant_data"
  end

  config.vm.define "server" do |server|
    config.vm.box = "centos-64-x64-vbox4210"
    config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
    config.vm.hostname = "elk-server01.ghostlab.net"
    config.vm.provider "virtualbox" do |vm|
      vm.name = "elk-server"
      vm.memory = 1024
    end
    config.vbguest.auto_update = false
    config.vm.network "private_network", ip: "192.168.65.10"
    config.ssh.forward_agent = true
    config.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "site.pp"
      puppet.module_path = "modules"
      puppet.facter = {
        "vagrant" => "1"
      }    
    end
    config.vm.synced_folder "data", "/vagrant_data"
  end
end
