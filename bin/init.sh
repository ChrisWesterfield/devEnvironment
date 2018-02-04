
#!/usr/bin/env bash

/usr/bin/env vagrant plugin install vagrant-triggers
/usr/bin/env vagrant plugin install vagrant-reload
/usr/bin/env vagrant plugin install vagrant-hostsupdater

if [[ -n "$1" ]]; then
    cp -i resources/config.yaml config.yaml
fi

cp -i resources/after.sh vagrant/after.sh
cp -i resources/aliases vagrant/aliases

echo "Environment initialized!"