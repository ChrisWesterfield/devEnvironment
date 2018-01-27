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

require File.expand_path(File.dirname(__FILE__) + '/scripts/homestead.rb')

Vagrant.require_version '>= 1.9.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    if File.exist? aliasesPath then
        config.vm.provision "file", source: aliasesPath, destination: "/tmp/bash_aliases"
        config.vm.provision "shell" do |s|
            s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /tmp/bash_aliases > /home/vagrant/.bash_aliases"
        end
    end

    if File.exist? homesteadYamlPath then
        settings = YAML::load(File.read(vagrantYamlPath))
    else
        abort "vagrant settings file not found in #{confDir}"
    end

    Homestead.configure(config, settings)

    if File.exist? afterScriptPath then
        config.vm.provision "shell", path: afterScriptPath, privileged: false, keep_color: true
    end

    if Vagrant.has_plugin?('vagrant-hostsupdater')
        config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
        config.hostsupdater.aliases = [ "profiler." + settings['name'], "pma." + settings['name'], "info." + settings['name'], "rabbit." + settings['name'], "search." + settings['name'], "kibana." + settings['name'], "mail." + settings['name'], "cockpit." + settings['name'], "ui." + settings['name']]
    elsif Vagrant.has_plugin?('vagrant-hostmanager')
        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
        config.hostmanager.aliases = settings['sites'].map { |site| site['map'] }
    end

    #triggers
    config.trigger.before :halt do
        info "Stoping Environment"
        run_remote "bash /vagrant/bin/stopTasks.sh"
    end

    config.trigger.after :up do
        info "Starting Environment"
        run_remote "bash /vagrant/bin/startTasks.sh"
    end
end
