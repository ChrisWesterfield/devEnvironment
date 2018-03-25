#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

mkdir /etc/nginx/ssl 2>/dev/null

PATH_SSL="/etc/ssl"

if [ ! -d "$PATH_SSL" ]
then
    mkdir   "$PATH_SSL"
fi


if [ ! -d "$PATH_SSL/ca" ]
then
    mkdir   "$PATH_SSL/ca"
fi

if [ ! -d "$PATH_SSL/site" ]
then
    mkdir   "$PATH_SSL/site"
fi

# Path to the custom Vagrant $(hostname) Root CA certificate.
PATH_ROOT_CNF="${PATH_SSL}/ca/vagrant.cnf"
PATH_ROOT_CRT="${PATH_SSL}/ca/vagrant.crt"
PATH_ROOT_KEY="${PATH_SSL}/ca/vagrant.key"

# Path to the custom site certificate.
PATH_CNF="${PATH_SSL}/site/${1}.cnf"
PATH_CRT="${PATH_SSL}/site/${1}.crt"
PATH_CSR="${PATH_SSL}/site/${1}.csr"
PATH_KEY="${PATH_SSL}/site/${1}.key"

BASE_CNF="
    [ ca ]
    default_ca = ca_vagrant_$(hostname)

    [ ca_vagrant_$(hostname) ]
    dir           = $PATH_SSL
    certs         = $PATH_SSL
    new_certs_dir = $PATH_SSL

    private_key   = $PATH_ROOT_KEY
    certificate   = $PATH_ROOT_CRT

    default_md    = sha256

    name_opt      = ca_default
    cert_opt      = ca_default
    default_days  = 365
    preserve      = no
    policy        = policy_loose

    [ policy_loose ]
    countryName             = optional
    stateOrProvinceName     = optional
    localityName            = optional
    organizationName        = optional
    organizationalUnitName  = optional
    commonName              = supplied
    emailAddress            = optional

    [ req ]
    prompt              = no
    encrypt_key         = no
    default_bits        = 2048
    distinguished_name  = req_distinguished_name
    string_mask         = utf8only
    default_md          = sha256
    x509_extensions     = v3_ca

    [ v3_ca ]
    authorityKeyIdentifier = keyid,issuer
    basicConstraints       = critical, CA:true, pathlen:0
    keyUsage               = critical, digitalSignature, keyCertSign
    subjectKeyIdentifier   = hash

    [ server_cert ]
    authorityKeyIdentifier = keyid,issuer:always
    basicConstraints       = CA:FALSE
    extendedKeyUsage       = serverAuth
    keyUsage               = critical, digitalSignature, keyEncipherment
    subjectAltName         = @alternate_names
    subjectKeyIdentifier   = hash
"

# Only generate the root certificate when there isn't one already there.
if [ ! -f $PATH_ROOT_CNF ] || [ ! -f $PATH_ROOT_KEY ] || [ ! -f $PATH_ROOT_CRT ]
then
    #Either recreate the root ca certificate or recover from vagrant directory!
    if [ -f "/vagrant/ssl/vagrant.cnf" ] && [ -f "/vagrant/ssl/vagrant.crt" ] && [ -f "/vagrant/ssl/vagrant.key" ] && [ -f "/vagrant/ssl/vagrant.srl" ]
    then
        cp /vagrant/ssl/vagrant.cnf $PATH_ROOT_CNF
        cp /vagrant/ssl/vagrant.crt $PATH_ROOT_CRT
        cp /vagrant/ssl/vagrant.key $PATH_ROOT_KEY
        cp /vagrant/ssl/vagrant.srl $PATH_SSL/ca/vagrant.srl
    else
        if [ ! -d "/vagrant/ssl" ]
        then
            mkdir /varant/ssl
        else
            rm /vagrant/ssl/*
        fi
        # Generate an OpenSSL configuration file specifically for this certificate.
        cnf="
            ${BASE_CNF}
            [ req_distinguished_name ]
            O  = mjrOne
            C  = DE
            CN = mjr!one $(hostname) Root CA
        "
        echo "$cnf" > $PATH_ROOT_CNF

        # Finally, generate the private key and certificate.
        openssl genrsa -out "$PATH_ROOT_KEY" 4096 2>/dev/null
        openssl req -config "$PATH_ROOT_CNF" \
            -key "$PATH_ROOT_KEY" \
            -x509 -new -extensions v3_ca -days 3650 -sha256 \
            -out "$PATH_ROOT_CRT" 2>/dev/null

        cp $PATH_ROOT_CNF /vagrant/ssl/vagrant.cnf
        cp $PATH_ROOT_CRT /vagrant/ssl/vagrant.crt
        cp $PATH_ROOT_KEY /vagrant/ssl/vagrant.key
        cp $PATH_SSL/ca/vagrant.srl /vagrant/ssl/vagrant.srl
    fi
fi

# Only generate a certificate if there isn't one already there.
if [ ! -f $PATH_CNF ] || [ ! -f $PATH_KEY ] || [ ! -f $PATH_CRT ]
then
    # Uncomment the global 'copy_extentions' OpenSSL option to ensure the SANs are copied into the certificate.
    sed -i '/copy_extensions\ =\ copy/s/^#\ //g' /etc/ssl/openssl.cnf

    # Generate an OpenSSL configuration file specifically for this certificate.
    cnf="
        ${BASE_CNF}
        [ req_distinguished_name ]
        O  = mjrOne
        C  = DE
        CN = $1

        [ alternate_names ]
        DNS.1 = $1
        DNS.2 = *.$1
    "
    echo "$cnf" > $PATH_CNF

    # Finally, generate the private key and certificate signed with the vagrant $(hostname) Root CA.
    openssl genrsa -out "$PATH_KEY" 2048 2>/dev/null
    openssl req -config "$PATH_CNF" \
        -key "$PATH_KEY" \
        -new -sha256 -out "$PATH_CSR" 2>/dev/null
    openssl x509 -req -extfile "$PATH_CNF" \
        -extensions server_cert -days 365 \
        -in "$PATH_CSR" \
        -CA "$PATH_ROOT_CRT" -CAkey "$PATH_ROOT_KEY" -CAcreateserial \
        -out "$PATH_CRT" 2>/dev/null
fi