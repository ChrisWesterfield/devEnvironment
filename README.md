# MJR!ONE Development Environment

##License: MIT
Original: Original Dervived from Laravel homestead

##Installation
### 1. initialize project

$# ./bin/init.sh

or for Windows

./bin/init.bat

### 2. Configure config.yaml 

Configure config.yaml according your requirements
Add the IP Address to pa.ssh.sh or vb.ssh.sh,
if you have an unixoed system or accessing the environment with an Cygwin bash

### 3. run vagrant up

$# vagrant up

or for Windows

vagrant.exe up

### 4. install managment tools (requires PHP + Composer)

composer install

(Windows Seperate approach required regarding php and composer)

### 5. enter vagrant environment

Unixoed/Cygwin Bash

Virtual Box:

$# ./vb.ssh.sh

Parallels:

$# ./pa.ssh.sh

Other Virtualisation Software or Windows

vagrant(.exe) ssh

## Known Issues

