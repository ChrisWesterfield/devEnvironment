# -*- mode: ruby -*-
# vi: set ft=ruby :
###################################################
# Vagrant Environment Config                      #
# Author: Chris Westerfield                       #
# Email: chris@mjr.one                            #
###################################################

require 'yaml'

VAGRANTFILE_API_VERSION ||= "2"
confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))

vagrantYamlPath = confDir + "/vagrant/etc/config.yaml"
afterScriptPath = confDir + "/vagrant/etc/after.sh"
aliasesPath = confDir + "/vagrant/etc/aliases"


require File.expand_path(File.dirname(__FILE__) + '/bin/vm/vagrant.rb')

Vagrant.require_version '>= 1.9.0'

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
      if File.exist? aliasesPath then
          config.vm.provision "file", source: aliasesPath, destination: "/tmp/bash_aliases"
          config.vm.provision "shell" do |s|
              s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /tmp/bash_aliases > /home/vagrant/.bash_aliases"
          end
      end
      if File.exist? vagrantYamlPath then
          settings = YAML::load(File.read(vagrantYamlPath))
      else
          abort "vagrant settings file not found in #{confDir}"
      end

      if (settings.has_key?("sites") and settings["sites"].count() > 0)
          hosts = []
          settings['sites'].each do |k,v|
                hosts.push(v['map'])
          end
          if Vagrant.has_plugin?('vagrant-hostsupdater')
            config.hostsupdater.aliases = hosts
          elsif Vagrant.has_plugin?('vagrant-hostmanager')
            config.hostmanager.enabled = true
            config.hostmanager.manage_host = true
            config.hostmanager.aliases = hosts
          end
      end
      VagrantVM.box(config, settings)
      VagrantVM.folders(config, settings)
      Vagrant.configure("2") do |config|
            config.vm.provision "shell", path: "/home/vagrant/base/bin/upgrade.sh"
      end
      VagrantVM.install(config, settings)
      VagrantVM.mjrone(config, settings)
      config.vm.provision :reload

      #triggers
      config.trigger.before :halt do
          info "Stoping Environment and Doing Backups"
          run_remote "/usr/bin/env bash /home/vagrant/base/bin/dbExport.sh"
          run_remote "/usr/bin/env bash /home/vagrant/base/bin/pgsqlExport.sh"
          run_remote "/usr/bin/env bash /home/vagrant/base/bin/mongoExport.sh"
      end

    config.trigger.after :up do
        info "Starting Environment"
        run_remote "/usr/bin/env bash /home/vagrant/base/bin/restartNginx.sh"
        run_remote "/usr/bin/env bash /home/vagrant/base/bin/setSystemCtl.sh"
    end
end
