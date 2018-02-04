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
    $ini = file_get_contents('/vagrant/etc/php/profiler.'.$version.'.ini');
    $string = 'tideways_xhprof.so';
    if($version === '5.6')
    {
        $string = 'xhprof.so';
    }
    $ini = str_replace(
        [
            ';extension='.$string,
        ]
        ,
        [
            'extension='.$string,
        ]
        ,
        $ini
    );
    file_put_contents('/vagrant/etc/php/profiler.'.$version.'.ini', $ini);
}
$ini = file_get_contents('/vagrant/etc/php/profiler.conf');
$ini = str_replace(
    [
        'php_admin_value auto_prepend_file "/vagrant/xhgui/external/header.php"',
    ]
    ,
    [
        '#php_admin_value auto_prepend_file "/vagrant/xhgui/external/header.php"',
    ]
    ,
    $ini);
file_put_contents('/vagrant/etc/php/profiler.conf', $ini);