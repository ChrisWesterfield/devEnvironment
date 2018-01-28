@echo off

if ["%~1"]==[""] (
    copy /-y resources\config.yaml config.yaml
)

copy /-y resources\after.sh after.sh
copy /-y resources\aliases aliases

echo Environment initialized!