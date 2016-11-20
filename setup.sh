#!/bin/bash

cd "$(dirname "$0")";

# Set up the database
echo "SETTING UP DATABASE"
cat database-schema.sql | psql --quiet

echo "LOADING THE CANADIAN EXPEDITIONARY FORCE DATASET"
./canadian-expeditionary-force-members/setup.sh