<?php
declare(strict_types=1);
$cfg['host'] = '127.0.0.1';
$tmp = [];
$masterHome = '/home/vagrant/.';
$masterConfig = json_decode(file_get_contents(__DIR__.'/../config.json'), true);
if(file_exists($masterHome.'maria'))
{
    if(file_exists($masterHome.'mariaMultiMaster'))
    {
        $sCount = 1;
        $tmp[] = [
            'name'        => 'MariaDB Master',
            'host'        => '127.0.0.1',
            'port'        => '3306',
            'description' => 'MariaDB',
            'db'          => true,
        ];
        if(array_key_exists('mariadbMultiMasterCount', $masterConfig['features']) && $masterConfig['features']['mariadbMultiMasterCount'] > 0)
        {
            for($i=0;$i<$masterConfig['features']['mariadbMultiMasterCount'];$i++)
            {
                $tmp[] = [
                    'name'        => 'MariaDB Slave'.$sCount,
                    'host'        => '127.0.0.1',
                    'port'        => '330'.(7+$i),
                    'description' => 'MariaDB Slave Server ('.'330'.(7+$i).')',
                    'db'          => true,
                ];
                $sCount++;
            }
        }

        if($sCount%2 > 0)
        {
            $tmp[] = [];
        }
    }
    else
    {
        $tmp[] = [
            'name'        => 'MySQL Master',
            'host'        => '127.0.0.1',
            'port'        => '3306',
            'description' => 'MySQL DB',
            'db'          => true,
        ];
        $tmp[] = [];
    }
    $tmp[] = [];
    $tmp[] = [];
}
if(file_exists($masterHome.'nginx'))
{
    $tmp[] = [
        'name'        => 'NginX Web',
        'port'        => '80',
        'description' => 'NginX Web Server HTTP',
        'db'          => false,
    ];
    $tmp[] = [
        'name'        => 'NginX Web',
        'port'        => '443',
        'description' => 'NginX Web Server HTTPS',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
}

$subConfig = [];
if(array_key_exists('php72', $masterConfig))
{
    $subConfig[] = [
        'name'        => 'PHP-FPM-7.2',
        'port'        => '9072',
        'description' => 'Application Server PHP7.2 - www',
        'db'          => false,
    ];
}
if(array_key_exists('php71', $masterConfig))
{
    $subConfig[] = [
        'name'        => 'PHP-FPM-7.1',
        'port'        => '9071',
        'description' => 'Application Server PHP7.1 - www',
        'db'          => false,
    ];
}
if(array_key_exists('php70', $masterConfig))
{
    $subConfig[] = [
        'name'        => 'PHP-FPM-7.0',
        'port'        => '9070',
        'description' => 'Application Server PHP7.0 - www',
        'db'          => false,
    ];
}
if(array_key_exists('php56', $masterConfig))
{
    $subConfig[] = [
        'name'        => 'PHP-FPM-5.6',
        'port'        => '9056',
        'description' => 'Application Server PHP5.6 - www',
        'db'          => false,
    ];
}

if(array_key_exists('fpm',$masterConfig)) {
    foreach ($masterConfig['fpm'] as $config)
    {
        if(array_key_exists('listen', $config) && strpos($config['listen'], '127.0.0.1:')!==false)
        $subConfig[] = [
            'name'        => 'PHP-FPM-'.$config['version'],
            'port'        => str_replace('127.0.0.1:','',$config['listen']),
            'description' => 'Application Server PHP'.$config['version'].' '.$config['name'],
            'db'          => false,
        ];
    }
}

if(count($subConfig)%2 === 1)
{
    $subConfig[]=[];
}
$subConfig[]=[];
$subConfig[]=[];

$tmp = array_merge($tmp, $subConfig);


if(file_exists($masterHome.'postgresql'))
{

    $tmp[] = [
        'name'        => 'PgSQL',
        'port'        => '5432',
        'description' => 'PostgreSQL Server',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'apache2'))
{
    $tmp[] = [
        'name'        => 'Apache2 Web Server',
        'port'        => '80',
        'description' => 'Apache2 Web Server HTTP',
        'db'          => false,
    ];
    $tmp[] = [
        'name'        => 'Apache2 Web Server',
        'port'        => '443',
        'description' => 'Apache2 Web Server HTTPS',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'ngroked'))
{

    $tmp[] = [
        'name'        => 'NgrokD',
        'port'        => '4040',
        'description' => 'NgrokD Dev Server Forwarding',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'mailhog'))
{
    $tmp[] = [
        'name'        => 'SMTP Server',
        'port'        => '1025',
        'description' => 'Mail Hog Smtp Server',
        'db'          => false,
    ];
    $tmp[] = [
        'name'        => 'SMTP Server UI',
        'port'        => '8025',
        'description' => 'Mail Hog Ui',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
}

$tmp[] = [
    'name'        => 'SSH Server',
    'port'        => '22',
    'description' => 'SSH Server',
    'db'          => false,
];
$tmp[] = [];
$tmp[] = [];
$tmp[] = [];

if(file_exists($masterHome.'elasticsearch'))
{
    $tmp[] = [
        'name'        => 'Elastic Search Web',
        'port'        => '9200',
        'description' => 'Elastic Search Service',
        'db'          => false,
    ];
    $tmp[] = [
        'name'        => 'Elastic Search Data',
        'port'        => '9300',
        'description' => 'Elastic Search Service',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'kibana'))
{
    $tmp[] = [
        'name'        => 'Kibana',
        'port'        => '5601',
        'description' => 'Kibana Elastic Search UI',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'logstash'))
{
    $tmp[] = [
        'name'        => 'Logstash',
        'port'        => '5000',
        'description' => 'Logstash Loging Service',
        'db'          => false,
    ];
    $tmp[] = [
        'name'        => 'Logstash',
        'port'        => '9600',
        'description' => 'Logstash Loging Service',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'redis'))
{
    $tmp[] = [
        'name'        => 'Redis',
        'port'        => '6379',
        'description' => 'Redis Server',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'memcached'))
{
    $tmp[] = [
        'name'        => 'Memcache',
        'port'        => '11211',
        'description' => 'Memcache Server',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'jenkins'))
{
    $tmp[] = [
        'name'        => 'Jenkins',
        'port'        => '8080',
        'description' => 'Jenkins Build Server',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'mongo'))
{

    $tmp[] = [
        'name'        => 'MongoDB',
        'port'        => '27017',
        'description' => 'Mongo DB Server for xhprof',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'beanstalkd'))
{
    $tmp[] = [
        'name'        => 'BeanstalkeD',
        'port'        => '11300',
        'description' => 'Jenkins Build Server',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'rabbitmq'))
{
    $tmp[] = [
        'name'        => 'Rabbit MQ',
        'port'        => '5672',
        'description' => 'Rabbit MQ Server',
        'db'          => false,
    ];
    $tmp[] = [
        'name'        => 'Admin',
        'port'        => '15672',
        'description' => 'Rabbit MQ Admin Server',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'cockpit'))
{
    $tmp[] = [
        'name'        => 'Cockpit',
        'port'        => '9090',
        'description' => 'Cockpit Server',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'couch'))
{
    $tmp[] = [
        'name'        => 'CouchDB',
        'port'        => '5984',
        'description' => 'CouchDB Server',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'statsd'))
{
    $tmp[] = [
        'name'        => 'StatsD',
        'port'        => '8082',
        'description' => 'StatsD Server',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}

if(file_exists($masterHome.'darkstat'))
{
    $tmp[] = [
        'name'        => 'Darkstat',
        'port'        => '667',
        'description' => 'Darkstat Server',
        'db'          => false,
    ];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
}
return $tmp;