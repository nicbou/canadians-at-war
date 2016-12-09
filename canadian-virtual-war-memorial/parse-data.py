import json
import sys
import psycopg2
import os

filename = sys.argv[1]
file = open(filename)
data = json.load(file)
file.close()

conn = psycopg2.connect("dbname='canadiansatwar' user='nicolas' host='localhost' password=''")
cursor = conn.cursor()

all_fields = (
    'additional_information', 'birth_country_id', 'birth_date_day', 'birth_date_month', 'birth_date_year',
    'birth_place', 'birth_province', 'casualty_type_id', 'cemetery_localities_id',
    'citation_text', 'country_id', 'dataset_id', 'death_age', 'death_country_id', 'death_date_day', 'death_date_month',
    'death_date_year', 'death_place', 'death_province', 'enlistment_date', 'enlistment_date_day',
    'enlistment_date_month', 'enlistment_date_year', 'enlistment_country_id', 'enlistment_place', 'enlistment_province',
    'force_id', 'given_name', 'image_cemetery_plan', 'initials', 'rank_id', 'regiment_id', 'regimental_number',
    'surname', 'unit_text', 'war_graves_id'
)
all_fields_incl_temp = all_fields + ('gravereference', 'war_graves_dataset_id')
numeric_fields = (
    'cemetery_id', 'death_age', 'death_country_id', 'enlistment_country_id', 'force_id', 'casualty_type_id',
    'birth_date_day', 'birth_date_month', 'birth_date_year', 'death_date_day', 'death_date_month', 'rank_id',
    'death_date_year', 'enlistment_date_day', 'enlistment_date_month', 'enlistment_date_year', 'cemetery_localities_id',
    'regiment_id', 'birth_country_id', 'country_id', 'war_graves_id'
)
insert_query = "INSERT INTO temp_cvwm_war_dead ({0}) VALUES ({1})".format(
    ', '.join(all_fields_incl_temp),
    ', '.join(['%({0})s'.format(c) for c in all_fields_incl_temp])
)

forces = {}
countries = {}
cemetery_names_to_ids = {}
ranks = {}
regiments = {}
cemetery_localities = {}


def create_temp_table():
    cursor.execute('BEGIN')
    cursor.execute('DROP TABLE IF EXISTS temp_cvwm_war_dead')
    cursor.execute('CREATE TEMP TABLE temp_cvwm_war_dead AS SELECT * FROM cvwm_war_dead LIMIT 0')
    cursor.execute('ALTER TABLE temp_cvwm_war_dead ADD COLUMN war_graves_dataset_id INTEGER')
    cursor.execute('ALTER TABLE temp_cvwm_war_dead ADD COLUMN gravereference TEXT')


def save_linked_tables():
    """Fill the tables the cvwm_war_dead references to"""
    def save_dictionary(dictionary, table_name):
        for id, name in dictionary.iteritems():
            # Insert even IDs without name, and update with name when available
            query = """
                INSERT INTO {0} (id, name)
                VALUES (%(id)s, %(name)s)
                ON CONFLICT (id) DO UPDATE
                    SET name = EXCLUDED.name
            """
            if not name:
                query = """
                    INSERT INTO {0} (id, name)
                    VALUES (%(id)s, %(name)s)
                    ON CONFLICT (id) DO NOTHING
                """

            cursor.execute(query.format(table_name), {'id': id, 'name': name})

    save_dictionary(cemetery_localities, 'cvwm_cemetery_localities')
    save_dictionary(countries, 'cvwm_countries')
    save_dictionary(forces, 'cvwm_forces')
    save_dictionary(ranks, 'cvwm_ranks')
    save_dictionary(regiments, 'cvwm_regiments')


def add_cemeteries_dataset_ids():
    """
    Add the missing dataset_ids in cemeteries by taking those from the CVWM dataset, which has them.
    Only 6-7 cemeteries should be updated
    """
    for name, dataset_id in cemetery_names_to_ids.iteritems():
        cursor.execute(
            """
            UPDATE cemeteries
            SET dataset_id=%(dataset_id)s
            WHERE name=%(name)s AND dataset_id IS NULL
            """,
            {'dataset_id': dataset_id, 'name': name}
        )


def save_war_dead(war_dead):
    cursor.execute(
        insert_query,
        war_dead
    )


def add_war_graves_dataset_ids():
    """Add the missing dataset_ids in war_graves by taking those from the CVWM dataset, which has them"""

    print('        Creating temporary indexes')
    cursor.execute("""
        CREATE UNIQUE INDEX person_search
        ON temp_cvwm_war_dead (surname, initials, regimental_number, gravereference)
    """)
    cursor.execute("""
        CREATE UNIQUE INDEX war_graves_dataset_id
        ON temp_cvwm_war_dead (war_graves_dataset_id)
    """)

    print('        Setting dataset_ids on war graves')
    cursor.execute("""
        WITH war_grave_ids AS (
            SELECT wg.id as id, war_graves_dataset_id AS dataset_id
            FROM temp_cvwm_war_dead wd
            JOIN war_graves wg
            ON
                wd.surname=wg.surname
                AND wd.initials=wg.initials
                AND wd.regimental_number=wg.servicenumberexport
        )

        UPDATE war_graves wg SET dataset_id=(
            SELECT dataset_id FROM war_grave_ids wgi WHERE wg.id=wgi.id LIMIT 1
        )
        WHERE id IN (
            SELECT id FROM war_grave_ids
        )
    """)

    print('        Setting war_graves_ids on war dead')
    cursor.execute("""
        WITH war_grave_ids AS (
            SELECT wg.id as id, war_graves_dataset_id AS dataset_id
            FROM temp_cvwm_war_dead wd
            JOIN war_graves wg
            ON
                wd.surname=wg.surname
                AND wd.initials=wg.initials
                AND wd.regimental_number=wg.servicenumberexport
        )

        UPDATE temp_cvwm_war_dead twd SET war_graves_id=(
            SELECT id FROM war_grave_ids wgi
            WHERE twd.war_graves_dataset_id=wgi.dataset_id
            LIMIT 1
        ) WHERE twd.war_graves_dataset_id IS NOT NULL
    """)


def commit_temp_table():
    cursor.execute(
        """
        INSERT INTO cvwm_war_dead ({0})
        SELECT {0} FROM temp_cvwm_war_dead
        """.format(
            ', '.join(all_fields),
            ', '.join(['%({0})s'.format(c) for c in all_fields])
        )
    )

    cursor.execute('COMMIT')
    cursor.close()
    conn.close()


records = []
for casualty in data['casualties']:
    record = {
        'additional_information': casualty.get('ADDITIONAL_INFORMATION'),
        'birth_country_id': casualty.get('BIRTH_CNTRY'),
        'birth_date_day': casualty.get('DAY_DATE_OF_BIRTH'),
        'birth_date_month': casualty.get('MONTH_DATE_OF_BIRTH'),
        'birth_date_year': casualty.get('YEAR_DATE_OF_BIRTH'),
        'birth_place': casualty.get('BIRTH_PLACE'),
        'birth_province': casualty.get('BIRTH_PROV'),
        'book_of_rememberence_page': casualty.get('BOOK_REF'),
        'casualty_type_id': casualty.get('CASUALTY_TYPE'),
        'cemetery_localities_id': casualty.get('LOCALITY'),
        'cemetery_id': casualty.get('CEMETERY'),
        'citation_text': casualty.get('CITATION_TEXT'),
        'country_id': casualty.get('COUNTRY'),
        'dataset_id': casualty.get('RN'),  # A separate ID. The primary key for their site.
        'death_age': casualty.get('AGE'),
        'death_country_id': casualty.get('DEATH_CNTRY'),
        'death_date_day': casualty.get('DAY_DATE_OF_DEATH'),
        'death_date_month': casualty.get('MONTH_DATE_OF_DEATH'),
        'death_date_year': casualty.get('YEAR_DATE_OF_DEATH'),
        'death_place': casualty.get('DEATH_PLACE'),
        'death_province': casualty.get('DEATH_PROV'),
        'enlistment_date': casualty.get('DATE_OF_ENLIST'),
        'enlistment_date_day': casualty.get('DAY_DATE_OF_ENLIST'),
        'enlistment_date_month': casualty.get('MONTH_DATE_OF_ENLIST'),
        'enlistment_date_year': casualty.get('YEAR_DATE_OF_ENLIST'),
        'enlistment_country_id': casualty.get('ENLIST_CNTRY'),
        'enlistment_place': casualty.get('ENLIST_PLACE'),
        'enlistment_province': casualty.get('ENLIST_PROV'),
        'force_id': casualty.get('FORCE'),
        'given_name': casualty.get('FORENAMES'),
        'gravereference': casualty.get('GRAVE_REFERENCE'),
        'image_cemetery_plan': casualty.get('PLAN_REF'),
        'initials': casualty.get('INITIALS'),
        'rank_id': casualty.get('RANK'),
        'regiment_id': casualty.get('REGIMENT'),
        'regimental_number': casualty.get('SERVICE_NO'),
        'surname': casualty.get('SURNAME'),
        'unit_text': casualty.get('UNIT_TEXT'),  # "23rd company"
        'war_graves_dataset_id': casualty.get('CASUALTY'),  # cgwc.org war grave ID
        'war_graves_id': '',  # Set later
    }

    for k, v in record.iteritems():
        record[k] = v.strip() or None

    for field in numeric_fields:
        try:
            record[field] = int(record[field])
        except:
            record[field] = None

    if record['force_id']:
        forces[record['force_id']] = casualty.get('FORCE_DESC')

    if record['country_id'] is not None:
        countries[record['country_id']] = countries.get(record['country_id']) or casualty.get('COUNTRY_DESC')
    if record['enlistment_country_id'] is not None:
        countries[record['enlistment_country_id']] = countries.get(record['enlistment_country_id']) or None
    if record['death_country_id'] is not None:
        countries[record['death_country_id']] = countries.get(record['death_country_id']) or None
    if record['birth_country_id'] is not None:
        countries[record['birth_country_id']] = countries.get(record['birth_country_id']) or None

    if record['cemetery_id'] is not None and casualty.get('CEMETERY_DESC'):
        cemetery_names_to_ids[casualty.get('CEMETERY_DESC')] = record['cemetery_id']

    if record['rank_id'] is not None:
        ranks[record['rank_id']] = casualty.get('RANK_DESCRIPTION')

    if record['regiment_id'] is not None:
        regiments[record['regiment_id']] = casualty.get('REGIMENT_DESCRIPTION')

    if record['cemetery_localities_id'] is not None:
        cemetery_localities[record['cemetery_localities_id']] = casualty.get('LOCALITY_DESC')

    if record['birth_province'] == 'UN' or record['birth_province'] == 'OT':  # "Unknown" or "Other"
        record['birth_province'] = None
    elif record['birth_province']:
        assert len(record['birth_province']) == 2
        record['birth_country_id'] = 15  # Canada

    if record['death_province'] == 'UN' or record['death_province'] == 'OT':  # "Unknown" or "Other"
        record['death_province'] = None
    elif record['death_province']:
        assert len(record['death_province']) == 2
        record['death_country_id'] = 15  # Canada

    if record['enlistment_province'] == 'UN' or record['enlistment_province'] == 'OT':  # "Unknown" or "Other"
        record['enlistment_province'] = None
    elif record['enlistment_province']:
        assert len(record['enlistment_province']) == 2
        record['death_country_id'] = 15  # Canada

    if record['death_date_year'] < 1914 or record['death_date_year'] > 1920 or not record['death_date_year']:
        continue

    records.append(record)

print('    Creating temporary table')
create_temp_table()

print('    Creating linked tables')
save_linked_tables()

print('    Adding dataset IDs to cemeteries')
add_cemeteries_dataset_ids()

print('    Saving records')
for record in records:
    save_war_dead(record)

print('    Adding dataset IDs to war graves')
add_war_graves_dataset_ids()

print('    Committing changes')
commit_temp_table()
