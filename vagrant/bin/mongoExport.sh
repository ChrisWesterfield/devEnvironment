#!/usr/bin/env bash
    outputdir="/home/vagrant/base/db/mongo"
    if [ ! -d $outputdir ]
    then mkdir $outputdir
    fi

    /usr/bin/env mongodump --out $outputdir

    echo "Done."