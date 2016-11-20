#!/bin/bash

pg_dump --create --schema-only --clean canadiansatwar > ../database-schema.sql