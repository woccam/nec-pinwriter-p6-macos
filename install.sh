#!/bin/bash
# Installiert den NEC-P6-Plus-Treiber unter macOS und richtet den Drucker ein.
# Aufruf:  sudo ./install.sh
set -e
cd "$(dirname "$0")"

if [ "$(id -u)" -ne 0 ]; then
  echo "Bitte mit sudo starten:  sudo ./install.sh"; exit 1
fi
if [ ! -x /usr/bin/perl ]; then
  echo "FEHLER: /usr/bin/perl fehlt (wird fuer den Filter benoetigt)."; exit 1
fi

FILTERDIR=/Library/Printers/NEC/filter
PPDDIR=/Library/Printers/PPDs/Contents/Resources

echo "==> Kopiere Filter nach $FILTERDIR"
mkdir -p "$FILTERDIR"
install -m 755 -o root -g wheel rastertonecp6 "$FILTERDIR/rastertonecp6"
xattr -c "$FILTERDIR/rastertonecp6" 2>/dev/null || true

echo "==> Kopiere PPD nach $PPDDIR"
mkdir -p "$PPDDIR"
install -m 644 -o root -g wheel NEC-P6Plus.ppd "$PPDDIR/NEC-P6Plus.ppd"
gzip -f "$PPDDIR/NEC-P6Plus.ppd"

if lpstat -p NEC_P6_Plus >/dev/null 2>&1; then
  lpadmin -p NEC_P6_Plus -P "$PPDDIR/NEC-P6Plus.ppd.gz"
  cupsenable NEC_P6_Plus; cupsaccept NEC_P6_Plus
  echo "Drucker NEC_P6_Plus aktualisiert."
  echo "Testseite drucken:  lp -d NEC_P6_Plus testseite.pdf"
  exit 0
fi

echo
echo "==> Gefundene Druckeranschluesse:"
URIS=()
while IFS= read -r line; do
  uri=$(echo "$line" | awk '{print $2}')
  case "$uri" in usb:*|parallel:*|serial:*|socket:*|lpd:*) URIS+=("$uri");; esac
done < <(lpinfo -v 2>/dev/null)

if [ ${#URIS[@]} -eq 0 ]; then
  echo "   Kein USB-/Parallel-/Seriell-Anschluss gefunden."
  echo "   Drucker einschalten, Adapter anschliessen und install.sh erneut starten,"
  echo "   oder spaeter manuell: Systemeinstellungen > Drucker > Hinzufuegen > 'NEC Pinwriter P6 Plus'."
  exit 0
fi

i=1
for u in "${URIS[@]}"; do echo "   [$i] $u"; i=$((i+1)); done
echo "   [m] Manuelle URI eingeben (z. B. socket://192.168.178.50:9100)"
read -r -p "Auswahl: " sel
if [ "$sel" = "m" ]; then
  read -r -p "URI: " URI
else
  URI="${URIS[$((sel-1))]}"
fi
[ -z "$URI" ] && { echo "Keine Auswahl."; exit 1; }

lpadmin -p NEC_P6_Plus -E -v "$URI" \
  -P "$PPDDIR/NEC-P6Plus.ppd.gz" \
  -D "NEC Pinwriter P6 Plus" -L "$(scutil --get ComputerName 2>/dev/null)" \
  -o printer-is-shared=false
cupsenable NEC_P6_Plus
cupsaccept NEC_P6_Plus

echo
echo "Fertig. Drucker 'NEC_P6_Plus' an $URI eingerichtet."
echo "Testseite drucken:  lp -d NEC_P6_Plus testseite.pdf"
