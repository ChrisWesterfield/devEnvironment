<?php
$config = file_get_contents('/home/vagrant/errbit.install.log');
$config = explode('Creating an initial admin user:',$config);
$config = $config[1];
$config = explode('Be sure to note down these credentials now!', $config);
$config = $config[0];
$config = explode('-- email:    ',$config);
$config = $config[1];
$config = explode('-- password: ',$config);
$user = str_replace("\n","",$config[0]);
$user = trim($user);
$password = str_replace("\n","",$config[1]);
$password = trim($password);
unset($config);
if(file_exists('/home/vagrant/.userData'))
{
    $config = json_decode(file_get_contents('/home/vagrant/.userData'),true);
}

if(empty($config))
{
    $config = [];
}

$config['errbit'] = [
    'username'=>$user,
    'password'=>$password,
];

file_put_contents('/home/vagrant/.userData',json_encode($config));