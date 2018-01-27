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
    <div class="row">
        <div  class="col-xs-12">
            <?php
                phpinfo();
            ?>
        </div>
    </div>
    <script src="js/jquery.js"></script>
    <script>window.jQuery || document.write('<script src="../../assets/js/vendor/jquery.min.js"><\/script>')</script>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>