#!/usr/bin/env bash
FILE=${1:-/vagrant/db/mysqldump.sql.gz}

# This gives an estimate of the size of the SQL file
# It appears that 80% is a good approximation of
# the ratio of estimated size to actual size
SIZE_QUERY="select ceil(sum(data_length) * 0.8) as size from information_schema.TABLES"

echo "Exporting databases to '$FILE'"
ADJUSTED_SIZE=$(mysql --vertical -uroot -p123 -e "$SIZE_QUERY" 2>/dev/null | grep 'size' | awk '{print $2}')
HUMAN_READABLE_SIZE=$(numfmt --to=iec-i --suffix=B --format="%.3f" $ADJUSTED_SIZE)

echo "Estimated uncompressed size: $HUMAN_READABLE_SIZE"
mysqldump -uroot -p123 --all-databases -h 127.0.0.1 -P 3306 --skip-lock-tables 2>/dev/null | pv  --size=$ADJUSTED_SIZE | gzip > "$FILE"

echo "Done."