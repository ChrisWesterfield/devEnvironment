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

vagrantYamlPath = confDir + "/config.yaml"
afterScriptPath = confDir + "/after.sh"
aliasesPath = confDir + "/aliases"

require File.expand_path(File.dirname(__FILE__) + '/bin/vm/vagrant.rb')

Vagrant.require_version '>= 1.9.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
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

    VagrantVM.box(config, settings)
    VagrantVM.install(config, settings)
    VagrantVM.ngrok(config, settings)
    VagrantVM.database(config, settings)
    VagrantVM.configure(config, settings)

    if File.exist? afterScriptPath then
        config.vm.provision "shell", path: afterScriptPath, privileged: false, keep_color: true
    end

    if Vagrant.has_plugin?('vagrant-hostsupdater')
        config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    elsif Vagrant.has_plugin?('vagrant-hostmanager')
        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
        config.hostmanager.aliases = settings['sites'].map { |site| site['map'] }
    end

    #triggers
    config.trigger.before :halt do
        info "Stoping Environment"
        run_remote "bash /vagrant/bin/stopTasks.sh"
        run_remote "/usr/bin/env bash /vagrant/bin/stopErrbit.sh"
        run_remote "/usr/bin/env bash /vagrant/bin/dbExport.sh"
        run_remote "/usr/bin/env bash /vagrant/bin/mongoExport.sh"
    end

    config.trigger.after :up do
        info "Starting Environment"
        run_remote "/usr/bin/env sudo resolvconf -u"
        run_remote "/usr/bin/env bash /vagrant/bin/stopMySQL.sh"
        run_remote "/usr/bin/env bash /vagrant/bin/fixDb.sh"
        run_remote "/usr/bin/env bash /vagrant/bin/restartDb.sh"
        run_remote "/usr/bin/env bash /vagrant/bin/startTasks.sh"
        run_remote "/usr/bin/env bash /vagrant/bin/fix.dns.sh"
        run_remote "/usr/bin/env bash /vagrant/bin/startErrbit.sh"
        run_remote "/usr/bin/env bash /vagrant/bin/startDarkstat.sh"
        run_remote "/usr/bin/env bash /vagrant/bin/restartWeb.sh"
    end
end
