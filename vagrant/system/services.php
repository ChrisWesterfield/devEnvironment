<?php
declare(strict_types=1);
$cfg['host'] = '127.0.0.1';
$tmp = [
    [
        'name'        => 'MySQL Master',
        'host'        => '127.0.0.1',
        'port'        => '3306',
        'description' => 'MySQL DB',
        'db'          => true,
    ],
    [
        'name'        => 'MySQL Slave',
        'host'        => '127.0.0.1',
        'port'        => '3307',
        'description' => 'MySQL DB',
        'db'          => true,
    ],
    [],
    [],
    [
        'name'        => 'SMTP Server',
        'port'        => '1025',
        'description' => 'Mail Hog Smtp Server',
        'db'          => false,
    ],
    [
        'name'        => 'SMTP Server UI',
        'port'        => '8025',
        'description' => 'Mail Hog Ui',
        'db'          => false,
    ],
    [],
    [],
    [
        'name'        => 'SSH Server',
        'port'        => '22',
        'description' => 'SSH Server',
        'db'          => false,
    ],
    [],
    [],
    [],
    [
        'name'        => 'Elastic Search Web',
        'port'        => '9200',
        'description' => 'Elastic Search Service',
        'db'          => false,
    ],
    [
        'name'        => 'Elastic Search Data',
        'port'        => '9300',
        'description' => 'Elastic Search Service',
        'db'          => false,
    ],
    [],
    [],
    [
        'name'        => 'Kibana',
        'port'        => '5601',
        'description' => 'Kibana Elastic Search UI',
        'db'          => false,
    ],
    [],
    [
        'name'        => 'Logstash',
        'port'        => '5000',
        'description' => 'Logstash Loging Service',
        'db'          => false,
    ],
    [
        'name'        => 'Logstash',
        'port'        => '9600',
        'description' => 'Logstash Loging Service',
        'db'          => false,
    ],
    [],
    [],
    [
        'name'        => 'PHP-APP',
        'port'        => '9000',
        'description' => 'Application Server APP1-5',
        'db'          => false,
    ],
    [
        'name'        => 'PHP-OTHERS',
        'port'        => '9600',
        'description' => 'Application Server for the rest',
        'db'          => false,
    ],
    [],
    [],
    [
        'name'        => 'WEB',
        'port'        => '80',
        'description' => 'Webb Server',
        'db'          => false,
    ],
];
if (extension_loaded('xhprof')) {
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [];
    $tmp[] = [
        'name'        => 'MongoDB',
        'port'        => '27017',
        'description' => 'Mongo DB Server for xhprof',
        'db'          => false,
    ];
    $tmp[] = [
        'name'        => 'MongoDB',
        'port'        => '28017',
        'description' => 'Mongo DB Server for xhprof',
        'db'          => false,
    ];
}

return $tmp;