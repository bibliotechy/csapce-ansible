# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

  require 'rbconfig'
  def os
    @os ||= (
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        :linux
      when /solaris|bsd/
        :unix
      else
        raise Error, "unknown os: #{host_os.inspect}"
      end
    )
  end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define "cspace" do |app|
    app.vm.box = "trusty64"
    app.vm.box_url = "https://vagrantcloud.com/ubuntu/boxes/trusty64"
    app.vm.network :private_network, ip: "10.10.10.100"
    app.vm.network :forwarded_port, guest: 8180, host: 8180
    app.vm.network :forwarded_port, guest: 5432, host: 2345
    app.vm.network :forwarded_port, guest: 1043, host:1043
    app.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 3072]
        case os
        when /linux/
          v.customize ["modifyvm", :id, "--cpus", `grep "^processor" /proc/cpuinfo | wc -l`.chomp]
        when /macosx/
          v.customize ["modifyvm", :id, "--cpus", `sysctl -n hw.ncpu`.chomp]
        end
      end
    end

    
    config.vm.synced_folder "src/", "/home/cspace/custom_cspace_source/", owner: "cspace", group: "cspace"  
    config.vm.provision :ansible do |ansible|
      ansible.host_key_checking = false
      ansible.playbook = "install.yml"
      ansible.inventory_path = "inventory/vagrant"
      ansible.limit = 'all'
   end
end
