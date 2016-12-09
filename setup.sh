#!/bin/bash

cd "$(dirname "$0")";

# Set up the database
printf "\e[42m SETTING UP DATABASE \e[0m\n"
cat database-schema.sql | psql --quiet

printf "\e[42m LOADING THE CANADIAN EXPEDITIONARY FORCE DATASET \e[0m\n"
./canadian-expeditionary-force-members/setup.sh

printf "\e[42m LOADING THE COMMONWEALTH WAR GRAVES COMMISSION DATASET \e[0m\n"
./commonwealth-war-graves-commission/setup.sh

printf "\e[42m LOADING THE CANADIAN VIRTUAL WAR MEMORIAL DATASET \e[0m\n"
./canadian-virtual-war-memorial/setup.sh