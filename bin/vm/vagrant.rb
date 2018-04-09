class VagrantVM
    def VagrantVM.box(config, settings)
        ENV['VAGRANT_DEFAULT_PROVIDER'] = settings["provider"] ||= "virtualbox"
        # Allow SSH Agent Forward from The Box
        config.ssh.forward_agent = true
        # Configure The Box
        config.vm.define settings["name"] ||= settings["name"]
        config.vm.box = settings["box"] ||= "bento/ubuntu-16.04"
        config.vm.box_version = settings["version"] ||= ">= 4.0.0"
        config.vm.hostname = settings["hostname"] ||= settings["name"]

        # Configure A Private Network IP
        if settings["ip"] != "autonetwork"
            config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.42"
        else
            config.vm.network :private_network, :ip => "0.0.0.0", :auto_network => true
        end

        # Configure Additional Networks
        if settings.has_key?("networks")
            settings["networks"].each do |network|
                config.vm.network network["type"], ip: network["ip"], bridge: network["bridge"] ||= nil, netmask: network["netmask"] ||= "255.255.255.0"
            end
        end
        # Configure A Few VirtualBox Settings
        config.vm.provider "virtualbox" do |vb|
            vb.name = settings["name"] ||= settings["name"]
            vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
            vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
            vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
            vb.customize ["modifyvm", :id, "--natdnshostresolver1", settings["natdnshostresolver"] ||= "on"]
            vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
            if settings.has_key?("gui") && settings["gui"]
                vb.gui = true
            end
        end

        # Override Default SSH port on the host
        if (settings.has_key?("default_ssh_port"))
            config.vm.network :forwarded_port, guest: 22, host: settings["default_ssh_port"], auto_correct: false, id: "ssh"
        end

        # Configure A Few VMware Settings
        ["vmware_fusion", "vmware_workstation"].each do |vmware|
            config.vm.provider vmware do |v|
                v.vmx["displayName"] = settings["name"] ||= settings["name"]
                v.vmx["memsize"] = settings["memory"] ||= 2048
                v.vmx["numvcpus"] = settings["cpus"] ||= 1
                v.vmx["guestOS"] = "ubuntu-64"
                if settings.has_key?("gui") && settings["gui"]
                    v.gui = true
                end
            end
        end

        # Configure A Few Parallels Settings
        config.vm.provider "parallels" do |v|
            v.name = settings["name"] ||= settings["name"]
            v.update_guest_tools = settings["update_parallels_tools"] ||= false
            v.memory = settings["memory"] ||= 2048
            v.cpus = settings["cpus"] ||= 1
        end

        # Standardize Ports Naming Schema
        if (settings.has_key?("ports"))
            settings["ports"].each do |port|
                port["guest"] ||= port["to"]
                port["host"] ||= port["send"]
                port["protocol"] ||= "tcp"
            end
        else
            settings["ports"] = []
        end
        # Configure The Public Key For SSH Access
        if settings.include? 'authorize'
            if File.exists? File.expand_path(settings["authorize"])
                config.vm.provision "shell" do |s|
                    s.inline = "echo $1 | grep -xq \"$1\" /home/vagrant/.ssh/authorized_keys || echo \"\n$1\" | tee -a /home/vagrant/.ssh/authorized_keys"
                    s.args = [File.read(File.expand_path(settings["authorize"]))]
                end
            end
        end

        # Copy The SSH Private Keys To The Box
        if settings.include? 'keys'
            if settings["keys"].to_s.length == 0
                puts "Check your config.yaml file, you have no private key(s) specified."
                exit
            end
            settings["keys"].each do |key|
                if File.exists? File.expand_path(key)
                    config.vm.provision "shell" do |s|
                        s.privileged = false
                        s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
                        s.args = [File.read(File.expand_path(key)), key.split('/').last]
                    end
                else
                    puts "Check your config.yaml file, the path to your private key does not exist."
                    exit
                end
            end
        end
    end

    def VagrantVM.folders(config, settings)
        if settings.include? 'folders'
            settings["folders"].each do |folder|
                if File.exists? File.expand_path(folder["map"])
                    mount_opts = []

                    if (folder["type"] == "nfs")
                        mount_opts = folder["mount_options"] ? folder["mount_options"] : ['actimeo=1', 'nolock']
                    elsif (folder["type"] == "smb")
                        mount_opts = folder["mount_options"] ? folder["mount_options"] : ['vers=3.02', 'mfsymlinks']
                    end

                    # For b/w compatibility keep separate 'mount_opts', but merge with options
                    options = (folder["options"] || {}).merge({ mount_options: mount_opts })

                    # Double-splat (**) operator only works with symbol keys, so convert
                    options.keys.each{|k| options[k.to_sym] = options.delete(k) }

                    config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil, **options

                    # Bindfs support to fix shared folder (NFS) permission issue on Mac
                    if (folder["type"] == "nfs")
                        if Vagrant.has_plugin?("vagrant-bindfs")
                            config.bindfs.bind_folder folder["to"], folder["to"]
                        end
                    end
                else
                    config.vm.provision "shell" do |s|
                        s.inline = ">&2 echo \"Unable to mount one of your folders. Please check your folders in config.yaml\""
                    end
                end
            end
        end
    end
    def VagrantVM.install(config, settings)
        scriptDir = File.dirname(__FILE__)
        #Configure BASHRC
        config.vm.provision "shell", run: "always" do |s|
            s.name = "Configuring Profile"
            s.path = scriptDir + "/profile.sh"
        end

        # Copy User Files Over to VM
        if settings.include? 'copy'
            settings["copy"].each do |file|
                config.vm.provision "file", run: "always" do |f|
                    f.source = File.expand_path(file["from"])
                    f.destination = file["to"].chomp('/') + "/" + file["from"].split('/').last
                end
            end
        end
        config.vm.provision "shell", run: "once" do |s|
            s.name = "Preparing Environment"
            s.path = scriptDir + "/base.sh"
        end
    end
    def VagrantVM.mjrone(config, settings)
        scriptDir = File.dirname(__FILE__)
        config.vm.provision "shell" do |s|
            s.privileged = false
            s.name = "Installing System Packages according to config.yaml"
            s.inline = "/home/vagrant/system/system mjrone:install"
        end
        config.vm.provision "shell" do |s|
            s.privileged = false
            s.name = "Creating FPM Pools"
            s.inline = "/home/vagrant/system/bin/system mjrone:sites:phpfpm"
        end
        config.vm.provision "shell" do |s|
            s.privileged = false
            s.name = "Creating Web Server Config Files"
            s.inline = "/home/vagrant/system/bin/system mjrone:sites:web"
        end
    end
end