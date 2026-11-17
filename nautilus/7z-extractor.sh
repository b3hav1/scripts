#!/bin/bash

LOG_DIR="$HOME/Scripts/logs"
LOG_FILE=$(basename "$0" .sh).log

mkdir -p "$LOG_DIR"
exec >> "$LOG_DIR/$LOG_FILE" 2>&1

if ! command -v 7z &>/dev/null; then
    echo "[ERROR] 7zip is not installed"
    exit 1
fi

echo "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | while read -r filepath
do
    [[ -z "$filepath" ]] && continue

    if [[ ! -f "$filepath" ]]; then
        echo "[INFO] Skipping $filepath"
        continue
    fi

    if ! 7z l "$filepath" &>/dev/null; then
        echo "[ERROR] Not a archive $filepath"
        continue
    fi

    if ! 7z t "$filepath" &>/dev/null; then
        echo "[ERROR] Invalid archive $filepath"
        continue
    fi

    dest=$(dirname "$filepath")
    filename="$(basename "${filepath%.*}")"

    echo "[INFO] Extracting $filepath"
    7z x "$filepath" -o"$dest/$filename" -y &>/dev/null
done
