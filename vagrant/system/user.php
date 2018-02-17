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
                    <table class="table table-bordered table-hover">
                        <thead>
                            <tr>
                                <th>Type</th>
                                <th>Application</th>
                                <td>Username</td>
                                <td>Password</td>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="4"><h5>MySQL Users</h5></td>
                            </tr>
                            <tr>
                                <td>User</td>
                                <td>MySQL</td>
                                <td>root</td>
                                <td>123</td>
                            </tr>
                            <?php
                                foreach($json['databases'] as $database)
                                {
                                    if($database['type']=='mysql')
                                    {
                                        if(array_key_exists('user', $database))
                                        {
                                            foreach($database['user'] as $user)
                                            {
                                                echo "<tr><td>MySQL ".(array_key_exists('type',$user)?$user['type']==='read'?'read':'write':'write')."</td>";
                                                echo "<td>MySQL</td><td>".$user['name']."</td><td>".$user['password']."</td></tr>";
                                            }
                                        }
                                    }
                                }
                                if(file_exists('/home/vagrant/.rabbitmq'))
                                {
                                    echo '<tr><td colspan="4"></td></tr>';
                                    echo '
                                        <tr>
                                            <th>Type</th>
                                            <th>Application</th>
                                            <td>Username</td>
                                            <td>Password</td>
                                        </tr>';
                                    echo "<tr><td>Admin</td><td>RabbitMQ</td><td>guest</td><td>guest</td></tr>";
                                }
                                if(file_exists('/home/vagrant/.userData'))
                                {
                                    echo '<tr><td colspan="4"></td></tr>';
                                    echo "<tr><td colspan='4'>Others</td></tr> ";
                                    echo '
                                        <tr>
                                            <th colspan="2">Application</th>
                                            <td>Username</td>
                                            <td>Password</td>
                                        </tr>';
                                    $userData = json_decode(file_get_contents('/home/vagrant/.userData'),true);
                                    foreach($userData as $sub=>$user)
                                    {
                                        echo "<tr><td colspan='2'>".$sub."</td><td>".$user["username"]."</td><td>".$user["password"]."</td></tr>";
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