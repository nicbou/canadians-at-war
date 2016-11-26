#!/bin/bash

cd "$(dirname "$0")"

echo "Parsing cemetery records and saving them to database..."
python parse-data-cemeteries.py cemetery-list-2016-11-23.csv

echo "Parsing war grave records and saving them to database..."
python parse-data.py casualty-list-2016-11-03.csv

echo "Linking war graves to CEF enlistees..."
cat join-to-CEF-records.sql | psql --quiet