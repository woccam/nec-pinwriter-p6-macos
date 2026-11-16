#!/bin/bash
# Removes printer and driver.  Usage: sudo bash uninstall.sh
[ "$(id -u)" -ne 0 ] && { echo "Please run with sudo."; exit 1; }
lpadmin -x NEC_P6_Plus 2>/dev/null
rm -f /Library/Printers/PPDs/Contents/Resources/NEC-P6Plus.ppd.gz
rm -rf /Library/Printers/NEC
echo "Driver removed."
