<?php
$config = json_decode(file_get_contents("/vagrant/config.json"),true);
$data = '<?php
$cfg[\'blowfish_secret\'] = \'r6EA8vX7c6LRoAykpCgGHxV6RvJm6QQNkdifRpG4xWkxUmZjxZxaV7RakMjj2Y2m\';
$i = 0;
$cfg[\'UploadDir\'] = \'\';
$cfg[\'SaveDir\'] = \'\';
$cfg[\'PmaNoRelation_DisableWarning\'] = true;
$cfg[\'SuhosinDisableWarning\'] = true;
$cfg[\'LoginCookieValidityDisableWarning\'] = true;
$cfg[\'NavigationTreeDbSeparator\'] = \'\';
$cfg[\'ShowPhpInfo\'] = true;
$cfg[\'DefaultLang\'] = \'de\';
$cfg[\'ServerDefault\'] = 1;
$cfg[\'ThemeDefault\'] = \'fallen\';
$i++;
//Master Config
$cfg[\'Servers\'][$i][\'verbose\'] = \'Master\';
$cfg[\'Servers\'][$i][\'host\'] = \'127.0.0.1\';
$cfg[\'Servers\'][$i][\'port\'] = \'3306\';
$cfg[\'Servers\'][$i][\'socket\'] = \'\';
$cfg[\'Servers\'][$i][\'auth_type\'] = \'config\';
$cfg[\'Servers\'][$i][\'user\'] = \'root\';
$cfg[\'Servers\'][$i][\'password\'] = \'123\';
$cfg[\'Servers\'][$i][\'pmadb\'] = \'phpmyadmin\';
$cfg[\'Servers\'][$i][\'controlhost\'] = \'127.0.0.1\';
$cfg[\'Servers\'][$i][\'controlport\'] = \'3306\';
$cfg[\'Servers\'][$i][\'controluser\'] = \'root\';
$cfg[\'Servers\'][$i][\'controlpass\'] = \'123\';
$cfg[\'Servers\'][$i][\'bookmarktable\'] = \'pma__bookmark\';
$cfg[\'Servers\'][$i][\'relation\'] = \'pma__relation\';
$cfg[\'Servers\'][$i][\'userconfig\'] = \'pma__userconfig\';
$cfg[\'Servers\'][$i][\'users\'] = \'pma__users\';
$cfg[\'Servers\'][$i][\'usergroups\'] = \'pma__usergroups\';
$cfg[\'Servers\'][$i][\'navigationhiding\'] = \'pma__navigationhiding\';
$cfg[\'Servers\'][$i][\'table_info\'] = \'pma__table_info\';
$cfg[\'Servers\'][$i][\'column_info\'] = \'pma__column_info\';
$cfg[\'Servers\'][$i][\'history\'] = \'pma__history\';
$cfg[\'Servers\'][$i][\'recent\'] = \'pma__recent\';
$cfg[\'Servers\'][$i][\'favorite\'] = \'pma__favorite\';
$cfg[\'Servers\'][$i][\'table_uiprefs\'] = \'pma__table_uiprefs\';
$cfg[\'Servers\'][$i][\'tracking\'] = \'pma__tracking\';
$cfg[\'Servers\'][$i][\'table_coords\'] = \'pma__table_coords\';
$cfg[\'Servers\'][$i][\'pdf_pages\'] = \'pma__pdf_pages\';
$cfg[\'Servers\'][$i][\'savedsearches\'] = \'pma__savedsearches\';
$cfg[\'Servers\'][$i][\'central_columns\'] = \'pma__central_columns\';
$cfg[\'Servers\'][$i][\'export_templates\'] = \'pma__export_templates\';';
if(array_key_exists('mariadbMultiMasterCount', $config['features']))
{
    for($i=0;$i<$config['features']['mariadbMultiMasterCount'];$i++)
    {
        $port = 7+$i;
        if($port<10)
        {
            $port = "0".$port;
        }
        $data.="
\$i++;
\$cfg['Servers'][\$i]['verbose'] = 'Slave ".($i+1)."';
\$cfg['Servers'][\$i]['host'] = '127.0.0.1';
\$cfg['Servers'][\$i]['port'] = '33".$port."';
\$cfg['Servers'][\$i]['socket'] = '';
\$cfg['Servers'][\$i]['auth_type'] = 'config';
\$cfg['Servers'][\$i]['user'] = 'root';
\$cfg['Servers'][\$i]['password'] = '123';";
    }
}
if(file_exists("/home/vagrant/phpmyadmin/config.inc.php"))
{
    unlink("/home/vagrant/phpmyadmin/config.inc.php");
}
file_put_contents("/home/vagrant/phpmyadmin/config.inc.php",$data);