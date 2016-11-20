# Parses records from the Canadian Expeditionary Force dataset and saves them to the database.
import xml.etree.ElementTree as etree
import sys
import psycopg2
from date_parser import parse_date


def save_enlistee(enlistee):
    enlistee_format = {
        'dataset_id': enlistee['dataset_id'],
        'reference_en': enlistee.get('reference_en'),
        'reference_fr': enlistee.get('reference_fr'),
        'surname': enlistee.get('surname'),
        'given_name': enlistee.get('given_name'),
        'document_number': enlistee.get('document_number'),
    }

    cursor.execute(
        """
            INSERT INTO cef_enlistees (
                dataset_id, reference_en, reference_fr, document_number, given_name, surname
            )
            VALUES (
                %(dataset_id)s, %(reference_en)s, %(reference_fr)s, %(document_number)s,
                %(given_name)s, %(surname)s
            )
            RETURNING id
        """,
        enlistee_format
    )
    row_id = cursor.fetchone()[0]

    for birthdate in zip(enlistee['raw_birthdates'], enlistee['birthdates']):
        birthdate_format = {
            'cef_enlistees_id': row_id,
            'raw_date': birthdate[0],
            'year': birthdate[1]['year'],
            'month': birthdate[1]['month'],
            'day': birthdate[1]['day'],
        }
        cursor.execute(
            """
            INSERT INTO cef_enlistees_birth_dates (
                cef_enlistees_id, raw_date, year, month, day
            )
            VALUES (
                %(cef_enlistees_id)s, %(raw_date)s, %(year)s, %(month)s, %(day)s
            )
            """,
            birthdate_format
        )

    for regimental_number in enlistee['regimental_numbers']:
        regimental_number_format = {
            'cef_enlistees_id': row_id,
            'regimental_number': regimental_number,
        }
        cursor.execute(
            """
            INSERT INTO cef_enlistees_regimental_numbers (
                cef_enlistees_id, regimental_number
            )
            VALUES (
                %(cef_enlistees_id)s, %(regimental_number)s
            )
            """,
            regimental_number_format
        )

    for image in enlistee['images']:
        image_format = {
            'cef_enlistees_id': row_id,
            'url': image,
        }
        cursor.execute(
            """
            INSERT INTO cef_enlistees_images (
                cef_enlistees_id, url
            )
            VALUES (
                %(cef_enlistees_id)s, %(url)s
            )
            """,
            image_format
        )


# This file is a flat list of XML elements under a <CEF_Data> node. Fortunately, they're ordered.
# EnlisteeId is the first element for each record.
enlistee = {}
ignored_tags = ('CEF_Data', 'Reference', 'RegimentalNumberList', 'BirthDateList', 'DigitizeList')
filename = sys.argv[1]

conn = psycopg2.connect("dbname='canadiansatwar' user='nicolas' host='localhost' password=''")
cursor = conn.cursor()

cursor.execute('BEGIN')
for event, elem in etree.iterparse(filename, events=('end',)):
    if elem.tag not in ignored_tags and elem.text:
        if elem.tag == 'RegimentalNumber':
            enlistee['regimental_numbers'].append(elem.text.strip())
        elif elem.tag == 'BirthDate':
            raw_date = elem.text
            parsed_date = parse_date(raw_date)
            enlistee['raw_birthdates'].append(raw_date)
            enlistee['birthdates'].append(parsed_date)
        elif elem.tag == 'ReferenceEn':
            enlistee['reference_en'] = elem.text.strip()
        elif elem.tag == 'ReferenceFr':
            enlistee['reference_fr'] = elem.text.strip()
        elif elem.tag == 'DocumentNumber':
            enlistee['document_number'] = elem.text.strip()
        elif elem.tag == 'Surname':
            enlistee['surname'] = elem.text.strip()
        elif elem.tag == 'GivenName':
            enlistee['given_name'] = elem.text.strip()
        elif elem.tag == 'Image':
            enlistee['images'].append(elem.text.strip())
        elif elem.tag == 'PersonID':  # New enlistee
            enlistee = {
                'birthdates': [],
                'raw_birthdates': [],
                'regimental_numbers': [],
                'images': [],
            }
            enlistee['dataset_id'] = elem.text.strip()
        else:
            print('unexpected tag: {0}'.format(elem))
    elif elem.tag == 'DigitizeList':  # Last tag for each enlistee. This means we're done with that enlistee
        save_enlistee(enlistee)

cursor.execute('COMMIT')
