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
    app.vm.box = "precise64"
    app.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box"
    app.vm.network :private_network, ip: "10.10.10.100"
    app.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 2048]
        case os
        when /linux/
          v.customize ["modifyvm", :id, "--cpus", `grep "^processor" /proc/cpuinfo | wc -l`.chomp]
        when /macosx/
          v.customize ["modifyvm", :id, "--cpus", `sysctl -n hw.ncpu`.chomp]
        end
      end
    end

    
    config.vm.provision :ansible do |ansible|
      ansible.host_key_checking = false
      ansible.playbook = "install.yml"
      ansible.inventory_path = "inventory/vagrant"
      ansible.limit = 'all'
   end
end
