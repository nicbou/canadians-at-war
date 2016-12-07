#!/bin/bash

cd "$(dirname "$0")";

mkdir -p tmp

records_per_file=2000  # This is for them, not for us

# Get 2000 records at a time. There are about 120 000 records.
for from in $(seq 0 $records_per_file 300000); do
    to=$(($from+$records_per_file));  # 0 to 200 does not include 200
    filename="tmp/records-${from}-${to}.json";

    wget -nc "http://www.veterans.gc.ca/xml/jsonp/app.cfc?method=remoteGetAllCasualtyInfo&start=${from}&end=${to}&callback=?&language=en" -O "$filename";

    download_size="$(($(wc -c < "$filename")))"
    if [ $download_size -lt 30 ]; then  # We have reached the end of pagination
        break;
    fi
done

for file in tmp/*; do
    echo "Parsing records from $file..."
    python parse-data.py "$file"
done