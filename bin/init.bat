@echo off

vagrant.exe plugin install vagrant-triggers
vagrant.exe plugin install vagrant-reload
vagrant.exe plugin install vagrant-hostsupdater

if ["%~1"]==[""] (
    copy /-y ../resources\config.yaml ../config.yaml
)

copy /-y ../resources\after.sh ../vagrant/after.sh
copy /-y ../resources\aliases ../vagrant/aliases

echo Environment initialized!