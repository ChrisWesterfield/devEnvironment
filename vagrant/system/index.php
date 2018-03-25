<!doctype html>
<?php
ini_set('display_errors', 1);
ini_set('error_reporting', E_ALL);
$files = file_get_contents('/vagrant/config.json');
$json = json_decode($files, true);
?>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Starting Page Dev Server</title>

    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.css" rel="stylesheet">
    <link href="css/bootstrap-grid.css" rel="stylesheet">
    <link href="css/bootstrap-reboot.css" rel="stylesheet">
    <script src="js/jquery.js"></script>
    <script src="js/bootstrap.bundle.js"></script>

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
                            include 'navigation.php';
                        ?>
                    </ul>
                </div>
            </nav>
            <main role="main" class="col-md-9 ml-sm-auto col-lg-10 pt-3 px-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pb-2 mb-3 border-bottom">
                    <?php
                        include('status.php');
                        $ss = new    ServerStatus();
                        $cfg['host'] = '127.0.0.1';
                        $skip = 0;
                        $cfg['services'] = require 'services.php';
                    ?>
                    <table class="table table-bordered" style="width: 100%;">
                        <colgroup>
                            <col class="col-xs-2">
                            <col class="col-xs-1">
                            <col class="col-xs-3">
                            <col class="col-xs-2">
                            <col class="col-xs-1">
                            <col class="col-xs-3">
                        </colgroup>
                        <thead>
                        <tr>
                            <th colspan="6">
                                <h5>Service Overview</h5>
                            </th>
                        </tr>
                        <tr>
                            <th colspan="2">CPU</th>
                            <td><?php echo $json['cpus']; ?></td>
                            <th colspan="2">RAM</th>
                            <td><?php echo $json['memory']; ?>MB</td>
                        </tr>
                        <tr>
                            <th colspan="2">IP</th>
                            <td><?php echo $json['ip']; ?></td>
                            <th colspan="2">Provider</th>
                            <td><?php echo $json['provider']; ?></td>
                        </tr>
                        <tr>
                            <th>Service</th>
                            <th>Status</th>
                            <th>Description</th>
                            <th>Service</th>
                            <th>Status</th>
                            <th>Description</th>
                        </tr>
                        </thead>
                        <tbody>
                        <?php
                        $i = 0;
                        foreach ($cfg['services'] as $service) {
                            if ($i == 0) {
                                echo '<tr>';
                            }
                            if (!empty($service)) {
                                echo '<td class="name">' . $service['name'] . '</td>';
                                if ($ss->checkServer((isset($service['host']) ? $service['host'] : $cfg['host']),
                                    $service['port'])) {
                                    echo '<td class="alert-success">Ok</td>';
                                } else {
                                    echo '<td class="alert-danger">Fail</td>';
                                }
                                echo '<td class="description">' . $service['description'] . '</td>';
                            } else {
                                echo '<td colspan="3"></td>';
                            }
                            if ($i == 1) {
                                echo '</tr>';
                                $i = 0;
                            } else {
                                $i = 1;
                            }
                        }
                        ?>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>