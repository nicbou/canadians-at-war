# Parses records from the Canadian Expeditionary Force dataset and saves them to the database.

import xml.etree.ElementTree as etree
import sys
from datetime import datetime, timedelta
import psycopg2
from date_parser import parse_date


def save_person(person):
    format = {
        'id': person['id'],
        'reference_en': person.get('reference_en'),
        'reference_fr': person.get('reference_fr'),
        'surname': person.get('surname'),
        'given_name': person.get('given_name'),
        'birth_date1': person['raw_birthdates'][0] if len(person['raw_birthdates']) > 0 else None,
        'birth_date2': person['raw_birthdates'][1] if len(person['raw_birthdates']) > 1 else None,
        'birth_date_year': person['birthdates'][0].get('year') if len(person['birthdates']) > 0 else None,
        'birth_date_month': person['birthdates'][0].get('month') if len(person['birthdates']) > 0 else None,
        'birth_date_day': person['birthdates'][0].get('day') if len(person['birthdates']) > 0 else None,
        'regiment_nr1': person['regimental_numbers'][0] if len(person['regimental_numbers']) > 0 else None,
        'regiment_nr2': person['regimental_numbers'][1] if len(person['regimental_numbers']) > 1 else None,
        'regiment_nr3': person['regimental_numbers'][2] if len(person['regimental_numbers']) > 2 else None,
        'image1': person['images'][0] if len(person['images']) > 0 else None,
        'image2': person['images'][1] if len(person['images']) > 1 else None,
        'image3': person['images'][2] if len(person['images']) > 2 else None,
        'document_number': person.get('document_number'),
    }
    cursor.execute(
        """
            INSERT INTO people (
                id, birth_date1, regiment_nr1, regiment_nr2, regiment_nr3, reference_en, reference_fr, document_number,
                given_name, surname, image1, image2, image3
            )
            VALUES (
                %(id)s, %(birth_date1)s, %(regiment_nr1)s, %(regiment_nr2)s, %(regiment_nr3)s, %(reference_en)s,
                %(reference_fr)s, %(document_number)s, %(given_name)s, %(surname)s, %(image1)s, %(image2)s, %(image3)s
            )
        """,
        format
    )


def print_progress(start, records_parsed):
    if records_parsed % 250 == 0:
        elapsed = datetime.now() - start
        formatted_elapsed = str(elapsed).split('.')[0]
        output = "{0}, {1} records parsed".format(formatted_elapsed, records_parsed)
        print(output)
        sys.stdout.write("\033[F")
    pass


# This file is a flat list of XML elements under a <CEF_Data> node. Fortunately, they're ordered.
# PersonId is the first element for each record.
person = {}
root_elem = None
ignored_tags = ('CEF_Data', 'Reference', 'RegimentalNumberList', 'BirthDateList', 'DigitizeList')
filename = sys.argv[1]
start = datetime.now()
records_parsed = 0

conn = psycopg2.connect("dbname='canadiansatwar' user='nicolas' host='localhost' password=''")
cursor = conn.cursor()
cursor.execute('BEGIN')

for event, elem in etree.iterparse(filename, events=('end',)):
    if elem.tag not in ignored_tags:
        if elem.tag == 'RegimentalNumber':
            person['regimental_numbers'].append(elem.text)
        elif elem.tag == 'BirthDate':
            raw_date = elem.text
            parsed_date = parse_date(raw_date)
            person['raw_birthdates'].append(raw_date)
            person['birthdates'].append(parsed_date)
        elif elem.tag == 'ReferenceEn':
            person['reference_en'] = elem.text
        elif elem.tag == 'ReferenceFr':
            person['reference_fr'] = elem.text
        elif elem.tag == 'DocumentNumber':
            person['document_number'] = elem.text
        elif elem.tag == 'Surname':
            person['surname'] = elem.text
        elif elem.tag == 'GivenName':
            person['given_name'] = elem.text
        elif elem.tag == 'Image':
            person['images'].append(elem.text)
        elif elem.tag == 'PersonID':  # New person
            person = {
                'birthdates': [],
                'raw_birthdates': [],
                'regimental_numbers': [],
                'images': [],
            }
            person['id'] = elem.text
        else:
            print('unexpected tag: {0}'.format(elem))
    elif elem.tag == 'DigitizeList':  # Last tag for each person. This means we're done with that person
        records_parsed += 1
        print_progress(start, records_parsed)
        save_person(person)

cursor.execute('COMMIT')
