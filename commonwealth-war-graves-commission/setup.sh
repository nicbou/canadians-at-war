#!/bin/bash

cd "$(dirname "$0")"

echo "Parsing cemetery records and saving them to database..."
python parse-data-cemeteries.py datasets/cemetery-list-2016-11-23.csv

echo "Loading missing information from mobile database..."
python parse-data-android-database.py datasets/android-app-2.0-database.json

echo "Parsing war grave records and saving them to database..."
python parse-data.py datasets/casualty-list-2016-11-03.csv

echo "Linking war graves to CEF enlistees..."
cat join-to-CEF-records.sql | psql --quiet canadiansatwar