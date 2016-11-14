# Parses records from the Canadian War Graves Commission dataset and saves them to the database.

import xml.etree.ElementTree as etree
import sys
from datetime import datetime, timedelta
import psycopg2
import csv
import json

ordered_column_names = (  # Ordered as they appear in the CSV file
    'surname',
    'given_name',
    'initials',
    'age',
    'honours_awards',
    'date_of_death1',
    'date_of_death2',
    'rank',
    'regiment',
    'unitshipsquadron',
    'country',
    'servicenumberexport',
    'cemeterymemorial',
    'gravereference',
    'additional_info',
)
column_count = len(ordered_column_names)
insert_query = "INSERT INTO war_graves ({0}) VALUES ({1})".format(
    ', '.join(ordered_column_names),
    ', '.join(['%({0})s'.format(c) for c in ordered_column_names])
)
conn = psycopg2.connect("dbname='canadiansatwar' user='nicolas' host='localhost' password=''")
cursor = conn.cursor()
cursor.execute('BEGIN')

filename = sys.argv[1]
start = datetime.now()
records_parsed = 0


def save_war_grave(war_grave):
    cursor.execute(
        insert_query,
        war_grave
    )


def print_progress(start, records_parsed):
    if records_parsed % 250 == 0:
        elapsed = datetime.now() - start
        formatted_elapsed = str(elapsed).split('.')[0]
        output = "{0}, {1} records parsed".format(formatted_elapsed, records_parsed)
        print(output)
        sys.stdout.write("\033[F")
    pass


with open(filename, 'r') as csvfile:
    csv_reader = csv.reader(csvfile, delimiter=',', quotechar='"')
    next(csv_reader)  # Skip header
    for row in csv_reader:
        war_grave = dict(zip(ordered_column_names, row))

        if len(war_grave['servicenumberexport']) and war_grave['servicenumberexport'][0] == "'":
            war_grave['servicenumberexport'] = war_grave['servicenumberexport'][1:-1]

        for field in ('date_of_death1', 'date_of_death2'):
            if len(war_grave[field]):
                raw_date = war_grave[field]
                war_grave[field] = datetime(int(raw_date[6:10]), int(raw_date[3:5]), int(raw_date[0:2]))
            else:
                war_grave[field] = None

        war_grave['age'] = int(war_grave['age']) if len(war_grave['age']) else None

        records_parsed += 1
        print_progress(start, records_parsed)
        save_war_grave(war_grave)

cursor.execute('COMMIT')
