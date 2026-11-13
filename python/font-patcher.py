from pathlib import Path
from fontTools.ttLib import TTFont
from fontTools.ttLib.tables._c_m_a_p import CmapSubtable

BASE_DIR = Path(__file__).parent
FONT_PATH = BASE_DIR / "fonts/Redacted-Regular.ttf"
OUTPUT_PATH = BASE_DIR / "fonts/Redacted-Patched.ttf"

font = TTFont(FONT_PATH)
glyph = font.getBestCmap()[ord("a")]

cmap = {}
# Starts after control characters
for code in range(0x0020, 0x110000):
    # Skips surrogate characters
    if 0xD800 <= code <= 0xDFFF:
        continue
    cmap[code] = glyph

# Many-to-one range mapping subtable
# Maps multiple chars to a single one
subtable = CmapSubtable.newSubtable(13)
subtable.platformID = 3 # def. Windows
subtable.platEncID = 10 # Full Unicode
subtable.language = 0
subtable.cmap = cmap

font["cmap"].tables = [subtable]
font.save(OUTPUT_PATH)
