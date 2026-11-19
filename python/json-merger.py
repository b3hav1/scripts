import json
from pathlib import Path

BASE_DIR = Path(__file__).parent
BASE_DIR /= "assets/minecraft/lang"

SOURCE_PATH = BASE_DIR / "en_us.json"
TARGET_PATH = BASE_DIR / "ru_ru.json"
INDENT_SIZE = 4

with open(SOURCE_PATH, "r", encoding="utf-8") as file:
    source_data = json.load(file)

with open(TARGET_PATH, "r", encoding="utf-8") as file:
    target_data = json.load(file)

data = source_data | target_data

with open(TARGET_PATH, "w", encoding="utf-8") as file:
    json.dump(data, file, ensure_ascii=False, indent=INDENT_SIZE)
