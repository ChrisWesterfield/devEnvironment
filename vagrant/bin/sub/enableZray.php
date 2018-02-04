<?php
$ini = file_get_contents('/vagrant/etc/php/zray.ini');
$ini = str_replace(
    [
        ';zend_extension=/opt/zray/lib/zray.so',
        ';zray.install_dir=/opt/zray',
    ]
    ,
    [
        'zend_extension=/opt/zray/lib/zray.so',
        'zray.install_dir=/opt/zray',
    ]
    ,
    $ini
);
file_put_contents('/vagrant/etc/php/zray.ini', $ini);