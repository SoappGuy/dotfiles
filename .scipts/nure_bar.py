import nure_tools
import datetime
import pytz
import sys
import json
import argparse

GROUP_ID = nure_tools.find_group("пзпі-23-2")["id"]
TIMEZONE = pytz.timezone('Europe/Kyiv')


LINKS = {

        'ІМ': {
            'DL': 'https://dl.nure.ua/course/view.php?id=19358',
            'Лк': 'https://meet.google.com/rnj-vuiq-auk',
            'Пз': 'https://meet.google.com/rnj-vuiq-auk',
            'Лб': 'https://meet.google.com/rnj-vuiq-auk'
        },
        'ІМ1п': {
            'DL': 'https://dl.nure.ua/course/view.php?id=19358',
            'Лк': 'https://meet.google.com/rnj-vuiq-auk',
            'Пз': 'https://meet.google.com/rnj-vuiq-auk',
            'Лб': 'https://meet.google.com/rnj-vuiq-auk'
        },
        'КДМ': {
            'DL': 'https://dl.nure.ua/course/view.php?id=18367',
            'Лк': 'https://meet.google.com/kce-hjtj-ggh',
            'Пз': 'https://meet.google.com/ayv-nzya-pcz',
            'Лб': 'https://meet.google.com/nom-hpjo-jrd'
        },
        'ОПр': {
            'DL': 'https://dl.nure.ua/course/view.php?id=18400',
            'Лк': 'https://meet.google.com/rfq-gtnx-vku',
            'Пз': 'https://meet.google.com/qwx-jjqi-gyf',
            'Лб': 'https://meet.google.com/qwx-jjqi-gyf'
        },
        'ВМ': {
            'DL': 'https://dl.nure.ua/course/view.php?id=19036',
            'Лк': 'https://meet.google.com/hmd-pfdd-nfr',
            'Пз': 'https://meet.google.com/dzb-cscf-btc',
            'Лб': ''
        },
        'УФМ': {
            'DL': 'https://dl.nure.ua/course/view.php?id=18655',
            'Лк': 'https://meet.google.com/jbg-mohr-ztz',
            'Пз': 'https://meet.google.com/jbg-mohr-ztz',
            'Лб': ''
        },
        'ФВ': {
            'DL': 'https://dl.nure.ua/course/view.php?id=19699',
            'Лк': '',
            'Пз': '',
            'Лб': ''
        },
        'Фіз': {
            'DL': 'https://dl.nure.ua/course/view.php?id=18832',
            'Лк': 'https://meet.google.com/ijk-kxaw-hfa',
            'Пз': 'https://meet.google.com/ijk-kxaw-hfa',
            'Лб': 'https://meet.google.com/xae-noqq-xqt'
        }
}


def now():
    today = datetime.datetime.now().astimezone(TIMEZONE)
    today = datetime.datetime(today.year, today.month, today.day)
    today_str = today.strftime("%Y-%m-%d %H:%m")
    end_str = (today + datetime.timedelta(days=1)).strftime("%Y-%m-%d %H:%m")

    schedule = nure_tools.get_schedule('group',
                                       GROUP_ID,
                                       today_str,
                                       end_str
                                       )

    schedule = sorted(schedule, key=lambda item: item['number_pair'])

    lessons = []
    current_time = datetime.datetime.now().astimezone(TIMEZONE)

    for item in schedule:
        item['start_time'] = datetime.datetime.fromtimestamp(item["start_time"]).astimezone(TIMEZONE)
        item['end_time'] = datetime.datetime.fromtimestamp(item["end_time"]).astimezone(
            TIMEZONE)

        if item['start_time'] <= current_time <= item['end_time']:
            lessons.append(item)
        elif item['start_time'] > current_time:
            lessons.append(item)

    return lessons


parser = argparse.ArgumentParser(description='nure_bar')
parser.add_argument('do', type=str,
                    choices=["main", "get_meet", "get_DL"],
                    help='Варіант виконання (main, get_meet, get_DL)')

if __name__ == '__main__':
    args = parser.parse_args()

    lessons = now()
    to_return = []
    for lesson in lessons:
        formatted_lesson = {
            "brief": lesson["subject"]["brief"],
            "lesson_type": lesson["type"],
            "start_time": lesson["start_time"].strftime("%H:%M"),
            "end_time": lesson["end_time"].strftime("%H:%M")
        }

        to_return.append(formatted_lesson)

    text = f"{to_return[0]['brief']}|{to_return[0]['lesson_type']} | {to_return[0]['start_time']} - {to_return[0]['end_time']}"
    tooltip = "\n".join(
        [f"{_['brief']}|{_['lesson_type']} | {_['start_time']} - {_['end_time']}" for _ in to_return[1:]])

    match args.do:
        case "main":
            sys.stdout.write(json.dumps(({"text": text,
                                          "tooltip": tooltip})))
        case "get_meet":
            sys.stdout.write(LINKS[to_return[0]["brief"]][to_return[0]["lesson_type"]])
        case "get_DL":
            sys.stdout.write(LINKS[to_return[0]["brief"]]["DL"])

