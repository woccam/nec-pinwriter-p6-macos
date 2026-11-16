#!/bin/bash
# Installs the NEC Pinwriter P6 Plus driver on macOS and sets up the printer.
# Usage:  sudo bash install.sh
set -e
cd "$(dirname "$0")"

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run with sudo:  sudo bash install.sh"; exit 1
fi
if [ ! -x /usr/bin/perl ]; then
  echo "ERROR: /usr/bin/perl not found (required by the filter)."; exit 1
fi

FILTERDIR=/Library/Printers/NEC/filter
PPDDIR=/Library/Printers/PPDs/Contents/Resources

echo "==> Installing filter to $FILTERDIR"
mkdir -p "$FILTERDIR"
install -m 755 -o root -g wheel rastertonecp6 "$FILTERDIR/rastertonecp6"
xattr -c "$FILTERDIR/rastertonecp6" 2>/dev/null || true

echo "==> Installing PPD to $PPDDIR"
mkdir -p "$PPDDIR"
install -m 644 -o root -g wheel NEC-P6Plus.ppd "$PPDDIR/NEC-P6Plus.ppd"
gzip -f "$PPDDIR/NEC-P6Plus.ppd"

if lpstat -p NEC_P6_Plus >/dev/null 2>&1; then
  lpadmin -p NEC_P6_Plus -P "$PPDDIR/NEC-P6Plus.ppd.gz"
  cupsenable NEC_P6_Plus; cupsaccept NEC_P6_Plus
  echo "Done. Printer NEC_P6_Plus updated to the new driver version."
  echo "Print a test page:  lp -d NEC_P6_Plus \"$PWD/testseite.pdf\""
  exit 0
fi

echo
echo "==> Printer ports found:"
URIS=()
while IFS= read -r line; do
  uri=$(echo "$line" | awk '{print $2}')
  case "$uri" in usb:*|parallel:*|serial:*|socket:*|lpd:*) URIS+=("$uri");; esac
done < <(lpinfo -v 2>/dev/null)

if [ ${#URIS[@]} -eq 0 ]; then
  echo "   No USB/parallel/serial printer port found."
  echo "   Switch the printer on, check the USB-parallel adapter and run the install command again."
  echo "   (The driver itself is installed; you can also add the printer in System Settings > Printers.)"
  exit 0
fi

i=1
for u in "${URIS[@]}"; do echo "   [$i] $u"; i=$((i+1)); done
echo "   [m] Enter a URI manually (e.g. socket://192.168.1.50:9100)"
read -r -p "Type the number of the usb:// line and press Return: " sel
if [ "$sel" = "m" ]; then
  read -r -p "URI: " URI
else
  URI="${URIS[$((sel-1))]}"
fi
[ -z "$URI" ] && { echo "Nothing selected - run the install command again."; exit 1; }

lpadmin -p NEC_P6_Plus -E -v "$URI" \
  -P "$PPDDIR/NEC-P6Plus.ppd.gz" \
  -D "NEC Pinwriter P6 Plus" -L "$(scutil --get ComputerName 2>/dev/null)" \
  -o printer-is-shared=false
cupsenable NEC_P6_Plus
cupsaccept NEC_P6_Plus

echo
echo "Done. Printer 'NEC Pinwriter P6 Plus' set up on $URI."
echo "Print a test page:  lp -d NEC_P6_Plus \"$PWD/testseite.pdf\""
