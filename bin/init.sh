
#!/usr/bin/env bash

if [[ -n "$1" ]]; then
    cp -i resources/config.yaml config.yaml
fi

cp -i resources/after.sh after.sh
cp -i resources/aliases aliases

echo "Environment initialized!"