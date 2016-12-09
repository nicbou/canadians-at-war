import json
import sys
import psycopg2
import os

filename = sys.argv[1]
file = open(filename)
cemeteries = json.load(file)
file.close()

conn = psycopg2.connect("dbname='canadiansatwar' user='nicolas' host='localhost' password=''")
cursor = conn.cursor()


def update_cemetery(cemetery):
    cursor.execute(
        """
        UPDATE cemeteries
        SET
            dataset_id=%(dataset_id)s,
            type=%(type)s,
            latitude=%(latitude)s,
            longitude=%(longitude)s,
            location_information=%(location_information)s,
            visiting_information=%(visiting_information)s,
            historical_information=%(historical_information)s,
            microsite_url=%(microsite_url)s
        WHERE name=%(name)s
        """,
        cemetery
    )

cursor.execute('BEGIN')
for cemetery in cemeteries:
    cemetery_info = {
        'name': cemetery.get('cemetery_desc'),
        'dataset_id': int(cemetery.get('cemetery')) if cemetery.get('cemetery') else None,
        'type': cemetery.get('cemetery_type_desc'),
        'latitude': cemetery.get('latitude') if cemetery.get('latitude') != 'NULL' else None,
        'longitude': cemetery.get('longitude') if cemetery.get('longitude') != 'NULL' else None,
        'location_information': cemetery.get('location_information') if cemetery.get('location_information') != 'NULL' else None,
        'visiting_information': cemetery.get('visiting_information') if cemetery.get('visiting_information') != 'NULL' else None,
        'historical_information': cemetery.get('historical_information') if cemetery.get('historical_information') != 'NULL' else None,
        'microsite_url': cemetery.get('Microsite_URL'),
    }

    # These columns are sometimes wrapped in quotes
    for column in ('name', 'location_information', 'visiting_information', 'historical_information'):
        if cemetery_info[column] and len(cemetery_info[column]) and cemetery_info[column][0] == '"':
            cemetery_info[column] = cemetery_info[column][1:-1].strip() or None

    if cemetery_info['dataset_id'] != 2061178:  # This cemetery is misformatted, but does not have WW1 casualties
        update_cemetery(cemetery_info)

cursor.execute('commit')
