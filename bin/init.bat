@echo off

if ["%~1"]==[""] (
    copy /-y ../resources\config.yaml ../config.yaml
)

copy /-y ../resources\after.sh ../vagrant/after.sh
copy /-y ../resources\aliases ../vagrant/aliases

echo Environment initialized!