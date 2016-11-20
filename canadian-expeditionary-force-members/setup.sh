#!/bin/bash

cd "$(dirname "$0")"

mkdir -p tmp
cd tmp

echo "Downloading records..."
wget -nc http://www.collectionscanada.gc.ca/obj/900/f11/001042_20141124.xml -O original-records.xml

echo "Preparing XML file..."
if [ ! -f utf8-records.xml ]; then
    echo "Converting from UTF-16 to UTF-8..."
    iconv -f utf-16 -t utf-8 original-records.xml > utf8-records.xml

    echo "Preparing XML file for splitting..."
    # Remove the root node
    # Note: OS X requires a backup file name with -i, hence the empty string
    # http://stackoverflow.com/questions/7573368/in-place-edits-with-sed-on-os-x
    sed -i '' 's/^\<CEF_Data\>//' utf8-records.xml
    sed -i '' 's/\<\/CEF_Data\>$//' utf8-records.xml

    # Add line breaks after each record to aid splitting (the original file is on one line)
    # Note: OS X doesn't support replacing with \n, so we use real line breaks
    # http://superuser.com/questions/307165/newlines-in-sed-on-mac-os-x/582558
    sed -i '' 's/\<\/DigitizeList\>/\<\/DigitizeList\>\
    /g' utf8-records.xml
else
    echo "Already done. Skipping."
fi

echo "Splitting XML file into smaller chunks..."
if [ ! -d 'split-records' ]; then
    # Split the file in series of 50000 records. These take ~500mb of RAM each to parse
    # Note: OS X doesn't support numeric suffices for split. It's a GNU split feature.
    mkdir split-records
    split -a4 -l50000 utf8-records.xml split-records/records

    # Add the root node back
    cd split-records
    for file in *; do
        echo -n "<CEF_Data>" > /tmp/tmpfile.$$
        cat "$file" >> /tmp/tmpfile.$$
        echo "</CEF_Data>" >> /tmp/tmpfile.$$;
        mv /tmp/tmpfile.$$ "$file"
    done
else
    echo "Already done. Skipping."
fi

echo "Parsing records and saving them to database..."
cd ..
for file in tmp/split-records/*; do
    echo "    Parsing records from $file..."
    python parse-data.py "$file"
done

echo "Done."