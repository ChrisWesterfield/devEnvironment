<?php
$versions = [];
if(count($argv)>1)
{
    foreach($argv as $item)
    {
        switch ($item)
        {
            case '56':
                $versions[] = '5.6';
                break;
            case '70':
                $versions[] = '7.0';
                break;
            case '71':
                $versions[] = '7.1';
                break;
            case '72':
                $versions[] = '7.2';
                break;
        }
    }
}
else
{
    $versions[] = '5.6';
    $versions[] = '7.0';
    $versions[] = '7.1';
    $versions[] = '7.2';
}
foreach($versions as $version)
{
    $ini = file_get_contents('/vagrant/etc/php/xdebug.' . $version . '.ini');
    $ini = str_replace(
        [
            ';zend_extension=xdebug.so',
            'xdebug.remote_enable=0',
            'xdebug.remote_connect_back=0',
            'xdebug.default_enable = 0',
            'xdebug.remote_autostart = 0',
            'xdebug.remote_connect_back = 0',
        ]
        ,
        [
            'zend_extension=xdebug.so',
            'xdebug.remote_enable=1',
            'xdebug.remote_connect_back=1',
            'xdebug.default_enable = 1',
            'xdebug.remote_autostart = 1',
            'xdebug.remote_connect_back = 1',
        ]
        ,
        $ini
    );
    file_put_contents('/vagrant/etc/php/xdebug.' . $version . '.ini', $ini);
}