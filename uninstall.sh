#!/bin/bash
# Entfernt Drucker und Treiber.  Aufruf: sudo ./uninstall.sh
[ "$(id -u)" -ne 0 ] && { echo "Bitte mit sudo starten."; exit 1; }
lpadmin -x NEC_P6_Plus 2>/dev/null
rm -f /Library/Printers/PPDs/Contents/Resources/NEC-P6Plus.ppd.gz
rm -rf /Library/Printers/NEC
echo "Treiber entfernt."
