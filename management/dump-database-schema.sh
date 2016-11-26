#!/bin/bash

cd "$(dirname "$0")";

# Note: If you are using Postgres.app on OS X, you need to add the location
# of pg_dump to your path, or you will get version mismatch errors:
# export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

pg_dump --create --schema-only --clean canadiansatwar > ../database-schema.sql