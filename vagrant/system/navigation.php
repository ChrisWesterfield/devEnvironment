<?php
    $host = '//'.$_SERVER['SERVER_NAME'].'/';
    $apps = $utilities = $startPage = $externalPages = [];
    $files = file_get_contents('/vagrant/config.json');
    $json = json_decode($files, true);
    foreach($json['sites'] as $site)
    {
        if($site['type']==='ignore' && $site['function']==='startpage')
        {
            $startPage[] = $site;
        }
        else if($site['type']==='ignore' && $site['function']==='external')
        {
            $externalPages[] = $site;
        }
        else if($site['type']==='ignore')
        {
            if($site['function']==='couchDbUi')
            {
                $site['map'] = $site['map'].'/_utils';
            }
            $utilities[] = $site;
        }
        else
        {
            $apps[] = $site;
        }
    }
    ?>
    <h4>Navigation</h4>
    <?php
    foreach($startPage as $app)
    {
        echo '<li class="nav-item"><a href="//'.$app['map'].'">'.(isset($app['desc'])?$app['desc']:$app['map']).'</a></li>';
    }
    ?>
    <li class="nav-item"><a href="user.php">User Daten</a> </li>
    <li><hr></li>
</ul>
<ul class="nav flex-column">
    <li><h4>Apps</h4></li>
    <?php
    foreach($apps as $app)
    {
        echo '<li class="nav-item"><a target="_blank" href="//'.$app['map'].'">'.(isset($app['desc'])?$app['desc']:$app['map']).'</a></li>';
    }
    ?>
    <li><hr></li>
</ul>
<ul class="nav flex-column">
    <li><h4>Links</h4></li>
    <?php
    foreach($externalPages as $app)
    {
        echo '<li class="nav-item"><a target="_blank" href="//'.$app['map'].'">'.(isset($app['desc'])?$app['desc']:$app['map']).'</a></li>';
    }
    ?>
    <li><hr></li>
</ul>
<ul class="nav flex-column">
    <li><h4>Tools</h4></li>
    <li class="nav-item"><a href="process.php">Process List</a></li>
    <?php
    foreach($utilities as $app)
    {
        echo '<li class="nav-item"><a target="'. ($app['function'] === 'phpinfo'?'_self':'_blank').'" href="//'.$app['map'].'">'.(isset($app['desc'])?$app['desc']:$app['map']).'</a></li>';
    }
    ?>
