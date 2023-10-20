import os
import re
from items import items_list


def get_item_names(item_list: list[dict]) -> list: 
    item_names = [x['fulltype'] for x in item_list]
    return item_names


def parse_map(save_path: str, item_names: list) -> dict:
    map_items = {}
    files = [f for f in os.listdir(save_path) if os.path.isfile(save_path + f)]
    for file in files:
        if not (file.startswith('map_') and file[-5].isdigit()):
            continue
        coords = tuple(int(x) for x in file.split('map_')[1].split('.')[0].split('_'))
        with open(save_path + file, 'rb') as bin_file:
            text_by_char = ''
            while True:
                data = bin_file.read(1)
                if not data:
                    break
                text_by_char += chr(ord(data))
            letters = re.sub('[^a-zA-Z0-9._]', '', text_by_char)
        map_items[coords] = {}
        for item in item_names:
            if item in letters:
                map_items[coords][item] = letters.count(item)
    return map_items


if __name__ == '__main__':
    save_path = 'save\\'
    item_names = get_item_names(items_list)
    map_items = parse_map(save_path, item_names)
