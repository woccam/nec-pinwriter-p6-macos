# Changelog

## 1.4.0 – 2026-11-16
- 360 dpi modes: own grey-level dithering (Bayer 8x8) with dot-gain correction – grey areas no longer turn black
- New option "Graustufen" (lighter / normal / darker) for 360 dpi
- 360 dpi tested on real hardware (bidirectional OK); dot-gain curve calibrated from scans of a NEC P6 Plus
- One-line installation (no download/unzip), step-by-step README
- Installer messages in English

## 1.3.0 – 2026-11-16
- Selectable print quality: 180×180, 360×180, 360×360 dpi
- Filter ~8× faster (table-based bit transposition)
- Printer default options (lpadmin -o …) are now honoured by the filter
- `install.sh` updates an existing installation without prompting

## 1.0.0 – 2026-11-16
- First release: 180 dpi, A4/Letter/fanfold, CUPS filter + PPD
