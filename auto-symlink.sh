#!/bin/bash

declare -A WATCH_DIRS=(
    ["$HOME/Scripts/systemd"]="$HOME/.config/systemd/user"
    ["$HOME/Scripts/nautilus"]="$HOME/.local/share/nautilus/scripts"
)

if ! command -v inotifywait &>/dev/null; then
    echo "[ERROR] inotify-tools is not installed"
    exit 1
fi

for dir in "${!WATCH_DIRS[@]}" "${WATCH_DIRS[@]}"; do
    if [[ ! -d "$dir" ]]; then
        echo "[INFO] Creating $dir"
        mkdir -p "$dir"
    fi
done

for src in "${!WATCH_DIRS[@]}"; do
    echo "[INFO] Starting watch $src"
done

inotifywait -mqe close_write,moved_to --format '%w %f' "${!WATCH_DIRS[@]}" |
while read -r watch_dir filename;
do
    src="${watch_dir%/}"
    dest="${WATCH_DIRS[$src]}"

    src_file="$src/$filename"
    dest_file="$dest/$filename"

    if [[ -z "$filename" || "$filename" == .* ]]; then
        echo "[INFO] Skipping $src_file"
        continue
    fi

    if [[ -e "$dest_file" || -L "$dest_file" ]]; then
        echo "[INFO] Already linked $dest_file"
        continue
    fi

    echo "[INFO] Linking $src_file -> $dest"
    ln -sn "$src_file" "$dest_file"
done
