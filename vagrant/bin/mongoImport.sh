#!/usr/bin/env bash
recoverdir="/vagrant/db/mongo"
if [ ! -d $outputdir ]
then
    echo "no directory found"
    exit 0
fi
/usr/bin/env mongorestore $recoverdir

echo "Done."