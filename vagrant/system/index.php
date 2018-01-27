<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <title>System Vagrant Environment</title>
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/styles.css" rel="stylesheet">
    </head>
    <body>
        <nav class="navbar navbar-inverse navbar-fixed-top">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar"
                            aria-expanded="false" aria-controls="navbar">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="http://registration.test">
                        <img src="images/logo.jpg" style="height: 20px;">
                    </a>
                </div>
                <div id="navbar" class="collapse navbar-collapse">
                    <ul class="nav navbar-nav">
                        <li><a target="_blank" href="http://app.registration.test">App1</a></li>
                        <li><a target="_blank" href="http://app2.registration.test">App2</a></li>
                        <li><a target="_blank" href="http://app3.registration.test">App3</a></li>
                        <li><a target="_blank" href="http://app4.registration.test">App4</a></li>
                        <li><a target="_blank" href="http://app5.registration.test">App5</a></li>
                        <li><a target="_blank" href="http://pma.registration.test">PMA</a></li>
                        <li><a target="_blank" href="http://mail.registration.test">Mail</a></li>
                        <li><a target="_blank" href="http://search.registration.test">ES</a></li>
                        <li><a target="_blank" href="http://kibana.registration.test">Kibana</a></li>
                        <?php
                        if (extension_loaded('tideways_xhprof')) {
                            ?>
                            <li><a target="_blank" href="http://profiler.registration.test">Prof</a></li>
                            <?php
                        }
                        ?>
                        <li><a target="_blank" href="http://registration.test/status">VTS</a></li>
                        <li><a target="_blank" href="schema/index.html">Schema</a> </li>
                        <li><a href="http://registration.test/phpinfo.php">Info</a></li>
                        <li><a target="_blank" href="http://getbootstrap.com/docs/4.0/getting-started/introduction/">BS</a></li>
                        <li><a target="_blank" href="https://fontawesome.com/icons?m=pro">FA</a></li>
                    </ul>
                </div>
            </div>
        </nav>
        <div class="container">
            <div style="position: absolute;top: 50px; bottom: 0px; left: 0px; right: 0px; background: url(images/background.jpg); background-size: cover;">
                <div  style="background-color: white; border: 1px solid black; border-radius: 10px; padding: 10px; margin-top: 15px;" class="col-xs-12 col-md-8 col-md-offset-2 col-lg-6 col-lg-offset-3">
                    <div class="row" style="margin-bottom: 10px;">
                        <div class="col-xs-4 col-md-4 col-lg-2">
                            <img src="images/logo.jpg" style="width: 100%;">
                        </div>
                        <div class="col-xs-8 col-md-8 col-lg-10">
                            <h3 class="hidden-xs hidden-sm">
                                Vagrant Entwicklungs Umgebung
                            </h3>
                        </div>
                    </div>
                    <div class="row" style="margin-bottom: 10px;">
                        <div class="col-xs-12">
                            <table style="border: 1px solid black; margin: 10px; margin: auto; width: 80%;" class="table table-responsive">
                                <thead class="hidden-sm hidden-xs">
                                    <tr style="border: 1px solid black;background-color: #aa0000;color: white;">
                                        <th style="border: 1px solid black;">Bezeichnung</th>
                                        <th style="border: 1px solid black;">User</th>
                                        <th style="border: 1px solid black;">Passwort</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr style="border: 1px solid black;">
                                        <td style="border: 1px solid black; padding:2px;">
                                            App
                                            <span class="hidden-md hidden-lg">
                                                <br>
                                                admin@test
                                                <br>
                                                <i>123</i>
                                            </span>
                                        </td>
                                        <td style="border: 1px solid black; padding:2px;" class="hidden-sm hidden-xs">admin@test</td>
                                        <td style="border: 1px solid black; padding:2px;" class="hidden-sm hidden-xs">123</td>
                                    </tr>
                                    <tr style="border: 1px solid black;">
                                        <td style="border: 1px solid black; padding:2px;">
                                            MySQL root
                                            <span class="hidden-md hidden-lg">
                                                <br>
                                                root
                                                <br>
                                                <i>123</i>
                                            </span>
                                        </td>
                                        <td style="border: 1px solid black; padding:2px;" class="hidden-sm hidden-xs">root</td>
                                        <td style="border: 1px solid black; padding:2px;" class="hidden-sm hidden-xs">123</td>
                                    </tr>
                                    <tr style="border: 1px solid black;">
                                        <td style="border: 1px solid black; padding:2px;">
                                            MySQL application
                                            <span class="hidden-md hidden-lg">
                                                <br>
                                                applicationRead
                                                <br>
                                                <i>123</i>
                                            </span>
                                        </td>
                                        <td style="border: 1px solid black; padding:2px;" class="hidden-sm hidden-xs">applicationRead</td>
                                        <td style="border: 1px solid black; padding:2px;" class="hidden-sm hidden-xs">123</td>
                                    </tr>
                                    <tr style="border: 1px solid black;">
                                        <td style="border: 1px solid black; padding:2px;">
                                            MySQL application
                                            <span class="hidden-md hidden-lg">
                                                <br>
                                                applicationWrite
                                                <br>
                                                <i>123</i>
                                            </span>
                                        </td>
                                        <td style="border: 1px solid black; padding:2px;" class="hidden-sm hidden-xs">applicationWrite</td>
                                        <td style="border: 1px solid black; padding:2px;" class="hidden-sm hidden-xs">123</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <?php
                    include('./status.php');
                    $ss = new    ServerStatus();
                    $cfg['host'] = '127.0.0.1';
                    $skip = 0;
                    $cfg['services'] = require 'services.php';
                    ?>
                    <div class="row" style="margin-bottom: 10px;">
                        <div class="col-xs-12">
                            <h5>Service Overview</h5>
                            <table class="table table-bordered table-condensed">
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
                    </div>
                </div>
            </div>
        </div>
        <script src="js/jquery.js"></script>
        <script>window.jQuery || document.write('<script src="../../assets/js/vendor/jquery.min.js"><\/script>')</script>
        <script src="js/bootstrap.min.js"></script>
    </body>
</html>