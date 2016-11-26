# Parses records from the Canadian War Graves Commission dataset and saves them to the database.

import xml.etree.ElementTree as etree
import sys
from datetime import datetime
import psycopg2
import csv
import json

ordered_column_names = (  # Ordered as they appear in the CSV file
    'name',
    'casualties_ww1',
    'casualties_ww2',
    'casualties_total',
    'country',
    'locality',
)
column_count = len(ordered_column_names)
insert_query = "INSERT INTO cemeteries ({0}) VALUES ({1})".format(
    ', '.join(ordered_column_names),
    ', '.join(['%({0})s'.format(c) for c in ordered_column_names])
)
conn = psycopg2.connect("dbname='canadiansatwar' user='nicolas' host='localhost' password=''")
cursor = conn.cursor()
cursor.execute('BEGIN')

filename = sys.argv[1]


def save_cemetery(cemetery):
    cursor.execute(
        insert_query,
        cemetery
    )


with open(filename, 'r') as csvfile:
    csv_reader = csv.reader(csvfile, delimiter=',', quotechar='"')
    next(csv_reader)  # Skip header
    for row in csv_reader:
        cemetery = dict(zip(ordered_column_names, row))
        for k, v in cemetery.iteritems():
            cemetery[k] = v.strip() or None

        cemetery['casualties_ww1'] = int(cemetery['casualties_ww1']) if cemetery['casualties_ww1'] else None
        cemetery['casualties_ww2'] = int(cemetery['casualties_ww2']) if cemetery['casualties_ww2'] else None
        cemetery['casualties_total'] = int(cemetery['casualties_total']) if cemetery['casualties_total'] else None
        save_cemetery(cemetery)

cursor.execute('COMMIT')
