#!/usr/bin/env bash
    outputdir="/vagrant/db/mongo"
    if [ ! -d $outputdir ]
    then mkdir $outputdir
    fi

    /usr/bin/env mongodump --out $outputdir

    echo "Done."