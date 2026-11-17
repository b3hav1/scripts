#!/bin/bash

EXT_ID="appindicatorsupport@rgcjonas.gmail.com"

if ! command -v gnome-extensions &>/dev/null; then
    echo "[ERROR] Running unsupported environment"
    exit 1
fi

if ! gnome-extensions info "$EXT_ID" &>/dev/null; then
    echo "[ERROR] Extension $EXT_ID is not installed"
    exit 1
fi

echo "[INFO] Starting watch login"

dbus-monitor --system "type='signal',interface='org.freedesktop.login1.Session',member='Unlock'" 2>/dev/null |
while read -r line;
do
    [[ "$line" != *"member=Unlock"* ]] && continue

    if gnome-extensions info "$EXT_ID" 2>/dev/null | grep -qi "enabled: no"; then
        echo "[INFO] Extension $EXT_ID disabled by user"
        continue
    fi

    echo "[INFO] Reloading extension $EXT_ID"

    sleep 1
    gnome-extensions disable "$EXT_ID"
    sleep 1
    gnome-extensions enable "$EXT_ID"
done
