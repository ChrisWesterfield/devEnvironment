#/usr/bin/env bash
if [ -e /home/vagrant/.apps/mongo ]
then
    echo "dumping mongo DB"
    outputdir="/home/vagrant/base/db/mongo"
    if [ ! -d $outputdir ]
    then mkdir $outputdir
    fi

    /usr/bin/env mongodump --out $outputdir

    echo "Done."
else
    echo "Mongo DB not installed"
fi