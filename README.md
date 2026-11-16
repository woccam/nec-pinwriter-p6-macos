# NEC Pinwriter P6 Plus – native macOS printer driver (CUPS)

**[Deutsch weiter unten](#deutsch)**

A native macOS driver for the **NEC Pinwriter P6 Plus** 24-pin dot-matrix printer
(likely also P6, P7, P7 Plus, P60, P70 – untested). No Linux, no Ghostscript,
no Homebrew, no Xcode required: a CUPS filter written in Perl (shipped with macOS)
plus a PPD file.

## Features
- Print from **any macOS app** via the standard print dialog
- Print quality: **180×180**, **360×180** or **360×360 dpi**
- Paper sizes: A4, US Letter, continuous fanfold 8.5×12", 240 mm×12", 8.5×11"
- Page end: exact page-length feed (continuous paper) or form feed (single sheets)
- Bidirectional / unidirectional printing, horizontal offset adjustment
- Works on Intel and Apple Silicon Macs

## Requirements
- macOS with `/usr/bin/perl` (included in current macOS releases)
- Connection: **USB-to-parallel adapter** (36-pin Centronics, "USB printer class").
  A network print server with a parallel port also works (`socket://IP:9100`).
- Printer in its standard (NEC/ESC-P compatible) emulation, not IBM Proprinter

## Installation
1. Download `nec-pinwriter-p6-macos-1.3.0.zip` from the latest
   [Release](../../releases/latest) (e.g. into `~/Downloads`).
2. In Terminal:
   ```
   cd ~/Downloads && unzip -o nec-pinwriter-p6-macos-1.3.0.zip
   cd nec-pinwriter-p6-macos-1.3.0 && sudo bash install.sh
   ```
3. Pick the `usb://…` entry from the list. Test page:
   ```
   lp -d NEC_P6_Plus testseite.pdf
   ```
Running `sudo bash install.sh` again updates an existing installation without questions.

## Settings
In the print dialog open **Options → Printer Options (ⓘ)**:
*Print quality*, *Page end*, *Print direction*, *Horizontal offset*.
For 360×360 dpi, unidirectional printing gives the cleanest result.

Set defaults permanently, e.g.:
```
lpadmin -p NEC_P6_Plus -o Resolution=360dpi -o NECDirection=Uni
```

## Uninstall
```
sudo bash uninstall.sh
```

## Troubleshooting
- No `usb://` entry: switch the printer on, check the adapter, run `install.sh` again.
- Logs: `sudo cupsctl --debug-logging`, then `tail -f /var/log/cups/error_log`
- Output shifted sideways: check paper alignment first, then use *Horizontal offset*.

## How it works
macOS renders each page to CUPS raster (1-bit black). `rastertonecp6` converts it to
24-pin bit-image graphics: `ESC * 39` (180 dpi) or `ESC * 40` (360 dpi horizontal),
paper feed via `ESC J n/180"`. For 360 dpi vertical it sets `FS 3 1` (LF = 1/360")
and prints each band in two interleaved passes, as Ghostscript's `necp6` driver does.

## Status
180 dpi is tested on real hardware (NEC P6 Plus, USB-parallel adapter, macOS).
360 dpi modes are verified with a printer-command emulator; real-hardware
reports welcome – please open an issue.

## License
AGPL-3.0-or-later. The 360 dpi logic follows Ghostscript's `necp6` driver
(Artifex Software, Inc., AGPL-3.0). See [LICENSE](LICENSE).

---

<a name="deutsch"></a>
# Deutsch: NEC Pinwriter P6 Plus – nativer macOS-Druckertreiber

Nativer macOS-Treiber für den 24-Nadeldrucker **NEC Pinwriter P6 Plus**
(vermutlich auch P6, P7, P7 Plus, P60, P70 – ungetestet). Kein Linux, kein
Ghostscript, kein Homebrew, kein Xcode nötig.

## Funktionen
- Drucken aus **jeder macOS-App** über den normalen Drucken-Dialog
- Druckqualität **180×180**, **360×180** oder **360×360 dpi**
- Papier: A4, US Letter, Endlospapier 8,5×12", 240 mm×12", 8,5×11"
- Seitenende: exakter Vorschub (Endlos) oder Seitenvorschub (Einzelblatt)
- Bi-/unidirektional, horizontaler Versatz einstellbar

## Voraussetzungen
- macOS mit `/usr/bin/perl` (in aktuellen macOS-Versionen enthalten)
- **USB-auf-Parallel-Adapter** (36-Pin Centronics, „USB Printer Class") oder
  Netzwerk-Printserver mit Parallelport
- Drucker in Standard-Emulation (NEC/ESC-P), nicht IBM-Proprinter

## Installation
1. `nec-pinwriter-p6-macos-1.3.0.zip` aus dem neuesten
   [Release](../../releases/latest) herunterladen.
2. Im Terminal:
   ```
   cd ~/Downloads && unzip -o nec-pinwriter-p6-macos-1.3.0.zip
   cd nec-pinwriter-p6-macos-1.3.0 && sudo bash install.sh
   ```
3. Den `usb://…`-Eintrag wählen. Testseite: `lp -d NEC_P6_Plus testseite.pdf`

Erneutes Ausführen von `sudo bash install.sh` aktualisiert eine bestehende Installation.

## Einstellungen
Im Drucken-Dialog: **Optionen → Druckeroptionen (ⓘ)** – Druckqualität,
Seitenende, Druckrichtung, horizontaler Versatz. Für 360×360 dpi
„Unidirektional" wählen.

## Deinstallation
`sudo bash uninstall.sh`

## Lizenz
AGPL-3.0-or-later. Die 360-dpi-Logik folgt dem Ghostscript-Treiber `necp6`.
