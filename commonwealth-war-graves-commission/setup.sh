#!/bin/bash

cd "$(dirname "$0")"

echo "Parsing records and saving them to database..."
python parse-data.py casualty-list-2016-11-03.csv