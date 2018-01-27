class VagrantVM
    def VagrantVM.configure(config, settings)
        # Set The VM Provider
        ENV['VAGRANT_DEFAULT_PROVIDER'] = settings["provider"] ||= "virtualbox"

        # Configure Local Variable To Access Scripts From Remote Location
        scriptDir = /vagrant/bin

        # Allow SSH Agent Forward from The Box
        config.ssh.forward_agent = true

        # Configure The Box
        config.vm.define settings["name"] ||= settings["name"]
        config.vm.box = settings["box"] ||= "bento/ubuntu-17.10"
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

        # Default Port Forwarding
        default_ports = {
            80 => 8000,
            443 => 44300,
            3306 => 33060,
            4040 => 4040,
            5432 => 54320,
            8025 => 8025,
            27017 => 27017
        }

        # Use Default Port Forwarding Unless Overridden
        unless settings.has_key?("default_ports") && settings["default_ports"] == false
            default_ports.each do |guest, host|
                unless settings["ports"].any? { |mapping| mapping["guest"] == guest }
                    config.vm.network "forwarded_port", guest: guest, host: host, auto_correct: true
                end
            end
        end

        # Add Custom Ports From Configuration
        if settings.has_key?("ports")
            settings["ports"].each do |port|
                config.vm.network "forwarded_port", guest: port["guest"], host: port["host"], protocol: port["protocol"], auto_correct: true
            end
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

        #Configure Language
        config.vm.provision "shell" do |s|
            s.privileged = true
            s.inline = "export LC_ALL=en_US.UTF-8 >> /etc/profile"
        end
        config.vm.provision "shell" do |s|
            s.privileged = true
            s.inline = "export LANG=en_US.UTF-8 >> /etc/profile"
        end

        #Configure BASHRC
        config.vm.provision "shell" do |s|
            s.privileged = false
            s.inline = "echo "source /vagrant/.bash_profile" >> /home/vagrant/.bashrc"
        end

        # Copy User Files Over to VM
        if settings.include? 'copy'
            settings["copy"].each do |file|
                config.vm.provision "file" do |f|
                    f.source = File.expand_path(file["from"])
                    f.destination = file["to"].chomp('/') + "/" + file["from"].split('/').last
                end
            end
        end

        # Register All Of The Configured Shared Folders
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

        #Prepare Environment
        config.vm.provision "shell" do |s|
            s.path = scriptDir + "/prepare.sh"
        end

        #Install and Compile nginx
        config.vm.provision "shell" do |s|
            s.path = scriptDir + "/clear-nginx.sh"
        end

        # Install All The Configured Nginx Sites
        config.vm.provision "shell" do |s|
            s.path = scriptDir + "/install-nginx.sh"
        end


        # Install PHP5.6 If Necessary
        if settings.has_key?("php56") && settings["php56"]
            config.vm.provision "shell" do |s|
                s.name = "Installing PHP 5.6"
                s.path = scriptDir + "/install-php5.6.sh"
            end
        end


        # Install PHP7.0 If Necessary
        if settings.has_key?("php70") && settings["php70"]
            config.vm.provision "shell" do |s|
                s.name = "Installing PHP 7.0"
                s.path = scriptDir + "/install-php7.0.sh"
            end
        end


        # Install PHP7.1 If Necessary
        if settings.has_key?("php71") && settings["php71"]
            config.vm.provision "shell" do |s|
                s.name = "Installing PHP 7.1"
                s.path = scriptDir + "/install-phhp7.1.sh"
            end
        end
        config.vm.provision "shell" do |s|
            s.path = scriptDir + "/install-php7.2.sh"
        end

        #Install PHP
        config.vm.provision "shell" do |s|
            s.path = scriptDir + "/install-php.sh"
        end

        if settings.include? 'sites'
            settings["sites"].each do |site|

                # Create SSL certificate
                config.vm.provision "shell" do |s|
                    s.name = "Creating Certificate: " + site["map"]
                    s.path = scriptDir + "/create-certificate.sh"
                    s.args = [site["map"]]
                end

                type = site["type"] ||= "laravel"

                if (type == "symfony")
                    type = "symfony2"
                end

                config.vm.provision "shell" do |s|
                    s.name = "Creating Site: " + site["map"]
                    if site.include? 'params'
                        params = "("
                        site["params"].each do |param|
                            params += " [" + param["key"] + "]=" + param["value"]
                        end
                        params += " )"
                    end
                    s.path = scriptDir + "/serve-#{type}.sh"
                    s.args = [site["map"], site["to"], site["port"] ||= "80", site["ssl"] ||= "443", site["php"] ||= "7.2", params ||= "", site["zray"] ||= "false"]

                    if site["zray"] == 'true'
                        config.vm.provision "shell" do |s|
                            s.inline = "ln -sf /opt/zray/gui/public " + site["to"] + "/ZendServer"
                        end
                    else
                        config.vm.provision "shell" do |s|
                            s.inline = "rm -rf " + site["to"] + "/ZendServer"
                        end
                    end
                end

                # Configure The Cron Schedule
                if (site.has_key?("schedule"))
                    config.vm.provision "shell" do |s|
                        s.name = "Creating Schedule"

                        if (site["schedule"])
                            s.path = scriptDir + "/cron-schedule.sh"
                            s.args = [site["map"].tr('^A-Za-z0-9', ''), site["to"]]
                        else
                            s.inline = "rm -f /etc/cron.d/$1"
                            s.args = [site["map"].tr('^A-Za-z0-9', '')]
                        end
                    end
                else
                    config.vm.provision "shell" do |s|
                        s.name = "Checking for old Schedule"
                        s.inline = "rm -f /etc/cron.d/$1"
                        s.args = [site["map"].tr('^A-Za-z0-9', '')]
                    end
                end
            end
        end

        # Configure All Of The Server Environment Variables
        config.vm.provision "shell" do |s|
            s.name = "Clear Variables"
            s.path = scriptDir + "/clear-variables.sh"
        end

        if settings.has_key?("variables")
            settings["variables"].each do |var|
                config.vm.provision "shell" do |s|
                    s.inline = "echo \"\nenv[$1] = '$2'\" >> /vagrant/etc/php/5.6/fpm/pool.d/www.conf"
                    s.args = [var["key"], var["value"]]
                end

                config.vm.provision "shell" do |s|
                    s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php/7.0/fpm/pool.d/www.conf"
                    s.args = [var["key"], var["value"]]
                end

                config.vm.provision "shell" do |s|
                    s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php/7.1/fpm/pool.d/www.conf"
                    s.args = [var["key"], var["value"]]
                end

                config.vm.provision "shell" do |s|
                    s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php/7.2/fpm/pool.d/www.conf"
                    s.args = [var["key"], var["value"]]
                end

                config.vm.provision "shell" do |s|
                    s.inline = "echo \"\n# Set Homestead Environment Variable\nexport $1=$2\" >> /home/vagrant/.profile"
                    s.args = [var["key"], var["value"]]
                end
            end

            config.vm.provision "shell" do |s|
                s.inline = "service php5.6-fpm restart; service php7.0-fpm restart; service php7.1-fpm restart; service php7.2-fpm restart;"
            end
        end

        config.vm.provision "shell" do |s|
            s.name = "Restarting Cron"
            s.inline = "sudo service cron restart"
        end

        config.vm.provision "shell" do |s|
            s.name = "Restarting Nginx"
            s.inline = "sudo service nginx restart; sudo service php5.6-fpm restart; sudo service php7.0-fpm restart; sudo service php7.1-fpm restart; sudo service php7.2-fpm restart"
        end

        # Install MariaDB If Necessary
        if settings.has_key?("mariadb") && settings["mariadb"]
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/install-maria.sh"
            end
        end

        # Install MariaDB If Necessary
        if settings.has_key?("mariadbMultiMaster") && settings["mariadbMultiMaster"] && settings.has_key?("mariadbMultiMasterCount")
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/configure-masterSlave.sh " + settings["mariadbMultiMasterCount"]
            end
        end

        # Install MongoDB If Necessary
        if settings.has_key?("mongodb") && settings["mongodb"]
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/install-mongo.sh"
            end
        end

        # Install CouchDB If Necessary
        if settings.has_key?("couchdb") && settings["couchdb"]
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/install-couch.sh"
            end
        end

        # Install Elasticsearch If Necessary
        if settings.has_key?("elasticsearch") && settings["elasticsearch"]
            config.vm.provision "shell" do |s|
                s.name = "Installing Elasticsearch"
                if settings["elasticsearch"] == 6
                    s.path = scriptDir + "/install-elasticsearch6.sh"
                else
                    s.path = scriptDir + "/install-elasticsearch5.sh"
                end
            end
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/serve-proxy.sh"
                s.args = [
                    "search."+settings["name"],
                    "9200",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + "search."+settings["name"]
                s.path = scriptDir + "/create-certificate.sh"
                s.args = ["search."+settings["name"]]
            end
        end

        # Install Kibana If Necessary
        if settings.has_key?("kibana") && settings["kibana"]
            config.vm.provision "shell" do |s|
                s.name = "Installing Kibana"
                s.path = scriptDir + "/install-kibana.sh"
            end
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/serve-proxy.sh"
                s.args = [
                    "kibana."+settings["name"],
                    "5601",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + "kibana."+settings["name"]
                s.path = scriptDir + "/create-certificate.sh"
                s.args = ["kibana."+settings["name"]]
            end
        end

        # Install Kibana If Necessary
        if settings.has_key?("logstash") && settings["logstash"]
            config.vm.provision "shell" do |s|
                s.name = "Installing Logstash"
                s.path = scriptDir + "/install-logstash.sh"
            end
        end

        # Configure All Of The Configured Databases
        if settings.has_key?("databases")
            settings["databases"].each do |db|
                config.vm.provision "shell" do |s|
                    s.name = "Creating MySQL Database: " + db
                    s.path = scriptDir + "/create-mysql.sh"
                    s.args = [db]
                end

                config.vm.provision "shell" do |s|
                    s.name = "Creating Postgres Database: " + db
                    s.path = scriptDir + "/create-postgres.sh"
                    s.args = [db]
                end

                if settings.has_key?("mongodb") && settings["mongodb"]
                    config.vm.provision "shell" do |s|
                        s.name = "Creating Mongo Database: " + db
                        s.path = scriptDir + "/create-mongo.sh"
                        s.args = [db]
                    end
                end

                if settings.has_key?("couchdb") && settings["couchdb"]
                    config.vm.provision "shell" do |s|
                        s.name = "Creating Couch Database: " + db
                        s.path = scriptDir + "/create-couch.sh"
                        s.args = [db]
                    end
                end
            end
        end

        # Update Composer On Every Provision
        config.vm.provision "shell" do |s|
            s.name = "Update Composer"
            s.inline = "sudo /usr/local/bin/composer self-update --no-progress && sudo chown -R vagrant:vagrant /home/vagrant/.composer/"
            s.privileged = false
        end

        # Configure Blackfire.io
        if settings.has_key?("blackfire")
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/blackfire.sh"
                s.args = [
                    settings["blackfire"][0]["id"],
                    settings["blackfire"][0]["token"],
                    settings["blackfire"][0]["client-id"],
                    settings["blackfire"][0]["client-token"]
                ]
            end
        end

        # Add config file for ngrok
        config.vm.provision "shell" do |s|
            s.path = scriptDir + "/create-ngrok.sh"
            s.args = [settings["ip"]]
            s.privileged = false
        end

        # Install Profiler If Necessary
        if settings.has_key?("profiler") && settings["profiler"]
            config.vm.provision "shell" do |s|
                s.name = "Installing Profiler"
                s.path = scriptDir + "/install-profiler.sh"
            end
        end

        # Install Redis If Necessary
        if settings.has_key?("redis") && settings["redis"]
            config.vm.provision "shell" do |s|
                s.name = "Installing Redis"
                s.path = scriptDir + "/install-redis.sh"
            end
        end

        # Install Memcached If Necessary
        if settings.has_key?("memcache") && settings["memcache"]
            config.vm.provision "shell" do |s|
                s.name = "Installing Memcached"
                s.path = scriptDir + "/install-memcache.sh"
            end
        end

        # Install Profiler If Necessary
        if settings.has_key?("profiler") && settings["profiler"]
            config.vm.provision "shell" do |s|
                s.name = "Installing Profiler"
                s.path = scriptDir + "/install-profiler.sh"
            end
        end

        # Install MailHog If Necessary
        if settings.has_key?("mailhog") && settings["mailhog"]
            config.vm.provision "shell" do |s|
                s.name = "Installing MailHog"
                s.path = scriptDir + "/install-mailhog.sh"
            end
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/serve-proxy.sh"
                s.args = [
                    "mail."+settings["name"],
                    "8025",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + "mail."+settings["name"]
                s.path = scriptDir + "/create-certificate.sh"
                s.args = ["mail."+settings["name"]]
            end
        end

        # Install NodeJs If Necessary
        if settings.has_key?("nodejs") && settings["nodejs"]
            config.vm.provision "shell" do |s|
                s.name = "Installing NodeJS"
                s.path = scriptDir + "/install-nodejs.sh"
            end
        end

        # Install Java If Necessary
        if settings.has_key?("java") && settings["java"]
            config.vm.provision "shell" do |s|
                s.name = "Installing Java"
                s.path = scriptDir + "/install-java.sh"
            end
        end

        # Install ANT If Necessary
        if settings.has_key?("ant") && settings["ant"]
            config.vm.provision "shell" do |s|
                s.name = "Installing ANT"
                s.path = scriptDir + "/install-ant.sh"
            end
        end

        # Install SuperVisord If Necessary
        if settings.has_key?("supervisor") && settings["supervisor"]
            config.vm.provision "shell" do |s|
                s.name = "Installing SuperVisord"
                s.path = scriptDir + "/install-supervisord.sh"
            end
        end

        # Install RabbitMQ If Necessary
        if settings.has_key?("rabbitmq") && settings["rabbitmq"]
            config.vm.provision "shell" do |s|
                s.name = "Installing RabbitMQ"
                s.path = scriptDir + "/install-rabbitmq.sh"
            end
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/serve-proxy.sh"
                s.args = [
                    "rabbit."+settings["name"],
                    "15672",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + "rabbit."+settings["name"]
                s.path = scriptDir + "/create-certificate.sh"
                s.args = ["rabbit."+settings["name"]]
            end
        end

        # Configuring If Necessary PHPMyAdmin
        if settings.has_key?("phpma") && settings["phpma"]
            config.vm.provision "shell" do |s|
                s.name = "Configuring PHPMyAdmin"
                s.path = scriptDir + "/configure-pma.sh"
            end
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/serve.pma.sh"
                s.args = [
                    "pma."+settings["name"],
                    "80",
                    "443",
                    "7.2"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + "pma."+settings["name"]
                s.path = scriptDir + "/create-certificate.sh"
                s.args = ["pma."+settings["name"]]
            end
        end

        # Configuring If Necessary XHGui
        if settings.has_key?("xhgui") && settings["xhgui"]
            config.vm.provision "shell" do |s|
                s.name = "Configuring XHGui"
                s.path = scriptDir + "/configure-xhgui.sh"
            end
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/serve.xhgui.sh"
                s.args = [
                    "profiler."+settings["name"],
                    "80",
                    "443",
                    "7.2"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + "profiler."+settings["name"]
                s.path = scriptDir + "/create-certificate.sh"
                s.args = ["profiler."+settings["name"]]
            end
        end

        config.vm.provision "shell" do |s|
            s.path = scriptDir + "/serve-statamic.sh"
            s.args = [
                settings["name"],
                "/vagrant/system",
                "80",
                "443",
                "7.2"
            ]
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + settings["name"]
                s.path = scriptDir + "/create-certificate.sh"
                s.args = [settings["name"]]
            end
        end

        # Install If Necessary Docker
        if settings.has_key?("docker") && settings["docker"]
            config.vm.provision "shell" do |s|
                s.name = "Install Docker Environment"
                s.path = scriptDir + "/install-docker.sh"
            end
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/serve-proxy.sh"
                s.args = [
                    "ui."+settings["name"],
                    "8020",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + "ui."+settings["name"]
                s.path = scriptDir + "/create-certificate.sh"
                s.args = ["ui."+settings["name"]]
            end
        end

        # Install If Necessary Cockpit
        if settings.has_key?("cockpit") && settings["cockpit"]
            config.vm.provision "shell" do |s|
                s.name = "Install Cockpit Environment"
                s.path = scriptDir + "/install-cockpit.sh"
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + "cockpit."+settings["name"]
                s.path = scriptDir + "/create-certificate.sh"
                s.args = ["cockpit."+settings["name"]]
            end
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/serve-proxy.sh"
                s.args = [
                    "cockpit."+settings["name"],
                    "9090",
                    "80",
                    "443"
                ]
            end
        end

        # Install If Necessary Statsd
        if settings.has_key?("statsd") && settings["statsd"]
            config.vm.provision "shell" do |s|
                s.name = "Install Statsd Environment"
                s.path = scriptDir + "/install-statsd.sh"
            end
            config.vm.provision "shell" do |s|
                s.path = scriptDir + "/serve.grafana.sh"
                s.args = [
                    "statsd."+settings["name"],
                    "8080",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + "statsd."+settings["name"]
                s.path = scriptDir + "/create-certificate.sh"
                s.args = ["statsd."+settings["name"]]
            end
        end
    end
end