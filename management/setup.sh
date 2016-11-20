#!/bin/bash

cd "$(dirname "$0")";

# Set up the database
cat ../database-schema.sql | psql