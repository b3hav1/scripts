#!/bin/bash

WATCH_DIRS=("$HOME/Scripts")

if ! command -v inotifywait &>/dev/null; then
    echo "[FATAL] inotify-tools is not installed"
    exit 1
fi

for dir in "${WATCH_DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
        echo "[INFO] Creating $dir"
        mkdir -p "$dir"
    fi

    echo "[INFO] Starting watch $dir"
done

inotifywait -mrqe close_write,moved_to --format '%w%f' "${WATCH_DIRS[@]}" | while read -r filepath
do
    filetype=$(file --mime-type -b "$filepath")

    if [[ ! -f "$filepath" || "$filetype" != "text/x-shellscript" ]]; then
        echo "[INFO] Skipping $filepath"
        continue
    fi

    echo "[INFO] Granting $filepath"
    chmod +x "$filepath"
done
