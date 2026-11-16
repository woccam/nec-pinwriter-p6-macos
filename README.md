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

## Installation (step by step)

You need: the printer connected via a **USB-to-parallel adapter** and switched on,
and the password you use to log in to your Mac.

1. **Open Terminal.** Press `Cmd ⌘ + Space`, type `Terminal`, press `Return`.
2. **Copy this whole line**, paste it into Terminal (`Cmd ⌘ + V`) and press `Return`:
   ```
   cd /tmp && curl -fsSL https://github.com/woccam/nec-pinwriter-p6-macos/archive/refs/heads/main.tar.gz | tar xz && cd nec-pinwriter-p6-macos-main && sudo bash install.sh
   ```
   This downloads the driver and starts the installer – nothing else to download or unzip.
3. **Enter your Mac password** when asked and press `Return`.
   You will **not see any characters** while typing – that is normal.
4. A numbered list of printer ports appears. **Type the number of the line that
   starts with `usb://`** and press `Return`.
   No `usb://` line? Switch the printer on, check the adapter cable, and repeat step 2.
5. Done – you will see `Done. Printer 'NEC Pinwriter P6 Plus' set up on usb://…`
   Print a test page by pasting this and pressing `Return`:
   ```
   lp -d NEC_P6_Plus /tmp/nec-pinwriter-p6-macos-main/testseite.pdf
   ```

From now on the printer appears as **NEC Pinwriter P6 Plus** in every app's print dialog.

**Updating** to a newer version: simply repeat step 2. Existing settings are kept,
no questions asked.

## Settings
In the print dialog scroll down to **Options → Printer Options** and click the
**ⓘ** button on the right:
*Print quality*, *Page end*, *Print direction*, *Horizontal offset*.
For 360×360 dpi, unidirectional printing gives the cleanest result.

Set defaults permanently, e.g.:
```
lpadmin -p NEC_P6_Plus -o Resolution=360dpi -o NECDirection=Uni
```

## Uninstall
Paste into Terminal and press `Return`:
```
cd /tmp && curl -fsSL https://github.com/woccam/nec-pinwriter-p6-macos/archive/refs/heads/main.tar.gz | tar xz && sudo bash nec-pinwriter-p6-macos-main/uninstall.sh
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

## Installation (Schritt für Schritt)

Voraussetzung: Drucker über **USB-Parallel-Adapter** angeschlossen und eingeschaltet,
und dein Mac-Anmeldepasswort.

1. **Terminal öffnen:** `Cmd ⌘ + Leertaste`, `Terminal` tippen, `Return`.
2. **Diese ganze Zeile kopieren**, ins Terminal einfügen (`Cmd ⌘ + V`), `Return`:
   ```
   cd /tmp && curl -fsSL https://github.com/woccam/nec-pinwriter-p6-macos/archive/refs/heads/main.tar.gz | tar xz && cd nec-pinwriter-p6-macos-main && sudo bash install.sh
   ```
   Das lädt den Treiber und startet die Installation – nichts herunterladen oder entpacken.
3. **Mac-Passwort eingeben** und `Return`. Beim Tippen erscheinen **keine Zeichen** – das ist normal.
4. Es erscheint eine nummerierte Liste. **Die Nummer der Zeile mit `usb://` eintippen**, `Return`.
   Keine `usb://`-Zeile? Drucker einschalten, Adapter prüfen, Schritt 2 wiederholen.
5. Fertig. Testseite: `lp -d NEC_P6_Plus /tmp/nec-pinwriter-p6-macos-main/testseite.pdf`

**Update:** einfach Schritt 2 wiederholen.

## Einstellungen
Im Drucken-Dialog nach unten zu **Optionen → Druckeroptionen** scrollen und rechts auf **ⓘ** klicken – Druckqualität,
Seitenende, Druckrichtung, horizontaler Versatz. Für 360×360 dpi
„Unidirektional" wählen.

## Deinstallation
Schritt 2 mit `uninstall.sh` statt `install.sh`

## Lizenz
AGPL-3.0-or-later. Die 360-dpi-Logik folgt dem Ghostscript-Treiber `necp6`.
