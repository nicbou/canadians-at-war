import re

min_year = 1834  # 80 years old in 1914
max_year = 1903  # 15 years old in 1918


def get_int(string):
    """Returns a (year, is_reliable) tuple. is_reliable is only true if parsing a string that matches \d+"""
    string = string.strip()

    # 1889 (90). Means the person could be born in either 1889 or 1890. We return the first one, and mark it as
    # unreliable
    string, was_subbed = re.subn(r'^(\d{4}) ?\((\d{2})\)$', r'\1\/\2', string)
    if was_subbed:
        return get_int(string[0:4])[0], False

    try:
        number = int(string)
        # Negative numbers don't make sense. '-3' means 03, 13, 23...
        # 0 means the value is not known

        # TODO: What about 1900?
        if number < 0:
            return None, False
        # 00 > 1900 is not reliable enough, since zeros are used as placeholder characters (0000-00-00)
        elif number == 0:
            return None, False
        else:
            return number, True
    except:
        return None, False


def get_year(string):
    """
    Tries to parse the year out of a given date part. Returns a (year, is_reliable) tuple.
    """
    # 81 > 1881, 01 > 1901. Not reliable since 01 can be a day, month or year
    parsed_year, is_reliable = get_int(string)
    parsed_year_len = len(str(parsed_year))

    if parsed_year is None:
        return None, False

    if len(string) == 2:
        if parsed_year + 1800 >= min_year:
            return parsed_year + 1800, parsed_year > 31
        elif parsed_year + 1900 <= max_year:
            return parsed_year + 1900, parsed_year > 31
        else:
            return None, False
    # 887 > 1887
    elif len(string) == 3:
        if max_year >= parsed_year + 1000 >= min_year:
            return parsed_year + 1000, True
        else:
            return None, False
    # 1887 > 1887
    elif len(string) == 4:
        if parsed_year > max_year or parsed_year < min_year:
            return None, False
        else:
            return parsed_year, is_reliable
    # 11887 > 1887
    elif len(string) == 5:
        if max_year >= parsed_year - 10000 >= min_year:
            return parsed_year - 10000, False
        else:
            return None, False

    # 061887 > june 1887, 188706 > june 1887
    elif len(string) == 6:
        parsed_year_at_end = None
        parsed_year_at_start = None

        parsed_year_at_end = None
        year_at_end_is_reliable = None
        parsed_year_at_start = None
        year_at_start_is_reliable = None

        # 061889 > 1889
        possible_month_at_start = get_int(string[0:2])[0]
        if possible_month_at_start > 0 and possible_month_at_start <= 12:
            parsed_year_at_end, year_at_end_is_reliable = get_year(string[2:6])

        # 188906 > 1889
        possible_month_at_end = get_int(string[4:6])[0]
        if possible_month_at_end > 0 and possible_month_at_end <= 12:
            parsed_year_at_start, year_at_start_is_reliable = get_year(string[0:4])

        if year_at_end_is_reliable:
            return parsed_year_at_end, year_at_end_is_reliable
        elif year_at_start_is_reliable:
            return parsed_year_at_start, year_at_start_is_reliable
        else:
            return None, False

    return None, False


def find_best_year(date_parts):
    parsed_parts = [get_year(part) for part in date_parts]
    parts_as_years, parts_are_reliable_years = zip(*parsed_parts)
    parsed_parts = zip(date_parts, parts_as_years, parts_are_reliable_years)

    def year_comparer(a, b):
        a_raw, a_parsed, a_is_reliable = a
        b_raw, b_parsed, b_is_reliable = b

        # Valid > Invalid
        if a_parsed is None and b_parsed is None:
            return 0
        elif a_parsed is None:
            return 1
        elif b_parsed is None:
            return -1

        # Reliable > Unreliable
        if a_is_reliable > b_is_reliable:
            return -1
        elif a_is_reliable == b_is_reliable:
            if a_parsed > 31 and b_parsed <= 31:
                return -1
            if a_parsed <= 31 and b_parsed > 31:
                return 1

            return cmp(len(b_raw), len(a_raw))
        elif a_is_reliable < b_is_reliable:
            return 1

    best_year = sorted(parsed_parts, cmp=year_comparer)[0]
    best_year_raw, best_year_parsed, best_year_reliable = best_year

    # When the year could be a day or month. e.g. '/02/' > 1902
    if len(best_year_raw) <= 2 and best_year_parsed > 1899:
        return best_year_raw, None, False

    # When there is an invalid 4+ character date part, any other number is likely NOT the year, unless it's > 31
    # e.g. 00/12/18x2 > None, 01/01/18886 > None, 01/xx/80 > 1880
    if len(best_year_raw) < 4 and len(max(date_parts, key=len)) > len(best_year_raw) and best_year_parsed >= 1900:
        return best_year_raw, None, False

    # When the date could be MM/DD or DD/MM, we can't trust the best year. e.g. 01/04
    if len(date_parts) == 2:
        def could_be_month_or_day(parsed_part):
            part_raw, part_parsed, part_reliable = parsed_part
            return part_parsed is None or part_parsed <= 31
        if all([could_be_month_or_day(part) for part in parsed_parts]):
            return best_year_raw, None, False

    return best_year


def parse_date(date_string):
    date_string = date_string.strip().lower()  # Lowercase because some parts contain plain english months

    # Dots appear, but never have a meaning. Likely OCR errors.
    date_string = date_string.replace('.', '').replace('`', '').replace('*', '')

    # Replace '-' with '/' IF it's a separator. They can also denote unreadable characters (12/-1/1885)
    date_string = re.sub(r'([^-])-([^-])', r'\1/\2', date_string)

    date_parts = date_string.strip('/').split('/')

    best_year_raw, best_year_parsed, best_year_reliable = find_best_year(date_parts)

    # When the best year is very likely to be a month. e.g. '/02/'
    if len(best_year_raw) <= 2 and best_year_raw <= 31:
        return best_year_raw, None, False

    return best_year_raw, best_year_parsed, best_year_reliable

assert get_int('1') == (1, True)
assert get_int('012') == (12, True)
assert get_int('234') == (234, True)
assert get_int('1938 (39)') == (1938, False)
assert get_int('1938(39)') == (1938, False)
assert get_int('potato') == (None, False)
assert get_int('0') == (None, False)
assert get_int('0000') == (None, False)
assert get_int('00') == (None, False)

assert get_year('0') == (None, False)
assert get_year('00') == (None, False)
assert get_year('000') == (None, False)
assert get_year('880') == (1880, True)
assert get_year('01') == (1901, False)
assert get_year('05') == (None, False)
assert get_year('29') == (None, False)
assert get_year('38') == (1838, True)
assert get_year('1901') == (1901, True)
assert get_year('1880') == (1880, True)
assert get_year('1906') == (None, False)
assert get_year('1833') == (None, False)
assert get_year('188006') == (1880, True)
assert get_year('061880') == (1880, True)

assert find_best_year(('01', '1880', 'potato')) == ('1880', 1880, True)
assert find_best_year(('01', '80', 'potato')) == ('80', 1880, True)
assert find_best_year(('01', '08', 'potato')) == ('01', None, False)
assert find_best_year(('', '', '')) == ('', None, False)
assert find_best_year(('81', '1880', 'potato')) == ('1880', 1880, True)

for line in open('dates.txt', 'r'):
    date = parse_date(line)
    print(line.strip().ljust(20) + (str(date[1]) if date[1] is not None else ''))
