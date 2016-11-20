# Parses records from the Canadian War Graves Commission dataset and saves them to the database.

import xml.etree.ElementTree as etree
import sys
from datetime import datetime
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


def save_war_grave(war_grave):
    cursor.execute(
        insert_query,
        war_grave
    )


with open(filename, 'r') as csvfile:
    csv_reader = csv.reader(csvfile, delimiter=',', quotechar='"')
    next(csv_reader)  # Skip header
    for row in csv_reader:
        war_grave = dict(zip(ordered_column_names, row))
        for k, v in mydict.iteritems():
            mydict[k] = v.strip() or None

        # This column uses single quotes, for some reason
        if len(war_grave['servicenumberexport']) and war_grave['servicenumberexport'][0] == "'":
            war_grave['servicenumberexport'] = war_grave['servicenumberexport'][1:-1].strip() or None

        for field in ('date_of_death1', 'date_of_death2') and war_grave[field] is not None:
            raw_date = war_grave[field]
            war_grave[field] = datetime(int(raw_date[6:10]), int(raw_date[3:5]), int(raw_date[0:2]))

        war_grave['age'] = int(war_grave['age']) if war_grave['age'] else None
        save_war_grave(war_grave)

cursor.execute('COMMIT')
