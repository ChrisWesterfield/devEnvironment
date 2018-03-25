<!doctype html>
<html lang="en">
<?php
$files = file_get_contents('/vagrant/config.json');
$json = json_decode($files, true);
$host = '';
foreach($json['sites'] as $site)
{
    if(array_key_exists('function', $site) && $site['function'] === 'startpage')
    {
        $host = '//'.$site['map'].'/';
    }
}
?>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>PHP Info 7.0</title>

    <!-- Bootstrap core CSS -->
    <link href="<?php echo $host?>css/bootstrap.css" rel="stylesheet">
    <link href="<?php echo $host?>css/bootstrap-grid.css" rel="stylesheet">
    <link href="<?php echo $host?>css/bootstrap-reboot.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="<?php echo $host?>dashboard.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0">
        <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">MJR.ONE</a>
        <ul class="navbar-nav px-3">
            <li class="nav-item text-nowrap">
                <a class="nav-link" href="https://bit.mjr.one/projects/PUBLIC/repos/developmentenvironment-v3/browse">Bit Bucket for Project</a>
            </li>
        </ul>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <nav class="col-md-2 d-none d-md-block bg-light sidebar">
                <div class="sidebar-sticky">
                    <ul class="nav flex-column">
                        <?php
                        include '../navigation.php';
                        ?>
                    </ul>
                </div>
            </nav>

            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
                    <?php
                        ob_start();
                        phpinfo();
                        $pinfo = ob_get_contents();
                        ob_end_clean();

                        $pinfo = preg_replace( '%^.*<body>(.*)</body>.*$%ms','$1',$pinfo);
                        echo $pinfo;
                    ?>
                </div>
            </main>
        </div>
    </div>
</body>