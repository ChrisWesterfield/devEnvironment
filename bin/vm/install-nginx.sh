#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ -f /home/vagrant/.nginx ]
then
    echo "NGINX already installed."
    exit 0
fi
touch /home/vagrant/.nginx
sudo apt-get install -y \
    libxml2-dev \
    libxslt1-dev  \
    libgeoip-dev  \
    libgoogle-perftools-dev \
    libperl-dev \
    libpcre++-dev \
    libcurl4-openssl-dev \
    libssl-dev

cd /vagrant/src/nginx/nginx-1.13.4
sudo chmod -R 0777 /vagrant/src/nginx/nginx-1.13.4
sudo make clean
sudo ./configure \
  --prefix=/usr/share/nginx \
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/lock/nginx.lock \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/access.log \
  --user=www-data \
  --group=www-data \
  --build=MJR-ONE-NGINX-1.13.4 \
  --with-threads \
  --with-file-aio \
  --with-http_gzip_static_module \
  --with-http_realip_module \
  --with-http_xslt_module \
  --with-http_geoip_module \
  --with-http_dav_module \
  --with-http_flv_module \
  --with-http_mp4_module \
  --with-http_gunzip_module \
  --with-http_secure_link_module \
  --with-http_random_index_module \
  --with-http_auth_request_module \
  --with-http_stub_status_module \
  --with-http_perl_module \
  --with-mail=dynamic \
  --with-mail_ssl_module \
  --with-stream=dynamic \
  --with-stream_ssl_module \
  --with-google_perftools_module \
  --with-pcre \
  --add-dynamic-module=/vagrant/src/nginx/headers-more-nginx-module-master \
  --add-dynamic-module=/vagrant/src/nginx/naxsi-master/naxsi_src \
  --add-dynamic-module=/vagrant/src/nginx/nginx-upload-progress-module-master \
  --add-dynamic-module=/vagrant/src/nginx/ngx_http_accounting_module-master \
  --add-dynamic-module=/vagrant/src/nginx/nginx-module-vts-master \
  --add-dynamic-module=/vagrant/src/nginx/graphite-nginx-module-master \
  --with-http_ssl_module \
  --with-http_v2_module


sudo make -j `cat /proc/cpuinfo | grep processor | wc -l`

sudo make install

sudo cp /vagrant/src/nginx/nginx.service /lib/systemd/system/nginx.service
sudo systemctl daemon-reload
sudo systemctl enable nginx.service
sudo rm -Rf /etc/nginx/
tar xzf /vagrant/nginx-etc.tgz  -C /etc/nginx
sudo /usr/sbin/service nginx restart
