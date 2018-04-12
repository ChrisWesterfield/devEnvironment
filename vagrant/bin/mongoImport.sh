#/usr/bin/env bash
if [ -e /home/vagrant/.apps/mongo ]
then
    echo "reading mongo DB dump"
    recoverdir="/home/vagrant/base/db/mongo"
    if [ ! -d $outputdir ]
    then
        echo "no directory found"
        exit 0
    fi
    /usr/bin/env mongorestore $recoverdir

    echo "Done."
else
    echo "Mongo DB not installed"
fi