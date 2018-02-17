require 'json'
class VagrantVM
    def VagrantVM.box(config, settings)
        features = settings["features"]
        # Set The VM Provider
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
            if features.has_key?("gui") && features["gui"]
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
                if features.has_key?("gui") && features["gui"]
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
    end
    def VagrantVM.install(config, settings)

        # Configure Local Variable To Access Scripts From Remote Location

        scriptDir = File.dirname(__FILE__)

        jsonSites = settings.to_json;

        siteProfiler = "profiler." + settings["name"]
        siteSearch = "search." + settings["name"]
        sitePma = "pma." + settings["name"]
        siteRabbit = "rabbit." + settings["name"]
        siteKibana = "kibana." + settings["name"]
        siteMail = "mail." + settings["name"]
        siteCockpit = "cockpit." + settings["name"]
        siteUi = "ui." + settings["name"]
        siteBuild = "build." + settings["name"]
        siteStart = settings["name"]
        siteStatsd = "statsd." + settings['name']
        siteInfo56 = 'info56.' + settings['name']
        siteInfo70 = 'info70.' + settings['name']
        siteInfo71 = 'info71.' + settings['name']
        siteInfo72 = 'info72.' + settings['name']
        siteDarkstat = 'darkstat.' + settings['name']
        siteErrbit = 'errbit.'+settings['name']
        siteBeanStalkdAdmin = 'bda.'+settings['name']
        siteMunin = 'munin.' + settings['name']
        siteCouchDB = 'couch'+settings['name']
        sitePhpMDa = 'phpmda'+settings['name']

        features = settings["features"]

        # Configure to use bash instead of sh
        config.vm.provision "shell" do |s|
            s.name = "Configuring Bash"
            s.privileged = true
            s.inline = "echo \"dash dash/sh boolean false\" | sudo debconf-set-selections && sudo dpkg-reconfigure -f noninteractive dash"
        end

        #Configure BASHRC
        config.vm.provision "shell" do |s|
            s.name = "Configuring Profile"
            s.path = scriptDir + "/configure/profile.sh"
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
            s.name = "Preparing Environment"
            s.path = scriptDir + "/configure/prepare-vm.sh"
        end

        # Install All The Configured Nginx Sites
        if features.has_key?("nginx") && features["nginx"] == true
            config.vm.provision "shell" do |s|
                s.name = "Install Nginx"
                s.path = scriptDir + "/install/nginx.sh"
            end
        end

        #Install PHP
        if features.has_key?("apache2") && features["apache2"] == true
            apache2php="7.2"
            if features.has_key?("apache2php")
                apache2php=features["apache2php"]
            end
            config.vm.provision "shell" do |s|
                s.name = "Installing Apache2"
                s.path = scriptDir + "/install/apache2.sh"
                s.args = [ apache2php ]
            end
        end


        # Install PHP5.6 If Necessary
        if (features.has_key?("php56") && features["php56"] == true) || (features.has_key?("phpmda") && features["phpmda"] == true)
            config.vm.provision "shell" do |s|
                s.name = "Installing PHP 5.6"
                s.path = scriptDir + "/install/php5.6.sh"
            end
        end


        # Install PHP7.0 If Necessary
        if features.has_key?("php70") && features["php70"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing PHP 7.0"
                s.path = scriptDir + "/install/php7.0.sh"
            end
        end


        # Install PHP7.1 If Necessary
        if features.has_key?("php71") && features["php71"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing PHP 7.1"
                s.path = scriptDir + "/install/php7.1.sh"
            end
        end


        # Install PHP7.1 If Necessary
        if features.has_key?("php72") && features["php72"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing PHP7.2"
                s.path = scriptDir + "/install/php7.2.sh"
            end
        end

        #Install PHP
        if features.has_key?("php") && features["php"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing PHP Plugins"
                s.path = scriptDir + "/install/php.sh"
            end
        end

        # Install Blackfire If Necessary
        if features.has_key?("blackfire") && features["blackfire"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Blackfire"
                s.path = scriptDir + "/install/blackfire.sh"
            end
        end

        # Configure All Of The Server Environment Variables
        config.vm.provision "shell" do |s|
            s.name = "Clear Variables"
            s.path = scriptDir + "/cleanup/variables.sh"
        end

        config.vm.provision "shell" do |s|
            s.name = "Restarting Cron"
            s.inline = "sudo service cron restart"
        end

        config.vm.provision "shell" do |s|
            s.name = "Restarting Apache2"
            s.inline = "/vagrant/bin/restartWeb.sh"
        end

        # Install MariaDB If Necessary
        if features.has_key?("mariadb") && features["mariadb"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Maria DB"
                s.path = scriptDir + "/install/maria.sh"
            end
        end

        # Install MariaDB If Necessary
        if features.has_key?("mariadb") && features["mariadb"] == true && features.has_key?("mariadbMultiMaster") && features["mariadbMultiMaster"] == true && features.has_key?("mariadbMultiMasterCount")
            config.vm.provision "shell" do |s|
                s.name = "Configuring Master + Slave Servers"
                s.path = scriptDir + "/configure/masterSlave.sh"
                s.args = [features["mariadbMultiMasterCount"]]
            end
        end

        # Install MongoDB If Necessary
        if (features.has_key?("mongodb") && features["mongodb"] == true) || (features.has_key?("xhgui") && features["xhgui"] == true) || (features.has_key?("errbit") && features["errbit"] == true)
            config.vm.provision "shell" do |s|
                s.name = "Installing MongoDB"
                s.path = scriptDir + "/install/mongo.sh"
            end
        end

        # Install CouchDB If Necessary
        if features.has_key?("couchdb") && features["couchdb"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing CouchDB"
                s.path = scriptDir + "/install/couch.sh"
            end
        end

        # Install Elasticsearch If Necessary
        if features.has_key?("elasticsearch") && features["elasticsearch"]
            config.vm.provision "shell" do |s|
                s.name = "Installing Elasticsearch"
                if features["elasticsearch"] == 6
                    s.path = scriptDir + "/install/elasticsearch6.sh"
                else
                    s.path = scriptDir + "/install/elasticsearch5.sh"
                end
            end
        end

        # Install Kibana If Necessary
        if features.has_key?("kibana") && features["kibana"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Kibana"
                s.path = scriptDir + "/install/kibana.sh"
            end
        end

        # Install Kibana If Necessary
        if features.has_key?("logstash") && features["logstash"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Logstash"
                s.path = scriptDir + "/install/logstash.sh"
            end
        end

        #Install Composer
        config.vm.provision "shell" do |s|
            s.name = "Installing Composer"
            s.path = scriptDir + "/install/composer.sh"
            s.privileged = true
        end

        # Update Composer On Every Provision
        config.vm.provision "shell" do |s|
            s.name = "Update Composer"
            s.inline = "sudo /usr/local/bin/composer self-update --no-progress && sudo chown -R vagrant:vagrant /home/vagrant/.composer/"
            s.privileged = false
        end

        # Configure Blackfire.io
        if features.has_key?("blackfire") && features["blackfire"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Blackfire"
                s.path = scriptDir + "/configure/blackfire.sh"
                s.args = [
                    settings["blackfire"]["id"],
                    settings["blackfire"]["token"],
                    settings["blackfire"]["client-id"],
                    settings["blackfire"]["client-token"]
                ]
            end
        end

        if features.has_key?("ngrok") && features["ngrok"] == true
            # Add config file for ngrok
            config.vm.provision "shell" do |s|
                s.name = "Installing NGROK"
                s.path = scriptDir + "/install/ngrok.sh"
                s.privileged = true
            end
        end

        # Install Profiler If Necessary
        if features.has_key?("profiler") && features["profiler"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Profiler"
                s.path = scriptDir + "/install/profiler.sh"
            end
        end

        # Install Redis If Necessary
        if features.has_key?("redis") && features["redis"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Redis"
                s.path = scriptDir + "/install/redis.sh"
            end
        end

        # Install Memcached If Necessary
        if features.has_key?("memcache") && features["memcache"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Memcached"
                s.path = scriptDir + "/install/memcached.sh"
            end
        end

        # Install MailHog If Necessary
        if features.has_key?("mailhog") && features["mailhog"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing MailHog"
                s.path = scriptDir + "/install/mailhog.sh"
            end
        end

        # Install NodeJs If Necessary
        if features.has_key?("nodejs") && features["nodejs"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing NodeJS"
                s.path = scriptDir + "/install/nodejs.sh"
            end
        end

        # Install Java If Necessary
        if features.has_key?("java") && features["java"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Java"
                s.path = scriptDir + "/install/java.sh"
            end
        end

        # Install ANT If Necessary
        if features.has_key?("ant") && features["ant"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing ANT"
                s.path = scriptDir + "/install/ant.sh"
            end
        end

        # Install SuperVisord If Necessary
        if features.has_key?("supervisor") && features["supervisor"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing SuperVisord"
                s.path = scriptDir + "/install/supervisord.sh"
            end
        end

        # Install RabbitMQ If Necessary
        if features.has_key?("rabbitmq") && features["rabbitmq"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing RabbitMQ"
                s.path = scriptDir + "/install/rabbitmq.sh"
            end
        end

        # Configuring If Necessary PHPMyAdmin
        if features.has_key?("mariadb") && features["mariadb"] == true && features.has_key?("phpma") && features["phpma"] == true
            config.vm.provision "shell" do |s|
                s.name = "Configuring PHPMyAdmin"
                s.path = scriptDir + "/install/phpmyadmin.sh"
                s.privileged = false
            end
        end

        # Configuring If Necessary XHGui
        if features.has_key?("xhgui") && features["xhgui"] == true
            config.vm.provision "shell" do |s|
                s.name = "Configuring XHGui"
                s.path = scriptDir + "/install/xhgui.sh"
                s.privileged = false
            end
        end

        if features.has_key?("php72") && features["php72"] == true
            config.vm.provision "shell" do |s|
                s.name = "enable PHP7.2-FPM"
                s.path = scriptDir + "/configure/enableService.sh"
                s.privileged = true
                s.args = ["php7.2-fpm"]
            end
        else
            config.vm.provision "shell" do |s|
                s.name = "Disabling PHP7.2-FPM"
                s.path = scriptDir + "/configure/disableService.sh"
                s.privileged = true
                s.args = ["php7.2-fpm"]
            end
        end
        if features.has_key?("php71") && features["php71"] == true
            config.vm.provision "shell" do |s|
                s.name = "enable PHP7.1-FPM"
                s.path = scriptDir + "/configure/enableService.sh"
                s.privileged = true
                s.args = [ "php7.1-fpm"]
            end
        else
            config.vm.provision "shell" do |s|
                s.name = "Disabling PHP7.1-FPM"
                s.path = scriptDir + "/configure/disableService.sh"
                s.privileged = true
                s.args = [ "php7.1-fpm"]
            end
        end

        if features.has_key?("php70") && features["php70"] == true
            config.vm.provision "shell" do |s|
                s.name = "enable PHP7.0-FPM"
                s.path = scriptDir + "/configure/enableService.sh"
                s.privileged = true
                s.args = ["php7.0-fpm"]
            end
        else
            config.vm.provision "shell" do |s|
                s.name = "Disabling PHP7.0-FPM"
                s.path = scriptDir + "/configure/disableService.sh"
                s.privileged = true
                s.args = ["php7.0-fpm"]
            end
        end

        if (features.has_key?("php56") && features["php56"] == true) || (features.has_key?("phpmda") && features["phpmda"] == true)
            config.vm.provision "shell" do |s|
                s.name = "enable PHP5.6-FPM"
                s.path = scriptDir + "/configure/enableService.sh"
                s.privileged = true
                s.args = ["php5.6-fpm"]
            end
        else
            config.vm.provision "shell" do |s|
                s.name = "Disabling PHP5.6-FPM"
                s.path = scriptDir + "/configure/disableService.sh"
                s.privileged = true
                s.args = ["php5.6-fpm"]
            end
        end

        if settings.has_key?("defaultPhp") && (settings["defaultPhp"] == "5.6" || settings["defaultPhp"] == "7.0" || settings["defaultPhp"] == "7.1" || settings["defaultPhp"] == "7.2")
            config.vm.provision "shell" do |s|
                s.name = "Setting Default PHP to " + settings["defaultPhp"]
                s.path = scriptDir + "/configure/phpShell.sh"
                s.privileged = true
                s.args = [ settings["defaultPhp"] ]
            end
        end

        # Install If Necessary Docker
        if features.has_key?("docker") && features["docker"] == true
            config.vm.provision "shell" do |s|
                s.name = "Install Docker Environment"
                s.path = scriptDir + "/install/docker.sh"
            end
        end

        # Install If Necessary Cockpit
        if features.has_key?("cockpit") && features["cockpit"] == true
            config.vm.provision "shell" do |s|
                s.name = "Install Cockpit Environment"
                s.path = scriptDir + "/install/cockpit.sh"
            end
        end

        # Install If Necessary Statsd
        if features.has_key?("statsd") && features["statsd"] == true
            config.vm.provision "shell" do |s|
                s.name = "Install Statsd Environment"
                s.path = scriptDir + "/install/statsd.sh"
            end
        end

        # Install If Necessary Jenkins
        if features.has_key?("jenkins") && features["jenkins"] == true
            config.vm.provision "shell" do |s|
                s.name = "Install Jenkins Environment"
                s.path = scriptDir + "/install/jenkins.sh"
            end
        end

        if features.has_key?("sqlite") && features["sqlite"]
            config.vm.provision "shell" do |s|
                s.name = "Installing sqlite"
                s.path = scriptDir + "/install/sqllite.sh"
            end
        end

        if features.has_key?("beanstalkd") && features["beanstalkd"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing beanstalkd"
                s.path = scriptDir + "/install/beanstalkd.sh"
            end
        end

        if features.has_key?("ohmyzsh") && features["ohmyzsh"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Oh My ZSH"
                s.path = scriptDir + "/install/oh-my-zsh.sh"
            end
        end

        if features.has_key?("postgresql") && features["postgresql"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing postgresql"
                s.path = scriptDir + "/install/postgresql.sh"
            end
        end

        if features.has_key?("zray") && features["zray"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing zray"
                s.path = scriptDir + "/install/zray.sh"
            end
        end

        if features.has_key?("qatools") && features["qatools"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing qatools"
                s.path = scriptDir + "/install/qatools.sh"
            end
        end

        if features.has_key?("webdriver") && features["webdriver"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing WebDriver"
                s.path = scriptDir + "/install/webdriver.sh"
            end
        end

        if features.has_key?("yarn") && features["yarn"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Yarn"
                s.path = scriptDir + "/install/yarn.sh"
            end
        end

        if features.has_key?("darkstat") && features["darkstat"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Yarn"
                s.path = scriptDir + "/install/darkstat.sh"
            end
        end

        if features.has_key?("errbit") && features["errbit"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Errbit"
                s.path = scriptDir + "/install/errbit.sh"
                s.args = [ siteErrbit, settings['name'] ]
            end
        end

        if features.has_key?("wpcli") && features["wpcli"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing WordPress CLI"
                s.path = scriptDir + "/install/wpcli.sh"
            end
        end

        if features.has_key?("flyway") && features["flyway"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing FlyWay"
                s.path = scriptDir + "/install/flyway.sh"
            end
        end

        if features.has_key?("beanstalkdadmin") && features["beanstalkdadmin"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Beanstalkd Admin Console"
                s.path = scriptDir + "/install/beanstalkadmin.sh"
            end
        end

        if features.has_key?("munin") && features["munin"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Munin"
                s.path = scriptDir + "/install/munin.sh"
                s.privileged = true
                s.args = [ settings['name'] ]
            end
        end

        if features.has_key?("phpmda") && features["phpmda"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing PHP MongoDB Admin"
                s.path = scriptDir + "/install/PhpMongoDbAdmin.sh"
                s.privileged = false
            end
        end

        if features.has_key?("hhvm") && features["hhvm"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing HHVM"
                s.path = scriptDir + "/install/hhvm.sh"
                s.privileged = true
            end
        end

        config.vm.provision "shell" do |s|
            s.name = "Fixing Home Directory"
            s.inline = "/vagrant/bin/chown-home.sh"
            s.privileged = false
        end



    end
    def VagrantVM.ngrok(config, settings)
        features = settings["features"]
        scriptDir = File.dirname(__FILE__)
        if features.has_key?("ngrok") && settings["ngrok"] == true
            #configure ngrok
            config.vm.provision "shell" do |s|
                s.name = "Creating NGROK Config"
                s.path = scriptDir + "/create/ngrok.sh"
                s.args = [settings["ip"]]
                s.privileged = false
            end
        end
    end
    def VagrantVM.database(config, settings)
        features = settings["features"]
        scriptDir = File.dirname(__FILE__)
        # Configure All Of The Configured Databases
        if settings.has_key?("databases")
            settings["databases"].each do |db|
                if db["type"] == "mysql"
                    if features.has_key?("mariadb") && features["mariadb"]
                        config.vm.provision "shell" do |s|
                            s.name = "Creating MySQL Database: " + db["name"]
                            s.path = scriptDir + "/create/mysql.sh"
                            s.args = [db["name"]]
                        end
                        if db.has_key?("user")
                            db["user"].each do |user|
                                if user.has_key?("type")
                                    permission=user["type"]
                                else
                                    permission="write"
                                end
                                config.vm.provision "shell" do |s|
                                    s.name = "Creating MySQL Database: " + db["name"]
                                    s.path = scriptDir + "/create/mysqlUser.sh"
                                    s.args = [db["name"], user["name"], user["password"], permission ]
                                end
                            end
                        end
                    end
                end

                if db["type"] == "pgsql"
                    if features.has_key?("postgresql") && features["postgresql"]
                        config.vm.provision "shell" do |s|
                            s.name = "Creating Postgres Database: " + db["name"]
                            s.path = scriptDir + "/create/postgres.sh"
                            s.args = [db["name"]]
                        end
                    end
                end

                if db["type"] == "mongodb"
                    if features.has_key?("mongodb") && features["mongodb"]
                        config.vm.provision "shell" do |s|
                            s.name = "Creating Mongo Database: " + db["name"]
                            s.path = scriptDir + "/create/mongo.sh"
                            s.args = [db["name"]]
                        end
                    end
                end

                if features.has_key?("couchdb") && features["couchdb"]
                    if db["type"] == "couchdb"
                        config.vm.provision "shell" do |s|
                            s.name = "Creating Couch Database: " + db["name"]
                            s.path = scriptDir + "/create/couch.sh"
                            s.args = [db["name"]]
                        end
                    end
                end
            end
        end
    end
    def VagrantVM.configure(config, settings)

        scriptDir = File.dirname(__FILE__)

        jsonSites = settings.to_json;

        siteProfiler = "profiler." + settings["name"]
        siteSearch = "search." + settings["name"]
        sitePma = "pma." + settings["name"]
        siteRabbit = "rabbit." + settings["name"]
        siteKibana = "kibana." + settings["name"]
        siteMail = "mail." + settings["name"]
        siteCockpit = "cockpit." + settings["name"]
        siteUi = "ui." + settings["name"]
        siteBuild = "build." + settings["name"]
        siteStart = settings["name"]
        siteStatsd = "statsd." + settings['name']
        siteInfo56 = 'info56.' + settings['name']
        siteInfo70 = 'info70.' + settings['name']
        siteInfo71 = 'info71.' + settings['name']
        siteInfo72 = 'info72.' + settings['name']
        siteDarkstat = 'darkstat.' + settings['name']
        siteErrbit = 'errbit.'+settings['name']
        siteBeanStalkdAdmin = 'bda.'+settings['name']
        siteMunin = 'munin.'+settings['name']
        siteCouchDB = 'couch'+settings['name']
        sitePhpMDa = 'phpmda'+settings['name']
        features = settings["features"]

        #nginx / apache2 configs

        #clear nginx confs
        config.vm.provision "shell" do |s|
            s.name = "Cleaning Up NGINX Home Directory"
            s.path = scriptDir + "/cleanup/nginx.sh"
        end



        if settings.has_key?("variables")
            settings["variables"].each do |var|
                if (features.has_key?("php56") && features["php56"] == true) || (features.has_key?("phpmda") && features["phpmda"] == true)
                    config.vm.provision "shell" do |s|
                        s.name = "Provision PHP 5.6 Pool"
                        s.inline = "echo \"\nenv[$1] = '$2'\" >> /vagrant/etc/php/5.6/fpm/pool.d/www.conf"
                        s.args = [var["key"], var["value"]]
                    end
                end

                if features.has_key?("php70") && features["php70"] == true
                    config.vm.provision "shell" do |s|
                        s.name = "Provision PHP 7.0 Pool"
                        s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php/7.0/fpm/pool.d/www.conf"
                        s.args = [var["key"], var["value"]]
                    end
                end

                if features.has_key?("php71") && features["php71"] == true
                    config.vm.provision "shell" do |s|
                        s.name = "Provision PHP 7.1 Pool"
                        s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php/7.1/fpm/pool.d/www.conf"
                        s.args = [var["key"], var["value"]]
                    end
                end

                if features.has_key?("php72") && features["php72"] == true
                    config.vm.provision "shell" do |s|
                        s.name = "Provision PHP 7.2 Pool"
                        s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php/7.2/fpm/pool.d/www.conf"
                        s.args = [var["key"], var["value"]]
                    end
                end

                config.vm.provision "shell" do |s|
                    s.name = "Setting Vagrant Environmental Variables"
                    s.inline = "echo \"\n# Set Vagrant Environment Variable\nexport $1=$2\" >> /home/vagrant/.profile"
                    s.args = [var["key"], var["value"]]
                end
            end
        end

        if features.has_key?("php72") && features["php72"] == true
            config.vm.provision "shell" do |s|
                s.name = "cleaning up FPM Configs 7.2"
                s.path = scriptDir + "/cleanup/phpFpmConfig.sh"
                s.args = [ "7.2" ]
            end
        end

        if features.has_key?("php71") && features["php71"] == true
            config.vm.provision "shell" do |s|
                s.name = "cleaning up FPM Configs 7.1"
                s.path = scriptDir + "/cleanup/phpFpmConfig.sh"
                s.args = [ "7.1" ]
            end
        end

        if features.has_key?("php70") && features["php70"] == true
            config.vm.provision "shell" do |s|
                s.name = "cleaning up FPM Configs 7.0"
                s.path = scriptDir + "/cleanup/phpFpmConfig.sh"
                s.args = [ "7.0" ]
            end
        end

        if (features.has_key?("php56") && features["php56"] == true) || (features.has_key?("phpmda") && features["phpmda"] == true)
            config.vm.provision "shell" do |s|
                s.name = "cleaning up FPM Configs 5.6"
                s.path = scriptDir + "/cleanup/phpFpmConfig.sh"
                s.args = [ "5.6" ]
            end
        end

        fpmWorker = Hash.new
        if settings.has_key?("fpm")
            settings["fpm"].each do |phpfpm|
                if phpfpm.has_key?("name") && phpfpm.has_key?("name") && ( ( phpfpm["version"] == "7.2" &&  features.has_key?("php72") && features["php72"] == true ) || ( phpfpm["version"] == "7.1" &&  features.has_key?("php71") && features["php71"] == true ) || ( phpfpm["version"] == "7.0" &&  features.has_key?("php70") && features["php70"] == true ) || ( phpfpm["version"] == "5.6" &&  features.has_key?("php56") && features["php56"] == true ) || (features.has_key?("phpmda") && features["phpmda"] == true))
                    setVersion = phpfpm["version"]
                    setName = phpfpm["name"]
                    if phpfpm.has_key?("listen")
                        setListen = phpfpm["listen"]
                    else
                        setListen = "/var/run/php-"+setName+".pid"
                    end
                    if phpfpm.has_key?("pm") && phpfpm["pm"] == "ondemand" && phpfpm.has_key?("max_spare")
                        setPm = "ondemand"
                        setMin = 0
                        setMax = 0
                        setMaxChildren = phpfpm["max_spare"]
                        setStartProcess = 0else
                        if phpfpm.has_key?("pm") && phpfpm["pm"] == "static" && phpfpm.has_key?("max_children")
                            setPm = "static"
                            setMin = 0
                            setMax = 0
                            setMaxChildren = phpfpm["max_children"]
                            setStartProcess = 0
                        else
                            setPm = "dynamic"
                            if phpfpm.has_key?("min_spare")
                                setMin = phpfpm["min_spare"]
                            else
                                setMin = 1
                            end
                            if phpfpm.has_key?("start_process") && setMin > phpfpm["start_process"]
                                setStartProcess = phpfpm["start_process"]
                            else
                                setStartProcess = setMin
                            end
                            if phpfpm.has_key?("max_spare") && phpfpm["max_spare"] >=setMin
                                setMax = phpfpm["max_spare"]
                            else
                                setMax = setMin
                            end
                            if phpfpm.has_key?("max_children") && phpfpm["max_children"] >=setMax
                                setMaxChildren = phpfpm["max_spare"]
                            else
                                setMaxChildren = setMax
                            end
                        end
                    end
                    if phpfpm.has_key?("log_errors") && phpfpm["log_errors"] == true
                        setLogError = 0
                    else
                        setLogError = 1
                    end
                    if phpfpm.has_key?("display_errors") && phpfpm["display_errors"] == false
                        setDisplayError = 0
                    else
                        setDisplayError = 1
                    end
                    if phpfpm.has_key?("xdebug") && phpfpm["xdebug"] == true
                        setXdebug = 1
                    else
                        setXdebug = 0
                    end
                    if phpfpm.has_key?("max_ram")
                        setMaxRam = phpfpm["max_ram"]
                    else
                        setMaxRam = "128M"
                    end
                    if phpfpm.has_key?("fpm_log")
                        setLog = phpfpm["fpm_log"]
                    else
                        setLog = "/vagrant/log/php-fpm." + setVersion + ".log"
                    end
                    config.vm.provision "shell" do |s|
                        s.name = "Creating PHP Config Version: " + setVersion + " FPM Name: "+setName
                        s.path = scriptDir + "/serve/phpFpm.sh"
                        s.args = [setName, setVersion, setListen, setPm, setMin, setMax, setMaxChildren, setStartProcess, setXdebug, setMaxRam, setLog, setLogError, setDisplayError]
                    end
                    fpmWorker[setName] = setListen
                end
            end
        end

        if (features.has_key?("php56") && features["php56"] == true) || (features.has_key?("phpmda") && features["phpmda"] == true)
            config.vm.provision "shell" do |s|
                s.name = "restarting Services"
                s.inline = "service php5.6-fpm restart;"
            end
        end

        if features.has_key?("php70") && features["php70"] == true
            config.vm.provision "shell" do |s|
                s.name = "restarting Services"
                s.inline = "service php7.0-fpm restart;"
            end
        end

        if features.has_key?("php71") && features["php71"] == true
            config.vm.provision "shell" do |s|
                s.name = "restarting Services"
                s.inline = "service php7.1-fpm restart;"
            end
        end

        if features.has_key?("php72") && features["php72"] == true
            config.vm.provision "shell" do |s|
                s.name = "restarting Services"
                s.inline = "service php7.2-fpm restart;"
            end
        end

        if settings.include? 'sites'
            settings["sites"].each do |site|

                if (site.has_key?("type") && site['type'] != "ignore")

                    if (features.has_key?("serverHttp") && features["serverHttp"] == true) or (site.has_key?("serverHttp") && site["serverHttp"] == true)
                        http = 1
                    else
                        http = 0
                    end

                    # Create SSL certificate
                    config.vm.provision "shell" do |s|
                        s.name = "Creating Certificate: " + site["map"]
                        s.path = scriptDir + "/create/certificate.sh"
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
                        if site.has_key?("fpm") && fpmWorker.has_key?(site["fpm"])
                            customWorker = fpmWorker[site["fpm"]]
                            site["php"] = "custome"
                        else
                            customWorker = "none"
                        end
                        s.path = scriptDir + "/serve/#{type}.sh"
                        s.args = [site["map"], site["to"], site["port"] ||= "80", site["ssl"] ||= "443", site["php"] ||= "7.2", params ||= "", site["zray"] ||= "false", http, customWorker]

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

                    if site["type"] == "apache"
                        config.vm.provision "shell" do |s|
                            s.path = scriptDir + "/serve/proxy.sh"
                            s.args = [
                                site["map"],
                                "81",
                                "80",
                                "443",
                                http
                            ]
                        end
                    end

                    # Configure The Cron Schedule
                    if (site.has_key?("schedule"))
                        config.vm.provision "shell" do |s|
                            s.name = "Creating Schedule"

                            if (site["schedule"])
                                s.path = scriptDir + "/create/cron-schedule.sh"
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
                else
                    if (site["function"] == 'profiler')
                        siteProfiler = site["map"];
                    end
                    if (site["function"] == 'search')
                        siteSearch = site["map"];
                    end
                    if (site["function"] == 'pma')
                        sitePma = site["map"];
                    end
                    if (site["function"] == 'rabbit')
                        siteRabbit = site["map"];
                    end
                    if (site["function"] == 'kibana')
                        siteKibana = site["map"];
                    end
                    if (site["function"] == 'mail')
                        siteMail = site["map"];
                    end
                    if (site["function"] == 'cockpit')
                        siteCockpit = site["map"];
                    end
                    if (site["function"] == 'ui')
                        siteUi = site["map"];
                    end
                    if (site["function"] == 'build')
                        siteBuild = site["map"];
                    end
                    if ( site["function"] == 'startpage' )
                        siteStart = site["map"];
                    end
                    if ( site["function"] == 'statsd' )
                        siteStatsd = site["map"];
                    end
                    if ( site["function"] == 'php56' )
                        sitePhp56 = site["map"];
                    end
                    if ( site["function"] == 'php70' )
                        sitePhp70 = site["map"];
                    end
                    if ( site["function"] == 'php71' )
                        sitePhp71 = site["map"];
                    end
                    if ( site["function"] == 'php72' )
                        sitePhp72 = site["map"];
                    end
                    if ( site["function"] == 'darkstat' )
                        siteErrbit = site["map"];
                    end
                    if ( site["function"] == 'errbit' )
                        sitePhp72 = site["map"];
                    end
                    if ( site["function"] == 'beanstalkdAdmin' )
                        siteBeanStalkdAdmin = site["map"];
                    end
                    if ( site["function"] == 'munin' )
                        siteMunin = site["map"];
                    end
                    if ( site["function"] == 'couchDbUi' )
                        siteCouchDB = site["map"];
                    end
                    if ( site["function"] == 'phpmda' )
                        sitePhpMDa = site["map"];
                    end
                end
            end
        end

        # Install Elasticsearch If Necessary
        if features.has_key?("elasticsearch") && features["elasticsearch"]
            config.vm.provision "shell" do |s|
                s.name = "Installing Web Host Elasticsearch"
                s.path = scriptDir + "/serve/proxy.sh"
                s.args = [
                    siteSearch,
                    "9200",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteSearch
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteSearch]
            end
        end
        if features.has_key?("kibana") && features["kibana"] == true
            config.vm.provision "shell" do |s|
                s.name = "Configure Kibana Proxy"
                s.path = scriptDir + "/serve/proxy.sh"
                s.args = [
                    siteKibana,
                    "5601",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteKibana
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteKibana]
            end
        end
        # Install MailHog If Necessary
        if features.has_key?("mailhog") && features["mailhog"] == true
            config.vm.provision "shell" do |s|
                s.name = "Creating MailHog  Proxy"
                s.path = scriptDir + "/serve/proxy.sh"
                s.args = [
                    siteMail,
                    "8025",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteMail
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteMail]
            end
        end
        # Install RabbitMQ If Necessary
        if features.has_key?("rabbitmq") && features["rabbitmq"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Host for RabbitMQ"
                s.path = scriptDir + "/serve/proxy.sh"
                s.args = [
                    siteRabbit,
                    "15672",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteRabbit
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteRabbit]
            end
        end
        if features.has_key?("mariadb") && features["mariadb"] == true && features.has_key?("phpma") && features["phpma"] == true
            config.vm.provision "shell" do |s|
                s.name ="Configuring PHPMyAdmin"
                s.path = scriptDir + "/configure/phpmyadmin.sh"
                s.privileged = false
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Host for phpMyAdmin"
                s.path = scriptDir + "/serve/pma.sh"
                s.args = [
                    sitePma,
                    "80",
                    "443",
                    "7.2"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + sitePma
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [sitePma]
            end
        end
        # Configuring If Necessary XHGui
        if features.has_key?("xhgui") && features["xhgui"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing XHGui Host"
                s.path = scriptDir + "/serve/xhgui.sh"
                s.args = [
                    siteProfiler,
                    "80",
                    "443",
                    "7.2"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteProfiler
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteProfiler]
            end
        end

        config.vm.provision "shell" do |s|
            s.path = scriptDir + "/serve/statamic.sh"
            s.name = "Installing Host for System Start Site"
            s.args = [
                siteStart,
                "/vagrant/system",
                "80",
                "443",
                "7.2"
            ]
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteStart
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteStart]
            end
        end
        if features.has_key?("php72") && features["php72"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Host Site for PHP7.2 phpinfo"
                s.path = scriptDir + "/serve/statamic.sh"
                s.args = [
                    siteInfo72,
                    "/vagrant/system/php72",
                    "80",
                    "443",
                    "7.2"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteInfo72
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteInfo72]
            end
        end
        if features.has_key?("php71") && features["php71"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Host Site for PHP7.1 phpinfo"
                s.path = scriptDir + "/serve/statamic.sh"
                s.args = [
                    siteInfo71,
                    "/vagrant/system/php71",
                    "80",
                    "443",
                    "7.1"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteInfo71
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteInfo71]
            end
        end
        if features.has_key?("php70") && features["php70"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Host Site for PHP7.0 phpinfo"
                s.path = scriptDir + "/serve/statamic.sh"
                s.args = [
                    siteInfo70,
                    "/vagrant/system/php70",
                    "80",
                    "443",
                    "7.0"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteInfo70
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteInfo70]
            end
        end
        if (features.has_key?("php56") && features["php56"] == true)||(features.has_key?("phpmda") && features["phpmda"] == true)
            config.vm.provision "shell" do |s|
                s.name = "Installing Host Site for PHP5.6 phpinfo"
                s.path = scriptDir + "/serve/statamic.sh"
                s.args = [
                    siteInfo56,
                    "/vagrant/system/php56",
                    "80",
                    "443",
                    "5.6"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteInfo56
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteInfo56]
            end
        end
        # Install If Necessary Docker
        if features.has_key?("docker") && features["docker"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Docker Gui Site"
                s.path = scriptDir + "/serve/proxy.sh"
                s.args = [
                    siteUi,
                    "8020",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteUi
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteUi]
            end
        end
        if features.has_key?("cockpit") && features["cockpit"] == true
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteCockpit
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteCockpit]
            end
            config.vm.provision "shell" do |s|
                s.name = "Installing Cockpit Environment Site"
                s.path = scriptDir + "/serve/proxy.sh"
                s.args = [
                    siteCockpit,
                    "9090",
                    "80",
                    "443"
                ]
            end
        end
        # Install If Necessary Statsd
        if features.has_key?("statsd") && features["statsd"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing statsd Site"
                s.path = scriptDir + "/serve/grafana.sh"
                s.args = [
                    siteStatsd,
                    "8082",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteStatsd
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteStatsd]
            end
        end
        # Install If Necessary Jenkins
        if features.has_key?("jenkins") && features["jenkins"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Jenkins Site"
                s.path = scriptDir + "/serve/proxy.sh"
                s.args = [
                    siteBuild,
                    "8080",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteBuild
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteBuild]
            end
        end

        #darkstat
        if features.has_key?("darkstat") && features["darkstat"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing DarkStat Site"
                s.path = scriptDir + "/serve/proxy.sh"
                s.args = [
                    siteDarkstat,
                    "667",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteDarkstat
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteDarkstat]
            end
        end

        #errbit
        if features.has_key?("errbit") && features["errbit"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Errbit Site"
                s.path = scriptDir + "/serve/proxy.sh"
                s.args = [
                    siteErrbit,
                    "8030",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteErrbit
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteErrbit]
            end
        end

        if features.has_key?("beanstalkdadmin") && features["beanstalkdadmin"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Host Site for Beanstalkd Admin"
                s.path = scriptDir + "/serve/statamic.sh"
                s.args = [
                    siteBeanStalkdAdmin,
                    "/home/vagrant/beanstalkd/public",
                    "80",
                    "443",
                    "7.2"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteBeanStalkdAdmin
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteBeanStalkdAdmin]
            end
        end

        if features.has_key?("couchdbui") && features["couchdbui"] == true

        end

        if features.has_key?("munin") && features["munin"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Host Site for Munin"
                s.path = scriptDir + "/serve/html.sh"
                s.args = [
                    siteMunin,
                    "80",
                    "443",
                    "/home/vagrant/munin",
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteMunin
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteMunin]
            end
        end
        if features.has_key?("couchdbui") && features["couchdbui"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Host Site for CouchDbUi"
                s.path = scriptDir + "/serve/proxy.sh"
                s.args = [
                    siteCouchDB,
                    "5984",
                    "80",
                    "443"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + siteCouchDB
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [siteCouchDB]
            end
        end
        if features.has_key?("phpmda") && features["phpmda"] == true
            config.vm.provision "shell" do |s|
                s.name = "Installing Host Site for PHP MongoDB Admin"
                s.path = scriptDir + "/serve/statamic.sh"
                s.args = [
                    sitePhpMDa,
                    "/home/vagrant/phpma",
                    "80",
                    "443",
                    "5.6"
                ]
            end
            config.vm.provision "shell" do |s|
                s.name = "Creating Certificate: " + sitePhpMDa
                s.path = scriptDir + "/create/certificate.sh"
                s.args = [sitePhpMDa]
            end
        end

        config.vm.provision "shell" do |s|
            s.name = "Saving Site Configuration"
            s.path = scriptDir + "/save_sites.sh"
            s.args = [jsonSites]
        end
        config.vm.provision "shell" do |s|
            s.inline = "/vagrant/bin/restartWeb.sh"
            s.privileged = false
        end
    end
    def VagrantVM.upgradeSystem(config)
        scriptDir = File.dirname(__FILE__)
        config.vm.provision "shell" do |s|
            s.path = scriptDir + "/upgrade.system.sh"
            s.name = "Updating Base Software"
            s.privileged = true
        end
        config.vm.provision "shell" do |s|
            s.inline = "/vagrant/bin/restartMySQL.sh"
            s.privileged = false
        end
        config.vm.provision "shell" do |s|
            s.inline = "/vagrant/bin/restartRabbitMq.sh"
            s.privileged = false
        end
    end
end